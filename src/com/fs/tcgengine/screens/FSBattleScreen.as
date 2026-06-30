package com.fs.tcgengine.screens
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.BoostsMng;
   import com.fs.tcgengine.controller.FSCardsMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TargetMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.boosts.Boost;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.BackgroundDef;
   import com.fs.tcgengine.model.rules.BattleEventDef;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.ConversationDef;
   import com.fs.tcgengine.model.rules.DungeonDef;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PassiveAbilityDef;
   import com.fs.tcgengine.model.rules.PortraitDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.rules.RaidDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.rules.RewardDef;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.model.rules.SubCategoryDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.cards.LightningAnimation;
   import com.fs.tcgengine.view.anims.fx.AttachedAnimation;
   import com.fs.tcgengine.view.board.BloodScreen;
   import com.fs.tcgengine.view.cards.AttachmentXL;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSEvent;
   import com.fs.tcgengine.view.cards.FSPower;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.battle.ActionPointsCounter;
   import com.fs.tcgengine.view.components.battle.FSAttackButton;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.components.battle.FSTurnsCounter;
   import com.fs.tcgengine.view.components.battle.GraveyardViewer;
   import com.fs.tcgengine.view.components.battle.TurnPanel;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.AbilitiesPanel;
   import com.fs.tcgengine.view.misc.BoostItem;
   import com.fs.tcgengine.view.misc.DeckJobConfigurator;
   import com.fs.tcgengine.view.misc.FSDefeatAnimation;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.FSObjectivesPanel;
   import com.fs.tcgengine.view.misc.FSVictoryAnimation;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.levels.FSPopupPlayLevel;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TimelineLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.greensock.easing.Sine;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.extensions.ColorArgb;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.deg2rad;
   
   public class FSBattleScreen extends Screen
   {
      
      public static const PLAYABLE_FOR_PROMOTE:int = 0;
      
      public static const PLAYABLE_FOR_SUMMON:int = 1;
      
      private static const ATTACK_ANIMATION_NAME:String = "card_combat";
      
      private static const SUGGEST_SOCKET_FACTOR_SCALE:Number = 1.1;
      
      public static var smFlaggedToUpdateQuestsProgress:Boolean = false;
      
      private static var smSaveQuestsProgressTimeOffset:Number = 60000;
      
      public static var smUserPayedInThisLevel:Boolean = false;
      
      protected var mBattleEngine:BattleEngine;
      
      protected var mOwnerSideDeckSocketCatalog:Dictionary;
      
      protected var mOpponentSideDeckSocketCatalog:Dictionary;
      
      protected var mOwnerBFSocketCatalog:Dictionary;
      
      protected var mOpponentBFSocketCatalog:Dictionary;
      
      protected var mOwnerSideDeckSocketSuggestCatalog:Dictionary;
      
      protected var mOwnerBFSocketSuggestCatalog:Dictionary;
      
      protected var mOpponentBFSocketSuggestCatalog:Dictionary;
      
      protected var mRowsAmount:int;
      
      protected var mColumnsAmount:int;
      
      protected var mOwnerPortrait:FSBattlefieldUserPortrait;
      
      protected var mOpponentPortrait:FSBattlefieldUserPortrait;
      
      protected var mEnemyActionBeingTriggered:FSCard;
      
      protected var mOwnerActionPointsCounter:ActionPointsCounter;
      
      protected var mOpponentActionPointsCounter:ActionPointsCounter;
      
      protected var mAttackButton:FSAttackButton;
      
      protected var mBoostsItems:Vector.<BoostItem>;
      
      protected var mBoostsContainer:Component;
      
      protected var mObjectivesPanel:FSObjectivesPanel;
      
      private var mAbilitiesChooserPanel:AbilitiesPanel;
      
      private var mCardAnimsON:Boolean = false;
      
      protected var mTurnsCounter:FSTurnsCounter;
      
      protected var mTurnPanel:TurnPanel;
      
      private var mBloodScreen:BloodScreen;
      
      protected var mOwnerDeckAreaBG:FSImage;
      
      protected var mOwnerDeckAreaBGLocked:FSImage;
      
      protected var mOwnerSacrificeImage:FSImage;
      
      protected var mOwnerPowerImage:FSImage;
      
      protected var mOpponentPowerImage:FSImage;
      
      protected var mOwnerPowerMc:MovieClip;
      
      protected var mOpponentPowerMc:MovieClip;
      
      protected var mOwnerPowerSummonIcon:FSImage;
      
      protected var mOwnerPowerSummonSuggestBG:FSImage;
      
      protected var mOwnerPowerSummonTextfield:FSTextfield;
      
      protected var mOpponentPowerSummonIcon:FSImage;
      
      protected var mOpponentPowerSummonSuggestBG:FSImage;
      
      protected var mOpponentPowerSummonTextfield:FSTextfield;
      
      protected var mOpponentSacrificeImage:FSImage;
      
      protected var mLightning:LightningAnimation;
      
      protected var mVictoryAnimation:FSVictoryAnimation;
      
      protected var mDefeatAnimation:FSDefeatAnimation;
      
      private var mDungeonGoldCounter:FSButton;
      
      private var mDungeonCardsCounter:FSButton;
      
      private var mAttackAnimationMC:MovieClip;
      
      private var mAIEvent:FSEvent;
      
      private var mAIPower:FSPower;
      
      private var mOwnerGraveyardButton:FSButton;
      
      private var mOwnerGraveyardViewer:GraveyardViewer;
      
      private var mOpponentGraveyardButton:FSButton;
      
      private var mOpponentGraveyardViewer:GraveyardViewer;
      
      private var mOwnerEmblemsVector:Vector.<FSImage>;
      
      private var mOwnerEmblemsTextfieldVector:Vector.<FSTextfield>;
      
      private var mOpponentEmblemsVector:Vector.<FSImage>;
      
      private var mOpponentEmblemsTextfieldVector:Vector.<FSTextfield>;
      
      private var mOwnerGreetingVoice:String;
      
      private var mOpponentGreetingVoice:String;
      
      private var mAttachedAnimationsVector:Vector.<AttachedAnimation>;
      
      private var mVictoryAnimationON:Boolean = false;
      
      private var mDefeatAnimationON:Boolean = false;
      
      private var mBGHighlights:FSImage;
      
      private var mFreeShuffleButton:FSButton;
      
      private var mScoresStarsContainer:Component;
      
      private var mMinScoreReachedStar:FSImage;
      
      private var mMedScoreReachedStar:FSImage;
      
      private var mMaxScoreReachedStar:FSImage;
      
      private var mIsTutorialLevel:Boolean;
      
      private var mAnimIconsLoaded:Boolean;
      
      protected var mOwnerCardDealingPoint:Point;
      
      protected var mOpponentCardDealingPoint:Point;
      
      private var mQuestsProgressTimeout:uint;
      
      protected var mPhysicalDeckOwner:FSImage;
      
      protected var mPhysicalDeckOpponent:FSImage;
      
      public function FSBattleScreen()
      {
         smUserPayedInThisLevel = false;
         mScreenName = Constants.BATTLE_SCREEN_NAME;
         mNeedsLoadingBar = true;
         var _loc1_:Boolean = Root.smBattleData.pvp != null && Root.smBattleData.pvp == true;
         var _loc2_:Boolean = _loc1_ && Root.smBattleData.online == true;
         this.mBattleEngine = _loc1_ ? new BattleEnginePvP(this) : new BattleEngine(this);
         this.mBattleEngine.init(_loc2_);
         this.chooseBGName();
         this.mQuestsProgressTimeout = setTimeout(this.saveQuestsProgress,smSaveQuestsProgressTimeOffset);
         super();
      }
      
      private function createAttackAnimation(param1:int = 0) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Vector.<Texture> = null;
         if(this.mAttackAnimationMC == null)
         {
            _loc2_ = ATTACK_ANIMATION_NAME;
            _loc3_ = 24;
            _loc4_ = Root.assets.getTextures(_loc2_ + "_");
            if((Boolean(_loc4_)) && _loc4_.length > 0)
            {
               if(this.mAttackAnimationMC == null)
               {
                  this.mAttackAnimationMC = new MovieClip(_loc4_,_loc3_);
                  this.mAttackAnimationMC.scale = 2;
                  this.mAttackAnimationMC.touchable = false;
                  this.mAttackAnimationMC.alignPivot();
                  this.mAttackAnimationMC.y = this.mBattleEngine.isPvPMatch() ? Starling.current.stage.stageHeight * 0.47 : Starling.current.stage.stageHeight * 0.35;
                  this.mAttackAnimationMC.visible = false;
               }
               Starling.juggler.add(this.mAttackAnimationMC);
               this.mAttackAnimationMC.stop();
               addChild(this.mAttackAnimationMC);
            }
            else if(param1 < 3)
            {
               TweenMax.delayedCall(0.1,this.createAttackAnimation,[param1 + 1]);
            }
         }
      }
      
      protected function chooseBGName() : void
      {
         var _loc3_:int = 0;
         var _loc5_:BackgroundDef = null;
         var _loc1_:LevelDef = this.mBattleEngine.getLevelDef();
         var _loc2_:int = _loc1_.getMapWorldParentIndex();
         _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc3_);
         var _loc4_:Boolean = Utils.getOwnerUserData() ? Utils.getOwnerUserData().flagsGetUseNewBGsON() : true;
         if(_loc4_)
         {
            _loc5_ = BackgroundDef(InstanceMng.getBackgroundDefMng().getDefBySku(_loc1_.getBackgroundSku(_loc3_)));
         }
         else
         {
            _loc5_ = BackgroundDef(InstanceMng.getBackgroundDefMng().getDefBySku(_loc1_.getBackgroundSkuOld(_loc3_)));
         }
         var _loc6_:String = _loc5_ ? _loc5_.getBGImageName() : null;
         mBGName = _loc6_ != null ? _loc6_ : "background_01";
      }
      
      public function onRetry() : void
      {
         this.performCardsLeavingFX(0,this.restartEngine);
         if(Config.smTracklistModeOn && Config.getConfig().battleHasOwnMusic())
         {
            Utils.loadNextTrack();
         }
      }
      
      private function onSkinResourcesLoaded() : void
      {
         this.mOwnerPortrait.refreshSkin();
      }
      
      public function loadNextDungeonLevel(param1:String) : void
      {
         Root.smBattleData.levelSku = param1;
         this.performCardsLeavingFX(0,this.restartEngine);
         if(Config.smTracklistModeOn && Config.getConfig().battleHasOwnMusic())
         {
            Utils.loadNextTrack();
         }
      }
      
      private function restartEngine() : void
      {
         this.reset(true);
         var _loc1_:Boolean = Root.smBattleData != null && Root.smBattleData.pvp != null && Root.smBattleData.pvp == true;
         this.mBattleEngine = _loc1_ ? new BattleEnginePvP(this) : new BattleEngine(this);
         this.mBattleEngine.init();
         this.mBattleEngine.startBattle();
         this.loadPowerResources();
         this.loadSkinsResources(true);
         this.loadPassiveAbilitiesSounds();
         this.loadAbilitiesAnims();
         this.addGreetingsVoices();
         InstanceMng.getResourcesMng().loadAssets(this.onSkinResourcesLoaded);
      }
      
      public function performCardsLeavingFX(param1:Number = 0, param2:Function = null, param3:Array = null) : Number
      {
         var _loc4_:FSCardSocket = null;
         var _loc5_:FSCard = null;
         var _loc9_:Number = NaN;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:FSCoordinate = new FSCoordinate(0,0);
         _loc9_ = 0.65 * Utils.getDefaultSpeedTime();
         var _loc10_:Number = 0.25 * Utils.getDefaultSpeedTime();
         this.suggestPlayableCardOFF();
         _loc6_ += param1;
         if(this.mOwnerSideDeckSocketCatalog != null)
         {
            _loc8_.setX(-200);
            _loc8_.setY(Starling.current.stage.stageHeight / 2);
            for each(_loc4_ in this.mOwnerSideDeckSocketCatalog)
            {
               _loc5_ = _loc4_ ? _loc4_.getParentCard() : null;
               if(_loc5_ != null)
               {
                  _loc5_.touchable = false;
                  _loc6_ += 0.1;
                  TweenMax.delayedCall(_loc6_,_loc5_.activateDropShadow,[false]);
                  SpecialFX.create3DRotation(_loc5_,_loc10_,_loc5_.rotationX,-180,90,_loc6_);
                  SpecialFX.createTransition(_loc5_,_loc8_,_loc9_,_loc6_,this.removeReturnedCard,[_loc5_]);
                  _loc7_++;
               }
            }
         }
         if(this.mOwnerBFSocketCatalog != null)
         {
            _loc8_.setX(Starling.current.stage.stageWidth + 50);
            _loc8_.setY(Starling.current.stage.stageHeight / 1.5);
            for each(_loc4_ in this.mOwnerBFSocketCatalog)
            {
               _loc5_ = _loc4_ ? _loc4_.getParentCard() : null;
               if(_loc5_ != null)
               {
                  _loc6_ += 0.1;
                  TweenMax.delayedCall(_loc6_,_loc5_.activateDropShadow,[false]);
                  SpecialFX.create3DRotation(_loc5_,_loc10_,_loc5_.rotationX,-180,90,_loc6_);
                  SpecialFX.createTransition(_loc5_,_loc8_,_loc9_,_loc6_,this.removeReturnedCard,[_loc5_]);
                  _loc7_++;
               }
            }
         }
         if(this.mOpponentBFSocketCatalog != null)
         {
            _loc8_.setX(Starling.current.stage.stageWidth + 50);
            _loc8_.setY(Starling.current.stage.stageHeight / 3);
            for each(_loc4_ in this.mOpponentBFSocketCatalog)
            {
               _loc5_ = _loc4_ ? _loc4_.getParentCard() : null;
               if(_loc5_ != null)
               {
                  _loc6_ += 0.1;
                  TweenMax.delayedCall(_loc6_,_loc5_.activateDropShadow,[false]);
                  SpecialFX.create3DRotation(_loc5_,_loc10_,_loc5_.rotationX,-180,90,_loc6_);
                  SpecialFX.createTransition(_loc5_,_loc8_,_loc9_,_loc6_,this.removeReturnedCard,[_loc5_]);
                  _loc7_++;
               }
            }
         }
         var _loc11_:Dictionary = Boolean(this.mBattleEngine) && Boolean(this.mBattleEngine.isPvPMatch()) && this is FSBattleScreenPvP ? FSBattleScreenPvP(this).getOpponentSideDeckSocketCatalog() : null;
         if(_loc11_)
         {
            _loc8_.setX(-200);
            _loc8_.setY(Starling.current.stage.stageHeight / 2);
            for each(_loc4_ in _loc11_)
            {
               _loc5_ = _loc4_ ? _loc4_.getParentCard() : null;
               if(_loc5_ != null)
               {
                  _loc6_ += 0.1;
                  TweenMax.delayedCall(_loc6_,_loc5_.activateDropShadow,[false]);
                  SpecialFX.create3DRotation(_loc5_,_loc10_,_loc5_.rotationX,-180,90,_loc6_);
                  SpecialFX.createTransition(_loc5_,_loc8_,_loc9_,_loc6_,this.removeReturnedCard,[_loc5_]);
                  _loc7_++;
               }
            }
         }
         if(this.mEnemyActionBeingTriggered != null)
         {
            _loc8_.setX(-200);
            _loc8_.setY(Starling.current.stage.stageHeight / 2);
            _loc6_ += 0.1;
            TweenMax.delayedCall(_loc6_,this.mEnemyActionBeingTriggered.activateDropShadow,[false]);
            SpecialFX.createTransition(this.mEnemyActionBeingTriggered,_loc8_,_loc9_,_loc6_,this.removeReturnedCard,[this.mEnemyActionBeingTriggered]);
            _loc7_++;
         }
         if(this.mOwnerPowerMc)
         {
            this.mOwnerPowerMc.removeFromParent();
         }
         if(this.mOpponentPowerMc)
         {
            this.mOpponentPowerMc.removeFromParent();
         }
         if(param2 != null)
         {
            if(param3)
            {
               TweenMax.delayedCall(_loc6_ + _loc9_,param2,param3);
            }
            else
            {
               TweenMax.delayedCall(_loc6_ + _loc9_,param2);
            }
         }
         return _loc6_ + _loc9_;
      }
      
      override protected function createBG() : void
      {
         var _loc1_:BackgroundDef = null;
         var _loc2_:String = null;
         super.createBG();
         if(mBG)
         {
            mBG.x = 0;
         }
         if(!Utils.isLowPerformanceDevice() && Config.getConfig().battleShowBGHighlights() && this.mBGHighlights == null && Boolean(Root.assets.getTexture(mBGName + "_highlights")))
         {
            _loc1_ = BackgroundDef(InstanceMng.getBackgroundDefMng().getDefBySku(mBGName));
            if(_loc1_)
            {
               _loc2_ = _loc1_.getHighlightsBGName();
               if(_loc2_ != null && _loc2_ != "")
               {
                  this.mBGHighlights = new FSImage(Root.assets.getTexture(_loc2_));
                  addChild(this.mBGHighlights);
                  this.mBGHighlights.width = mBG.width;
                  this.mBGHighlights.height = mBG.height;
                  SpecialFX.createYoYoAlphaTransition(this.mBGHighlights,0.25,2);
               }
            }
         }
         if(this.mBGHighlights)
         {
            this.mBGHighlights.x = 0;
         }
      }
      
      protected function createTurnsCounter() : void
      {
         var _loc1_:int = InstanceMng.getTargetMng().getCurrentLevelRequiredTurns();
         if(_loc1_ > 0)
         {
            if(this.mTurnsCounter == null)
            {
               this.mTurnsCounter = InstanceMng.getResourcesMng().createTurnsCounter(_loc1_);
               this.mTurnsCounter.touchable = false;
               this.mTurnsCounter.x = 5;
               this.mTurnsCounter.y = this.mAttackButton.y - this.mAttackButton.height / 2 - this.mTurnsCounter.height / 2.15;
            }
            else
            {
               this.mTurnsCounter.updateProgressBarMaxValue(_loc1_);
            }
            addChild(this.mTurnsCounter);
         }
         else if(this.mTurnsCounter)
         {
            this.mTurnsCounter.removeFromParent();
         }
      }
      
      protected function getActionDeckAssetName(param1:Boolean = true) : String
      {
         return "actionDeck";
      }
      
      public function enableBoostsPanel(param1:Boolean) : void
      {
         var _loc2_:BoostItem = null;
         var _loc3_:int = 0;
         param1 &&= !Config.KICKSTARTER_EDITION;
         if(this.mBoostsContainer != null)
         {
            for each(_loc2_ in this.mBoostsItems)
            {
               if(_loc2_ != null)
               {
                  if(param1 == true)
                  {
                     if(Boolean(_loc2_.getBoostDef()) && _loc2_.getBoostDef().isPermanent())
                     {
                        if(InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().canBoosterBeUsed(_loc2_.getBoostDef().getSku()))
                        {
                           _loc2_.setEnabled(param1);
                        }
                        else
                        {
                           _loc2_.setEnabled(false);
                        }
                     }
                     else
                     {
                        _loc2_.setEnabled(param1);
                     }
                  }
                  else
                  {
                     _loc2_.setEnabled(param1);
                  }
               }
            }
         }
      }
      
      public function refreshBoostsPanelAmounts() : void
      {
         var _loc1_:BoostItem = null;
         var _loc2_:int = 0;
         if(this.mBoostsContainer != null)
         {
            for each(_loc1_ in this.mBoostsItems)
            {
               if(_loc1_ != null)
               {
                  _loc1_.updateAmount();
               }
            }
         }
      }
      
      public function disposeBoostsItems() : void
      {
         var _loc1_:BoostItem = null;
         for each(_loc1_ in this.mBoostsItems)
         {
            if(_loc1_ != null)
            {
               _loc1_.dispose();
               _loc1_ = null;
            }
         }
      }
      
      override protected function setResourcesToLoad() : void
      {
         var _loc1_:LevelDef = null;
         var _loc2_:BackgroundDef = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:RaidDef = null;
         var _loc6_:int = 0;
         var _loc7_:BattleEventDef = null;
         var _loc8_:CardDef = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:BattleEventDef = null;
         var _loc13_:CardDef = null;
         var _loc14_:String = null;
         super.setResourcesToLoad();
         if(this.mBattleEngine != null)
         {
            _loc1_ = this.mBattleEngine.getLevelDef();
            if(_loc1_ != null)
            {
               this.mIsTutorialLevel = InstanceMng.getTutorialDefMng().getTutorialDefsByLevelSku(_loc1_.getSku()) != null;
               if(Root.smBattleData.isRaid)
               {
                  _loc5_ = InstanceMng.getRaidsMng().getCurrentRaidDef();
                  _loc6_ = InstanceMng.getRaidsMng().getCurrentRaidDifficulty();
                  _loc7_ = _loc5_.getBattleEventByDifficultyIndex(_loc6_);
                  if(_loc7_)
                  {
                     _loc8_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc7_.getActionSku()));
                     InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc8_);
                  }
               }
               if(this.mBattleEngine.getLevelDef().hasBattleEvent())
               {
                  _loc9_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
                  _loc10_ = LevelDef(this.mBattleEngine.getLevelDef()).getMapWorldParentIndex();
                  _loc11_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc11_);
                  _loc12_ = BattleEventDef(InstanceMng.getBattleEventDefMng().getDefBySku(LevelDef(this.mBattleEngine.getLevelDef()).getBattleEventSkuByDifficulty(_loc9_,_loc11_)));
                  if(_loc12_)
                  {
                     _loc13_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc12_.getActionSku()));
                     InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc13_);
                  }
               }
               if(Config.getConfig().gameHasTierFrames())
               {
                  InstanceMng.getResourcesMng().addResourcesFolderByName("frames");
               }
               InstanceMng.getResourcesMng().addResourcesFolderByName("framesFactionsRarities");
               if(Config.getConfig().cardsHaveCustomAuras())
               {
                  InstanceMng.getResourcesMng().addResourcesFolderByName("anims/animAuras");
               }
               if(Config.getConfig().showFireworksOnVictoryAnimation())
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("misc/firework",FSResourceMng.TYPE_AUDIO);
                  InstanceMng.getResourcesMng().addResourceToLoad("misc/pre_firework",FSResourceMng.TYPE_AUDIO);
               }
               this.loadPowerResources();
               this.addPortraitResources();
               this.addGreetingsVoices();
               this.loadPassiveAbilitiesSounds();
               if(Config.USE_DEATH_ANIM)
               {
                  InstanceMng.getResourcesMng().addResourcesFolderByName("anims/animDeath");
               }
               this.loadConversationsAssets();
               InstanceMng.getResourcesMng().enqueueSpecialResourceToLoad(mBGName,"battlegrounds",FSResourceMng.TYPE_TEXTURE_JPG);
               _loc2_ = BackgroundDef(InstanceMng.getBackgroundDefMng().getDefBySku(mBGName));
               if(Config.getConfig().battleShowBGHighlights())
               {
                  if(_loc2_)
                  {
                     _loc14_ = _loc2_.getHighlightsBGName();
                     if(_loc14_ != null && _loc14_ != "")
                     {
                        InstanceMng.getResourcesMng().enqueueSpecialResourceToLoad(_loc14_,"battlegrounds",FSResourceMng.TYPE_TEXTURE_PNG);
                     }
                  }
               }
               if(_loc2_ != null && _loc2_.getSocketPrefix() != "" && _loc2_.getSocketPrefix() != null)
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("sockets/" + _loc2_.getSocketPrefix() + "_off",FSResourceMng.TYPE_TEXTURE_PNG);
                  InstanceMng.getResourcesMng().addResourceToLoad("sockets/" + _loc2_.getSocketPrefix() + "_on",FSResourceMng.TYPE_TEXTURE_PNG);
                  if(Config.getConfig().battleUseDeckBG())
                  {
                     InstanceMng.getResourcesMng().addResourceToLoad("cardHolders/" + _loc2_.getCardHolderBG(),FSResourceMng.TYPE_TEXTURE_PNG);
                     if(Utils.isIOS())
                     {
                        InstanceMng.getResourcesMng().enqueueSpecialResourceToLoad(_loc2_.getCardHolderBG(),"cardHolders",FSResourceMng.TYPE_TEXTURE_PNG);
                     }
                     if(Config.getConfig().battleShowRedPanelWhenNoAPLeft())
                     {
                        InstanceMng.getResourcesMng().addResourceToLoad("cardHolders/card_holder_lock",FSResourceMng.TYPE_TEXTURE_PNG);
                        if(Utils.isIOS())
                        {
                           InstanceMng.getResourcesMng().enqueueSpecialResourceToLoad("card_holder_lock","cardHolders",FSResourceMng.TYPE_TEXTURE_PNG);
                        }
                     }
                  }
               }
               _loc3_ = InstanceMng.getTargetMng().getCurrentLevelRequiredTurns(_loc1_);
               _loc4_ = Config.getConfig().battleHasSimpleUI();
               if((_loc4_) && (_loc3_ > 0 || this.mBattleEngine.isOnlineMatch()))
               {
                  InstanceMng.getResourcesMng().addResourcesFolderByName("animTimePVP");
               }
               if(Config.getConfig().hasSkins())
               {
                  this.loadSkinsResources(true);
                  this.loadSkinsResources(false);
               }
               this.loadAbilitiesAnims();
               InstanceMng.getResourcesMng().loadAssets();
            }
         }
      }
      
      private function loadAbilitiesAnims() : void
      {
         var loadAnimsByDeck:Function;
         var assetsEnqueued:Dictionary = null;
         if(Config.LOAD_ABILITIES_ANIMS_ON_DEMAND)
         {
            loadAnimsByDeck = function(param1:UserBattleInfo):void
            {
               var _loc2_:Array = null;
               var _loc3_:PassiveAbilityDef = null;
               var _loc4_:AbilityDef = null;
               var _loc5_:Array = null;
               var _loc6_:int = 0;
               var _loc7_:CardDef = null;
               var _loc8_:String = null;
               var _loc9_:RarityDef = null;
               var _loc10_:String = null;
               var _loc11_:SubCategoryDef = null;
               var _loc12_:String = null;
               var _loc13_:Array = null;
               if(param1)
               {
                  if(Config.getConfig().gameHasPassive())
                  {
                     _loc3_ = param1.getPassiveAbilityDef();
                     if(_loc3_)
                     {
                        _loc4_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc3_.getAbilitiesSkus()[0]));
                        if(_loc4_)
                        {
                           InstanceMng.getResourcesMng().addResourcesFolderByName("anims/" + _loc4_.getAnimIconName());
                           assetsEnqueued["anims/" + _loc4_.getAnimIconName()] = 1;
                        }
                     }
                  }
                  _loc2_ = param1.getDeckArray();
                  if(_loc2_)
                  {
                     _loc5_ = new Array();
                     _loc6_ = 0;
                     while(_loc6_ < _loc2_.length)
                     {
                        _loc7_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc2_[_loc6_]));
                        if(_loc7_)
                        {
                           if(mBattleEngine.getLevelDef().isCardAllowedInThisLevel(_loc7_))
                           {
                              assetsEnqueued = InstanceMng.getResourcesMng().loadCardAnimsResources(_loc7_,assetsEnqueued);
                           }
                           _loc8_ = _loc7_.getCardRarity();
                           _loc9_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc8_));
                           if((Boolean(_loc9_)) && _loc9_.getHasAura())
                           {
                              _loc13_ = _loc7_.getSubCategorySku();
                              _loc10_ = (Boolean(_loc13_)) && _loc13_.length > 0 ? _loc13_[0] : null;
                              _loc11_ = _loc10_ ? SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(_loc10_)) : null;
                              _loc12_ = _loc11_ ? _loc11_.getAnimAura() : "";
                              if((Boolean(_loc12_)) && assetsEnqueued["anims/" + _loc12_] == null)
                              {
                                 InstanceMng.getResourcesMng().addResourcesFolderByName("anims/" + _loc12_);
                                 assetsEnqueued["anims/" + _loc4_.getAnimIconName()] = 1;
                              }
                           }
                        }
                        _loc6_++;
                     }
                  }
               }
            };
            assetsEnqueued = new Dictionary(true);
            InstanceMng.getResourcesMng().addResourcesFolderByName("anims/animIcons");
            InstanceMng.getResourcesMng().addResourcesFolderByName("anims/ap_use");
            loadAnimsByDeck(this.mBattleEngine.getOwnerBattleInfo());
            loadAnimsByDeck(this.mBattleEngine.getOpponentBattleInfo());
         }
         else if(!this.mAnimIconsLoaded)
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("animIcons");
            this.mAnimIconsLoaded = true;
         }
      }
      
      private function loadPassiveAbilitiesSounds() : void
      {
         var _loc1_:String = null;
         if(Config.getConfig().gameHasPassive() && Boolean(this.mBattleEngine))
         {
            if(this.mBattleEngine.getOwnerBattleInfo())
            {
               _loc1_ = this.mBattleEngine.getOwnerBattleInfo().getPassiveAbilitySound();
            }
            if(_loc1_ != null && _loc1_ != "")
            {
               InstanceMng.getResourcesMng().addResourceToLoad("battleFX/" + _loc1_,FSResourceMng.TYPE_AUDIO);
            }
            if(this.mBattleEngine.getOpponentBattleInfo())
            {
               _loc1_ = this.mBattleEngine.getOpponentBattleInfo().getPassiveAbilitySound();
            }
            if(_loc1_ != null && _loc1_ != "")
            {
               InstanceMng.getResourcesMng().addResourceToLoad("battleFX/" + _loc1_,FSResourceMng.TYPE_AUDIO);
            }
         }
      }
      
      private function unloadPassiveAbilitiesSounds() : void
      {
         var _loc1_:String = null;
         if(Config.getConfig().gameHasPassive() && Boolean(this.mBattleEngine))
         {
            if(this.mBattleEngine.getOwnerBattleInfo())
            {
               _loc1_ = this.mBattleEngine.getOwnerBattleInfo().getPassiveAbilitySound();
            }
            if(_loc1_ != null && _loc1_ != "")
            {
               Root.assets.removeSound(_loc1_);
            }
            if(this.mBattleEngine.getOpponentBattleInfo())
            {
               _loc1_ = this.mBattleEngine.getOpponentBattleInfo().getPassiveAbilitySound();
            }
            if(_loc1_ != null && _loc1_ != "")
            {
               Root.assets.removeSound(_loc1_);
            }
         }
      }
      
      private function loadPowerResources() : void
      {
         var _loc1_:PowerDef = null;
         var _loc2_:Boolean = false;
         var _loc3_:PowerDef = null;
         var _loc4_:Boolean = false;
         if(Config.getConfig().gameHasPowers())
         {
            _loc1_ = this.mBattleEngine.getOwnerBattleInfo().getPowerDefFromDeck();
            if(_loc1_)
            {
               _loc2_ = _loc1_.hasAnimatedBG();
               if(_loc2_)
               {
                  if(Root.assets.getTextureAtlas(_loc1_.getAnimatedBG()) == null)
                  {
                     InstanceMng.getResourcesMng().addResourceToLoad("cardsAnimated/" + _loc1_.getAnimatedBG(),FSResourceMng.TYPE_TEXTURE_ATLAS);
                  }
                  else
                  {
                     FSDebug.debugTrace("[loadPowerResources] owner power loading skipped since it\'s already on mem");
                  }
               }
            }
            else
            {
               FSDebug.debugTrace("[loadPowerResources] no owner power def found");
            }
            if(this.mBattleEngine.isPvPMatch())
            {
               _loc3_ = this.mBattleEngine.getOpponentBattleInfo().getPowerDefFromDeck();
               if(_loc3_)
               {
                  _loc4_ = _loc3_.hasAnimatedBG();
                  if(_loc4_)
                  {
                     if(Root.assets.getTextureAtlas(_loc3_.getAnimatedBG()) == null)
                     {
                        InstanceMng.getResourcesMng().addResourceToLoad("cardsAnimated/" + _loc3_.getAnimatedBG(),FSResourceMng.TYPE_TEXTURE_ATLAS);
                     }
                     else
                     {
                        FSDebug.debugTrace("[loadPowerResources] opponent power loading skipped since it\'s already on mem");
                     }
                  }
               }
               else
               {
                  FSDebug.debugTrace("[loadPowerResources] no opponent power def found");
               }
            }
         }
      }
      
      protected function loadSkinsResources(param1:Boolean, param2:Boolean = false) : void
      {
         var _loc3_:HeroCharacterDef = this.getHeroCharacterDef(param1,param2);
         if(Boolean(_loc3_) && Root.assets.getTexture(_loc3_.getBGImageName()) == null)
         {
            InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc3_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
         }
      }
      
      public function getHeroCharacterDef(param1:Boolean, param2:Boolean) : HeroCharacterDef
      {
         var _loc3_:UserData = null;
         var _loc4_:UserBattleInfo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:HeroCharacterDef = null;
         var _loc9_:DungeonDef = null;
         var _loc10_:String = null;
         var _loc11_:JobDef = null;
         var _loc12_:DeckJobConfigurator = null;
         if(param1)
         {
            _loc3_ = Utils.getOwnerUserData();
         }
         else if(param2)
         {
            _loc3_ = InstanceMng.getUserDataMng().getOpponentUserData();
         }
         else
         {
            _loc4_ = this.mBattleEngine ? this.mBattleEngine.getOpponentBattleInfo() : null;
            _loc3_ = _loc4_ ? _loc4_.getUserData() : null;
            if(_loc3_ == null)
            {
               _loc5_ = LevelDef(this.mBattleEngine.getLevelDef()).getMapWorldParentIndex();
               _loc6_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc6_);
               _loc8_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mBattleEngine.getLevelDef().getEnemyHeroSku(_loc6_)));
            }
         }
         if(_loc3_)
         {
            _loc7_ = param2 ? _loc3_.getSelectedDeckIndexPvP() : _loc3_.getSelectedDeckIndex();
            _loc8_ = null;
            if(Config.getConfig().gameHasClassSystem())
            {
               if(Root.smBattleData.isDungeon == true)
               {
                  _loc9_ = InstanceMng.getDungeonsMng().getCurrentDungeonDef();
                  _loc10_ = _loc9_.getDungeonHeroSku();
                  _loc8_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc10_));
               }
               else if(UserDataMng.isBasicDeck(_loc7_))
               {
                  _loc11_ = InstanceMng.getJobsDefMng().getBasicJobByDeck(_loc7_.toString());
                  if(_loc11_)
                  {
                     _loc8_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc11_.getDefaultSkinSku()));
                  }
               }
               else
               {
                  _loc12_ = _loc3_.getDeckJobConfiguratorByDeck(_loc7_);
                  if(_loc12_)
                  {
                     _loc8_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc12_.getSkinSku()));
                  }
               }
            }
         }
         return _loc8_;
      }
      
      private function loadConversationsAssets() : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc1_:Array = this.getConversationBlocksAssetsArr();
         if(_loc1_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc3_ = _loc1_[_loc2_];
               InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc3_,FSResourceMng.TYPE_TEXTURE_PNG);
               _loc2_++;
            }
         }
      }
      
      private function unLoadConversationsAssets() : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc1_:Array = this.getConversationBlocksAssetsArr();
         if(_loc1_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc3_ = _loc1_[_loc2_];
               Root.assets.removeTexture(_loc3_);
               _loc2_++;
            }
         }
      }
      
      protected function getConversationBlocksAssetsArr() : Array
      {
         var returnValue:Array = null;
         var levelDef:LevelDef = null;
         var conversationsDefsArr:Array = null;
         var customConvDef:ConversationDef = null;
         var i:int = 0;
         var conversationDef:ConversationDef = null;
         var processConv:Function = function(param1:ConversationDef):void
         {
            var _loc3_:String = null;
            var _loc4_:PortraitDef = null;
            var _loc5_:String = null;
            var _loc6_:String = null;
            var _loc2_:HeroCharacterDef = InstanceMng.getHeroCharactersDefMng() ? HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(param1.getHeroSku())) : null;
            if(Config.getConfig().hasPortraits() && Boolean(_loc2_))
            {
               _loc3_ = _loc2_.getPortraitSku();
               _loc4_ = PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(_loc3_));
               if(_loc4_)
               {
                  _loc5_ = _loc4_.getRankFrameBG();
                  returnValue.push(_loc5_);
                  if(!Config.smPortraitFramesInAtlas)
                  {
                     _loc6_ = _loc4_.getBGImageName();
                     returnValue.push(_loc6_);
                  }
               }
            }
            returnValue.push(_loc2_.getBGImageName());
         };
         if(this.mBattleEngine)
         {
            levelDef = this.mBattleEngine.getLevelDef();
            if(levelDef != null)
            {
               conversationsDefsArr = InstanceMng.getConversationsDefMng() ? InstanceMng.getConversationsDefMng().getConversationsDefsByLevelSku(levelDef.getSku()) : null;
               if(conversationsDefsArr)
               {
                  i = 0;
                  while(i < conversationsDefsArr.length)
                  {
                     conversationDef = conversationsDefsArr[i];
                     if(conversationDef)
                     {
                        if(returnValue == null)
                        {
                           returnValue = new Array();
                        }
                        processConv(conversationDef);
                     }
                     i++;
                  }
               }
               customConvDef = InstanceMng.getConversationsDefMng().getConversationDefByCallKey("custom");
               if(customConvDef)
               {
                  if(returnValue == null)
                  {
                     returnValue = new Array();
                  }
                  processConv(customConvDef);
               }
            }
         }
         return returnValue;
      }
      
      protected function addPortraitResources() : void
      {
         var _loc2_:UserData = null;
         var _loc3_:PortraitDef = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:UserData = null;
         var _loc9_:Boolean = false;
         var _loc10_:String = null;
         var _loc11_:HeroCharacterDef = null;
         var _loc12_:HeroCharacterDef = null;
         var _loc13_:HeroCharacterDef = null;
         if(!Config.smPortraitFramesInAtlas)
         {
            _loc2_ = Utils.getOwnerUserData();
            InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + FSBattlefieldUserPortrait.FRAME_BG_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
            if(Config.getConfig().battleEnemyPortraitSpecial())
            {
               InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + FSBattlefieldUserPortrait.ENEMY_FRAME_BG_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
            }
            if(Boolean(_loc2_) && Config.getConfig().gameHasRanks())
            {
               if(!Config.smPortraitFramesInAtlas)
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc2_.getCurrentRankFrameBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
                  InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc2_.getCurrentPortraitBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
               }
            }
         }
         var _loc1_:UserBattleInfo = this.mBattleEngine ? this.mBattleEngine.getOpponentBattleInfo() : null;
         if(_loc1_)
         {
            _loc7_ = this.mBattleEngine != null && this.mBattleEngine.isOnlineMatch();
            if(_loc7_)
            {
               _loc8_ = _loc1_.getUserData();
               _loc9_ = Config.getConfig().hasPortraits() && !Config.smPortraitFramesInAtlas;
               if(Boolean(_loc8_) && _loc9_)
               {
                  _loc10_ = _loc8_.getCurrentPortraitBGImageName(false);
                  InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc10_,FSResourceMng.TYPE_TEXTURE_PNG);
                  if(Config.getConfig().gameHasRanks())
                  {
                     _loc3_ = _loc8_.getCurrentPortraitDef(false);
                     _loc4_ = _loc3_.getBGImageName();
                     InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc4_,FSResourceMng.TYPE_TEXTURE_PNG);
                     _loc6_ = _loc3_.getRankFrameBG();
                     InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc6_,FSResourceMng.TYPE_TEXTURE_PNG);
                  }
               }
               else if(Config.getConfig().hasSkins())
               {
                  _loc11_ = InstanceMng.getUserDataMng().getOpponentUserData().getCurrentSkinDef();
                  if(_loc11_)
                  {
                     InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc11_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
                  }
               }
            }
            else
            {
               _loc12_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mBattleEngine.getLevelDef().getEnemyHeroSku(UserData.WORLD_DEFAULT)));
               if(_loc12_)
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc12_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
                  if(Config.getConfig().gameHasRanks() && !Config.smPortraitFramesInAtlas)
                  {
                     _loc5_ = _loc12_.getPortraitSku();
                     _loc3_ = PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(_loc5_));
                     _loc4_ = _loc3_.getBGImageName();
                     InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc4_,FSResourceMng.TYPE_TEXTURE_PNG);
                     _loc6_ = _loc3_.getRankFrameBG();
                     InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc6_,FSResourceMng.TYPE_TEXTURE_PNG);
                  }
               }
            }
         }
         else
         {
            InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + FSResourceMng.DEFAULT_PHOTO_AI_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
         }
         if(Config.getConfig().hasPortraits())
         {
            InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + FSResourceMng.DEFAULT_AI_PORTRAIT_FRAME_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
            InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + FSResourceMng.DEFAULT_PHOTO_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
         }
         else if(Config.getConfig().hasSkins())
         {
            _loc13_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentSkinDef();
            if(_loc13_)
            {
               InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc13_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
            }
         }
      }
      
      private function addGreetingsVoices() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:HeroCharacterDef = null;
         var _loc3_:HeroCharacterDef = null;
         if(Config.getConfig().gameHasClassSystem())
         {
            _loc1_ = this.mBattleEngine != null && this.mBattleEngine.isPvPMatch();
            _loc2_ = this.getHeroCharacterDef(true,_loc1_);
            if(_loc2_)
            {
               this.mOwnerGreetingVoice = _loc2_.getGreetingsVoice();
               if(this.mOwnerGreetingVoice != "" && Root.assets.getSound(this.mOwnerGreetingVoice) == null)
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("fx/" + this.mOwnerGreetingVoice,FSResourceMng.TYPE_AUDIO);
               }
            }
            _loc3_ = this.getHeroCharacterDef(false,_loc1_);
            if(_loc3_)
            {
               this.mOpponentGreetingVoice = _loc3_.getGreetingsVoice();
               if(this.mOpponentGreetingVoice != "" && Root.assets.getSound(this.mOpponentGreetingVoice) == null)
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("fx/" + this.mOpponentGreetingVoice,FSResourceMng.TYPE_AUDIO);
               }
            }
         }
      }
      
      public function playGreetingsVoice(param1:Boolean) : void
      {
         if(param1)
         {
            if(Boolean(this.mOwnerGreetingVoice) && this.mOwnerGreetingVoice != "")
            {
               Utils.playSound(this.mOwnerGreetingVoice,SoundManager.TYPE_SFX);
               if(Boolean(this.mOwnerPortrait) && Boolean(this.mOwnerPortrait.getFrameContainer()))
               {
                  SpecialFX.createYoYoAlphaTransition(this.mOwnerPortrait.getFrameContainer(),0.5,0.5);
                  TweenMax.delayedCall(3,this.deactivateGreetingsFX,[this.mOwnerPortrait.getFrameContainer()]);
               }
            }
         }
         else if(Boolean(this.mOpponentGreetingVoice) && this.mOpponentGreetingVoice != "")
         {
            Utils.playSound(this.mOpponentGreetingVoice,SoundManager.TYPE_SFX);
            if(Boolean(this.mOpponentPortrait) && Boolean(this.mOpponentPortrait.getFrameContainer()))
            {
               SpecialFX.createYoYoAlphaTransition(this.mOpponentPortrait.getFrameContainer(),0.5,0.5);
               TweenMax.delayedCall(3,this.deactivateGreetingsFX,[this.mOpponentPortrait.getFrameContainer()]);
            }
         }
      }
      
      private function deactivateGreetingsFX(param1:Component) : void
      {
         if(param1)
         {
            TweenMax.killTweensOf(param1);
            param1.alpha = 0.999;
         }
      }
      
      override public function notifyAssetsLoaded(param1:* = null) : void
      {
         var _loc2_:Vector.<String> = null;
         super.notifyAssetsLoaded();
         if(Boolean(this.mBattleEngine) && !this.mBattleEngine.hasBattleStarted())
         {
            this.mBattleEngine.startBattle();
            setScreenPopupsResourcesLoaded();
            if(Config.getConfig().battleHasOwnMusic())
            {
               Utils.stopAllSounds(true);
               _loc2_ = new Vector.<String>();
               _loc2_.push("track_02");
               Utils.addTrackList(_loc2_);
               Utils.loadNextTrack();
            }
         }
      }
      
      private function saveQuestsProgress(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = this.mBattleEngine && !this.mBattleEngine.isBattleOver() && smFlaggedToUpdateQuestsProgress || param1;
         if(!Root.smRootDeactivated && _loc2_)
         {
            InstanceMng.getUserDataMng().updateQuestsProgress();
            smFlaggedToUpdateQuestsProgress = false;
         }
         this.mQuestsProgressTimeout = setTimeout(this.saveQuestsProgress,smSaveQuestsProgressTimeOffset);
      }
      
      override public function unload() : void
      {
         var _loc2_:PowerDef = null;
         var _loc3_:Boolean = false;
         var _loc4_:PowerDef = null;
         var _loc5_:Boolean = false;
         var _loc6_:RaidDef = null;
         var _loc7_:int = 0;
         var _loc8_:BattleEventDef = null;
         var _loc9_:CardDef = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:BattleEventDef = null;
         var _loc14_:CardDef = null;
         var _loc15_:int = 0;
         var _loc16_:Boolean = false;
         var _loc17_:String = null;
         clearTimeout(this.mQuestsProgressTimeout);
         InstanceMng.getUserDataMng().updateQuestsProgress();
         TweenMax.killAll();
         this.unLoadConversationsAssets();
         if(Config.getConfig().gameHasPowers())
         {
            if(this.mBattleEngine)
            {
               _loc2_ = this.mBattleEngine.getOwnerBattleInfo() ? this.mBattleEngine.getOwnerBattleInfo().getPowerDefFromDeck() : null;
               if(_loc2_)
               {
                  _loc3_ = _loc2_.hasAnimatedBG();
                  if(_loc3_)
                  {
                     Root.assets.removeTextureAtlas(_loc2_.getAnimatedBG());
                     Root.assets.removeTexture(_loc2_.getAnimatedBG());
                  }
               }
               if(this.mBattleEngine.isPvPMatch())
               {
                  _loc4_ = this.mBattleEngine.getOpponentBattleInfo() ? this.mBattleEngine.getOpponentBattleInfo().getPowerDefFromDeck() : null;
                  if(_loc4_)
                  {
                     _loc5_ = _loc4_.hasAnimatedBG();
                     if(_loc5_)
                     {
                        Root.assets.removeTextureAtlas(_loc4_.getAnimatedBG());
                     }
                  }
               }
            }
         }
         if(Root.smBattleData.isRaid)
         {
            if(InstanceMng.getRaidsMng())
            {
               _loc6_ = InstanceMng.getRaidsMng().getCurrentRaidDef();
               _loc7_ = InstanceMng.getRaidsMng().getCurrentRaidDifficulty();
               _loc8_ = _loc6_ ? _loc6_.getBattleEventByDifficultyIndex(_loc7_) : null;
               if(_loc8_)
               {
                  _loc9_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc8_.getActionSku()));
                  if(_loc9_)
                  {
                     Root.assets.removeTexture(_loc9_.getBGImageName());
                  }
               }
            }
         }
         else if(Boolean(this.mBattleEngine) && Boolean(this.mBattleEngine.getLevelDef()) && this.mBattleEngine.getLevelDef().hasBattleEvent())
         {
            if(InstanceMng.getUserDataMng().getOwnerUserData())
            {
               _loc10_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
               _loc11_ = LevelDef(this.mBattleEngine.getLevelDef()).getMapWorldParentIndex();
               _loc12_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc12_);
               _loc13_ = BattleEventDef(InstanceMng.getBattleEventDefMng().getDefBySku(LevelDef(this.mBattleEngine.getLevelDef()).getBattleEventSkuByDifficulty(_loc10_,_loc12_)));
               if(_loc13_)
               {
                  _loc14_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc13_.getActionSku()));
                  if(_loc14_)
                  {
                     Root.assets.removeTexture(_loc14_.getBGImageName());
                  }
               }
            }
         }
         if(this.mIsTutorialLevel)
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("tutorial",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         }
         if(Boolean(this.mBattleEngine) && Boolean(this.mBattleEngine.getLevelDef()))
         {
            _loc15_ = InstanceMng.getTargetMng().getCurrentLevelRequiredTurns(this.mBattleEngine.getLevelDef());
            _loc16_ = Config.getConfig().battleHasSimpleUI();
            if((_loc16_) && (_loc15_ > 0 || this.mBattleEngine.isOnlineMatch()))
            {
               InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("animTimePVP",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
            }
         }
         this.reset();
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("portraits",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("battleFX",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_AUDIO));
         if(Config.getConfig().battleUnloadFXFolder())
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("fx",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_AUDIO));
         }
         if(this.mOwnerGreetingVoice != null && this.mOwnerGreetingVoice != "")
         {
            Root.assets.removeSound(this.mOwnerGreetingVoice);
         }
         if(this.mOpponentGreetingVoice != null && this.mOpponentGreetingVoice != "")
         {
            Root.assets.removeSound(this.mOpponentGreetingVoice);
         }
         this.unloadPassiveAbilitiesSounds();
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("frames",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesXL",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesFactionsRarities",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("animIcons",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         if(Config.getConfig().cardsHaveCustomAuras())
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("anims/animAuras",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         }
         if(Config.USE_DEATH_ANIM)
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("anims/animDeath",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         }
         if(Config.getConfig().showFireworksOnVictoryAnimation())
         {
            Root.assets.removeSound("firework");
            Root.assets.removeSound("pre_firework");
         }
         if(InstanceMng.getFacebookPlugin() != null && InstanceMng.getFacebookPlugin().isSessionOpen() || InstanceMng.getApplication().isKongregateVersion())
         {
            if(InstanceMng.getUserDataMng())
            {
               InstanceMng.getUserDataMng().updateFriendsInfo();
            }
         }
         Root.assets.removeTexture(mBGName);
         var _loc1_:BackgroundDef = BackgroundDef(InstanceMng.getBackgroundDefMng().getDefBySku(mBGName));
         if(Config.getConfig().battleShowBGHighlights())
         {
            if(_loc1_)
            {
               _loc17_ = _loc1_.getHighlightsBGName();
               if(_loc17_ != null && _loc17_ != "")
               {
                  Root.assets.removeTexture(_loc17_);
               }
            }
         }
         if(_loc1_ != null && _loc1_.getSocketPrefix() != "" && _loc1_.getSocketPrefix() != null)
         {
            Root.assets.removeTexture(_loc1_.getSocketPrefix() + "_off");
            Root.assets.removeTexture(_loc1_.getSocketPrefix() + "_on");
            if(Config.getConfig().battleUseDeckBG())
            {
               Root.assets.removeTexture(_loc1_.getCardHolderBG());
               Root.assets.removeTexture("card_holder_lock");
               InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("cardHolders",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
               if(Utils.isIOS())
               {
                  InstanceMng.getResourcesMng().removeSpecialScreenResources("cardHolders");
               }
            }
         }
         if(Config.getConfig().battleHasOwnMusic())
         {
            Utils.stopAllSounds(true);
            if(Config.smTracklistModeOn && Utils.isMusicOn())
            {
               Utils.addTrackList(InstanceMng.getResourcesMng().getSoundTrack());
               Utils.loadNextTrack();
            }
         }
         Utils.onPackUnfoldedCleanRewardEffect();
         if(Config.getConfig().getTutorialON())
         {
            InstanceMng.getTutorialMng().unload();
         }
         Utils.destroyObject(this.mBattleEngine);
         this.mBattleEngine = null;
         Utils.destroyArray(this.mBoostsItems);
         this.mBoostsItems = null;
         DictionaryUtils.clearDictionary(this.mOwnerSideDeckSocketCatalog);
         this.mOwnerSideDeckSocketCatalog = null;
         DictionaryUtils.clearDictionary(this.mOpponentSideDeckSocketCatalog);
         this.mOpponentSideDeckSocketCatalog = null;
         DictionaryUtils.clearDictionary(this.mOwnerBFSocketCatalog);
         this.mOwnerBFSocketCatalog = null;
         DictionaryUtils.clearDictionary(this.mOpponentBFSocketCatalog);
         this.mOpponentBFSocketCatalog = null;
         DictionaryUtils.clearDictionary(this.mOwnerSideDeckSocketSuggestCatalog);
         this.mOwnerSideDeckSocketSuggestCatalog = null;
         DictionaryUtils.clearDictionary(this.mOwnerBFSocketSuggestCatalog);
         this.mOwnerBFSocketSuggestCatalog = null;
         DictionaryUtils.clearDictionary(this.mOpponentBFSocketSuggestCatalog);
         this.mOpponentBFSocketSuggestCatalog = null;
         if(this.mTurnPanel)
         {
            this.mTurnPanel.removeFromParent(true);
            this.mTurnPanel = null;
         }
         super.unload();
      }
      
      protected function reset(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:RewardDef = null;
         var _loc6_:int = 0;
         var _loc7_:FSTextfield = null;
         var _loc8_:FSImage = null;
         var _loc9_:FSTextfield = null;
         var _loc10_:FSImage = null;
         if(!param1)
         {
            if(this.mBloodScreen)
            {
               this.mBloodScreen.removeFromParent(true);
               this.mBloodScreen = null;
            }
            if(InstanceMng.getConversationsMng())
            {
               InstanceMng.getConversationsMng().unload();
            }
            if(this.mOwnerActionPointsCounter)
            {
               this.mOwnerActionPointsCounter.removeFromParent(true);
               this.mOwnerActionPointsCounter = null;
            }
            if(this.mOpponentActionPointsCounter)
            {
               this.mOpponentActionPointsCounter.removeFromParent(true);
               this.mOpponentActionPointsCounter = null;
            }
            if(this.mBGHighlights)
            {
               this.mBGHighlights.removeFromParent(true);
               this.mBGHighlights = null;
            }
            if(this.mOwnerPortrait)
            {
               this.mOwnerPortrait.unload();
               this.mOwnerPortrait.removeFromParent(true);
               this.mOwnerPortrait = null;
            }
            if(this.mOpponentPortrait)
            {
               this.mOpponentPortrait.unload();
               this.mOpponentPortrait.removeFromParent(true);
               this.mOpponentPortrait = null;
            }
            if(this.mAttackButton)
            {
               this.mAttackButton.removeFromParent(true);
               this.mAttackButton = null;
            }
            if(this.mTurnPanel)
            {
               this.mTurnPanel.unload();
            }
            if(this.mBoostsContainer != null)
            {
               this.mBoostsContainer.removeChildren(0,-1,true);
               this.mBoostsContainer = null;
            }
            if(this.mBoostsItems != null)
            {
               this.disposeBoostsItems();
               this.mBoostsItems.length = 0;
               this.mBoostsItems = null;
            }
            if(this.mAbilitiesChooserPanel)
            {
               this.mAbilitiesChooserPanel.removeFromParent(true);
               this.mAbilitiesChooserPanel = null;
            }
            if(this.mObjectivesPanel)
            {
               this.mObjectivesPanel.removeFromParent(true);
               this.mObjectivesPanel = null;
            }
            if(this.mTurnsCounter)
            {
               this.mTurnsCounter.removeFromParent(true);
               this.mTurnsCounter = null;
            }
            this.mRowsAmount = 0;
            this.mColumnsAmount = 0;
            if(this.mOwnerDeckAreaBG)
            {
               this.mOwnerDeckAreaBG.removeFromParent(true);
               this.mOwnerDeckAreaBG = null;
            }
            if(this.mOwnerDeckAreaBGLocked)
            {
               this.mOwnerDeckAreaBGLocked.removeFromParent(true);
               this.mOwnerDeckAreaBGLocked = null;
            }
            if(this.mOwnerSacrificeImage)
            {
               this.mOwnerSacrificeImage.removeFromParent(true);
               this.mOwnerSacrificeImage = null;
            }
            if(this.mOpponentSacrificeImage)
            {
               this.mOpponentSacrificeImage.removeFromParent(true);
               this.mOpponentSacrificeImage = null;
            }
            if(this.mDungeonCardsCounter)
            {
               this.mDungeonCardsCounter.removeFromParent(true);
               this.mDungeonCardsCounter = null;
            }
            if(this.mDungeonGoldCounter)
            {
               this.mDungeonGoldCounter.removeFromParent(true);
               this.mDungeonGoldCounter = null;
            }
            if(this.mAIEvent)
            {
               this.mAIEvent.removeFromParent(true);
               this.mAIEvent = null;
            }
            if(this.mAIPower)
            {
               this.mAIPower.removeFromParent(true);
               this.mAIPower = null;
            }
         }
         if(this.mFreeShuffleButton)
         {
            this.mFreeShuffleButton.removeFromParent(true);
            this.mFreeShuffleButton = null;
         }
         if(this.mMinScoreReachedStar)
         {
            this.mMinScoreReachedStar.removeFromParent(true);
            this.mMinScoreReachedStar = null;
         }
         if(this.mMedScoreReachedStar)
         {
            this.mMedScoreReachedStar.removeFromParent(true);
            this.mMedScoreReachedStar = null;
         }
         if(this.mMaxScoreReachedStar)
         {
            this.mMaxScoreReachedStar.removeFromParent(true);
            this.mMaxScoreReachedStar = null;
         }
         if(this.mPhysicalDeckOwner)
         {
            this.mPhysicalDeckOwner.removeFromParent(true);
            this.mPhysicalDeckOwner = null;
         }
         if(this.mPhysicalDeckOpponent)
         {
            this.mPhysicalDeckOpponent.removeFromParent(true);
            this.mPhysicalDeckOpponent = null;
         }
         if(this.mScoresStarsContainer)
         {
            this.mScoresStarsContainer.removeFromParent(true);
            this.mScoresStarsContainer = null;
         }
         if(this.mVictoryAnimation)
         {
            this.mVictoryAnimation.removeFromParent(true);
            this.mVictoryAnimation = null;
         }
         if(this.mDefeatAnimation)
         {
            this.mDefeatAnimation.removeFromParent(true);
            this.mDefeatAnimation = null;
         }
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc3_ = Boolean(this.mBattleEngine) && Boolean(this.mBattleEngine.getLevelDef()) ? LevelDef(this.mBattleEngine.getLevelDef()).getMapWorldParentIndex() : 0;
            _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc4_);
            _loc5_ = Boolean(this.mBattleEngine) && Boolean(this.mBattleEngine.getLevelDef()) ? RewardDef(InstanceMng.getRewardsDefMng().getDefBySku(this.mBattleEngine.getLevelDef().getRewardSkuByDifficulty(_loc2_,_loc4_))) : null;
            if(_loc5_ != null)
            {
               DictionaryUtils.disposeCatalogCards(_loc5_.getCards(),param1,true);
            }
         }
         if(this.mOwnerPortrait)
         {
            this.mOwnerPortrait.unload();
         }
         if(this.mOpponentPortrait)
         {
            this.mOpponentPortrait.unload();
         }
         if(this.mOwnerPowerImage)
         {
            this.mOwnerPowerImage.removeFromParent(true);
            this.mOwnerPowerImage = null;
         }
         if(this.mOwnerPowerMc)
         {
            Starling.juggler.remove(this.mOwnerPowerMc);
            this.mOwnerPowerMc.removeFromParent(true);
            this.mOwnerPowerMc = null;
         }
         if(this.mOwnerPowerSummonIcon)
         {
            this.mOwnerPowerSummonIcon.removeFromParent(true);
            this.mOwnerPowerSummonIcon = null;
         }
         if(this.mOwnerPowerSummonSuggestBG)
         {
            this.mOwnerPowerSummonSuggestBG.removeFromParent(true);
            this.mOwnerPowerSummonSuggestBG = null;
         }
         if(this.mOwnerPowerSummonTextfield)
         {
            this.mOwnerPowerSummonTextfield.removeFromParent(true);
            this.mOwnerPowerSummonTextfield = null;
         }
         if(this.mOpponentPowerImage)
         {
            this.mOpponentPowerImage.removeFromParent(true);
            this.mOpponentPowerImage = null;
         }
         if(this.mOpponentPowerMc)
         {
            Starling.juggler.remove(this.mOpponentPowerMc);
            this.mOpponentPowerMc.removeFromParent(true);
            this.mOpponentPowerMc = null;
         }
         if(this.mAttackAnimationMC)
         {
            Starling.juggler.remove(this.mAttackAnimationMC);
            this.mAttackAnimationMC.removeFromParent(true);
            this.mAttackAnimationMC = null;
         }
         if(this.mOpponentPowerSummonIcon)
         {
            this.mOpponentPowerSummonIcon.removeFromParent(true);
            this.mOpponentPowerSummonIcon = null;
         }
         if(this.mOpponentPowerSummonSuggestBG)
         {
            this.mOpponentPowerSummonSuggestBG.removeFromParent(true);
            this.mOpponentPowerSummonSuggestBG = null;
         }
         if(this.mOpponentPowerSummonTextfield)
         {
            this.mOpponentPowerSummonTextfield.removeFromParent(true);
            this.mOpponentPowerSummonTextfield = null;
         }
         if(this.mOwnerGraveyardButton)
         {
            this.mOwnerGraveyardButton.removeFromParent(true);
            this.mOwnerGraveyardButton = null;
         }
         if(this.mOwnerGraveyardViewer)
         {
            this.mOwnerGraveyardViewer.removeFromParent(true);
            this.mOwnerGraveyardViewer = null;
         }
         if(this.mOpponentGraveyardButton)
         {
            this.mOpponentGraveyardButton.removeFromParent(true);
            this.mOpponentGraveyardButton = null;
         }
         if(this.mOpponentGraveyardViewer)
         {
            this.mOpponentGraveyardViewer.removeFromParent(true);
            this.mOpponentGraveyardViewer = null;
         }
         if(Boolean(this.mAttachedAnimationsVector) && !param1)
         {
            _loc6_ = 0;
            while(_loc6_ < this.mAttachedAnimationsVector.length)
            {
               this.mAttachedAnimationsVector[_loc6_].removeFromParent(true);
               _loc6_++;
            }
            this.mAttachedAnimationsVector.length = 0;
            this.mAttachedAnimationsVector = null;
         }
         if(this.mOwnerEmblemsTextfieldVector)
         {
            for each(_loc7_ in this.mOwnerEmblemsTextfieldVector)
            {
               _loc7_.removeFromParent(true);
               _loc7_ = null;
            }
            this.mOwnerEmblemsTextfieldVector.length = 0;
            this.mOwnerEmblemsTextfieldVector = null;
         }
         if(this.mOwnerEmblemsVector)
         {
            for each(_loc8_ in this.mOwnerEmblemsVector)
            {
               if(_loc8_)
               {
                  _loc8_.removeFromParent(true);
                  _loc8_ = null;
               }
            }
            this.mOwnerEmblemsVector.length = 0;
            this.mOwnerEmblemsVector = null;
         }
         if(this.mOpponentEmblemsTextfieldVector)
         {
            for each(_loc9_ in this.mOpponentEmblemsTextfieldVector)
            {
               if(_loc9_)
               {
                  _loc9_.removeFromParent(true);
                  _loc9_ = null;
               }
            }
            this.mOpponentEmblemsTextfieldVector.length = 0;
            this.mOpponentEmblemsTextfieldVector = null;
         }
         if(this.mOpponentEmblemsVector)
         {
            for each(_loc10_ in this.mOpponentEmblemsVector)
            {
               if(_loc10_)
               {
                  _loc10_.removeFromParent(true);
                  _loc10_ = null;
               }
            }
            this.mOpponentEmblemsVector.length = 0;
            this.mOpponentEmblemsVector = null;
         }
         DictionaryUtils.disposeCatalogCards(this.mOwnerSideDeckSocketCatalog,param1);
         DictionaryUtils.disposeCatalogCards(this.mOwnerBFSocketCatalog,param1);
         DictionaryUtils.disposeCatalogCards(this.mOpponentBFSocketCatalog,param1);
         DictionaryUtils.disposeCatalogCards(this.mOwnerSideDeckSocketSuggestCatalog,param1);
         DictionaryUtils.disposeCatalogCards(this.mOwnerBFSocketSuggestCatalog,param1);
         DictionaryUtils.disposeCatalogCards(this.mOpponentBFSocketSuggestCatalog,param1);
         if(Boolean(this.mBattleEngine) && Boolean(this.mBattleEngine.getLevelDef()))
         {
            DictionaryUtils.disposeCatalogCards(this.mBattleEngine.getLevelDef().getAIUnits(_loc4_),param1,true);
            DictionaryUtils.disposeCatalogCards(this.mBattleEngine.getLevelDef().getAIAttachments(_loc4_),param1,true);
            DictionaryUtils.disposeCatalogCards(this.mBattleEngine.getLevelDef().getAIActions(_loc4_),param1,true);
            DictionaryUtils.disposeCatalogCards(this.mBattleEngine.getLevelDef().getAIEasyUnits(_loc4_),param1,true);
            DictionaryUtils.disposeCatalogCards(this.mBattleEngine.getLevelDef().getAIEasyAttachments(_loc4_),param1,true);
            DictionaryUtils.disposeCatalogCards(this.mBattleEngine.getLevelDef().getAIEasyActions(_loc4_),param1,true);
         }
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            DictionaryUtils.disposeCatalogCards(InstanceMng.getUserDataMng().getOwnerUserData().getSelectedDeck(),param1,true);
         }
         DictionaryUtils.clearDictionary(this.mOwnerSideDeckSocketCatalog);
         this.mOwnerSideDeckSocketCatalog = null;
         DictionaryUtils.clearDictionary(this.mOwnerBFSocketCatalog);
         this.mOwnerBFSocketCatalog = null;
         DictionaryUtils.clearDictionary(this.mOpponentBFSocketCatalog);
         this.mOpponentBFSocketCatalog = null;
         DictionaryUtils.clearDictionary(this.mOwnerSideDeckSocketSuggestCatalog);
         this.mOwnerSideDeckSocketSuggestCatalog = null;
         DictionaryUtils.clearDictionary(this.mOwnerBFSocketSuggestCatalog);
         this.mOwnerBFSocketSuggestCatalog = null;
         DictionaryUtils.clearDictionary(this.mOpponentBFSocketSuggestCatalog);
         this.mOpponentBFSocketSuggestCatalog = null;
         this.updateCurrentTurnsTextfield();
         if(this.mBattleEngine)
         {
            this.mBattleEngine.reset(param1);
         }
         this.mBattleEngine.destroy();
         this.mBattleEngine = null;
         this.setSelectedCard(null);
         this.mCardAnimsON = false;
         this.mOwnerCardDealingPoint = null;
         this.mOpponentCardDealingPoint = null;
         Utils.removeLog();
      }
      
      public function createVictoryAnimation(param1:Number = 1, param2:Function = null, param3:Array = null) : void
      {
         var _loc5_:Texture = null;
         var _loc4_:Number = 0.6 * Utils.getDefaultSpeedTime();
         createTranslucentBG(true,0.75,_loc4_);
         if(this.mVictoryAnimation == null)
         {
            _loc5_ = this.mBattleEngine.getOwnerBattleInfo().getUserBattlePortrait().getCharacterCurrentTexture();
            this.mVictoryAnimation = new FSVictoryAnimation(_loc5_,param2,param3,true);
         }
         this.mVictoryAnimationON = true;
         this.mVictoryAnimation.x = Starling.current.stage.stageWidth / 2;
         this.mVictoryAnimation.y = Starling.current.stage.stageHeight / 2;
         addChild(this.mVictoryAnimation);
         this.mVictoryAnimation.performFadeIn();
         TweenMax.delayedCall(param1,this.removeVictoryAnimation);
      }
      
      public function skipDefeatAnimation() : void
      {
         if(this.mDefeatAnimationON && Boolean(this.mDefeatAnimation))
         {
            this.removeDefeatAnimation(true);
         }
      }
      
      public function skipVictoryAnimation() : void
      {
         if(Boolean(this.mVictoryAnimation) && this.mVictoryAnimationON)
         {
            this.removeVictoryAnimation(true);
         }
      }
      
      public function removeVictoryAnimation(param1:Boolean = false) : void
      {
         TweenMax.killDelayedCallsTo(this.removeVictoryAnimation);
         var _loc2_:Number = param1 ? 0 : 0.5 * Utils.getDefaultSpeedTime();
         if(Boolean(this.mVictoryAnimation) && Boolean(contains(this.mVictoryAnimation)) && this.mVictoryAnimation.isShown())
         {
            this.mVictoryAnimation.performFadeOut(_loc2_);
         }
         TweenMax.delayedCall(_loc2_,this.onVictoryAnimRemoved);
         this.mVictoryAnimationON = false;
      }
      
      public function onVictoryAnimRemoved() : void
      {
         if(mTransparentBGShown)
         {
            this.removeTranslucentBG(false,true);
         }
         this.mVictoryAnimation = null;
      }
      
      public function createDefeatAnimation(param1:Number = 1, param2:Function = null, param3:Array = null) : void
      {
         var speed:Number = NaN;
         var ownerCharTexture:Texture = null;
         var fadeOffDelay:Number = param1;
         var onFadeOffFunction:Function = param2;
         var onFadeOffParams:Array = param3;
         var onIssuePerformExit:Function = function():void
         {
            if(onFadeOffFunction != null)
            {
               if(onFadeOffParams != null)
               {
                  onFadeOffFunction.apply(null,onFadeOffParams);
               }
               else
               {
                  onFadeOffFunction();
               }
            }
         };
         if(Boolean(this.mBattleEngine) && Boolean(this.mBattleEngine.getOwnerBattleInfo()) && Boolean(this.mBattleEngine.getOwnerBattleInfo().getUserBattlePortrait()))
         {
            speed = 0.6 * Utils.getDefaultSpeedTime();
            createTranslucentBG(true,speed);
            if(this.mDefeatAnimation == null)
            {
               ownerCharTexture = this.mBattleEngine.getOwnerBattleInfo().getUserBattlePortrait().getCharacterCurrentTexture();
               if(ownerCharTexture)
               {
                  this.mDefeatAnimation = new FSDefeatAnimation(ownerCharTexture,onFadeOffFunction,onFadeOffParams);
               }
            }
            if(this.mDefeatAnimation)
            {
               this.mDefeatAnimationON = true;
               addChild(this.mDefeatAnimation);
               this.mDefeatAnimation.x = Starling.current.stage.stageWidth / 2;
               this.mDefeatAnimation.y = Starling.current.stage.stageHeight / 2;
               this.mDefeatAnimation.performFadeIn();
               TweenMax.delayedCall(fadeOffDelay,this.removeDefeatAnimation);
            }
            else
            {
               this.removeDefeatAnimation(true);
               onIssuePerformExit();
            }
         }
         else
         {
            onIssuePerformExit();
         }
      }
      
      public function removeDefeatAnimation(param1:Boolean = false) : void
      {
         TweenMax.killDelayedCallsTo(this.removeDefeatAnimation);
         var _loc2_:Number = param1 ? 0 : 0.5 * Utils.getDefaultSpeedTime();
         if(Boolean(this.mDefeatAnimation) && Boolean(contains(this.mDefeatAnimation)) && this.mDefeatAnimation.isShown())
         {
            this.mDefeatAnimation.performFadeOut(_loc2_);
         }
         TweenMax.delayedCall(_loc2_,this.onDefeatAnimRemoved);
         this.mDefeatAnimationON = false;
      }
      
      public function onDefeatAnimRemoved() : void
      {
         if(mTransparentBGShown)
         {
            this.removeTranslucentBG(false,true);
         }
         this.mDefeatAnimation = null;
      }
      
      override protected function setupParticleFX() : void
      {
      }
      
      override protected function setupExtraParticleFX() : void
      {
      }
      
      protected function createAttackButton() : void
      {
         if(mBG)
         {
            if(this.mAttackButton == null)
            {
               this.mAttackButton = new FSAttackButton();
               if(!Config.getConfig().attackButtonHasBG())
               {
                  this.mAttackButton.x = this.mAttackButton.width / 2;
                  addChild(this.mAttackButton);
               }
               else
               {
                  this.mAttackButton.x = 0;
                  addChild(this.mAttackButton);
                  addChild(this.mOwnerPortrait);
                  addChild(this.mOpponentPortrait);
               }
            }
            this.mAttackButton.y = Config.getConfig().battleHasSimpleUI() ? this.mOwnerPortrait.y - this.mAttackButton.height / 1.35 : (this.mAttackButton.y = mBG.height / 2);
            addChild(this.mAttackButton);
            if(this.mObjectivesPanel)
            {
               addChild(this.mObjectivesPanel);
            }
            if(this.mTurnsCounter)
            {
               addChild(this.mTurnsCounter);
               if(this.mTurnsCounter.getProgressBar())
               {
                  addChild(this.mTurnsCounter.getProgressBar());
               }
            }
         }
      }
      
      public function showAttackButton() : void
      {
         this.createAttackButton();
         if(this.mBattleEngine.getPlayersStateId() == BattleEngine.STATE_OWNER_MOVING_CARDS)
         {
            this.mBattleEngine.enableAttackButton();
         }
         else
         {
            this.mBattleEngine.disableAttackButton();
         }
      }
      
      protected function createPhysicalDecks() : void
      {
         var _loc1_:Boolean = Config.getConfig().gameShowsPhysicalCardsDeck();
         if(!_loc1_)
         {
            return;
         }
         if(this.mPhysicalDeckOwner == null)
         {
            this.mPhysicalDeckOwner = new FSImage(Root.assets.getTexture("bf_deck"));
            this.mPhysicalDeckOwner.touchable = false;
            this.mPhysicalDeckOwner.alignPivot();
            this.mPhysicalDeckOwner.x = 0;
            this.mPhysicalDeckOwner.y = this.mAttackButton ? this.mAttackButton.y + this.mAttackButton.height : Starling.current.stage.stageHeight / 2 + this.mPhysicalDeckOwner.height / 2;
            this.mPhysicalDeckOwner.rotation = deg2rad(90);
            addChild(this.mPhysicalDeckOwner);
         }
         if(this.mBattleEngine.isPvPMatch())
         {
            if(this.mPhysicalDeckOpponent == null)
            {
               this.mPhysicalDeckOpponent = new FSImage(Root.assets.getTexture("bf_deck"));
               this.mPhysicalDeckOpponent.touchable = false;
               this.mPhysicalDeckOpponent.alignPivot();
               this.mPhysicalDeckOpponent.x = 0;
               this.mPhysicalDeckOpponent.y = this.mAttackButton ? this.mAttackButton.y - this.mAttackButton.height : Starling.current.stage.stageHeight / 2 - this.mPhysicalDeckOwner.height / 2;
               this.mPhysicalDeckOpponent.rotation = deg2rad(90);
               addChild(this.mPhysicalDeckOpponent);
               if(this.mOpponentPortrait)
               {
                  addChild(this.mOpponentPortrait);
               }
            }
         }
      }
      
      public function updateCurrentTurnsTextfield() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(InstanceMng.getTargetMng())
         {
            _loc1_ = InstanceMng.getTargetMng().getCurrentLevelRequiredTurns();
            if(_loc1_ > 0 && this.mTurnsCounter != null && Boolean(this.mBattleEngine))
            {
               _loc2_ = this.mBattleEngine.getCurrentTurnId();
               if(!isNaN(_loc2_))
               {
                  this.mTurnsCounter.updateCounterAmount((_loc1_ + 1 - this.mBattleEngine.getCurrentTurnId()).toString());
               }
            }
         }
      }
      
      public function showObjectivesPanel() : void
      {
         this.createOwnerActionPointsCounter();
         this.createOpponentActionPointsCounter();
         this.updateObjectivesProgress();
      }
      
      public function updateObjectivesProgress() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Dictionary = null;
         var _loc8_:Array = null;
         if(Boolean(InstanceMng.getTargetMng()) && Boolean(this.mBattleEngine))
         {
            _loc1_ = InstanceMng.getTargetMng().getObjectivesCatalog(this.mBattleEngine.getLevelDef());
            if(_loc1_ != null && Boolean(this.mObjectivesPanel))
            {
               _loc2_ = new Object();
               _loc2_.sku = "MAIN";
               _loc2_.text = InstanceMng.getTargetMng().getMainObjectiveText() ? InstanceMng.getTargetMng().getMainObjectiveText().toUpperCase() : "";
               this.mObjectivesPanel.setObjectivesText(TargetMng.MAIN_SUBOBJECTIVE,_loc2_);
               _loc3_ = DictionaryUtils.getKeys(_loc1_);
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc6_ = int(_loc3_[_loc4_]);
                  _loc7_ = _loc1_[_loc6_];
                  if(_loc7_ != null)
                  {
                     _loc8_ = InstanceMng.getTargetMng().getObjectiveText(_loc7_,_loc6_,false);
                     _loc5_ = 0;
                     while(_loc5_ < _loc8_.length)
                     {
                        this.mObjectivesPanel.setObjectivesText(_loc6_,_loc8_[_loc5_]);
                        _loc5_++;
                     }
                  }
                  _loc4_++;
               }
            }
            this.updateObjectivesPanelPosition();
         }
      }
      
      protected function updateObjectivesPanelPosition() : void
      {
      }
      
      protected function createOwnerActionPointsCounter() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:FSImage = null;
         var _loc4_:int = 0;
         if(this.mBattleEngine)
         {
            if(this.mOwnerActionPointsCounter == null)
            {
               this.mOwnerActionPointsCounter = new ActionPointsCounter(true);
               _loc1_ = this.mBattleEngine.getLevelDef().getActionPointsPerTurn();
               _loc2_ = this.mBattleEngine.getOwnerBattleInfo().getAPGenerated();
               _loc1_ += _loc2_;
               this.mOwnerActionPointsCounter.setFullAPAmount(_loc1_);
               this.updateActionPointsLeft(true);
               if(!Config.getConfig().battleHasSimpleUI())
               {
                  if(this.mOwnerActionPointsCounter.getAPShowMode() == ActionPointsCounter.AP_MODE_TEXTFIELD)
                  {
                     _loc3_ = this.mOwnerPortrait.getPortrait();
                     this.mOwnerActionPointsCounter.x = this.mOwnerPortrait.x + _loc3_.x;
                     this.mOwnerActionPointsCounter.y = this.mOwnerPortrait.y + this.mOwnerPortrait.getPlayerHPCover().y - this.mOwnerActionPointsCounter.height / 2;
                  }
                  else
                  {
                     this.mOwnerActionPointsCounter.x = this.getActionPointsCounterPosX();
                     this.mOwnerActionPointsCounter.y = mBG.height / 2 + this.mOwnerActionPointsCounter.height / 2;
                  }
               }
               else
               {
                  this.mOwnerActionPointsCounter.x = this.mOwnerPortrait.getPlayerHPCover().x - this.mOwnerActionPointsCounter.width / 5;
                  this.mOwnerActionPointsCounter.y = this.mOwnerPortrait.y + this.mOwnerPortrait.getPlayerHPCover().y - this.mOwnerActionPointsCounter.height / 5;
               }
               this.mOwnerActionPointsCounter.refreshAnimationPosition();
            }
            if(!InstanceMng.getApplication().isGuildsPanelOpen())
            {
               this.updateActionPointsLeft(false);
               if(!Config.getConfig().battleHasSimpleUI())
               {
                  _loc4_ = getChildIndex(this.mOwnerPortrait);
                  _loc4_ = _loc4_ > 0 ? int(_loc4_ - 1) : _loc4_;
                  addChildAt(this.mOwnerActionPointsCounter,_loc4_);
               }
               else
               {
                  addChild(this.mOwnerActionPointsCounter);
               }
            }
         }
      }
      
      private function getActionPointsCounterPosX() : Number
      {
         var _loc1_:int = Config.getConfig().getActionPointsShowMode();
         if(_loc1_ == ActionPointsCounter.AP_MODE_PROG_BAR_TEXTFIELD)
         {
            return Starling.current.stage.stageWidth * 0.215;
         }
         return Starling.current.stage.stageWidth * 0.39;
      }
      
      protected function createOpponentActionPointsCounter() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:FSImage = null;
         var _loc4_:int = 0;
         if(this.mBattleEngine)
         {
            if(this.mOpponentActionPointsCounter == null)
            {
               this.mOpponentActionPointsCounter = new ActionPointsCounter(false);
               _loc1_ = this.mBattleEngine.isPvPMatch() ? this.mBattleEngine.getLevelDef().getActionPointsPerTurn() : this.mBattleEngine.getLevelDef().getAIActionPointsPerTurn();
               _loc2_ = this.mBattleEngine.getOpponentBattleInfo().getAPGenerated();
               _loc1_ += _loc2_;
               this.mOpponentActionPointsCounter.setFullAPAmount(_loc1_);
               this.updateActionPointsLeft(true);
               if(!Config.getConfig().battleHasSimpleUI())
               {
                  if(this.mOpponentActionPointsCounter.getAPShowMode() == ActionPointsCounter.AP_MODE_TEXTFIELD)
                  {
                     _loc3_ = this.mOpponentPortrait.getPortrait();
                     this.mOpponentActionPointsCounter.x = this.mOpponentPortrait.x + _loc3_.x;
                     this.mOpponentActionPointsCounter.y = this.mOpponentPortrait.y + this.mOpponentPortrait.getPlayerHPCover().y - this.mOwnerActionPointsCounter.height / 2;
                  }
                  else
                  {
                     this.mOpponentActionPointsCounter.x = this.getActionPointsCounterPosX();
                     this.mOpponentActionPointsCounter.y = mBG.height / 2 - this.mOpponentActionPointsCounter.height / 2 * 1.7;
                  }
               }
               else
               {
                  this.mOpponentActionPointsCounter.x = this.mOpponentPortrait.getPlayerHPCover().x - this.mOpponentActionPointsCounter.width / 5;
                  this.mOpponentActionPointsCounter.y = this.mOpponentPortrait.y + this.mOpponentPortrait.getPlayerHPCover().y - this.mOpponentActionPointsCounter.height / 5;
               }
               this.mOpponentActionPointsCounter.refreshAnimationPosition();
            }
            if(!contains(this.mOpponentActionPointsCounter))
            {
               this.updateActionPointsLeft(true);
               if(!Config.getConfig().battleHasSimpleUI())
               {
                  _loc4_ = getChildIndex(this.mOpponentPortrait);
                  _loc4_ = _loc4_ > 0 ? int(_loc4_ - 1) : _loc4_;
                  addChildAt(this.mOpponentActionPointsCounter,_loc4_);
               }
               else
               {
                  addChild(this.mOpponentActionPointsCounter);
               }
            }
         }
      }
      
      public function updateActionPointsLeft(param1:Boolean = false) : void
      {
         var levelDef:LevelDef = null;
         var forceUpdate:Boolean = param1;
         var calculateAPsLeft:Function = function(param1:Boolean):void
         {
            var _loc3_:UserBattleInfo = null;
            var _loc4_:int = 0;
            var _loc5_:int = 0;
            var _loc6_:int = 0;
            var _loc7_:int = 0;
            var _loc8_:Boolean = false;
            var _loc2_:ActionPointsCounter = param1 ? mOwnerActionPointsCounter : mOpponentActionPointsCounter;
            if(_loc2_)
            {
               _loc3_ = param1 ? mBattleEngine.getOwnerBattleInfo() : mBattleEngine.getOpponentBattleInfo();
               _loc4_ = param1 ? levelDef.getActionPointsPerTurn() : levelDef.getAIActionPointsPerTurn();
               _loc5_ = _loc3_.getActionPointsLeft();
               _loc6_ = _loc3_.getNextTurnExtraActionPoints();
               _loc7_ = _loc3_.getAPGenerated();
               _loc4_ += _loc7_;
               if(_loc5_ == _loc4_ && _loc6_ > 0)
               {
                  _loc2_.setAPLeft(_loc5_ + _loc6_);
               }
               _loc8_ = _loc5_ == _loc4_ + _loc6_;
               _loc2_.updateActionPointsLeft(_loc5_,_loc8_);
            }
         };
         levelDef = this.mBattleEngine ? this.mBattleEngine.getLevelDef() : null;
         var isOwnerTurn:Boolean = this.mBattleEngine.isOwnerTurn();
         if(forceUpdate)
         {
            calculateAPsLeft(true);
            calculateAPsLeft(false);
         }
         else
         {
            calculateAPsLeft(isOwnerTurn);
         }
      }
      
      public function dealOwnerCardsToDeck(param1:Boost = null, param2:String = "", param3:Boolean = false) : void
      {
         var _loc4_:FSCard = null;
         var _loc7_:FSCardSocket = null;
         var _loc9_:Number = NaN;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:AbilityDef = null;
         var _loc16_:FSCoordinate = null;
         var _loc17_:Boolean = false;
         var _loc18_:Function = null;
         var _loc19_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:UserBattleInfo = this.mBattleEngine.getOwnerBattleInfo();
         if(_loc8_ != null)
         {
            _loc10_ = this.mBattleEngine.getNextHandDealTopCards();
            _loc11_ = this.mBattleEngine.getNextHandIncreasesRank() != -1;
            if(_loc10_)
            {
               Utils.setLogText(TextManager.getText("TID_BOOST_BEST_HAND_DEALING"));
            }
            if(Boolean(param1) && this.mBattleEngine.getBoostWaitingForResource() != null)
            {
               this.mBattleEngine.resetBoostWaitingForResource();
            }
            _loc12_ = InstanceMng.getBattleEngine().getNextHand(null,param2);
            if(_loc12_)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc12_.length)
               {
                  _loc4_ = InstanceMng.getCardsMng().createCard(_loc12_[_loc5_]);
                  if(_loc4_ != null)
                  {
                     _loc4_.setParentUserBattleInfo(_loc8_);
                     _loc15_ = _loc4_.getCostModifierAbilityDef();
                     if(_loc15_)
                     {
                        _loc4_.updateSummonCost(_loc15_);
                     }
                     _loc11_ = this.mBattleEngine.getNextHandIncreasesRank() != -1;
                     addChild(_loc4_);
                     _loc13_ = param2 != "" ? _loc8_.getPlayableCardsUsedInTurn() : _loc5_;
                     _loc4_.setPlayableCardId(_loc13_);
                     _loc14_ = this.getFirstEmptyDeckSocketIndex(true);
                     _loc8_.addPlayableCard(_loc4_);
                     _loc7_ = this.getCardSocketByIndex(_loc14_,this.mOwnerSideDeckSocketCatalog);
                     _loc4_.setAttachedToSocket(_loc7_,true);
                     _loc4_.setBattleSceneParent(this);
                     _loc16_ = this.getSocketWorldCoordsByIndex(_loc14_,this.mOwnerSideDeckSocketCatalog);
                     _loc16_.setX(_loc16_.getX());
                     _loc16_.setY(_loc16_.getY());
                     _loc17_ = _loc5_ == _loc12_.length - 1;
                     _loc18_ = null;
                     _loc19_ = null;
                     if(_loc17_ && param2 == "")
                     {
                        if(param1 != null)
                        {
                           _loc18_ = this.executeBoost;
                           _loc19_ = [param1];
                        }
                        else
                        {
                           _loc18_ = param3 ? this.enableAfterFreeReshuffle : this.battleEngineChangePlayersState;
                        }
                     }
                     else
                     {
                        _loc18_ = null;
                     }
                     if(_loc11_)
                     {
                        if(_loc4_.isUnit() && !_loc4_.isTopTier())
                        {
                           _loc4_.promoteCardFree(this.mBattleEngine.getNextHandIncreasesRank());
                           this.mBattleEngine.setNextHandIncreasesRank(-1);
                        }
                     }
                     _loc9_ = this.getDealCardSpeed(true,_loc5_);
                     this.performCardDealFX(_loc4_,_loc16_,_loc9_,_loc7_,_loc18_,_loc19_);
                     _loc6_++;
                  }
                  _loc5_++;
               }
            }
            if(_loc6_ == 0)
            {
               if(param1 != null)
               {
                  param1.onExecuted();
               }
               else if(!param3)
               {
                  this.mBattleEngine.changePlayersState();
               }
               else
               {
                  this.enableAfterFreeReshuffle();
               }
            }
         }
         if(_loc10_)
         {
            this.mBattleEngine.setNextHandDealTopCards(false);
         }
         InstanceMng.getBattleEngine().resetNextHandArr();
         if(Config.TRACE_BATTLE_LOGS)
         {
            FSDebug.debugTrace("[dealOwnerCardsToDeck] - Owner\'s cards dealed");
         }
      }
      
      public function getDealCardSpeed(param1:Boolean, param2:Number = -1) : Number
      {
         var _loc3_:Number = 1.5;
         var _loc4_:Number = 0.125;
         var _loc5_:Number = 0.67;
         var _loc6_:Number = 1;
         var _loc7_:Number = _loc3_ * _loc6_;
         return _loc7_ * (param1 ? param2 * _loc4_ : _loc5_);
      }
      
      public function performCardDealFX(param1:FSCard, param2:FSCoordinate, param3:Number, param4:FSCardSocket, param5:Function, param6:Array = null) : Number
      {
         var onCardPlaced:Function = null;
         var isEnemyCard:Boolean = false;
         var coverCanVanish:Boolean = false;
         var pointToUse:Point = null;
         var gameShowsPhysicalDeck:Boolean = false;
         var speed:Number = NaN;
         var oldWidth:int = 0;
         var oldHeight:int = 0;
         var newScale:Number = NaN;
         var rotationY:Number = NaN;
         var tl:TimelineLite = null;
         var childIndex:int = 0;
         var card:FSCard = param1;
         var coord:FSCoordinate = param2;
         var delay:Number = param3;
         var cardSocket:FSCardSocket = param4;
         var onCompleteFunction:Function = param5;
         var onCompletedParams:Array = param6;
         onCardPlaced = function():void
         {
            Utils.playSound(Constants.SOUND_CARD_TO_BF,SoundManager.TYPE_SFX);
            card.activateDropShadow(true);
         };
         if(Boolean(card) && Boolean(coord) && Boolean(cardSocket))
         {
            isEnemyCard = card.isEnemyCard(true);
            coverCanVanish = !isEnemyCard || isEnemyCard && (!InstanceMng.getBattleEngine().isOnlineMatch() || BattleEngine.smShowOpponentCardsDeck);
            gameShowsPhysicalDeck = Config.getConfig().gameShowsPhysicalCardsDeck();
            if(isEnemyCard)
            {
               if(Boolean(this.mOpponentCardDealingPoint == null) && Boolean(this.mOpponentPortrait) && Boolean(this.mOpponentPortrait.getHPPlayerViewer()))
               {
                  if(!gameShowsPhysicalDeck)
                  {
                     this.mOpponentCardDealingPoint = this.mOpponentPortrait.localToGlobal(new Point(this.mOpponentPortrait.getHPPlayerViewer().x,this.mOpponentPortrait.getHPPlayerViewer().y));
                     this.mOpponentCardDealingPoint.x -= card.width;
                     this.mOpponentCardDealingPoint.y += this.mOpponentPortrait.getHPPlayerViewer().height / 2;
                  }
                  else
                  {
                     this.mOpponentCardDealingPoint = new Point(this.mPhysicalDeckOpponent.x,this.mPhysicalDeckOpponent.y);
                  }
               }
               pointToUse = this.mOpponentCardDealingPoint;
            }
            else
            {
               if(Boolean(this.mOwnerCardDealingPoint == null) && Boolean(this.mOwnerPortrait) && Boolean(this.mOwnerPortrait.getHPPlayerViewer()))
               {
                  if(!gameShowsPhysicalDeck)
                  {
                     this.mOwnerCardDealingPoint = this.mOwnerPortrait.localToGlobal(new Point(this.mOwnerPortrait.getHPPlayerViewer().x,this.mOwnerPortrait.getHPPlayerViewer().y));
                     this.mOwnerCardDealingPoint.x -= card.width;
                     this.mOwnerCardDealingPoint.y += this.mOwnerPortrait.getHPPlayerViewer().height / 2;
                  }
                  else
                  {
                     this.mOwnerCardDealingPoint = new Point(this.mPhysicalDeckOwner.x,this.mPhysicalDeckOwner.y);
                  }
               }
               pointToUse = this.mOwnerCardDealingPoint;
            }
            if(gameShowsPhysicalDeck)
            {
               childIndex = isEnemyCard ? getChildIndex(this.mPhysicalDeckOpponent) : getChildIndex(this.mPhysicalDeckOwner);
               addChildAt(card,childIndex);
            }
            card.x = pointToUse ? pointToUse.x : -card.width;
            card.y = pointToUse ? pointToUse.y : Starling.current.stage.stageHeight;
            speed = this.getDealCardSpeed(false);
            oldWidth = card.width;
            oldHeight = card.height;
            card.rotationZ = cardSocket.rotationZ;
            card.width = cardSocket.width;
            card.height = cardSocket.height;
            newScale = card.scale;
            card.rotationZ = 0;
            card.width = oldWidth * 0.78;
            card.height = oldHeight * 0.78;
            rotationY = deg2rad(-180);
            card.rotationY = rotationY;
            card.rotationZ = deg2rad(90);
            tl = new TimelineLite();
            TweenMax.delayedCall(delay,Utils.playSound,[Constants.SOUND_CARD_SLIDE,SoundManager.TYPE_SFX]);
            tl.to(card,speed / 5,{
               "x":card.x + card.width / 1.85,
               "delay":delay,
               "ease":Sine.easeIn,
               "onComplete":addChild,
               "onCompleteParams":[card]
            });
            tl.to(card,speed / 2,{
               "x":coord.getX(),
               "y":coord.getY(),
               "rotationX":deg2rad(0),
               "rotationY":(coverCanVanish ? deg2rad(0) : rotationY),
               "rotationZ":cardSocket.rotationZ,
               "scale":(coverCanVanish ? newScale : newScale * 1.15),
               "onComplete":onCompleteFunction,
               "onCompleteParams":onCompletedParams,
               "ease":Sine.easeOut
            });
            tl.call(onCardPlaced);
            return tl.totalDuration();
         }
         return 0;
      }
      
      public function getFirstEmptyDeckSocketIndex(param1:Boolean) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:FSCardSocket = null;
         var _loc2_:int = 0;
         var _loc3_:Dictionary = param1 ? this.mOwnerSideDeckSocketCatalog : this.mOpponentSideDeckSocketCatalog;
         if(_loc3_)
         {
            _loc4_ = 0;
            _loc5_ = this.mBattleEngine.getLevelDef() ? this.mBattleEngine.getLevelDef().getDeckCards() : 0;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(_loc3_[_loc4_] != null)
               {
                  _loc6_ = _loc3_[_loc4_];
               }
               if(Boolean(_loc6_) && _loc6_.isEmpty())
               {
                  return _loc4_;
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function enableAfterFreeReshuffle() : void
      {
         this.lockUI(false);
         this.enableBoostsPanel(true);
         showLoadingIcon(false,true);
         this.suggestPlayableCardON();
         if(this.mBattleEngine)
         {
            this.mBattleEngine.flagAsReshuffling(false);
         }
      }
      
      private function executeBoost(param1:Boost) : void
      {
         if(param1)
         {
            param1.onExecuted();
         }
      }
      
      public function dealOpponentCardsToDeck(param1:String = "") : void
      {
         var _loc4_:FSCard = null;
         var _loc5_:int = 0;
         var _loc6_:AbilityDef = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:UserBattleInfo = this.mBattleEngine.getOpponentBattleInfo();
         var _loc3_:int = 0;
         if(_loc2_ != null)
         {
            _loc7_ = InstanceMng.getBattleEngine().getNextHand(null,param1);
            if(_loc7_)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc7_.length)
               {
                  _loc4_ = InstanceMng.getCardsMng().createCard(_loc7_[_loc5_]);
                  _loc4_.setParentUserBattleInfo(this.mBattleEngine.getOpponentBattleInfo());
                  _loc6_ = _loc4_.getCostModifierAbilityDef();
                  if(_loc6_)
                  {
                     _loc4_.updateSummonCost(_loc6_);
                  }
                  if(_loc4_ != null)
                  {
                     _loc8_ = param1 != "" ? _loc2_.getPlayableCardsUsedInTurn() : _loc5_;
                     _loc4_.setPlayableCardId(_loc8_);
                     _loc9_ = this.getFirstEmptyDeckSocketIndex(false);
                     _loc2_.addPlayableCard(_loc4_);
                     _loc4_.setAttachedToSocket(null,true);
                     _loc4_.setBattleSceneParent(this);
                     _loc4_.x = -_loc4_.width;
                     _loc4_.y = Starling.current.stage.stageHeight * 0.33;
                     _loc3_++;
                  }
                  _loc5_++;
               }
            }
            this.mBattleEngine.changePlayersState();
         }
         InstanceMng.getBattleEngine().resetNextHandArr();
         if(Config.TRACE_BATTLE_LOGS)
         {
            FSDebug.debugTrace("[dealOpponentCardsToDeck] - " + _loc3_ + " Opponent\'s cards dealed");
         }
      }
      
      public function addCardToHand(param1:String) : void
      {
         var _loc2_:FSCard = null;
         var _loc4_:int = 0;
         var _loc5_:FSCardSocket = null;
         var _loc7_:AbilityDef = null;
         var _loc3_:UserBattleInfo = this.mBattleEngine.isOwnerTurn() ? this.mBattleEngine.getOwnerBattleInfo() : this.mBattleEngine.getOpponentBattleInfo();
         var _loc6_:Dictionary = this.mBattleEngine.isOwnerTurn() ? this.mOwnerSideDeckSocketCatalog : this.mOpponentSideDeckSocketCatalog;
         _loc2_ = InstanceMng.getCardsMng().createCard(param1);
         if(_loc2_ != null)
         {
            _loc2_.setParentUserBattleInfo(_loc3_);
            _loc7_ = _loc2_.getCostModifierAbilityDef();
            if(_loc7_)
            {
               _loc2_.updateSummonCost(_loc7_);
            }
            _loc4_ = this.getIndexCardSocketEmpty(_loc6_);
            _loc2_.setPlayableCardId(_loc4_);
            _loc3_.addPlayableCard(_loc2_);
            _loc5_ = this.getCardSocketByIndex(_loc4_,_loc6_);
            _loc2_.setAttachedToSocket(_loc5_,true);
            _loc2_.setBattleSceneParent(this);
            _loc2_.width = _loc5_.width;
            _loc2_.height = _loc5_.height;
            _loc2_.x = _loc5_.x;
            _loc2_.y = _loc5_.y;
            addChild(_loc2_);
         }
      }
      
      public function returnOpponentCardsToDeck(param1:Boolean = false) : void
      {
         var _loc2_:UserBattleInfo = null;
         var _loc4_:FSCard = null;
         _loc2_ = this.mBattleEngine.getOpponentBattleInfo();
         var _loc3_:Dictionary = DictionaryUtils.createCatalogCopy(_loc2_.getPlayableCardsCatalog());
         this.suggestPlayableCardOFF();
         for each(_loc4_ in _loc3_)
         {
            _loc4_.touchable = false;
            _loc2_.addCardSkuToCatalogs(_loc4_.getCardDef().getSku(),1);
            this.removeReturnedCard(_loc4_);
         }
         TweenMax.delayedCall(1,this.battleEngineChangePlayersState);
         if(Config.TRACE_BATTLE_LOGS)
         {
            FSDebug.debugTrace("[returnOpponentCardsToDeck] - Opponent\'s cards returned");
         }
      }
      
      protected function battleEngineChangePlayersState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         if(this.mBattleEngine)
         {
            this.mBattleEngine.changePlayersState();
            _loc1_ = this.mBattleEngine.getCurrentTurnId();
            _loc2_ = !this.mBattleEngine.getOwnerMovesFirst().value == 1 && !this.mBattleEngine.isOwnerTurn() ? _loc1_ == 0 : _loc1_ == 1;
            if(this.mBattleEngine.getBattleStateId() == BattleEngine.BATTLE_STATE_PLAYER_MOVING_CARDS && _loc2_)
            {
               if(this.mBattleEngine.isOwnerTurn() && !this.mBattleEngine.ownerHasDiscarded())
               {
                  this.showReshuffleButton(this.mBattleEngine.getOwnerBattleInfo());
               }
               else if(!this.mBattleEngine.isOwnerTurn())
               {
                  if(this.mBattleEngine.isPvPMatch() && !this.mBattleEngine.isOnlineMatch())
                  {
                     this.showReshuffleButton(this.mBattleEngine.getOpponentBattleInfo());
                  }
               }
            }
         }
      }
      
      private function showReshuffleButton(param1:UserBattleInfo) : void
      {
         var onFreeShuffleTriggered:Function = null;
         var userBattleInfo:UserBattleInfo = param1;
         onFreeShuffleTriggered = function(param1:Event):void
         {
            if(mBattleEngine)
            {
               if(mBattleEngine)
               {
                  mBattleEngine.reshuffleHand();
               }
               disableFreeReshuffle(userBattleInfo);
            }
         };
         if(this.isReshuffleUnlocked())
         {
            if(this.mFreeShuffleButton == null)
            {
               this.mFreeShuffleButton = new FSButton(Root.assets.getTexture("shuffle_button"));
               this.mFreeShuffleButton.addEventListener(Event.TRIGGERED,onFreeShuffleTriggered);
               this.mFreeShuffleButton.setTooltipText(TextManager.getText("TID_GEN_RESHUFFLE_TOOLTIP"));
               this.mFreeShuffleButton.x = Starling.current.stage.stageWidth;
               this.mFreeShuffleButton.y = Starling.current.stage.stageHeight / 2;
               SpecialFX.createTransition(this.mFreeShuffleButton,new FSCoordinate(this.mFreeShuffleButton.x - this.mFreeShuffleButton.width / 2,this.mFreeShuffleButton.y),0.25,0,null,null,Back.easeOut);
               addChild(this.mFreeShuffleButton);
            }
         }
      }
      
      public function disableFreeReshuffle(param1:UserBattleInfo) : void
      {
         var onButtonGone:Function = null;
         var userBattleInfo:UserBattleInfo = param1;
         onButtonGone = function():void
         {
            if(mFreeShuffleButton)
            {
               mFreeShuffleButton.removeFromParent();
               mFreeShuffleButton.destroy();
               mFreeShuffleButton = null;
            }
         };
         if(this.mFreeShuffleButton)
         {
            this.mFreeShuffleButton.touchable = false;
            SpecialFX.createTransition(this.mFreeShuffleButton,new FSCoordinate(this.mFreeShuffleButton.x + this.mFreeShuffleButton.width / 2,this.mFreeShuffleButton.y),0.25,0,onButtonGone,null,Back.easeIn);
         }
         if(userBattleInfo)
         {
            userBattleInfo.setHasDiscarded(true);
         }
      }
      
      public function returnOwnerCardsToDeck(param1:Boost = null, param2:Boolean = false) : void
      {
         var onCompleteFunction:Function = null;
         var onCompleteParams:Object = null;
         var coord:FSCoordinate = null;
         var card:FSCard = null;
         var removeLastCardBeforeReshuffling:Function = null;
         var delay:Number = NaN;
         var calledFromBoost:Boost = param1;
         var freeReshuffle:Boolean = param2;
         removeLastCardBeforeReshuffling = function(param1:FSCard, param2:Boost, param3:Function):void
         {
            removeReturnedCard(param1);
            loadNextCardsHandResources(param2,param3);
         };
         var battleUserInfo:UserBattleInfo = this.mBattleEngine.getOwnerBattleInfo();
         var playableCards:Dictionary = battleUserInfo.getPlayableCardsCatalog();
         var playableCardsLength:int = DictionaryUtils.getDictionaryLength(playableCards);
         var count:int = playableCardsLength;
         this.suggestPlayableCardOFF();
         for each(card in playableCards)
         {
            card.touchable = false;
            battleUserInfo.addCardSkuToCatalogs(card.getCardDef().getSku(),1);
            coord = this.mOwnerCardDealingPoint ? new FSCoordinate(this.mOwnerCardDealingPoint.x,this.mOwnerCardDealingPoint.y) : new FSCoordinate(-card.width,Starling.current.stage.stageHeight / 2);
            onCompleteFunction = this.removeReturnedCard;
            if(count == playableCardsLength)
            {
               if(calledFromBoost != null)
               {
                  onCompleteFunction = removeLastCardBeforeReshuffling;
                  onCompleteParams = [card,calledFromBoost,this.onNextCardsHandResourcesLoadedCalledFromBoost];
               }
               else if(freeReshuffle)
               {
                  onCompleteFunction = removeLastCardBeforeReshuffling;
                  onCompleteParams = [card,null,this.onNextCardsHandResourcesLoadedCalledFromBoost];
               }
               else
               {
                  onCompleteParams = [card,true];
               }
            }
            else
            {
               onCompleteParams = [card];
            }
            delay = this.getDealCardSpeed(true,count);
            this.performReturnEffectOnCard(card,coord,delay,onCompleteFunction,onCompleteParams);
            count--;
         }
         if(playableCardsLength == 0)
         {
            if(calledFromBoost != null)
            {
               this.loadNextCardsHandResources(calledFromBoost,this.onNextCardsHandResourcesLoadedCalledFromBoost);
            }
            else if(freeReshuffle)
            {
               this.loadNextCardsHandResources(null,this.onNextCardsHandResourcesLoadedCalledFromBoost);
            }
            else
            {
               this.battleEngineChangePlayersState();
            }
         }
         FSDebug.debugTrace("[returnOwnerCardsToDeck] - Owner\'s cards returned");
      }
      
      protected function performReturnEffectOnCard(param1:FSCard, param2:FSCoordinate, param3:Number, param4:Function, param5:Object) : void
      {
         var _loc6_:Number = 0.3 * Utils.getDefaultSpeedTime();
         TweenMax.delayedCall(param3,param1.activateDropShadow,[false]);
         SpecialFX.createTransition(param1,param2,_loc6_,param3,param4,param5);
         SpecialFX.create3DRotation(param1,_loc6_,param1.rotationX,-180,90,param3);
         var _loc7_:Boolean = Config.getConfig().gameShowsPhysicalCardsDeck();
         if(_loc7_)
         {
            if(this.mPhysicalDeckOwner)
            {
               addChild(this.mPhysicalDeckOwner);
            }
            if(this.mPhysicalDeckOpponent)
            {
               addChild(this.mPhysicalDeckOpponent);
            }
            if(this.mOpponentPortrait)
            {
               addChild(this.mOpponentPortrait);
            }
         }
      }
      
      protected function loadNextCardsHandResources(param1:Boost = null, param2:Function = null, param3:Array = null) : void
      {
         if(this.mBattleEngine)
         {
            this.mBattleEngine.loadNextCardsHandResources(param1,param2,param3);
         }
      }
      
      protected function onNextCardsHandResourcesLoadedCalledFromBoost() : void
      {
         showLoadingIcon(false,true);
         var _loc1_:Boolean = this.mBattleEngine.getBoostWaitingForResource() == null;
         this.dealOwnerCardsToDeck(this.mBattleEngine.getBoostWaitingForResource(),"",_loc1_);
      }
      
      public function removeReturnedCard(param1:FSCard, param2:Boolean = false) : void
      {
         var _loc3_:UserBattleInfo = null;
         if(param1 != null)
         {
            _loc3_ = param1.getParentUserBattleInfo();
            if(_loc3_ != null && param1.getCardDef() != null)
            {
               if(param1.isOnBF())
               {
                  _loc3_.removeFightCardFromBattlefield(param1);
               }
               else
               {
                  _loc3_.removeCardFromPlayableCardsCatalog(param1);
               }
               if(param1.getAttachedToSocket())
               {
                  param1.getAttachedToSocket().setParentCard(null);
               }
               param1.removeCardElemsFromDisplayList();
               param1.setParentUserBattleInfo(null);
            }
            Utils.playSound(Constants.SOUND_CARD_TO_BF,SoundManager.TYPE_SFX);
            TweenMax.killTweensOf(param1);
            if(Config.USE_CARD_POOLING)
            {
               FSCardsMng.addCardToPool(param1,false);
            }
            else
            {
               param1 = null;
            }
         }
         if(param2)
         {
            this.mBattleEngine.changePlayersState();
         }
      }
      
      public function createUI() : void
      {
         if(!Root.smBattleData.isDungeon)
         {
            this.createBoostItems();
         }
         else
         {
            this.createDungeonProgressStats();
         }
         this.createPortraits();
         this.showAttackButton();
         this.createPhysicalDecks();
         this.createTurnsCounter();
         this.createObjectivesPanel();
         this.createSockets();
         reAddUIVisualsOptions();
         this.createAttackAnimation();
         reset3DCameraPosition();
         if(Config.getConfig().gameHasGraveyard())
         {
            if(this.mOwnerGraveyardButton)
            {
               addChild(this.mOwnerGraveyardButton);
            }
            if(this.mOpponentGraveyardButton)
            {
               addChild(this.mOpponentGraveyardButton);
            }
         }
      }
      
      private function createDungeonProgressStats() : void
      {
         if(this.mDungeonGoldCounter == null)
         {
            this.mDungeonGoldCounter = new FSButton(Root.assets.getTexture("shop_top_icon_gold"),"0");
            this.mDungeonGoldCounter.enableScaleOnMouseOver(false);
            this.mDungeonGoldCounter.disableTriggeredEvent();
            this.mDungeonGoldCounter.scaleWhenDown = 1;
            this.mDungeonGoldCounter.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mDungeonGoldCounter.setTooltipText(TextManager.getText("TID_DUNGEON_INFO_GOLD_GAME"));
            this.mDungeonGoldCounter.x = this.mDungeonGoldCounter.width / 2;
            this.mDungeonGoldCounter.y = this.mDungeonGoldCounter.height / 2;
            addChild(this.mDungeonGoldCounter);
         }
         if(this.mDungeonCardsCounter == null)
         {
            this.mDungeonCardsCounter = new FSButton(Root.assets.getTexture("small_random_card_reward"),"0");
            this.mDungeonCardsCounter.enableScaleOnMouseOver(false);
            this.mDungeonCardsCounter.disableTriggeredEvent();
            this.mDungeonCardsCounter.scaleWhenDown = 1;
            this.mDungeonCardsCounter.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mDungeonCardsCounter.setTooltipText(TextManager.getText("TID_DUNGEON_INFO_RANDOM_CARDS_GAME"));
            this.mDungeonCardsCounter.x = this.mDungeonGoldCounter.x + this.mDungeonGoldCounter.width;
            this.mDungeonCardsCounter.y = this.mDungeonGoldCounter.y;
            addChild(this.mDungeonCardsCounter);
         }
         this.updateDungeonRewardsSummary();
      }
      
      public function updateDungeonRewardsSummary() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = InstanceMng.getDungeonsMng().getDungeonRewardsToClaimSummary();
         if(Boolean(this.mDungeonGoldCounter) && Boolean(_loc2_) && Boolean(_loc2_.hasGold) && Boolean(_loc2_.gold))
         {
            _loc1_ = _loc2_.gold;
            if(this.mDungeonGoldCounter.text != _loc1_)
            {
               if(this.mDungeonGoldCounter.getTextfield())
               {
                  SpecialFX.createTextfieldAmountTransition(this.mDungeonGoldCounter.getTextfield(),int(_loc1_),1.5,false);
               }
            }
         }
         if(Boolean(this.mDungeonCardsCounter) && Boolean(_loc2_) && Boolean(_loc2_.hasCards) && Boolean(_loc2_.cards))
         {
            _loc1_ = String(_loc2_.cards).split(",").length.toString();
            if(_loc1_ != this.mDungeonCardsCounter.text)
            {
               if(this.mDungeonCardsCounter.getTextfield())
               {
                  SpecialFX.createTextfieldAmountTransition(this.mDungeonCardsCounter.getTextfield(),int(_loc1_),1.5,false);
               }
            }
         }
         addChild(this.mDungeonGoldCounter);
         addChild(this.mDungeonCardsCounter);
      }
      
      protected function createBoostItems() : void
      {
         var _loc1_:Array = null;
         var _loc2_:FSCoordinate = null;
         var _loc3_:BoostItem = null;
         var _loc4_:int = 0;
         var _loc5_:BoostDef = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:UserData = null;
         var _loc11_:Boolean = false;
         var _loc12_:ShopBoostDef = null;
         if(this.mBoostsItems == null)
         {
            this.mBoostsItems = new Vector.<BoostItem>();
         }
         if(this.mBoostsContainer == null)
         {
            this.mBoostsContainer = new Component();
            this.mBoostsContainer.x = 0;
            this.mBoostsContainer.y = 0;
            addChild(this.mBoostsContainer);
            _loc1_ = Boolean(this.mBattleEngine) && Boolean(this.mBattleEngine.getLevelDef()) ? this.mBattleEngine.getLevelDef().getBoostsArr() : null;
            if(_loc1_ != null)
            {
               _loc8_ = 0;
               _loc9_ = true;
               _loc10_ = Utils.getOwnerUserData();
               _loc11_ = _loc10_ ? _loc10_.isPayingUser() : false;
               _loc4_ = 0;
               while(_loc4_ < _loc1_.length)
               {
                  _loc6_ = _loc1_[_loc4_];
                  _loc5_ = BoostDef(InstanceMng.getBoostsDefMng().getDefBySku(_loc6_));
                  _loc12_ = _loc5_ ? ShopBoostDef(InstanceMng.getShopBoostsDefMng().getDefByRegularBoostSku(_loc5_.getSku())) : null;
                  _loc9_ = _loc11_ || _loc12_ == null || !_loc11_ && _loc12_ && !_loc12_.shopDisplayOnlyToPayingUsers();
                  if((_loc9_) && (Boolean(_loc5_ && !_loc5_.isPermanent()) || Boolean(_loc5_.isPermanent() && InstanceMng.getApplication().hasPermanentBoosts())))
                  {
                     _loc3_ = new BoostItem(_loc8_,_loc5_,BoostsMng.BOOST);
                     this.mBoostsItems.push(_loc3_);
                     _loc7_ = !Utils.isTablet() ? _loc3_.width * (Config.getConfig().getMaxBoostsOnScreen() + 1) : _loc3_.width * Config.getConfig().getMaxBoostsOnScreen();
                     _loc2_ = Utils.getXYPositionInContainer(_loc8_,_loc3_.width,_loc3_.height,_loc7_,_loc3_.height,Config.getConfig().getMaxBoostsOnScreen(),1,true);
                     _loc3_.x = _loc2_.getX() + _loc3_.width / 2;
                     _loc3_.y = _loc2_.getY() + _loc3_.height / 2;
                     this.mBoostsContainer.addChild(_loc3_);
                     _loc8_++;
                  }
                  _loc4_++;
               }
            }
            if(_loc3_)
            {
               this.updateBoostsContainerPosition(_loc3_);
            }
         }
      }
      
      protected function updateBoostsContainerPosition(param1:BoostItem) : void
      {
         this.mBoostsContainer.x = param1.width * 0.5;
      }
      
      private function createPortraits() : void
      {
         this.createOwnerPortrait();
         this.createOpponentPortrait();
      }
      
      protected function createOwnerPortrait() : void
      {
         var _loc1_:PowerDef = null;
         if(this.mOwnerPortrait == null)
         {
            this.mOwnerPortrait = InstanceMng.getResourcesMng().createUserBattlefieldPortrait(true,this.mBattleEngine.getLevelDef().getSku());
            addChild(this.mOwnerPortrait);
            this.mOwnerPortrait.getGuildInfo();
         }
         this.setPortraitPosition(true);
         if(Config.getConfig().gameHasGraveyard())
         {
            this.createOwnerGraveyardButton();
         }
         if(this.mOwnerPortrait)
         {
            this.mOwnerPortrait.x = 0;
            this.mOwnerPortrait.y = this.getPortraitYPosition(true);
            this.mOwnerPortrait.refreshGuildEmblemPos();
         }
         this.mOwnerPortrait.setUserBattleInfo(this.mBattleEngine.getOwnerBattleInfo());
         this.mBattleEngine.getOwnerBattleInfo().setUserBattlePortrait(this.mOwnerPortrait);
         this.mOwnerPortrait.updateHP();
         if(Config.getConfig().gameHasSacrifice())
         {
            this.createOwnerSacrificeImage();
         }
         else if(Config.getConfig().gameHasPowers())
         {
            if(this.mBattleEngine.getOwnerPower())
            {
               _loc1_ = this.mBattleEngine.getOwnerPower().getCardDef() as PowerDef;
               this.createOwnerPowerAnimation(_loc1_);
            }
         }
      }
      
      private function createOwnerGraveyardButton() : void
      {
         if(this.mOwnerGraveyardButton == null)
         {
            this.mOwnerGraveyardButton = new FSButton(Root.assets.getTexture("return_icon_on"));
            this.mOwnerGraveyardButton.x = this.getDeckCardsExtraSpaceX();
            this.mOwnerGraveyardButton.y = this.getDeckCardsExtraSpaceY();
            this.mOwnerGraveyardButton.addEventListener(TouchEvent.TOUCH,this.onOwnerGraveyardTouch);
            addChild(this.mOwnerGraveyardButton);
         }
      }
      
      private function createOpponentGraveyardButton() : void
      {
         if(this.mOpponentGraveyardButton == null)
         {
            this.mOpponentGraveyardButton = new FSButton(Root.assets.getTexture("return_icon_on"));
            this.mOpponentGraveyardButton.x = this.mOpponentPortrait.x + this.mOpponentPortrait.width;
            this.mOpponentGraveyardButton.y = this.mOpponentPortrait.y + this.mOpponentPortrait.height;
            this.mOpponentGraveyardButton.addEventListener(TouchEvent.TOUCH,this.onOpponentGraveyardTouch);
            addChild(this.mOpponentGraveyardButton);
         }
      }
      
      private function onOpponentGraveyardTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this.mOpponentGraveyardButton,TouchPhase.ENDED) : null;
         if(Boolean(_loc2_) && !this.mBattleEngine.isOwnerTurn())
         {
            this.mOpponentGraveyardViewer = new GraveyardViewer();
            addChild(this.mOpponentGraveyardViewer);
         }
      }
      
      public function createOwnerGraveyard() : void
      {
         if(Config.getConfig().gameHasGraveyard())
         {
            this.mOwnerGraveyardViewer = new GraveyardViewer(true);
            addChild(this.mOwnerGraveyardViewer);
         }
      }
      
      public function createOpponentGraveyard() : void
      {
         if(Config.getConfig().gameHasGraveyard())
         {
            this.mOpponentGraveyardViewer = new GraveyardViewer(true);
            addChild(this.mOpponentGraveyardViewer);
         }
      }
      
      private function onOwnerGraveyardTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this.mOwnerGraveyardButton,TouchPhase.ENDED) : null;
         if(Boolean(_loc2_) && this.mBattleEngine.isOwnerTurn())
         {
            this.mOwnerGraveyardViewer = new GraveyardViewer();
            addChild(this.mOwnerGraveyardViewer);
         }
      }
      
      protected function createOwnerSacrificeImage() : void
      {
         if(this.mOwnerSacrificeImage == null && this.isSacrificeUnlocked())
         {
            this.mOwnerSacrificeImage = new FSImage(Root.assets.getTexture("return_icon_on"));
            this.mOwnerSacrificeImage.addEventListener(TouchEvent.TOUCH,this.onOwnerSacrificeTouch);
            this.mOwnerSacrificeImage.alignPivot();
         }
         if(this.mOwnerSacrificeImage)
         {
            if(Config.getConfig().battleHasSimpleUI())
            {
               this.mOwnerSacrificeImage.x = this.mOwnerPortrait.x + this.mOwnerPortrait.getPlayerHPCover().x + this.mOwnerPortrait.getPlayerHPCover().width / 2 - this.mOwnerSacrificeImage.width / 3.5;
               this.mOwnerSacrificeImage.y = this.mOwnerPortrait.y + this.mOwnerPortrait.getPlayerHPCover().y;
            }
            else
            {
               this.mOwnerSacrificeImage.x = this.mOwnerPortrait.x + this.mOwnerPortrait.getPlayerHPCover().x + this.mOwnerPortrait.getPlayerHPCover().width - this.mOwnerSacrificeImage.width / 3.5;
               this.mOwnerSacrificeImage.y = this.mOwnerPortrait.y + this.mOwnerPortrait.getPlayerHPCover().y + this.mOwnerSacrificeImage.height / 2.5;
            }
            addChild(this.mOwnerSacrificeImage);
         }
      }
      
      public function createOwnerPowerAnimation(param1:PowerDef, param2:int = 0) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Texture> = null;
         if(this.mBattleEngine.getOwnerPower() != null && this.isPowerUnlocked())
         {
            _loc3_ = param1.getAnimatedBG();
            _loc4_ = param1.getAnimatedBGFPS();
            _loc5_ = Root.assets.getTextures(_loc3_ + "_");
            if((Boolean(_loc5_)) && _loc5_.length > 0)
            {
               this.mOwnerPowerMc = new MovieClip(_loc5_,_loc4_);
               this.mOwnerPowerMc.touchable = false;
               Starling.juggler.add(this.mOwnerPowerMc);
               this.mOwnerPowerMc.play();
               this.mOwnerPowerMc.alignPivot();
               this.mOwnerPowerMc.scaleX = 0.65;
               this.mOwnerPowerMc.scaleY = 0.65;
               if(!Config.getConfig().battleHasSimpleUI())
               {
                  this.mOwnerPowerMc.y = this.mOwnerPortrait.y + this.mOwnerPortrait.height * 0.8;
               }
               else
               {
                  this.mOwnerPowerMc.y = this.mOwnerPortrait.y + this.mOwnerPortrait.getPlayerHPCover().y;
               }
               addChild(this.mOwnerPowerMc);
               this.createOwnerPowerFrameImage();
               this.createOwnerPowerSummonIcon();
               this.createOwnerPowerSummonTextfield(param1);
            }
            else if(!InstanceMng.getBattleEngine().isBattleOver())
            {
               TweenMax.delayedCall(0.5,this.createOwnerPowerAnimation,[param1,param2 + 1]);
               FSDebug.debugTrace("Attempting to create power anim, attempt #" + (param2 + 1));
            }
         }
      }
      
      public function createOwnerPowerFrameImage() : void
      {
         var _loc1_:PassiveAbilityDef = null;
         var _loc2_:AbilityDef = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(this.mOwnerPowerImage == null && this.mBattleEngine.getOwnerPower() != null && this.isPowerUnlocked())
         {
            this.mOwnerPowerImage = new FSImage(Root.assets.getTexture("power_icon_off"));
            this.mOwnerPowerImage.scale *= 0.9;
            this.mOwnerPowerImage.alignPivot();
            this.mOwnerPowerImage.y = this.mOwnerPowerMc ? this.mOwnerPowerMc.y : this.mOwnerPortrait.y + this.mOwnerPortrait.height * 0.7 + this.mOwnerPowerImage.height / 2;
            _loc1_ = Config.getConfig().gameHasPassive() && Boolean(this.mBattleEngine.getOwnerBattleInfo()) ? this.mBattleEngine.getOwnerBattleInfo().getPassiveAbilityDef() : null;
            _loc2_ = Boolean(_loc1_) && Boolean(_loc1_.getAbilitiesSkus() != null) && _loc1_.getAbilitiesSkus().length > 0 ? AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc1_.getAbilitiesSkus()[0])) : null;
            _loc3_ = _loc2_ ? TextManager.getText("TID_GEN_PASSIVE") + ": " + _loc2_.getDesc() : "";
            _loc4_ = Boolean(this.mBattleEngine.getOwnerPower().getAbilities()) && this.mBattleEngine.getOwnerPower().getAbilities().length > 0 ? this.mBattleEngine.getOwnerPower().getAbilities()[0].getAbilityDef().getDesc() : "";
            _loc4_ = _loc3_ != "" ? _loc3_ + "\n" + TextManager.getText("TID_GEN_ACTIVE") + ": " + _loc4_ : TextManager.getText("TID_GEN_ACTIVE") + ": " + _loc4_;
            if(_loc4_ != "")
            {
               this.mOwnerPowerImage.setTooltipText(_loc4_);
            }
            this.mOwnerPowerImage.addEventListener(TouchEvent.TOUCH,this.onOwnerPowerTouch);
            if(!Config.getConfig().battleHasSimpleUI())
            {
               this.mOwnerPowerImage.x = this.mOwnerPortrait.x + this.mOwnerPortrait.getPlayerHPCover().width / 2.2;
            }
            else
            {
               this.mOwnerPowerImage.x = this.mOwnerPortrait.x + this.mOwnerPortrait.getPlayerHPCover().width - this.mOwnerPowerImage.width / 2;
            }
            addChild(this.mOwnerPowerImage);
            if(this.mOwnerPowerMc)
            {
               this.mOwnerPowerMc.x = this.mOwnerPowerImage.x;
            }
         }
      }
      
      public function createOwnerPowerSummonIcon() : void
      {
         if(this.mOwnerPowerMc != null && this.mOwnerPowerSummonIcon == null)
         {
            this.mOwnerPowerSummonIcon = new FSImage(Root.assets.getTexture("frame_summon_icon"));
            this.mOwnerPowerSummonIcon.scale *= 0.9;
            this.mOwnerPowerSummonIcon.touchable = false;
            this.mOwnerPowerSummonIcon.alignPivot();
            this.mOwnerPowerSummonIcon.x = this.mOwnerPowerMc.x;
            this.mOwnerPowerSummonIcon.y = this.mOwnerPowerMc.y + this.mOwnerPowerSummonIcon.width * 0.55;
            addChild(this.mOwnerPowerSummonIcon);
         }
      }
      
      public function suggestOwnerPower(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         if(this.mOwnerPowerMc)
         {
            if(this.mOwnerPowerSummonSuggestBG == null && Root.assets.getTexture("power_suggest_bg") != null)
            {
               this.mOwnerPowerSummonSuggestBG = new FSImage(Root.assets.getTexture("power_suggest_bg"));
               this.mOwnerPowerSummonSuggestBG.alignPivot();
               this.mOwnerPowerSummonSuggestBG.scale = 0.69;
               this.mOwnerPowerSummonSuggestBG.x = this.mOwnerPowerMc.x;
               this.mOwnerPowerSummonSuggestBG.y = this.mOwnerPowerMc.y;
               _loc3_ = getChildIndex(this.mOwnerPowerMc) != -1 ? getChildIndex(this.mOwnerPowerMc) : 0;
               addChildAt(this.mOwnerPowerSummonSuggestBG,_loc3_);
            }
            _loc2_ = this.mBattleEngine ? this.mBattleEngine.isPowerUsableAndHasTargets(this.mBattleEngine.getOwnerPower(),this.mBattleEngine.getOwnerBattleInfo()) : false;
            if(this.mOwnerPowerSummonSuggestBG)
            {
               this.mOwnerPowerSummonSuggestBG.visible = param1 && _loc2_;
            }
         }
      }
      
      public function suggestOpponentPower(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this.mOpponentPowerMc)
         {
            if(this.mOpponentPowerSummonSuggestBG == null && Root.assets.getTexture("power_suggest_bg") != null)
            {
               this.mOpponentPowerSummonSuggestBG = new FSImage(Root.assets.getTexture("power_suggest_bg"));
               this.mOpponentPowerSummonSuggestBG.alignPivot();
               this.mOpponentPowerSummonSuggestBG.scale = 0.69;
               this.mOpponentPowerSummonSuggestBG.x = this.mOpponentPowerMc.x;
               this.mOpponentPowerSummonSuggestBG.y = this.mOpponentPowerMc.y;
               addChildAt(this.mOpponentPowerSummonSuggestBG,getChildIndex(this.mOpponentPowerMc));
            }
            _loc2_ = this.mBattleEngine ? this.mBattleEngine.isPowerUsableAndHasTargets(this.mBattleEngine.getOpponentPower(),this.mBattleEngine.getOpponentBattleInfo()) : false;
            if(this.mOpponentPowerSummonSuggestBG)
            {
               this.mOpponentPowerSummonSuggestBG.visible = param1 && _loc2_;
            }
         }
      }
      
      public function createOwnerPowerSummonTextfield(param1:PowerDef) : void
      {
         if(this.mOwnerPowerSummonIcon != null && this.mOwnerPowerSummonTextfield == null)
         {
            this.mOwnerPowerSummonTextfield = new FSTextfield(this.mOwnerPowerSummonIcon.width,this.mOwnerPowerSummonIcon.height,param1.getSummonCost().toString());
            this.mOwnerPowerSummonTextfield.touchable = false;
            this.mOwnerPowerSummonTextfield.alignPivot();
            this.mOwnerPowerSummonTextfield.x = this.mOwnerPowerSummonIcon.x;
            this.mOwnerPowerSummonTextfield.y = this.mOwnerPowerSummonIcon.y;
            addChild(this.mOwnerPowerSummonTextfield);
         }
      }
      
      public function unHighlightPlayablePortraits(param1:Boolean = false) : void
      {
         if(this.mOwnerPortrait != null)
         {
            this.mOwnerPortrait.deactivateSpecialHighlightParticle();
         }
         if(this.mOpponentPortrait != null)
         {
            this.mOpponentPortrait.deactivateSpecialHighlightParticle();
         }
      }
      
      public function showCancelPower(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.mOwnerPowerImage)
            {
               this.mOwnerPowerImage.texture = Root.assets.getTexture("power_icon_cancel");
            }
         }
         else if(this.mOpponentPowerImage)
         {
            this.mOpponentPowerImage.texture = Root.assets.getTexture("power_icon_cancel");
         }
      }
      
      public function hideCancelPower(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.mOwnerPowerImage)
            {
               this.mOwnerPowerImage.texture = Root.assets.getTexture("power_icon_on");
            }
         }
         else if(this.mOpponentPowerImage)
         {
            this.mOpponentPowerImage.texture = Root.assets.getTexture("power_icon_on");
         }
      }
      
      private function playerHasCardsOnBF(param1:Boolean) : Boolean
      {
         var _loc4_:FSCardSocket = null;
         var _loc2_:Boolean = false;
         var _loc3_:Dictionary = param1 ? this.mOwnerBFSocketCatalog : this.mOpponentBFSocketCatalog;
         if(_loc3_)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.getParentCard() != null)
               {
                  return true;
               }
            }
         }
         return _loc2_;
      }
      
      private function onOwnerPowerTouch(param1:TouchEvent) : void
      {
         var _loc3_:UserBattleInfo = null;
         var _loc4_:Touch = null;
         var _loc2_:Boolean = InstanceMng.getBattleEngine().isOwnerTurn();
         if(_loc2_)
         {
            _loc3_ = InstanceMng.getBattleEngine().getOwnerBattleInfo();
            _loc4_ = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
            if(_loc4_)
            {
               if(this.mBattleEngine.isOwnerPowerActive())
               {
                  this.executePower(_loc3_,_loc2_);
                  this.disableFreeReshuffle(_loc3_);
               }
            }
            _loc4_ = param1 ? param1.getTouch(this,TouchPhase.HOVER) : null;
            if(this.mOwnerPowerMc)
            {
               this.mOwnerPowerMc.alpha = _loc4_ ? 0.8 : 1;
            }
            _loc4_ = param1.getTouch(this);
            if(_loc4_)
            {
               this.mOwnerPowerImage.showTooltip();
            }
            else
            {
               this.mOwnerPowerImage.closeTooltip();
            }
         }
      }
      
      private function onOpponentPowerTouch(param1:TouchEvent) : void
      {
         var _loc3_:UserBattleInfo = null;
         var _loc4_:Touch = null;
         var _loc2_:Boolean = InstanceMng.getBattleEngine().isOwnerTurn();
         if(!_loc2_)
         {
            _loc3_ = InstanceMng.getBattleEngine().getOpponentBattleInfo();
            _loc4_ = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
            if(_loc4_)
            {
               if(this.mBattleEngine.isOpponentPowerActive())
               {
                  this.executePower(_loc3_,_loc2_);
                  this.disableFreeReshuffle(_loc3_);
               }
            }
            _loc4_ = param1 ? param1.getTouch(this,TouchPhase.HOVER) : null;
            if(this.mOpponentPowerMc)
            {
               this.mOpponentPowerMc.alpha = _loc4_ ? 0.8 : 1;
            }
            _loc4_ = param1.getTouch(this);
            if(_loc4_)
            {
               this.mOpponentPowerImage.showTooltip();
            }
            else
            {
               this.mOpponentPowerImage.closeTooltip();
            }
         }
      }
      
      private function executePower(param1:UserBattleInfo, param2:Boolean) : void
      {
         this.mBattleEngine.executePowerAbility(param1,param2);
      }
      
      private function onOwnerSacrificeTouch(param1:TouchEvent) : void
      {
         var _loc3_:UserBattleInfo = null;
         var _loc4_:Touch = null;
         var _loc2_:Boolean = InstanceMng.getBattleEngine().isOwnerTurn();
         if(_loc2_)
         {
            _loc3_ = InstanceMng.getBattleEngine().getOwnerBattleInfo();
            _loc4_ = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
            if(_loc4_)
            {
               if(this.mLightning == null)
               {
                  if(this.playerHasCardsOnBF(_loc2_))
                  {
                     if(_loc3_.hasActionPointsLeft(Config.getConfig().getSacrificeCost()))
                     {
                        if(_loc3_.isSacrificeAvailable())
                        {
                           InstanceMng.getBattleEngine().setSacrificeWaitingForTarget(true);
                           Utils.setLogText(TextManager.getText("TID_RETURN_DESCRIPTION"),false,true);
                           this.createLightning();
                           this.highlightSacrificeTargets(true);
                        }
                        else
                        {
                           Utils.setLogText(TextManager.getText("TID_RETURN_ONCE"));
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
                  else
                  {
                     Utils.setLogText(TextManager.getText("TID_RETURN_NEED_CARDS"));
                  }
               }
               else
               {
                  InstanceMng.getBattleEngine().setSacrificeWaitingForTarget(false);
                  this.highlightSacrificeTargets(false);
               }
            }
            _loc4_ = param1 ? param1.getTouch(this,TouchPhase.HOVER) : null;
            if(this.mOwnerSacrificeImage)
            {
               this.mOwnerSacrificeImage.alpha = _loc4_ ? 0.8 : 1;
            }
         }
      }
      
      private function onOpponentSacrificeTouch(param1:TouchEvent) : void
      {
         var _loc3_:UserBattleInfo = null;
         var _loc4_:Touch = null;
         var _loc2_:Boolean = InstanceMng.getBattleEngine().isOwnerTurn();
         if(!_loc2_ && InstanceMng.getBattleEngine().isPvPMatch() && !InstanceMng.getBattleEngine().isOnlineMatch())
         {
            _loc3_ = InstanceMng.getBattleEngine().getOpponentBattleInfo();
            _loc4_ = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
            if(_loc4_)
            {
               if(this.mLightning == null)
               {
                  if(this.playerHasCardsOnBF(_loc2_))
                  {
                     if(_loc3_.hasActionPointsLeft(Config.getConfig().getSacrificeCost()))
                     {
                        if(_loc3_.isSacrificeAvailable())
                        {
                           InstanceMng.getBattleEngine().setSacrificeWaitingForTarget(true);
                           Utils.setLogText(TextManager.getText("TID_RETURN_DESCRIPTION"),false,true);
                           this.createLightning();
                           this.highlightSacrificeTargets(true);
                        }
                        else
                        {
                           Utils.setLogText(TextManager.getText("TID_RETURN_ONCE"));
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
                  else
                  {
                     Utils.setLogText(TextManager.getText("TID_RETURN_NEED_CARDS"));
                  }
               }
               else
               {
                  InstanceMng.getBattleEngine().setSacrificeWaitingForTarget(false);
                  this.highlightSacrificeTargets(false);
               }
            }
            _loc4_ = param1 ? param1.getTouch(this,TouchPhase.HOVER) : null;
            if(this.mOpponentSacrificeImage)
            {
               this.mOpponentSacrificeImage.alpha = _loc4_ ? 0.8 : 1;
            }
         }
      }
      
      public function createLightning() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc1_:FSImage = InstanceMng.getBattleEngine().isOwnerTurn() ? this.mOwnerSacrificeImage : this.mOpponentSacrificeImage;
         var _loc4_:Point = null;
         _loc2_ = _loc1_.x;
         _loc3_ = _loc1_.y;
         _loc4_ = new Point(_loc2_,_loc3_);
         var _loc5_:FSBattlefieldUserPortrait = InstanceMng.getBattleEngine().isOwnerTurn() ? this.mOwnerPortrait : this.mOpponentPortrait;
         this.mLightning = InstanceMng.getCardAnimsMng().requestSacrificeAnimation(_loc5_,-1);
         Utils.playSound(Constants.SOUND_SACRIFICE_TRIGGER,SoundManager.TYPE_SFX);
      }
      
      public function getLightning() : LightningAnimation
      {
         return this.mLightning;
      }
      
      public function highlightSacrificeTargets(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:Dictionary = null;
         var _loc6_:Vector.<FSCardSocket> = null;
         var _loc7_:FSCard = null;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:FSCardSocket = null;
         var _loc11_:ColorArgb = null;
         var _loc12_:ColorArgb = null;
         var _loc13_:Vector.<FSCardSocket> = null;
         if(this.mBattleEngine)
         {
            _loc2_ = false;
            _loc3_ = this.mBattleEngine.isOwnerTurn();
            if(_loc3_)
            {
               _loc5_ = this.mBattleEngine.getOwnerBattleInfo() != null ? this.mBattleEngine.getOwnerBattleInfo().getFightCards() : null;
            }
            else
            {
               _loc5_ = this.mBattleEngine.getOpponentBattleInfo() != null ? this.mBattleEngine.getOpponentBattleInfo().getFightCards() : null;
            }
            if(_loc5_ != null)
            {
               _loc2_ = true;
               for each(_loc7_ in _loc5_)
               {
                  if(_loc6_ == null)
                  {
                     _loc6_ = new Vector.<FSCardSocket>();
                  }
                  if(_loc7_)
                  {
                     _loc6_.push(_loc7_.getAttachedToSocket());
                     if(!param1 && Boolean(_loc7_.getAttachedToSocket()))
                     {
                        _loc7_.getAttachedToSocket().deactivateHighlightTween();
                     }
                  }
               }
            }
            if(_loc2_)
            {
               _loc8_ = _loc3_ || this.mBattleEngine.isPvPMatch() && !this.mBattleEngine.isOnlineMatch();
               if(_loc8_)
               {
                  _loc9_ = _loc6_ ? int(_loc6_.length) : 0;
                  _loc4_ = 0;
                  while(_loc4_ < _loc9_)
                  {
                     _loc10_ = _loc6_[_loc4_];
                     if(param1)
                     {
                        _loc11_ = new ColorArgb(0.4,0.1,0.9,1);
                        _loc12_ = new ColorArgb(0.4,0,0.9,0);
                        if(_loc10_)
                        {
                           _loc10_.activateHighlightTween(65280,true,1,_loc11_,_loc12_);
                        }
                     }
                     _loc4_++;
                  }
               }
               if(param1)
               {
                  _loc13_ = _loc3_ || this.mBattleEngine.isPvPMatch() ? _loc6_ : null;
                  this.mBattleEngine.enableBFCards(false,_loc13_);
                  this.mBattleEngine.enableSideDeck(false);
                  this.mBattleEngine.disableAttackButton();
                  if(_loc3_)
                  {
                     if(this.mOwnerSacrificeImage)
                     {
                        this.mOwnerSacrificeImage.texture = Root.assets.getTexture("return_icon_cancel");
                     }
                  }
                  else if(this.mOpponentSacrificeImage)
                  {
                     this.mOpponentSacrificeImage.texture = Root.assets.getTexture("return_icon_cancel");
                  }
               }
               else
               {
                  if(this.mBattleEngine.isOnlineMatch() && PvPConnectionMng.smExpirationTimeLeft > 0 || !this.mBattleEngine.isOnlineMatch())
                  {
                     this.mBattleEngine.enableBFCards(true);
                     this.mBattleEngine.enableSideDeck(true);
                     this.mBattleEngine.enableAttackButton();
                  }
                  if(_loc3_)
                  {
                     if(this.mOwnerSacrificeImage)
                     {
                        this.mOwnerSacrificeImage.texture = Root.assets.getTexture("return_icon_on");
                     }
                  }
                  else if(this.mOpponentSacrificeImage)
                  {
                     this.mOpponentSacrificeImage.texture = Root.assets.getTexture("return_icon_on");
                  }
                  Utils.removeLog();
                  if(this.mLightning)
                  {
                     this.mLightning.unloadMovieclip();
                     this.mLightning.unload();
                     this.mLightning.removeFromParent(true);
                     this.mLightning = null;
                  }
               }
            }
         }
      }
      
      public function highlightPowerTargets(param1:Boolean, param2:PowerDef) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Dictionary = null;
         var _loc7_:Vector.<FSCardSocket> = null;
         var _loc8_:Dictionary = null;
         var _loc9_:Dictionary = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:FSCard = null;
         var _loc15_:Boolean = false;
         var _loc16_:int = 0;
         var _loc17_:FSCardSocket = null;
         var _loc18_:ColorArgb = null;
         var _loc19_:ColorArgb = null;
         var _loc20_:Vector.<FSCardSocket> = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = this.mBattleEngine.isOwnerTurn();
         if(InstanceMng.getPowerDefMng().getIsPowerAbilityForFriendTargets(param2.getSku()))
         {
            if(_loc4_)
            {
               _loc6_ = this.mBattleEngine.getOwnerBattleInfo().getFightCards();
            }
            else
            {
               _loc6_ = this.mBattleEngine.getOpponentBattleInfo().getFightCards();
            }
         }
         else if(InstanceMng.getPowerDefMng().getPowerAbilityAffectsAllTargets(param2.getSku()))
         {
            _loc8_ = this.mBattleEngine.getOwnerBattleInfo().getFightCards();
            _loc9_ = this.mBattleEngine.getOpponentBattleInfo().getFightCards();
            _loc10_ = DictionaryUtils.getKeys(_loc8_);
            _loc11_ = DictionaryUtils.getKeys(_loc9_);
            _loc12_ = 0;
            _loc13_ = 0;
            if(_loc10_)
            {
               _loc12_ = 0;
               while(_loc12_ < _loc10_.length)
               {
                  if(_loc6_ == null)
                  {
                     _loc6_ = new Dictionary(true);
                  }
                  _loc6_[_loc13_] = _loc8_[_loc10_[_loc12_]];
                  _loc13_++;
                  _loc12_++;
               }
            }
            if(_loc11_)
            {
               _loc12_ = 0;
               while(_loc12_ < _loc11_.length)
               {
                  if(_loc6_ == null)
                  {
                     _loc6_ = new Dictionary(true);
                  }
                  _loc6_[_loc13_] = _loc9_[_loc11_[_loc12_]];
                  _loc13_++;
                  _loc12_++;
               }
            }
         }
         else if(_loc4_)
         {
            _loc6_ = this.mBattleEngine.getOpponentBattleInfo().getFightCards();
         }
         else
         {
            _loc6_ = this.mBattleEngine.getOwnerBattleInfo().getFightCards();
         }
         if(_loc6_ != null)
         {
            _loc3_ = true;
            for each(_loc14_ in _loc6_)
            {
               if(_loc7_ == null)
               {
                  _loc7_ = new Vector.<FSCardSocket>();
               }
               _loc7_.push(_loc14_.getAttachedToSocket());
               if(!param1)
               {
                  _loc14_.getAttachedToSocket().deactivateHighlightTween();
                  _loc14_.unHighlightPlayableSocketsVector();
               }
            }
         }
         if(_loc3_)
         {
            _loc15_ = _loc4_ || InstanceMng.getBattleEngine().isPvPMatch() && !InstanceMng.getBattleEngine().isOnlineMatch();
            if(_loc15_)
            {
               _loc16_ = _loc7_ ? int(_loc7_.length) : 0;
               _loc5_ = 0;
               while(_loc5_ < _loc16_)
               {
                  _loc17_ = _loc7_[_loc5_];
                  if(param1)
                  {
                     _loc18_ = new ColorArgb(0.4,0.1,0.9,1);
                     _loc19_ = new ColorArgb(0.4,0,0.9,0);
                     _loc17_.activateHighlightTween(65280,true,1,_loc18_,_loc19_);
                  }
                  _loc5_++;
               }
            }
            if(param1)
            {
               _loc20_ = _loc4_ || this.mBattleEngine.isPvPMatch() ? _loc7_ : null;
               this.mBattleEngine.enableBFCards(false,_loc20_);
               this.mBattleEngine.enableSideDeck(false);
               this.mBattleEngine.disableAttackButton();
               if(_loc4_)
               {
                  if(this.mOwnerPowerImage)
                  {
                     this.mOwnerPowerImage.texture = Root.assets.getTexture("return_icon_cancel");
                  }
               }
               else if(this.mOpponentPowerImage)
               {
                  this.mOpponentPowerImage.texture = Root.assets.getTexture("return_icon_cancel");
               }
            }
            else if(Boolean(InstanceMng.getBattleEngine()) && (Boolean(InstanceMng.getBattleEngine().isOnlineMatch() && PvPConnectionMng.smExpirationTimeLeft > 0)) || !InstanceMng.getBattleEngine().isOnlineMatch())
            {
               this.mBattleEngine.enableBFCards(true);
               this.mBattleEngine.enableSideDeck(true);
               this.mBattleEngine.enableAttackButton();
               Utils.removeLog();
            }
         }
      }
      
      public function enableSacrificeButton(param1:Boolean, param2:Boolean) : void
      {
         if(param1)
         {
            if(this.mOwnerSacrificeImage)
            {
               this.mOwnerSacrificeImage.texture = param2 ? Root.assets.getTexture("return_icon_on") : Root.assets.getTexture("return_icon_off");
               this.mOwnerSacrificeImage.touchable = true;
            }
         }
         else if(this.mOpponentSacrificeImage)
         {
            this.mOpponentSacrificeImage.texture = param2 ? Root.assets.getTexture("return_icon_on") : Root.assets.getTexture("return_icon_off");
            this.mOpponentSacrificeImage.touchable = true;
         }
      }
      
      protected function createOpponentPortrait() : void
      {
         var _loc2_:RaidDef = null;
         var _loc3_:int = 0;
         var _loc4_:FSNumber = null;
         var _loc5_:PowerDef = null;
         if(this.mOpponentPortrait == null)
         {
            this.mOpponentPortrait = InstanceMng.getResourcesMng().createUserBattlefieldPortrait(false,this.mBattleEngine.getLevelDef().getSku());
            this.setPortraitPosition(false);
            addChild(this.mOpponentPortrait);
            this.mOpponentPortrait.getGuildInfo();
         }
         this.mOpponentPortrait.setUserBattleInfo(this.mBattleEngine.getOpponentBattleInfo());
         this.mBattleEngine.getOpponentBattleInfo().setUserBattlePortrait(this.mOpponentPortrait);
         var _loc1_:Boolean = Boolean(Root.smBattleData.isRaid);
         if(_loc1_ && (!InstanceMng.getBattleEngine().isOnlineMatch() || PvPConnectionMng.smPlayingAgainstBOT))
         {
            _loc2_ = InstanceMng.getRaidsMng().getCurrentRaidDef();
            _loc3_ = InstanceMng.getRaidsMng().getCurrentRaidDifficulty();
            _loc4_ = new FSNumber(InstanceMng.getRaidsMng().getRaidBossHP(_loc2_,_loc3_));
            this.mOpponentPortrait.getHPPlayerViewer().updateHP(_loc4_.value);
            if(InstanceMng.getBattleEngine().getOpponentBattleInfo())
            {
               InstanceMng.getBattleEngine().getOpponentBattleInfo().setHP(_loc4_);
            }
         }
         this.mOpponentPortrait.updateHP();
         if(this.mOpponentPortrait)
         {
            this.mOpponentPortrait.x = 0;
            this.mOpponentPortrait.y = this.getPortraitYPosition(false);
            this.mOpponentPortrait.refreshGuildEmblemPos();
         }
         if(this.mOpponentSacrificeImage)
         {
            this.mOpponentSacrificeImage.x = this.getDeckCardsExtraSpaceX() - this.mOpponentSacrificeImage.width / 2;
            this.mOpponentSacrificeImage.y = this.mOpponentPortrait.y + this.mOpponentPortrait.height + this.mOpponentSacrificeImage.height / 2;
            if(Utils.isIphone())
            {
               this.mOpponentSacrificeImage.x -= Utils.isIphone5() ? this.mOpponentSacrificeImage.width : this.mOpponentSacrificeImage.width / 2;
            }
         }
         if(Config.getConfig().gameHasSacrifice() && (this.mBattleEngine.isPvPMatch() || !this.mBattleEngine.isPvPMatch() && this.mBattleEngine.getLevelDef().getIAUseSacrifice()) && this.isSacrificeUnlocked())
         {
            this.createOpponentSacrificeImage();
         }
         else if(Config.getConfig().gameHasPowers() && (this.mBattleEngine.isPvPMatch() || !this.mBattleEngine.isPvPMatch() && this.mBattleEngine.getLevelDef().getIAUsePowers()) && this.mBattleEngine.getOpponentPower() != null)
         {
            _loc5_ = this.mBattleEngine.getOpponentPower().getCardDef() as PowerDef;
            this.createOpponentPowerAnimation(_loc5_);
         }
         if(Config.getConfig().gameHasGraveyard() && this.mBattleEngine.isPvPMatch())
         {
            this.createOpponentGraveyardButton();
         }
      }
      
      private function getPortraitYPosition(param1:Boolean) : Number
      {
         var _loc2_:Number = 0;
         var _loc3_:Number = 1.05;
         if(param1)
         {
            _loc2_ = Starling.current.stage.stageHeight - this.mOwnerPortrait.height * _loc3_;
         }
         else if(!InstanceMng.getBattleEngine().isPvPMatch())
         {
            _loc2_ = Root.smBattleData.isDungeon ? this.mDungeonCardsCounter.y + this.mDungeonCardsCounter.height * 0.55 : this.mBoostsContainer.y + this.mBoostsContainer.height * 1.1;
         }
         else
         {
            _loc2_ = Config.getConfig().battleHasSimpleUI() ? Starling.current.stage.stageHeight * 0.05 : 0;
         }
         return _loc2_;
      }
      
      protected function setPortraitPosition(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         if(param1)
         {
            if(this.mOwnerPortrait)
            {
               this.mOwnerPortrait.x = 0;
               this.mOwnerPortrait.y = this.getPortraitYPosition(true);
               this.mOwnerPortrait.refreshGuildEmblemPos();
            }
         }
         else if(this.mOpponentPortrait)
         {
            this.mOpponentPortrait.x = 0;
            this.mOpponentPortrait.y = this.getPortraitYPosition(false);
            this.mOpponentPortrait.refreshGuildEmblemPos();
         }
      }
      
      private function createOpponentSacrificeImage() : void
      {
         if(Config.getConfig().gameHasSacrifice())
         {
            if(this.mOpponentSacrificeImage == null)
            {
               this.mOpponentSacrificeImage = new FSImage(Root.assets.getTexture("return_icon_on"));
               this.mOpponentSacrificeImage.addEventListener(TouchEvent.TOUCH,this.onOpponentSacrificeTouch);
               this.mOpponentSacrificeImage.alignPivot();
            }
            if(Config.getConfig().battleHasSimpleUI())
            {
               this.mOpponentSacrificeImage.x = this.mOpponentPortrait.x + this.mOpponentPortrait.getPlayerHPCover().x + this.mOpponentPortrait.getPlayerHPCover().width / 2 - this.mOpponentSacrificeImage.width / 3.5;
               this.mOpponentSacrificeImage.y = this.mOpponentPortrait.y + this.mOpponentPortrait.getPlayerHPCover().y;
            }
            else
            {
               this.mOpponentSacrificeImage.x = this.mOpponentPortrait.x + this.mOpponentPortrait.getPlayerHPCover().x + this.mOpponentPortrait.getPlayerHPCover().width - this.mOpponentSacrificeImage.width / 3.5;
               this.mOpponentSacrificeImage.y = this.mOpponentPortrait.y + this.mOpponentPortrait.getPlayerHPCover().y + this.mOpponentSacrificeImage.height / 2.5;
            }
            addChild(this.mOpponentSacrificeImage);
         }
      }
      
      public function createOpponentPowerSummonTextfield(param1:PowerDef) : void
      {
         if(this.mOpponentPowerSummonIcon != null && this.mOpponentPowerSummonTextfield == null)
         {
            this.mOpponentPowerSummonTextfield = new FSTextfield(this.mOpponentPowerSummonIcon.width,this.mOpponentPowerSummonIcon.height,param1.getSummonCost().toString());
            this.mOpponentPowerSummonTextfield.touchable = false;
            this.mOpponentPowerSummonTextfield.alignPivot();
            this.mOpponentPowerSummonTextfield.x = this.mOpponentPowerSummonIcon.x;
            this.mOpponentPowerSummonTextfield.y = this.mOpponentPowerSummonIcon.y;
            addChild(this.mOpponentPowerSummonTextfield);
         }
      }
      
      public function createOpponentPowerSummonIcon() : void
      {
         if(this.mOpponentPowerMc != null && this.mOpponentPowerSummonIcon == null)
         {
            this.mOpponentPowerSummonIcon = new FSImage(Root.assets.getTexture("frame_summon_icon"));
            this.mOpponentPowerSummonIcon.scale *= 0.9;
            this.mOpponentPowerSummonIcon.touchable = false;
            this.mOpponentPowerSummonIcon.alignPivot();
            this.mOpponentPowerSummonIcon.x = this.mOpponentPowerMc.x;
            this.mOpponentPowerSummonIcon.y = this.mOpponentPowerMc.y + this.mOpponentPowerSummonIcon.width * 0.55;
            addChild(this.mOpponentPowerSummonIcon);
         }
      }
      
      public function createOpponentPowerFrameImage() : void
      {
         var _loc1_:PassiveAbilityDef = null;
         var _loc2_:AbilityDef = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(this.mOpponentPowerImage == null && this.mBattleEngine.getOpponentPower() != null && this.isPowerUnlocked())
         {
            this.mOpponentPowerImage = new FSImage(Root.assets.getTexture("power_icon_off"));
            this.mOpponentPowerImage.scale *= 0.9;
            this.mOpponentPowerImage.alignPivot();
            this.mOpponentPowerImage.y = this.mOpponentPowerMc ? this.mOpponentPowerMc.y : this.mOpponentPortrait.y + this.mOpponentPortrait.height * 0.7 + this.mOpponentPowerImage.height / 2;
            _loc1_ = Config.getConfig().gameHasPassive() && Boolean(this.mBattleEngine.getOpponentBattleInfo()) ? this.mBattleEngine.getOpponentBattleInfo().getPassiveAbilityDef() : null;
            _loc2_ = Boolean(_loc1_) && Boolean(_loc1_.getAbilitiesSkus() != null) && _loc1_.getAbilitiesSkus().length > 0 ? AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc1_.getAbilitiesSkus()[0])) : null;
            _loc3_ = _loc2_ ? TextManager.getText("TID_GEN_PASSIVE") + ": " + _loc2_.getDesc() : "";
            _loc4_ = Boolean(this.mBattleEngine.getOpponentPower().getAbilities()) && this.mBattleEngine.getOpponentPower().getAbilities().length > 0 ? this.mBattleEngine.getOpponentPower().getAbilities()[0].getAbilityDef().getDesc() : "";
            _loc4_ = _loc3_ != "" ? _loc3_ + "\n" + TextManager.getText("TID_GEN_ACTIVE") + ": " + _loc4_ : TextManager.getText("TID_GEN_ACTIVE") + ": " + _loc4_;
            if(_loc4_ != "")
            {
               this.mOpponentPowerImage.setTooltipText(_loc4_);
            }
            this.mOpponentPowerImage.addEventListener(TouchEvent.TOUCH,this.onOpponentPowerTouch);
            if(!Config.getConfig().battleHasSimpleUI())
            {
               this.mOpponentPowerImage.x = this.mOpponentPortrait.x + this.mOpponentPortrait.getPlayerHPCover().width / 2.2;
            }
            else
            {
               this.mOpponentPowerImage.x = this.mOpponentPortrait.x + this.mOpponentPortrait.getPlayerHPCover().width - this.mOpponentPowerImage.width / 2;
            }
            addChild(this.mOpponentPowerImage);
            if(this.mOpponentPowerMc)
            {
               this.mOpponentPowerMc.x = this.mOpponentPowerImage.x;
            }
         }
      }
      
      public function createOpponentPowerAnimation(param1:PowerDef, param2:int = 0) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Texture> = null;
         if(this.mOpponentPowerMc == null && this.mBattleEngine.getOpponentPower() != null && this.isPowerUnlocked())
         {
            _loc3_ = param1.getAnimatedBG();
            _loc4_ = param1.getAnimatedBGFPS();
            _loc5_ = Root.assets.getTextures(_loc3_ + "_");
            if(_loc5_)
            {
               this.mOpponentPowerMc = new MovieClip(_loc5_,_loc4_);
               this.mOpponentPowerMc.touchable = false;
               Starling.juggler.add(this.mOpponentPowerMc);
               this.mOpponentPowerMc.play();
            }
            this.mOpponentPowerMc.alignPivot();
            this.mOpponentPowerMc.scaleX = 0.65;
            this.mOpponentPowerMc.scaleY = 0.65;
            if(!Config.getConfig().battleHasSimpleUI())
            {
               this.mOpponentPowerMc.y = this.mOpponentPortrait.y + this.mOpponentPortrait.height * 0.8;
            }
            else
            {
               this.mOpponentPowerMc.y = this.mOpponentPortrait.y + this.mOpponentPortrait.getPlayerHPCover().y;
            }
            addChild(this.mOpponentPowerMc);
            this.createOpponentPowerFrameImage();
            this.createOpponentPowerSummonIcon();
            this.createOpponentPowerSummonTextfield(param1);
         }
         else if(!InstanceMng.getBattleEngine().isBattleOver())
         {
            TweenMax.delayedCall(0.5,this.createOpponentPowerAnimation,[param1,param2 + 1]);
            FSDebug.debugTrace("Attempting to create opp power anim, attempt #" + (param2 + 1));
         }
      }
      
      private function isSacrificeUnlocked() : Boolean
      {
         return Root.smBattleData.isRaid || Root.smBattleData.isDungeon || InstanceMng.getBattleEngine().isPvPMatch() || Config.isSacrificeUnlockedByLevel(InstanceMng.getBattleEngine().getLevelDef().getLevelIndex());
      }
      
      private function isPowerUnlocked() : Boolean
      {
         return Root.smBattleData.isRaid || Root.smBattleData.isDungeon || InstanceMng.getBattleEngine().isPvPMatch() || Config.isPowerUnlockedByLevel(InstanceMng.getBattleEngine().getLevelDef().getLevelIndex());
      }
      
      private function isReshuffleUnlocked() : Boolean
      {
         return Root.smBattleData.isRaid || Root.smBattleData.isDungeon || InstanceMng.getBattleEngine().isPvPMatch() || Config.isReshuffleUnlockedByLevel(InstanceMng.getBattleEngine().getLevelDef().getLevelIndex());
      }
      
      protected function createObjectivesPanel() : void
      {
         var _loc1_:Component = null;
         if(this.mObjectivesPanel == null)
         {
            this.mObjectivesPanel = new FSObjectivesPanel();
            _loc1_ = this.mOpponentPortrait.getFrameContainer();
            if(_loc1_)
            {
               this.mObjectivesPanel.x = Utils.isIOS() ? this.getDeckCardsExtraSpaceX() * 1.15 : this.getDeckCardsExtraSpaceX() * 1.75;
               this.mObjectivesPanel.y = this.mOpponentPortrait.y;
               if(this.getBoostsHeight() == 0)
               {
                  this.mObjectivesPanel.y += _loc1_.height / 2.5;
               }
            }
            this.updateObjectivesPanelPosition();
            addChild(this.mObjectivesPanel);
         }
      }
      
      protected function createSockets() : void
      {
         this.mOwnerSideDeckSocketCatalog = new Dictionary(true);
         this.mOwnerBFSocketCatalog = new Dictionary(true);
         this.mOpponentBFSocketCatalog = new Dictionary(true);
         this.mOwnerSideDeckSocketSuggestCatalog = new Dictionary(true);
         this.mOwnerBFSocketSuggestCatalog = new Dictionary(true);
         this.mOpponentBFSocketSuggestCatalog = new Dictionary(true);
         this.mRowsAmount = this.mBattleEngine.getLevelDef().getRowsAmount();
         this.mColumnsAmount = this.mBattleEngine.getLevelDef().getColumnsAmount();
         this.createOwnerDeckAreaSockets();
         this.createBattlefieldSockets();
      }
      
      protected function createOwnerDeckAreaSockets(param1:uint = 1) : void
      {
         var _loc2_:Boolean = Config.getConfig().PvPDeckAreaSocketsUseColors();
         param1 = !_loc2_ ? uint(-1) : param1;
         this.createOwnerDeckSocketsBG();
         var _loc3_:int = this.mBattleEngine.getLevelDef().getDeckCards();
         var _loc4_:int = Config.getConfig().getDeckDefaultRows();
         var _loc5_:int = Config.getConfig().getDeckDefaultColumns();
         var _loc6_:int = this.getDeckAreaWidth();
         var _loc7_:int = this.getDeckAreaHeight();
         var _loc8_:int = this.getDeckCardsExtraSpaceX();
         var _loc9_:int = this.getDeckCardsExtraSpaceY();
         this.createDefaultSocket(_loc4_,_loc5_,false,false,_loc6_,_loc7_,_loc8_,_loc9_,_loc3_,this.mOwnerSideDeckSocketCatalog,param1);
         if(Config.getConfig().getActivateSuggestPlayable())
         {
            this.createDefaultSocket(_loc4_,_loc5_,false,false,_loc6_,_loc7_,_loc8_,_loc9_,_loc3_,this.mOwnerSideDeckSocketSuggestCatalog,param1,true);
         }
      }
      
      private function createBattlefieldSockets() : void
      {
         this.createOwnerBattlefieldSockets();
         this.createOpponentBattlefieldSockets();
      }
      
      private function createOwnerBattlefieldSockets() : void
      {
         var _loc1_:int = this.getBFWidth();
         var _loc2_:int = this.getBFHeight();
         var _loc3_:Number = this.getBFExtraSpaceX();
         var _loc4_:Number = this.getBFExtraSpaceY();
         this.createDefaultSocket(this.mRowsAmount,this.mColumnsAmount,false,true,_loc1_,_loc2_,_loc3_,_loc4_,0,this.mOwnerBFSocketCatalog);
         if(Config.getConfig().getActivateSuggestPlayable())
         {
            this.createDefaultSocket(this.mRowsAmount,this.mColumnsAmount,false,true,_loc1_,_loc2_,_loc3_,_loc4_,0,this.mOwnerBFSocketSuggestCatalog,1,true);
         }
      }
      
      protected function createOpponentBattlefieldSockets() : void
      {
         var _loc1_:Number = Starling.current.stage.stageHeight * 0.01;
         this.createDefaultSocket(this.mRowsAmount,this.mColumnsAmount,true,true,this.getBFWidth(),this.getBFHeight(),this.getOpponentBFExtraSpaceX(),_loc1_,0,this.mOpponentBFSocketCatalog);
         if(Config.getConfig().getActivateSuggestPlayable())
         {
            this.createDefaultSocket(this.mRowsAmount,this.mColumnsAmount,true,true,this.getBFWidth(),this.getBFHeight(),this.getOpponentBFExtraSpaceX(),_loc1_,0,this.mOpponentBFSocketSuggestCatalog,1,true);
         }
      }
      
      protected function createDefaultSocket(param1:int, param2:int, param3:Boolean, param4:Boolean, param5:int, param6:int, param7:int = 0, param8:int = 0, param9:int = 0, param10:Dictionary = null, param11:uint = 1, param12:Boolean = false) : void
      {
         var _loc13_:FSCardSocket = null;
         var _loc14_:FSCoordinate = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:FSCardSocket = null;
         var _loc28_:Number = NaN;
         var _loc15_:Number = 1;
         var _loc18_:int = 0;
         if(param9 != 0 && param9 <= 3)
         {
            param2 = 1;
         }
         _loc16_ = 0;
         while(_loc16_ < param1)
         {
            _loc17_ = 0;
            while(_loc17_ < param2)
            {
               if(param9 != 0 && _loc18_ >= param9)
               {
                  return;
               }
               _loc13_ = this.createCardSocket();
               _loc13_.setupSocket(param3,param4,_loc16_,_loc17_,param1,_loc18_,param12);
               _loc15_ = this.calculateScaleFactor(_loc13_,param5,param6,param2,param1);
               _loc13_.scaleX *= _loc15_;
               _loc13_.scaleY *= _loc15_;
               if(param12)
               {
                  if(!param4)
                  {
                     _loc27_ = param3 ? FSCardSocket(this.mOpponentSideDeckSocketCatalog[_loc18_]) : FSCardSocket(this.mOwnerSideDeckSocketCatalog[_loc18_]);
                  }
                  else
                  {
                     _loc27_ = param3 ? FSCardSocket(this.mOpponentBFSocketCatalog[_loc18_]) : FSCardSocket(this.mOwnerBFSocketCatalog[_loc18_]);
                  }
                  if(_loc27_)
                  {
                     _loc13_.width = _loc27_.width * SUGGEST_SOCKET_FACTOR_SCALE;
                     _loc13_.height = _loc27_.height * SUGGEST_SOCKET_FACTOR_SCALE;
                  }
                  _loc13_.alignPivot();
                  _loc13_.x = _loc27_.x;
                  _loc13_.y = _loc27_.y;
               }
               else
               {
                  _loc14_ = Utils.getXYPositionInContainer(_loc18_,_loc13_.width,_loc13_.height,param5,param6,param2,param1,true);
                  _loc13_.x = param7 + _loc14_.getX();
                  _loc13_.y = param8 + _loc14_.getY();
                  _loc13_.x += _loc13_.width / 2;
                  _loc13_.y += _loc13_.height / 2;
                  if(this is FSBattleScreenPvP)
                  {
                     _loc28_ = mBG.height * Config.getConfig().battleGetPvPDeckExtraYFactor();
                     _loc28_ = param3 ? -_loc28_ : _loc28_;
                     _loc13_.y += _loc28_;
                  }
               }
               if(param11 != 1 && !param12)
               {
                  _loc13_.getBGImage().color = param11;
               }
               _loc19_ = 0;
               _loc20_ = 0;
               _loc21_ = 0;
               _loc22_ = 0;
               _loc23_ = param3 ? -1 : 1;
               _loc24_ = 3;
               if(_loc16_ % 2 == 0)
               {
                  _loc19_ = _loc17_ % 2 == 0 ? int(_loc23_ * -1) : 0;
                  _loc20_ = _loc17_ % 2 == 0 ? 0 : _loc23_;
               }
               else
               {
                  _loc19_ = _loc17_ % 2 == 0 ? 0 : int(_loc23_ * -1);
                  _loc20_ = _loc17_ % 2 == 0 ? _loc23_ : 0;
               }
               _loc21_ = _loc19_ * _loc24_;
               _loc22_ = _loc20_ * _loc24_;
               _loc25_ = Utils.randomInt(_loc19_,_loc20_);
               _loc26_ = Utils.randomInt(_loc21_,_loc22_);
               _loc13_.rotate(new Vector3D(0,0,1),_loc25_);
               _loc13_.y += _loc26_;
               addChild(_loc13_);
               if(param10 != null)
               {
                  param10[_loc18_] = _loc13_;
               }
               _loc18_++;
               _loc17_++;
            }
            _loc16_++;
         }
      }
      
      protected function createCardSocket() : FSCardSocket
      {
         return new FSCardSocket();
      }
      
      protected function calculateScaleFactor(param1:FSCardSocket, param2:Number, param3:Number, param4:int, param5:int) : Number
      {
         return Utils.calculateScaleFactor(param1.width,param1.height,param2,param3,param4,param5);
      }
      
      public function getCardSocketByIndex(param1:int, param2:Dictionary) : FSCardSocket
      {
         var _loc3_:FSCardSocket = null;
         if(param2 != null)
         {
            if(param2[param1] != null)
            {
               _loc3_ = FSCardSocket(param2[param1]);
            }
         }
         return _loc3_;
      }
      
      public function getIndexCardSocketEmpty(param1:Dictionary) : int
      {
         var _loc4_:FSCardSocket = null;
         var _loc2_:int = 0;
         var _loc3_:int = -1;
         if(param1 != null)
         {
            for each(_loc4_ in param1)
            {
               if(_loc4_.getParentCard() == null)
               {
                  break;
               }
               _loc2_++;
            }
         }
         if(_loc2_ < DictionaryUtils.getDictionaryLength(param1))
         {
            _loc3_ = _loc2_;
         }
         return _loc3_;
      }
      
      public function getSocketWorldCoordsByIndex(param1:int, param2:Dictionary) : FSCoordinate
      {
         var _loc3_:FSCoordinate = null;
         var _loc4_:FSCardSocket = this.getCardSocketByIndex(param1,param2);
         if(_loc4_ != null)
         {
            _loc3_ = new FSCoordinate();
            _loc3_.setX(_loc4_.x);
            _loc3_.setY(_loc4_.y);
         }
         return _loc3_;
      }
      
      override public function setSelectedCard(param1:FSCard) : void
      {
         if(mSelectedCard != null && !mSelectedCard.isOnSummonCooldown())
         {
            if(mSelectedCard.filter)
            {
               mSelectedCard.filter.dispose();
               mSelectedCard.filter = null;
            }
         }
         mSelectedCard = param1;
      }
      
      public function getOwnerBFSocketCatalog() : Dictionary
      {
         return this.mOwnerBFSocketCatalog;
      }
      
      public function setOwnerBFSocketCatalog(param1:Dictionary) : void
      {
         this.mOwnerBFSocketCatalog = param1;
      }
      
      public function getOpponentBFSocketCatalog() : Dictionary
      {
         return this.mOpponentBFSocketCatalog;
      }
      
      public function setOpponentBFSocketCatalog(param1:Dictionary) : void
      {
         this.mOpponentBFSocketCatalog = param1;
      }
      
      public function getBattleEngine() : BattleEngine
      {
         return this.mBattleEngine;
      }
      
      public function setBattleEngine(param1:BattleEngine) : void
      {
         this.mBattleEngine = param1;
      }
      
      public function getActionPointsCounter(param1:Boolean) : ActionPointsCounter
      {
         if(param1)
         {
            return this.mOwnerActionPointsCounter;
         }
         return this.mOpponentActionPointsCounter;
      }
      
      override public function removeTranslucentBG(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:Popup = InstanceMng.getPopupMng().getPopupShown();
         if(_loc3_ == null)
         {
            super.removeTranslucentBG(param1,param2);
         }
         if(Boolean(mSelectedCard && !param2) && Boolean(getOptionsPanel() != null) && !getOptionsPanel().areCreditsBeingShown())
         {
            if(mSelectedCard is FSAttachment && FSAttachment(mSelectedCard).isOnBF() && getZoomedCardXL() != null && getZoomedCardXL() is AttachmentXL)
            {
               AttachmentXL(getZoomedCardXL()).onAttachmentXLTouched();
            }
            else
            {
               if(mSelectedCard is FSAttachment)
               {
                  if(Boolean(FSAttachment(mSelectedCard).getAttachedToSocket() != null) && Boolean(FSAttachment(mSelectedCard).getAttachedToSocket().getParentCard()) && FSAttachment(mSelectedCard).getAttachedToSocket().getParentCard() is FSUnit)
                  {
                     FSUnit(FSAttachment(mSelectedCard).getAttachedToSocket().getParentCard()).notifyCardSelected();
                  }
               }
               mSelectedCard.setDisableIntersections(true);
               SpecialFX.zoomOut(mSelectedCard);
            }
         }
         if(_loc3_ != null)
         {
            _loc3_.visible = true;
         }
         this.removeTurnMsg(param1);
      }
      
      override protected function onBackgroundTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Boolean = false;
         var _loc4_:Popup = null;
         if(!Root.assets.isLoading && !Screen.smCarrousselTransitionON)
         {
            _loc2_ = param1.getTouch(this,TouchPhase.ENDED);
            if(_loc2_)
            {
               _loc3_ = Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().isPlayersIntroPlaying();
               if(_loc3_ && !InstanceMng.getBattleEngine().isOnlineMatch())
               {
                  InstanceMng.getBattleEngine().skipPlayersIntro();
                  return;
               }
               if(this.mVictoryAnimationON)
               {
                  if(Root.smBattleData.isDungeon)
                  {
                     if(InstanceMng.getDungeonsMng().hasCompletedAllDungeonLevels())
                     {
                        return;
                     }
                  }
                  this.skipVictoryAnimation();
                  return;
               }
               if(this.mDefeatAnimationON)
               {
                  this.skipDefeatAnimation();
                  return;
               }
               _loc4_ = InstanceMng.getPopupMng().getPopupInBackground();
               if(_loc4_ is FSPopupPlayLevel && FSPopupPlayLevel(_loc4_).isLevelCompleted() || InstanceMng.getPopupMng().getPopupShown() == null)
               {
                  if(Boolean(!_loc3_) && Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().getBattleStateId() != BattleEngine.BATTLE_STATE_BATTLE_OVER)
                  {
                     this.removeTranslucentBG(true);
                  }
               }
               else
               {
                  checkIfPopupsCanBeClosed();
               }
            }
         }
         else
         {
            FSDebug.debugTrace("NOT TOUCHABLE, LOADING STUFF");
         }
      }
      
      public function displayTurnMessage(param1:String, param2:uint = 16744448, param3:Number = -1) : void
      {
         createTranslucentBG(true,0.0001);
         if(this.mTurnPanel == null)
         {
            this.mTurnPanel = new TurnPanel();
         }
         addChild(this.mTurnPanel);
         this.mTurnPanel.x = param3 != -1 ? param3 : Starling.current.stage.stageWidth / 2;
         this.mTurnPanel.y = Starling.current.stage.stageHeight / 2;
         var _loc4_:String = TextManager.getText(param1);
         _loc4_ = _loc4_ == null ? param1 : _loc4_;
         this.mTurnPanel.performFadeIn(_loc4_);
         if(this.mBattleEngine.isOwnerTurn())
         {
            Utils.playSound(Constants.SOUND_TURN_CHANGE,SoundManager.TYPE_SFX);
         }
         TweenMax.delayedCall(1,this.removeTurnMsg);
      }
      
      public function removeTurnMsg(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         TweenMax.killDelayedCallsTo(this.removeTurnMsg);
         if(Boolean(this.mTurnPanel) && Boolean(contains(this.mTurnPanel)) && this.mTurnPanel.isShown())
         {
            _loc2_ = 0.5 * Utils.getDefaultSpeedTime();
            this.mTurnPanel.performFadeOut(_loc2_);
            TweenMax.delayedCall(_loc2_,this.onTurnMsgRemoved);
         }
      }
      
      public function onTurnMsgRemoved() : void
      {
         if(mTransparentBGShown)
         {
            this.removeTranslucentBG(false,true);
         }
         if(Boolean(this.mBattleEngine) && this.mBattleEngine.getWaitingForBannerAnimToIncreaseState())
         {
            this.mBattleEngine.setWaitingForBannerAnimToIncreaseState(false);
            TweenMax.delayedCall(0.1,this.battleEngineChangePlayersState);
         }
      }
      
      public function showMap() : void
      {
         dispatchEventWith(Screen.GO_TO_MAP,true);
      }
      
      public function showPvPScreen() : void
      {
         dispatchEventWith(Screen.GO_TO_PVP,true);
      }
      
      public function showDungeonsScreen() : void
      {
         dispatchEventWith(Screen.GO_TO_DUNGEONS,true);
      }
      
      public function showRaidsScreen() : void
      {
         dispatchEventWith(Screen.GO_TO_RAIDS,true);
      }
      
      public function getAttackButton() : FSAttackButton
      {
         return this.mAttackButton;
      }
      
      public function getOwnerSacrificeButton() : FSImage
      {
         return this.mOwnerSacrificeImage;
      }
      
      public function getOpponentSacrificeButton() : FSImage
      {
         return this.mOpponentSacrificeImage;
      }
      
      public function getOwnerPowerButton() : MovieClip
      {
         return this.mOwnerPowerMc;
      }
      
      public function getOpponentPowerButton() : MovieClip
      {
         return this.mOpponentPowerMc;
      }
      
      public function getOwnerSideDeckSocketCatalog() : Dictionary
      {
         return this.mOwnerSideDeckSocketCatalog;
      }
      
      public function getOpponentSideDeckSocketCatalog() : Dictionary
      {
         return this.mOpponentSideDeckSocketCatalog;
      }
      
      public function getAbilitiesChooserPanel() : AbilitiesPanel
      {
         return this.mAbilitiesChooserPanel;
      }
      
      public function setAbilitiesChooserPanel(param1:AbilitiesPanel) : void
      {
         this.mAbilitiesChooserPanel = param1;
      }
      
      public function openAbilitiesChooserPanel(param1:FSAction, param2:*) : void
      {
         if(this.mAbilitiesChooserPanel == null)
         {
            this.mAbilitiesChooserPanel = new AbilitiesPanel();
         }
         Utils.removeLog();
         param1.unHighlightAllPlayableItems();
         this.mAbilitiesChooserPanel.setupPanel(param1,param2);
         addChild(this.mAbilitiesChooserPanel);
      }
      
      public function unHighlightAllSockets() : void
      {
         var _loc1_:FSCard = null;
         var _loc2_:Dictionary = null;
         var _loc3_:FSCardSocket = null;
         _loc2_ = this.mBattleEngine.getOwnerBattleInfo().getFightCards();
         if(_loc2_ != null)
         {
            for each(_loc1_ in _loc2_)
            {
               if(_loc1_ != null)
               {
                  _loc1_.unHighlightAllPlayableItems();
               }
            }
         }
         _loc2_ = this.mBattleEngine.getOpponentBattleInfo().getFightCards();
         if(_loc2_ != null)
         {
            for each(_loc1_ in _loc2_)
            {
               if(_loc1_ != null)
               {
                  _loc1_.unHighlightAllPlayableItems();
               }
            }
         }
         if(this.mOwnerBFSocketCatalog != null)
         {
            for each(_loc3_ in this.mOwnerBFSocketCatalog)
            {
               _loc3_.deactivateHighlightTween();
            }
         }
         if(this.mOpponentBFSocketCatalog != null)
         {
            for each(_loc3_ in this.mOpponentBFSocketCatalog)
            {
               _loc3_.deactivateHighlightTween();
            }
         }
      }
      
      public function closeAbilitiesChooserPanel() : void
      {
         if(this.mAbilitiesChooserPanel != null)
         {
            this.mAbilitiesChooserPanel.cleanAndClose();
         }
      }
      
      public function areCardAnimsON() : Boolean
      {
         return this.mCardAnimsON;
      }
      
      public function setCardAnimsON(param1:Boolean) : void
      {
         this.lockUI(param1);
      }
      
      override public function lockUI(param1:Boolean) : void
      {
         if(this.mAttackButton != null && (this.mBattleEngine.isOwnerTurn() || this.mBattleEngine.isPvPMatch()))
         {
            if(param1)
            {
               this.mBattleEngine.disableAttackButton();
            }
            else
            {
               this.mBattleEngine.enableAttackButton();
            }
            this.mBattleEngine.enableBFCards(!param1);
            this.mBattleEngine.enableSideDeck(!param1);
            if(Config.getConfig().gameHasSacrifice())
            {
               this.mBattleEngine.enableSacrificeButton(!param1);
            }
            if(Config.getConfig().gameHasPowers())
            {
               this.mBattleEngine.enableOwnerPowerButton(!param1,true);
               this.mBattleEngine.enableOpponentPowerButton(!param1,true);
            }
         }
         this.mCardAnimsON = param1;
      }
      
      public function showInvulnerableShield(param1:Boolean) : void
      {
         if(this.mOwnerPortrait != null)
         {
            this.mOwnerPortrait.setPlayerInvulnerable(param1);
         }
      }
      
      public function getOwnerPortrait() : FSBattlefieldUserPortrait
      {
         return this.mOwnerPortrait;
      }
      
      public function getOpponentPortrait() : FSBattlefieldUserPortrait
      {
         return this.mOpponentPortrait;
      }
      
      public function getDeckAreaWidth() : int
      {
         return mBG.width / 3.35;
      }
      
      public function getDeckAreaHeight() : int
      {
         return mBG.height / 2.5;
      }
      
      public function getBFWidth() : int
      {
         var _loc1_:int = this.getBFExtraSpaceX();
         var _loc2_:int = mBG.width / 2;
         var _loc3_:FSButton = InstanceMng.getCurrentScreen().getGuildsButton();
         var _loc4_:int = _loc3_.x;
         var _loc5_:int = _loc4_ - (_loc1_ + _loc2_);
         return _loc2_ + _loc5_;
      }
      
      public function getBFHeight() : int
      {
         return mBG.height * 0.5 - Starling.current.stage.stageHeight * 0.01;
      }
      
      public function getBFExtraSpaceX() : int
      {
         return this.mOwnerPortrait ? int(this.mOwnerPortrait.x + this.mOwnerPortrait.getUsefulWidth() + this.getDeckAreaWidth() * 0.95) : 0;
      }
      
      public function getOpponentBFExtraSpaceX() : int
      {
         return this.mOpponentPortrait.x + this.mOpponentPortrait.getUsefulWidth() + this.getDeckAreaWidth() * 0.95;
      }
      
      public function getBFExtraSpaceY() : int
      {
         return this.getBFHeight();
      }
      
      public function getDeckCardsExtraSpaceX() : int
      {
         return this.mOwnerPortrait.getUsefulWidth();
      }
      
      public function getDeckCardsExtraSpaceY() : int
      {
         return Starling.current.stage.stageHeight * 0.59;
      }
      
      public function getBoostsHeight() : int
      {
         return this.mBoostsContainer ? int(this.mBoostsContainer.height) : 0;
      }
      
      public function getObjectivesHeight() : int
      {
         return this.mObjectivesPanel ? int(this.mObjectivesPanel.height) : 0;
      }
      
      public function setObjectivesPanelonTop() : void
      {
         if(this.mObjectivesPanel)
         {
            addChild(this.mObjectivesPanel);
         }
      }
      
      override public function onEnterFrame(param1:Event) : void
      {
         super.onEnterFrame(param1);
         if(Config.getConfig().getTutorialON() && this.mIsTutorialLevel)
         {
            InstanceMng.getTutorialMng().onEnterFrame(param1);
         }
         InstanceMng.getConversationsMng().onEnterFrame(param1);
      }
      
      public function setEnemyActionBeingTriggered(param1:FSCard) : void
      {
         this.mEnemyActionBeingTriggered = param1;
      }
      
      public function showBloodScreenEffect() : void
      {
         if(this.mBloodScreen == null)
         {
            this.mBloodScreen = new BloodScreen();
         }
         this.mBloodScreen.trigger();
         addChild(this.mBloodScreen);
      }
      
      public function showNotEnoughAPEffect(param1:FSCard = null) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:FSImage = null;
         if(InstanceMng.getBattleEngine() != null)
         {
            if(InstanceMng.getBattleEngine().isOnlineMatch())
            {
               this.getActionPointsCounter(true).triggerNotEnoughAPAnim();
            }
            else if(InstanceMng.getBattleEngine().isPvPMatch())
            {
               _loc4_ = InstanceMng.getBattleEngine().isOwnerTurn();
               this.getActionPointsCounter(_loc4_).triggerNotEnoughAPAnim();
            }
            else
            {
               this.getActionPointsCounter(true).triggerNotEnoughAPAnim();
            }
         }
         var _loc2_:Boolean = Config.getConfig().battleGetLockDeckWhenNoMana();
         if(Config.getConfig().battleUseDeckBG() && _loc2_)
         {
            if(InstanceMng.getBattleEngine().isOwnerTurn())
            {
               TweenMax.killDelayedCallsTo(this.showOwnerLockedDeckSocketsBG);
               this.showOwnerLockedDeckSocketsBG(true);
               TweenMax.delayedCall(3,this.showOwnerLockedDeckSocketsBG,[false]);
            }
            else
            {
               TweenMax.killDelayedCallsTo(this.showOpponentLockedDeckSocketsBG);
               this.showOpponentLockedDeckSocketsBG(true);
               TweenMax.delayedCall(3,this.showOpponentLockedDeckSocketsBG,[false]);
            }
            InstanceMng.getLogPanel().alpha = 0;
            _loc5_ = InstanceMng.getBattleEngine().isOwnerTurn() ? this.getOwnerLockedDeckSocketsBG() : this.getOpponentLockedDeckSocketsBG();
            Utils.setLogText(TextManager.getText("TID_LOG_ACTION"),true,false,false,true,0.5,Align.CENTER,Align.TOP,_loc5_,false,1);
            SpecialFX.createZoomAlphaTween(InstanceMng.getLogPanel(),0.5,0.001,0.999,3,1,null,this.onNotEnoughAPLogTextFadeIn);
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_LOG_ACTION"),true);
         }
         if(Config.getConfig().battleGetVoiceOnError())
         {
            Utils.playSound(Constants.SOUND_NOT_ENOUGH_MANA,SoundManager.TYPE_SFX);
         }
         var _loc3_:ActionPointsCounter = this.getActionPointsCounter(InstanceMng.getBattleEngine().isOwnerTurn());
         if(_loc3_)
         {
            _loc3_.startNotEnoughAPEffect();
         }
         if(param1)
         {
            param1.startNotEnoughAPEffect();
         }
      }
      
      private function onNotEnoughAPLogTextFadeIn() : void
      {
         var _loc1_:FSImage = InstanceMng.getBattleEngine().isOwnerTurn() ? this.getOwnerLockedDeckSocketsBG() : this.getOpponentLockedDeckSocketsBG();
         if(_loc1_)
         {
            addChild(_loc1_);
         }
         addChild(InstanceMng.getLogPanel());
      }
      
      protected function createOwnerDeckSocketsBG() : void
      {
         var _loc1_:BackgroundDef = null;
         var _loc2_:String = null;
         if(Config.getConfig().battleUseDeckBG())
         {
            if(this.mOwnerDeckAreaBG == null)
            {
               _loc1_ = BackgroundDef(InstanceMng.getBackgroundDefMng().getDefBySku(mBGName));
               if(_loc1_ != null)
               {
                  _loc2_ = _loc1_.getCardHolderBG();
                  this.mOwnerDeckAreaBG = new FSImage(Root.assets.getTexture(_loc2_));
                  this.mOwnerDeckAreaBG.touchable = false;
                  this.mOwnerDeckAreaBG.x = this.getDeckCardsExtraSpaceX() + (this.getDeckAreaWidth() - this.mOwnerDeckAreaBG.width) / 2;
                  this.mOwnerDeckAreaBG.y = mBG.height - this.mOwnerDeckAreaBG.height;
                  addChild(this.mOwnerDeckAreaBG);
               }
            }
         }
      }
      
      public function showOwnerLockedDeckSocketsBG(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Function = null;
         if(Config.getConfig().battleUseDeckBG() && Config.getConfig().battleShowRedPanelWhenNoAPLeft() && Boolean(this.mOwnerDeckAreaBG))
         {
            if(this.mOwnerDeckAreaBGLocked == null)
            {
               this.mOwnerDeckAreaBGLocked = new FSImage(Root.assets.getTexture("card_holder_lock"));
               this.mOwnerDeckAreaBGLocked.x = this.mOwnerDeckAreaBG.x + (this.mOwnerDeckAreaBG.width - this.mOwnerDeckAreaBGLocked.width) / 2;
               this.mOwnerDeckAreaBGLocked.y = this.mOwnerDeckAreaBG.y;
            }
            if(param1)
            {
               this.mOwnerDeckAreaBGLocked.alpha = 0.001;
               addChild(this.mOwnerDeckAreaBGLocked);
            }
            TweenMax.killTweensOf(this.mOwnerDeckAreaBGLocked);
            _loc2_ = param1 ? 0.999 : 0.001;
            _loc3_ = !param1 ? this.removeOwnerDeckAreBGLockedFromParent : null;
            SpecialFX.tweenToAlpha(this.mOwnerDeckAreaBGLocked,_loc2_,0.5,0,_loc3_);
         }
      }
      
      private function removeOwnerDeckAreBGLockedFromParent() : void
      {
         if(this.mOwnerDeckAreaBGLocked)
         {
            this.mOwnerDeckAreaBGLocked.removeFromParent();
         }
      }
      
      public function getOwnerLockedDeckSocketsBG() : FSImage
      {
         return this.mOwnerDeckAreaBGLocked;
      }
      
      public function showOpponentLockedDeckSocketsBG(param1:Boolean) : void
      {
      }
      
      public function getOpponentLockedDeckSocketsBG() : FSImage
      {
         return null;
      }
      
      public function suggestPlayableCardON() : void
      {
         var _loc1_:FSCardSocket = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         if(Config.getConfig().getActivateSuggestPlayable() && this.mBattleEngine.getBattleStateId() == BattleEngine.BATTLE_STATE_PLAYER_MOVING_CARDS && (this.mBattleEngine.isOwnerTurn() || !this.mBattleEngine.isOwnerTurn() && this.mBattleEngine.isPvPMatch() && !this.mBattleEngine.isOnlineMatch()))
         {
            _loc2_ = 0;
            this.suggestPlayableCardOFF();
            _loc3_ = this.mBattleEngine.getLevelDef().getRowsAmount() * this.mBattleEngine.getLevelDef().getColumnsAmount();
            _loc4_ = _loc2_ < _loc3_;
            for each(_loc1_ in this.mOwnerBFSocketCatalog)
            {
               if(_loc1_.getParentCard() != null && _loc1_.getParentCard().getType() == FSCard.TYPE_UNIT)
               {
                  _loc2_ += 1;
                  _loc4_ = _loc2_ < _loc3_;
                  if(this.canApplyEffectPlayableToCardSocketPromote(_loc1_,this.mBattleEngine.isOwnerTurn()))
                  {
                     this.makeEffectPlayableToCardSocket(_loc1_,this.mOwnerBFSocketSuggestCatalog,true);
                  }
               }
            }
            for each(_loc1_ in this.mOwnerSideDeckSocketCatalog)
            {
               if(this.canApplyEffectPlayableToCardSocketSummon(_loc1_,this.mBattleEngine.isOwnerTurn()))
               {
                  if(_loc4_ || !_loc4_ && (_loc1_.getParentCard() is FSAction || _loc1_.getParentCard() is FSAttachment))
                  {
                     this.makeEffectPlayableToCardSocket(_loc1_,this.mOwnerSideDeckSocketSuggestCatalog);
                  }
               }
            }
            this.checkPowerSuggestions();
         }
      }
      
      protected function checkPowerSuggestions() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:PowerDef = null;
         var _loc4_:Boolean = false;
         if(this.mBattleEngine)
         {
            _loc4_ = this.mBattleEngine.isOwnerTurn();
            if(Config.getConfig().gameHasPowers())
            {
               if(_loc4_)
               {
                  _loc1_ = this.mOwnerActionPointsCounter ? this.mOwnerActionPointsCounter.getAPLeft() : 0;
                  _loc3_ = this.mBattleEngine.getOwnerPower() ? this.mBattleEngine.getOwnerPower().getCardDef() as PowerDef : null;
               }
               else
               {
                  _loc1_ = this.mOpponentActionPointsCounter ? this.mOpponentActionPointsCounter.getAPLeft() : 0;
                  _loc3_ = this.mBattleEngine.getOpponentPower() ? this.mBattleEngine.getOpponentPower().getCardDef() as PowerDef : null;
               }
               if(_loc3_)
               {
                  _loc2_ = _loc3_.getSummonCost();
                  if(_loc1_ >= _loc2_)
                  {
                     if(_loc4_)
                     {
                        this.suggestOwnerPower(true);
                     }
                     else
                     {
                        this.suggestOpponentPower(true);
                     }
                  }
               }
            }
         }
      }
      
      public function canApplyEffectPlayableToCardSocketPromote(param1:FSCardSocket, param2:Boolean) : Boolean
      {
         var _loc3_:FSCard = null;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:Boolean = false;
         var _loc6_:Boolean = InstanceMng.getBattleEngine().getLevelDef().isUpgradeAllowed();
         if((Boolean(_loc6_)) && Boolean(this.mOwnerActionPointsCounter) && Boolean(this.mOpponentActionPointsCounter))
         {
            _loc7_ = param2 ? this.mOwnerActionPointsCounter.getAPLeft() : this.mOpponentActionPointsCounter.getAPLeft();
            _loc3_ = param1 ? param1.getParentCard() : null;
            if(Boolean(_loc3_) && _loc3_.getType() == FSCard.TYPE_UNIT)
            {
               _loc5_ = _loc3_.getCardDef().getUpgradeCost();
               if(_loc5_ > 0 && _loc5_ <= _loc7_)
               {
                  _loc4_ = true;
               }
            }
         }
         return _loc4_;
      }
      
      public function suggestPlayableCardOFF() : void
      {
         var _loc1_:FSCardSocket = null;
         if(Config.getConfig().getActivateSuggestPlayable())
         {
            if(this.mOwnerSideDeckSocketCatalog)
            {
               for each(_loc1_ in this.mOwnerSideDeckSocketSuggestCatalog)
               {
                  _loc1_.visible = false;
                  this.onSuggestSocketHidden(_loc1_);
               }
            }
            if(this.mOwnerBFSocketCatalog)
            {
               for each(_loc1_ in this.mOwnerBFSocketSuggestCatalog)
               {
                  _loc1_.visible = false;
                  this.onSuggestSocketHidden(_loc1_);
               }
            }
            if(this.mOpponentBFSocketCatalog)
            {
               for each(_loc1_ in this.mOpponentBFSocketSuggestCatalog)
               {
                  _loc1_.visible = false;
                  this.onSuggestSocketHidden(_loc1_);
               }
            }
            this.suggestOwnerPower(false);
            this.suggestOpponentPower(false);
         }
      }
      
      protected function onSuggestSocketHidden(param1:FSCardSocket) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Dictionary = null;
         var _loc5_:FSCardSocket = null;
         if(param1)
         {
            _loc2_ = param1.isBattlefieldSocket();
            _loc3_ = !param1.getIsEnemy();
            if(_loc2_)
            {
               _loc4_ = _loc3_ ? this.mOwnerBFSocketCatalog : this.mOpponentBFSocketCatalog;
            }
            else
            {
               _loc4_ = _loc3_ ? this.mOwnerSideDeckSocketCatalog : this.mOpponentSideDeckSocketCatalog;
            }
            if(_loc4_)
            {
               _loc5_ = _loc4_[param1.getSocketIndex()];
               _loc5_.getParentCard() && _loc5_.getParentCard().setCardDropShadowAlpha(1);
            }
         }
      }
      
      public function canApplyEffectPlayableToCardSocketSummon(param1:FSCardSocket, param2:Boolean) : Boolean
      {
         var _loc3_:FSCard = null;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Dictionary = null;
         var _loc9_:FSCard = null;
         var _loc10_:Boolean = false;
         var _loc11_:Vector.<Ability> = null;
         var _loc12_:Ability = null;
         var _loc5_:Boolean = false;
         if(param1)
         {
            _loc3_ = param1.getParentCard();
            if(_loc3_ != null)
            {
               _loc6_ = _loc3_.getCardSummonCost();
               _loc4_ = _loc3_.getType();
               if(!this.mOwnerActionPointsCounter || !this.mOpponentActionPointsCounter)
               {
                  return false;
               }
               _loc7_ = param2 ? this.mOwnerActionPointsCounter.getAPLeft() : this.mOpponentActionPointsCounter.getAPLeft();
               _loc8_ = param2 ? this.mOwnerBFSocketCatalog : this.mOpponentBFSocketCatalog;
               if(_loc3_ is FSAttachment)
               {
                  for each(param1 in _loc8_)
                  {
                     _loc9_ = param1.getParentCard();
                     if(_loc9_)
                     {
                        _loc10_ = _loc9_.hasWellEquipped(_loc3_);
                        if(Boolean(_loc9_) && _loc10_)
                        {
                           _loc6_ = _loc6_ - 1 >= 0 ? int(_loc6_ - 1) : 0;
                        }
                     }
                  }
               }
               if(_loc6_ <= _loc7_)
               {
                  if(_loc4_ == FSCard.TYPE_ATTACHMENT)
                  {
                     for each(param1 in _loc8_)
                     {
                        if(_loc3_.isCardAttachableToSocket(param1))
                        {
                           _loc5_ = true;
                        }
                     }
                  }
                  else if(_loc4_ == FSCard.TYPE_ACTION)
                  {
                     for each(param1 in _loc8_)
                     {
                        _loc11_ = _loc3_.getAbilities();
                        for each(_loc12_ in _loc11_)
                        {
                           if(_loc12_.canBeExecutedAndHasTargets())
                           {
                              _loc5_ = true;
                              break;
                           }
                        }
                     }
                  }
                  else
                  {
                     _loc5_ = true;
                  }
               }
            }
         }
         return _loc5_;
      }
      
      protected function makeEffectPlayableToCardSocket(param1:FSCardSocket, param2:Dictionary, param3:Boolean = false) : void
      {
         var _loc6_:FSCardSocket = null;
         var _loc4_:ColorArgb = new ColorArgb(0,1,0,1);
         var _loc5_:ColorArgb = new ColorArgb(0,1,0,0);
         if(param1.getParentCard().getCardDef().getTier() < 3 && param3 || !param3)
         {
            for each(_loc6_ in param2)
            {
               if(_loc6_.getColumnIndex() == param1.getColumnIndex() && _loc6_.getRowIndex() == param1.getRowIndex())
               {
                  _loc6_.visible = true;
                  TweenMax.killTweensOf(_loc6_);
                  _loc6_.alpha = 1;
                  SpecialFX.createYoYoAlphaTransition(_loc6_,0.9,0.5);
                  param1.getParentCard() && param1.getParentCard().setCardDropShadowAlpha(0);
                  break;
               }
            }
         }
      }
      
      public function isAnyCardOrPowerPlayable() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:FSCardSocket = null;
         if(Config.getConfig().getActivateSuggestPlayable() && this.mBattleEngine.isOwnerTurn())
         {
            for each(_loc2_ in this.mOwnerBFSocketCatalog)
            {
               if(_loc2_.getParentCard() != null && _loc2_.getParentCard().getType() == FSCard.TYPE_UNIT)
               {
                  if(this.canApplyEffectPlayableToCardSocketPromote(_loc2_,this.mBattleEngine.isOwnerTurn()))
                  {
                     _loc1_ = true;
                     break;
                  }
               }
            }
            if(!_loc1_ && this.mColumnsAmount * this.mRowsAmount > this.getSocketsFilled())
            {
               for each(_loc2_ in this.mOwnerSideDeckSocketCatalog)
               {
                  if(this.canApplyEffectPlayableToCardSocketSummon(_loc2_,this.mBattleEngine.isOwnerTurn()))
                  {
                     _loc1_ = true;
                     break;
                  }
               }
            }
         }
         else
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      private function getSocketsFilled() : int
      {
         var _loc2_:FSCardSocket = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.mOwnerBFSocketCatalog)
         {
            if(_loc2_.getParentCard() != null)
            {
               _loc1_ += 1;
            }
         }
         return _loc1_;
      }
      
      public function performAttackAnimation(param1:FSUnit) : void
      {
         if(this.mAttackAnimationMC)
         {
            this.mAttackAnimationMC.alpha = 0.001;
            this.mAttackAnimationMC.x = param1.x;
            addChild(this.mAttackAnimationMC);
            this.mAttackAnimationMC.visible = true;
            this.mAttackAnimationMC.play();
            SpecialFX.tweenToAlpha(this.mAttackAnimationMC,0.999,0.5,1,this.onAttackAnimationComplete);
         }
      }
      
      private function onAttackAnimationComplete() : void
      {
         if(this.mAttackAnimationMC)
         {
            TweenMax.killTweensOf(this.mAttackAnimationMC);
            this.mAttackAnimationMC.stop();
            this.mAttackAnimationMC.visible = false;
         }
      }
      
      public function getOwnerPowerImage() : FSImage
      {
         return this.mOwnerPowerImage;
      }
      
      public function getOpponentPowerImage() : FSImage
      {
         return this.mOpponentPowerImage;
      }
      
      public function createAIEvent(param1:String) : FSEvent
      {
         if(this.mAIEvent == null)
         {
            this.mAIEvent = new FSEvent(param1);
         }
         return this.mAIEvent;
      }
      
      public function createAIPower(param1:String) : FSPower
      {
         if(this.mAIPower == null)
         {
            this.mAIPower = new FSPower(param1);
         }
         return this.mAIPower;
      }
      
      public function updateEmblems() : void
      {
         var _loc1_:UserBattleInfo = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(Config.getConfig().gameHasEmblems())
         {
            _loc1_ = this.mBattleEngine.isOwnerTurn() ? this.mBattleEngine.getOwnerBattleInfo() : this.mBattleEngine.getOpponentBattleInfo();
            _loc2_ = DictionaryUtils.getKeys(_loc1_.getEmblems());
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               if(this.mOwnerEmblemsVector == null)
               {
                  this.mOwnerEmblemsVector = new Vector.<FSImage>();
               }
               if(this.mOwnerEmblemsTextfieldVector == null)
               {
                  this.mOwnerEmblemsTextfieldVector = new Vector.<FSTextfield>();
               }
               if(this.mOpponentEmblemsVector == null)
               {
                  this.mOpponentEmblemsVector = new Vector.<FSImage>();
               }
               if(this.mOpponentEmblemsTextfieldVector == null)
               {
                  this.mOpponentEmblemsTextfieldVector = new Vector.<FSTextfield>();
               }
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = _loc2_[_loc3_];
                  if(this.existEmblemNameInVector(_loc4_))
                  {
                     this.updateEmblemText(_loc4_);
                  }
                  else
                  {
                     this.createEmblem(_loc4_);
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      private function updateEmblemText(param1:String) : void
      {
         var _loc3_:UserBattleInfo = null;
         var _loc4_:Dictionary = null;
         var _loc5_:int = 0;
         var _loc2_:Vector.<FSTextfield> = this.mBattleEngine.isOwnerTurn() ? this.mOwnerEmblemsTextfieldVector : this.mOpponentEmblemsTextfieldVector;
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            _loc3_ = this.mBattleEngine.isOwnerTurn() ? this.mBattleEngine.getOwnerBattleInfo() : this.mBattleEngine.getOpponentBattleInfo();
            _loc4_ = _loc3_.getEmblems();
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               if(FSTextfield(_loc2_[_loc5_]).name == param1)
               {
                  FSTextfield(_loc2_[_loc5_]).text = _loc4_[param1];
                  break;
               }
               _loc5_++;
            }
         }
      }
      
      private function createEmblem(param1:String) : void
      {
         var _loc2_:UserBattleInfo = this.mBattleEngine.isOwnerTurn() ? this.mBattleEngine.getOwnerBattleInfo() : this.mBattleEngine.getOpponentBattleInfo();
         var _loc3_:FactionDef = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(param1));
         var _loc4_:Dictionary = _loc2_.getEmblems();
         var _loc5_:Vector.<FSImage> = this.mBattleEngine.isOwnerTurn() ? this.mOwnerEmblemsVector : this.mOpponentEmblemsVector;
         var _loc6_:Vector.<FSTextfield> = this.mBattleEngine.isOwnerTurn() ? this.mOwnerEmblemsTextfieldVector : this.mOpponentEmblemsTextfieldVector;
         var _loc7_:FSImage = new FSImage(Root.assets.getTexture("defense_card_icon"));
         _loc7_.name = param1;
         var _loc8_:FSCoordinate = this.getCoordinateLastEmblem();
         _loc7_.x = _loc8_.getX() + _loc7_.width;
         _loc7_.y = _loc8_.getY();
         _loc5_.push(_loc7_);
         addChild(_loc7_);
         var _loc9_:FSTextfield = new FSTextfield(_loc7_.width,_loc7_.height,_loc4_[param1]);
         _loc9_.name = param1;
         _loc9_.x = _loc7_.x;
         _loc9_.y = _loc7_.y;
         _loc6_.push(_loc9_);
         addChild(_loc9_);
      }
      
      private function getCoordinateLastEmblem() : FSCoordinate
      {
         var _loc1_:FSCoordinate = null;
         var _loc2_:FSBattlefieldUserPortrait = this.mBattleEngine.isOwnerTurn() ? this.mOwnerPortrait : this.mOpponentPortrait;
         var _loc3_:Vector.<FSImage> = this.mBattleEngine.isOwnerTurn() ? this.mOwnerEmblemsVector : this.mOpponentEmblemsVector;
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc1_ = new FSCoordinate(FSImage(_loc3_[_loc3_.length - 1]).x + FSImage(_loc3_[_loc3_.length - 1]).width / 4,FSImage(_loc3_[_loc3_.length - 1]).y);
         }
         else
         {
            _loc1_ = new FSCoordinate(0,_loc2_.y);
         }
         return _loc1_;
      }
      
      private function existEmblemNameInVector(param1:String) : Boolean
      {
         var _loc3_:FSImage = null;
         var _loc2_:Boolean = false;
         var _loc4_:Vector.<FSImage> = this.mBattleEngine.isOwnerTurn() ? this.mOwnerEmblemsVector : this.mOpponentEmblemsVector;
         if((Boolean(_loc4_)) && _loc4_.length > 0)
         {
            for each(_loc3_ in _loc4_)
            {
               if(_loc3_.name == param1)
               {
                  _loc2_ = true;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public function createAttachedAnimation(param1:FSCard) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:AttachedAnimation = null;
         if(param1)
         {
            _loc2_ = Config.getConfig().getCardAttachedAnimOverSocket();
            if(!_loc2_ || Boolean(_loc2_ && param1.getAttachedToSocket()) && Boolean(param1.getAttachedToSocket().isBattlefieldSocket()))
            {
               if(this.mAttachedAnimationsVector == null)
               {
                  this.mAttachedAnimationsVector = new Vector.<AttachedAnimation>();
               }
               if(this.mAttachedAnimationsVector.length > 0)
               {
                  this.mAttachedAnimationsVector.pop().refreshCard(param1);
               }
               else
               {
                  _loc3_ = new AttachedAnimation(param1);
                  _loc3_.touchable = false;
               }
            }
         }
      }
      
      public function onAttachedAnimEnd(param1:AttachedAnimation) : void
      {
         if(param1)
         {
            if(this.mAttachedAnimationsVector == null)
            {
               this.mAttachedAnimationsVector = new Vector.<AttachedAnimation>();
            }
            this.mAttachedAnimationsVector.push(param1);
         }
      }
      
      public function updateUIForScreenShots() : void
      {
         if(this.mScoresStarsContainer != null)
         {
            this.mScoresStarsContainer.visible = !Config.smScreenShotMode;
         }
         if(this.mObjectivesPanel)
         {
            this.mObjectivesPanel.visible = !Config.smScreenShotMode;
         }
         if(this.mBoostsContainer)
         {
            this.mBoostsContainer.visible = !Config.smScreenShotMode;
         }
         if(Boolean(this.mAttackButton) && Boolean(this.mAttackButton.getTurnsTextfield()))
         {
            this.mAttackButton.getTurnsTextfield().visible = !Config.smScreenShotMode;
         }
         if(Boolean(this.mOpponentPortrait) && Boolean(this.mOpponentPortrait.getNameFrame()))
         {
            this.mOpponentPortrait.getNameFrame().visible = !Config.smScreenShotMode;
         }
         if(Boolean(this.mOwnerPortrait) && Boolean(this.mOwnerPortrait.getNameFrame()))
         {
            this.mOwnerPortrait.getNameFrame().visible = !Config.smScreenShotMode;
         }
         if(getOptionsPanel())
         {
            getOptionsPanel().visible = !Config.smScreenShotMode;
         }
         if(getGuildsButton())
         {
            getGuildsButton().visible = !Config.smScreenShotMode;
         }
         if(this.mOwnerActionPointsCounter)
         {
            this.mOwnerActionPointsCounter.visible = !Config.smScreenShotMode;
         }
         if(this.mOpponentActionPointsCounter)
         {
            this.mOpponentActionPointsCounter.visible = !Config.smScreenShotMode;
         }
      }
      
      public function updateScoreStars() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Texture = null;
         var _loc13_:Texture = null;
         var _loc1_:Boolean = Boolean(Root.smBattleData.isDungeon);
         var _loc2_:Boolean = Boolean(Root.smBattleData.isRaid);
         var _loc3_:Boolean = InstanceMng.getBattleEngine().isPvPMatch();
         if(Boolean(this.mBattleEngine && !_loc1_ && !_loc2_) && Boolean(!_loc3_) && Boolean(this.mBattleEngine.getLevelDef()))
         {
            _loc4_ = InstanceMng.getScoreMng().calculateFinalScore(true);
            _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc6_ = this.mBattleEngine.getLevelDef().getMinScoreByDifficulty(_loc5_);
            _loc7_ = this.mBattleEngine.getLevelDef().getMedScoreByDifficulty(_loc5_);
            _loc8_ = this.mBattleEngine.getLevelDef().getMaxScoreByDifficulty(_loc5_);
            _loc9_ = _loc4_ >= _loc6_;
            _loc10_ = _loc4_ >= _loc7_;
            _loc11_ = _loc4_ >= _loc8_;
            _loc12_ = Root.assets.getTexture("battle_star_icon_empty");
            _loc13_ = Root.assets.getTexture("battle_star_icon");
            if(this.mScoresStarsContainer == null)
            {
               this.mScoresStarsContainer = new Component();
               this.mScoresStarsContainer.touchable = true;
               this.mScoresStarsContainer.setTooltipText(TextManager.getText("TID_BATTLE_STARS",true));
               addChild(this.mScoresStarsContainer);
            }
            if(this.mMinScoreReachedStar == null)
            {
               this.mMinScoreReachedStar = _loc9_ ? new FSImage(_loc13_) : new FSImage(_loc12_);
               this.mMinScoreReachedStar.x = 0;
               this.mMinScoreReachedStar.y = 0;
               this.mScoresStarsContainer.addChild(this.mMinScoreReachedStar);
            }
            else
            {
               this.mMinScoreReachedStar.texture = _loc9_ ? _loc13_ : _loc12_;
            }
            if(this.mMedScoreReachedStar == null)
            {
               this.mMedScoreReachedStar = _loc10_ ? new FSImage(_loc13_) : new FSImage(_loc12_);
               this.mMedScoreReachedStar.x = this.mMinScoreReachedStar.x + this.mMinScoreReachedStar.width;
               this.mMedScoreReachedStar.y = 0;
               this.mScoresStarsContainer.addChild(this.mMedScoreReachedStar);
            }
            else
            {
               this.mMedScoreReachedStar.texture = _loc10_ ? _loc13_ : _loc12_;
            }
            if(this.mMaxScoreReachedStar == null)
            {
               this.mMaxScoreReachedStar = _loc11_ ? new FSImage(_loc13_) : new FSImage(_loc12_);
               this.mMaxScoreReachedStar.x = this.mMedScoreReachedStar.x + this.mMedScoreReachedStar.width;
               this.mMaxScoreReachedStar.y = 0;
               this.mScoresStarsContainer.addChild(this.mMaxScoreReachedStar);
            }
            else
            {
               this.mMaxScoreReachedStar.texture = _loc11_ ? _loc13_ : _loc12_;
            }
            this.mScoresStarsContainer.x = Starling.current.stage.stageWidth - this.mScoresStarsContainer.width;
            this.mScoresStarsContainer.y = 0;
         }
      }
      
      override public function onConnectionLost(param1:Boolean = true, param2:Boolean = true, param3:Boolean = false) : void
      {
         super.onConnectionLost(param1,true,param3);
         if(!Utils.smInternetAvailable)
         {
            if(Root.smBattleData.isRaid)
            {
               Utils.setLogText(TextManager.getText("TID_SERVER_RAID_DESYNC"),true,false,false);
            }
         }
      }
      
      public function isOwnerBFSocketsFull() : Boolean
      {
         var _loc1_:Dictionary = null;
         var _loc2_:FSCardSocket = null;
         if(this.mBattleEngine)
         {
            _loc1_ = !this.mBattleEngine.isOnlineMatch() && this.mBattleEngine.isPvPMatch() && !this.mBattleEngine.isOwnerTurn() ? this.mOpponentBFSocketCatalog : this.mOwnerBFSocketCatalog;
            if(_loc1_ != null)
            {
               for each(_loc2_ in _loc1_)
               {
                  if(_loc2_.getParentCard() == null)
                  {
                     return false;
                  }
               }
            }
         }
         return true;
      }
      
      override public function addLights(param1:Boolean = false, param2:Boolean = false) : void
      {
         super.addLights(true,true);
      }
   }
}

