package com.fs.tcgengine.screens
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.boosts.Boost;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.BackgroundDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.battle.ActionPointsCounter;
   import com.fs.tcgengine.view.components.battle.FSTimeLeftCounter;
   import com.fs.tcgengine.view.components.misc.ChatButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.pvp.PvPOverEffect;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.events.TouchEvent;
   import starling.utils.Align;
   import starling.utils.StringUtil;
   
   public class FSBattleScreenPvP extends FSBattleScreen
   {
      
      protected var mOpponentSideDeckSocketSuggestCatalog:Dictionary;
      
      protected var mChatButton:ChatButton;
      
      protected var mTimeLeftCounter:FSTimeLeftCounter;
      
      protected var mOpponentDeckAreaBG:FSImage;
      
      protected var mOpponentDeckAreaBGLocked:FSImage;
      
      public var mPvPOverEffect:PvPOverEffect;
      
      private var mOfflineMatchContainer:Component;
      
      private var mOfflineMatchIcon:FSImage;
      
      private var mOfflineMatchTextfield:FSTextfield;
      
      public function FSBattleScreenPvP()
      {
         super();
      }
      
      public static function getResumeStdCardPlaybackTime() : Number
      {
         return 1.5 * Utils.getDefaultSpeedTime();
      }
      
      override protected function setResourcesToLoad() : void
      {
         if(!InstanceMng.getApplication().areOnDemandDefinitionsInitialized())
         {
            InstanceMng.getResourcesMng().addDefinitionsFolderByName(StringUtil.format(InstanceMng.getResourcesMng().getAssetsOnDemandURL("fonts_on_demand/") + "{0}x" + Layout.getType(),Main.smScaleFactor));
         }
         InstanceMng.getResourcesMng().addResourcesFolderByName("pvpLeagues");
         if(mBattleEngine != null)
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("battleScreenPvP");
            InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + "player_2_photo",FSResourceMng.TYPE_TEXTURE_PNG);
         }
         super.setResourcesToLoad();
      }
      
      override protected function loadSkinsResources(param1:Boolean, param2:Boolean = false) : void
      {
         super.loadSkinsResources(param1,true);
      }
      
      override public function notifyAssetsLoaded(param1:* = null) : void
      {
         if(!InstanceMng.getApplication().areOnDemandDefinitionsInitialized())
         {
            InstanceMng.getApplication().initializeManagers();
            InstanceMng.getResourcesMng().removeDefinitions();
         }
         super.notifyAssetsLoaded(param1);
      }
      
      private function createOfflineInfo() : void
      {
         if(PvPConnectionMng.smPlayingAgainstOfflineDeck)
         {
            if(this.mOfflineMatchContainer == null)
            {
               this.mOfflineMatchContainer = new Component();
            }
            this.mOfflineMatchContainer.touchable = true;
            addChild(this.mOfflineMatchContainer);
            this.mOfflineMatchContainer.setTooltipText(TextManager.getText("TID_PVP_IA_MATCH_INFO",true));
            if(this.mOfflineMatchIcon == null)
            {
               this.mOfflineMatchIcon = new FSImage(Root.assets.getTexture("pvp_offline_match_icon"));
            }
            this.mOfflineMatchContainer.addChild(this.mOfflineMatchIcon);
            if(this.mOfflineMatchTextfield == null)
            {
               this.mOfflineMatchTextfield = new FSTextfield(mBGSprite.width / 4,this.mOfflineMatchIcon.height,TextManager.getText("TID_PVP_IA_MATCH",true));
               this.mOfflineMatchTextfield.x = this.mOfflineMatchIcon.x + this.mOfflineMatchIcon.width;
               this.mOfflineMatchTextfield.y = this.mOfflineMatchIcon.y;
            }
            this.mOfflineMatchContainer.addChild(this.mOfflineMatchTextfield);
         }
      }
      
      override protected function trackPageView() : void
      {
         if(Config.PRODUCTION_BUILD)
         {
            InstanceMng.getApplication().trackCurrentScreen(mScreenName + "PvP");
         }
      }
      
      override protected function chooseBGName() : void
      {
         var _loc1_:Dictionary = InstanceMng.getBackgroundDefMng().getAllDefs();
         var _loc2_:Array = DictionaryUtils.getKeys(_loc1_);
         var _loc3_:Boolean = Utils.getOwnerUserData() ? Utils.getOwnerUserData().flagsGetUseNewBGsON() : true;
         _loc2_ = this.removeTutorialBGsFromRotation(_loc2_,_loc3_);
         var _loc4_:int = Boolean(_loc2_) && _loc2_.length > 0 ? Utils.randomInt(0,_loc2_.length - 1) : -1;
         var _loc5_:LevelDef = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().getLevelDef() : null;
         var _loc6_:String = "background_01";
         if(_loc5_ != null)
         {
            _loc6_ = _loc3_ ? _loc5_.getBackgroundSku(UserData.WORLD_DEFAULT) : _loc5_.getBackgroundSkuOld(UserData.WORLD_DEFAULT);
         }
         var _loc7_:BackgroundDef = _loc4_ != -1 ? BackgroundDef(InstanceMng.getBackgroundDefMng().getDefBySku(_loc2_[_loc4_])) : BackgroundDef(InstanceMng.getBackgroundDefMng().getDefBySku(_loc6_));
         var _loc8_:String = _loc7_ ? _loc7_.getBGImageName() : null;
         mBGName = _loc8_ != null ? _loc8_ : "background_01";
      }
      
      private function removeTutorialBGsFromRotation(param1:Array, param2:Boolean) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:BackgroundDef = null;
         var _loc5_:Boolean = false;
         if(param1)
         {
            _loc5_ = false;
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(!_loc5_)
               {
                  _loc4_ = BackgroundDef(InstanceMng.getBackgroundDefMng().getDefBySku(param1[_loc3_]));
                  if((Boolean(_loc4_)) && (_loc4_.isTutorial() || (param2 && _loc4_.isOld() || !param2 && !_loc4_.isOld())))
                  {
                     param1.splice(_loc3_,1);
                     _loc5_ = true;
                  }
               }
               _loc3_++;
            }
         }
         if(_loc5_)
         {
            return this.removeTutorialBGsFromRotation(param1,param2);
         }
         return param1;
      }
      
      public function createPvPOverEffect(param1:UserBattleInfo, param2:Number = 0, param3:String = null, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false) : void
      {
         this.mPvPOverEffect = new PvPOverEffect(param2,param1,param3,param4,param5,param6);
         addChild(this.mPvPOverEffect);
      }
      
      override public function unload() : void
      {
         if(this.mOpponentDeckAreaBG)
         {
            this.mOpponentDeckAreaBG.removeFromParent(true);
            this.mOpponentDeckAreaBG = null;
         }
         if(this.mOpponentDeckAreaBGLocked)
         {
            this.mOpponentDeckAreaBGLocked.removeFromParent(true);
            this.mOpponentDeckAreaBGLocked = null;
         }
         if(this.mTimeLeftCounter)
         {
            this.mTimeLeftCounter.removeFromParent(true);
            this.mTimeLeftCounter = null;
         }
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("battleScreenPvP",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         Root.assets.removeTexture("player_2_photo",true);
         InstanceMng.getResourcesMng().removeResourcesFromFolder("pvpLeagues");
         if(this.mChatButton)
         {
            this.mChatButton.removeFromParent(true);
            this.mChatButton = null;
         }
         if(this.mPvPOverEffect)
         {
            this.mPvPOverEffect.removeFromParent(true);
            this.mPvPOverEffect = null;
         }
         if(this.mOfflineMatchIcon)
         {
            this.mOfflineMatchIcon.removeFromParent(true);
            this.mOfflineMatchIcon = null;
         }
         if(this.mOfflineMatchTextfield)
         {
            this.mOfflineMatchTextfield.removeFromParent(true);
            this.mOfflineMatchTextfield = null;
         }
         if(this.mOfflineMatchContainer)
         {
            this.mOfflineMatchContainer.removeFromParent(true);
            this.mOfflineMatchContainer = null;
         }
         if(this.mOfflineMatchContainer)
         {
            this.mOfflineMatchContainer.removeFromParent(true);
            this.mOfflineMatchContainer = null;
         }
         PvPConnectionMng.smPlayingFriendlyMatch = false;
         PvPConnectionMng.smPlayingAgainstBOT = false;
         PvPConnectionMng.smPlayingAgainstOfflineDeck = false;
         PvPConnectionMng.smUserInPvPBattle = false;
         PvPConnectionMng.smBattleSyncData = null;
         PvPConnectionMng.smInitMatchInfoReceived = false;
         PvPConnectionMng.smPvPFriendlyUID = "";
         DictionaryUtils.clearDictionary(this.mOpponentSideDeckSocketSuggestCatalog);
         this.mOpponentSideDeckSocketSuggestCatalog = null;
         super.unload();
      }
      
      override public function createUI() : void
      {
         super.createUI();
         this.createChatIcon();
         this.createTimeLeftCounter();
         this.createOfflineInfo();
      }
      
      override protected function getActionDeckAssetName(param1:Boolean = true) : String
      {
         return param1 ? "actionDeck_pvp_owner" : "actionDeck_pvp_opponent";
      }
      
      override protected function createSockets() : void
      {
         super.createSockets();
         mOpponentSideDeckSocketCatalog = new Dictionary(true);
         this.mOpponentSideDeckSocketSuggestCatalog = new Dictionary(true);
         this.createOpponentsDeckAreaSockets();
      }
      
      override protected function createOwnerDeckAreaSockets(param1:uint = 1) : void
      {
         super.createOwnerDeckAreaSockets(1196203);
      }
      
      protected function createOpponentsDeckAreaSockets() : void
      {
         var _loc1_:Boolean = Config.getConfig().PvPDeckAreaSocketsUseColors();
         var _loc2_:uint = _loc1_ ? 16711680 : uint(-1);
         var _loc3_:Number = Starling.current.stage.stageHeight * 0.04;
         var _loc4_:int = mBattleEngine.getLevelDef().getDeckCards();
         createDefaultSocket(Config.getConfig().getDeckDefaultRows(),Config.getConfig().getDeckDefaultColumns(),true,false,getDeckAreaWidth(),getDeckAreaHeight(),mOwnerPortrait.getUsefulWidth(),_loc3_,_loc4_,mOpponentSideDeckSocketCatalog,_loc2_);
         if(Config.getConfig().getActivateSuggestPlayable())
         {
            createDefaultSocket(Config.getConfig().getDeckDefaultRows(),Config.getConfig().getDeckDefaultColumns(),true,false,getDeckAreaWidth(),getDeckAreaHeight(),mOwnerPortrait.getUsefulWidth(),_loc3_,_loc4_,this.mOpponentSideDeckSocketSuggestCatalog,_loc2_,true);
         }
      }
      
      override protected function createObjectivesPanel() : void
      {
      }
      
      override protected function createBoostItems() : void
      {
      }
      
      override public function updateObjectivesProgress() : void
      {
      }
      
      override public function enableBoostsPanel(param1:Boolean) : void
      {
      }
      
      override public function updateCurrentTurnsTextfield() : void
      {
      }
      
      override public function dealOwnerCardsToDeck(param1:Boost = null, param2:String = "", param3:Boolean = false) : void
      {
         showLoadingIcon(false,true);
         this.dealCardsToDeck(param2);
         if(param2 == "")
         {
            BattleEnginePvP(mBattleEngine).onOwnerCardsDealt();
         }
      }
      
      override public function dealOpponentCardsToDeck(param1:String = "") : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:FSCard = null;
         var _loc5_:CardDef = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         if(mBattleEngine.isOnlineMatch())
         {
            if(BattleEnginePvP(mBattleEngine).checkSavedCardsForResume() && !PvPConnectionMng.isPlayingVSAI())
            {
               showLoadingIcon(false,true);
               this.getBattleEnginePvP().resumePlayableCards(false);
            }
            else
            {
               if(PvPConnectionMng.isPlayingVSAI() && mBattleEngine.isNextHandCalculated())
               {
                  _loc3_ = mBattleEngine.getNextHand(null,param1);
                  if(Boolean(PvPConnectionMng.smPvPBattleData["save"]) && Boolean(PvPConnectionMng.smPvPBattleData["save"]["opponentBattleInfo"]) && Boolean(PvPConnectionMng.smPvPBattleData["save"]["opponentBattleInfo"].mPlayableCardsCatalog))
                  {
                     delete PvPConnectionMng.smPvPBattleData["save"]["opponentBattleInfo"].mPlayableCardsCatalog;
                  }
                  if(PvPConnectionMng.smPvPBattleData["save"] == null)
                  {
                     _loc6_ = InstanceMng.getBattleEngine().getCurrentTurnId().toString();
                     PvPConnectionMng.prepareSaveObj(_loc6_,Root.smBattleData["mOwnerMovesFirst"]);
                  }
                  _loc2_ = 0;
                  while(_loc2_ < _loc3_.length)
                  {
                     _loc5_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_[_loc2_]));
                     _loc7_ = _loc5_ is UnitDef ? UnitDef(_loc5_).getSummonCooldown() : 0;
                     PvPConnectionMng.storePlayableCard(_loc3_[_loc2_],_loc2_,_loc7_);
                     _loc2_++;
                  }
                  showLoadingIcon(false,true);
                  this.getBattleEnginePvP().resumePlayableCards(false);
                  return;
               }
               if(mBattleEngine != null && !mBattleEngine.isOwnerTurn())
               {
                  this.handleExpirationTimerOnOpponentCardsReceived();
               }
            }
         }
         else
         {
            this.dealCardsToDeck();
         }
      }
      
      private function handleExpirationTimerOnOpponentCardsReceived() : void
      {
         PvPConnectionMng.smExpirationTime = TimerUtil.currentTimeMillis() + TimerUtil.secondToMs(Config.smPvPWaitingOpponentMoveTime);
         BattleEnginePvP(mBattleEngine).requestOpponentPvPTimer(true);
         showLoadingIcon(true,false,Align.RIGHT,Align.CENTER,1,null,InstanceMng.getLogPanel());
      }
      
      public function dealCardsToDeck(param1:String = "", param2:Boolean = false) : void
      {
         var _loc6_:FSCardSocket = null;
         var _loc7_:FSCard = null;
         var _loc8_:int = 0;
         var _loc9_:Dictionary = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:AbilityDef = null;
         var _loc14_:FSCoordinate = null;
         var _loc15_:Boolean = false;
         var _loc16_:Function = null;
         var _loc3_:Boolean = mBattleEngine.isOwnerTurn();
         var _loc4_:UserBattleInfo = _loc3_ ? mBattleEngine.getOwnerBattleInfo() : mBattleEngine.getOpponentBattleInfo();
         var _loc5_:int = 0;
         if(_loc4_ != null)
         {
            _loc8_ = 0;
            _loc9_ = mBattleEngine.isOwnerTurn() ? mOwnerSideDeckSocketCatalog : mOpponentSideDeckSocketCatalog;
            _loc10_ = InstanceMng.getBattleEngine().getNextHand();
            if(_loc10_)
            {
               _loc8_ = 0;
               while(_loc8_ < _loc10_.length)
               {
                  _loc7_ = InstanceMng.getCardsMng().createCard(_loc10_[_loc8_]);
                  if(_loc7_ != null)
                  {
                     _loc7_.setParentUserBattleInfo(_loc4_);
                     _loc13_ = _loc7_.getCostModifierAbilityDef();
                     if(_loc13_)
                     {
                        _loc7_.updateSummonCost(_loc13_);
                     }
                     addChild(_loc7_);
                     _loc11_ = param1 != "" ? _loc4_.getPlayableCardsUsedInTurn() : _loc8_;
                     _loc7_.setPlayableCardId(_loc11_);
                     _loc12_ = param1 == "" ? _loc11_ : getFirstEmptyDeckSocketIndex(_loc3_);
                     _loc4_.addPlayableCard(_loc7_);
                     _loc6_ = getCardSocketByIndex(_loc12_,_loc9_);
                     _loc7_.setAttachedToSocket(_loc6_,true);
                     _loc7_.setBattleSceneParent(this);
                     _loc14_ = getSocketWorldCoordsByIndex(_loc12_,_loc9_);
                     _loc14_.setX(_loc14_.getX());
                     _loc14_.setY(_loc14_.getY());
                     _loc15_ = _loc8_ == _loc10_.length - 1;
                     if((_loc15_) && param1 == "")
                     {
                        _loc16_ = param2 ? enableAfterFreeReshuffle : battleEngineChangePlayersState;
                     }
                     else
                     {
                        _loc16_ = null;
                     }
                     performCardDealFX(_loc7_,_loc14_,getDealCardSpeed(true,_loc8_),_loc6_,_loc16_);
                     _loc5_++;
                  }
                  _loc8_++;
               }
            }
            if(_loc5_ == 0)
            {
               _loc16_ = param2 ? enableAfterFreeReshuffle : battleEngineChangePlayersState;
            }
         }
         InstanceMng.getBattleEngine().resetNextHandArr();
         FSDebug.debugTrace("[dealCardsToDeck] - cards dealed");
         if(param2)
         {
            BattleEnginePvP(mBattleEngine).onOwnerCardsDealt(true);
         }
      }
      
      private function getBattleEnginePvP() : BattleEnginePvP
      {
         return BattleEnginePvP(mBattleEngine);
      }
      
      override public function returnOpponentCardsToDeck(param1:Boolean = false) : void
      {
         this.returnPlayerCardsToDeck(param1,false);
      }
      
      override public function returnOwnerCardsToDeck(param1:Boost = null, param2:Boolean = false) : void
      {
         this.returnPlayerCardsToDeck(param2);
      }
      
      private function returnPlayerCardsToDeck(param1:Boolean = false, param2:Boolean = true) : void
      {
         var onCompleteFunction:Function = null;
         var onCompleteParams:Object = null;
         var coord:FSCoordinate = null;
         var card:FSCard = null;
         var removeLastCardAndDealCardsToDeck:Function = null;
         var dealCardsAfterFreeReshuffle:Function = null;
         var isEnemyCard:Boolean = false;
         var delay:Number = NaN;
         var freeReshuffle:Boolean = param1;
         var isOwner:Boolean = param2;
         removeLastCardAndDealCardsToDeck = function(param1:FSCard, param2:Boolean = true):void
         {
            removeReturnedCard(param1);
            if(param2)
            {
               loadNextCardsHandResources(null,dealCardsAfterFreeReshuffle);
            }
            else if(PvPConnectionMng.realTimeAllowed())
            {
               InstanceMng.getBattleEngine().setResumingPvPCard(false);
               FSDebug.debugTrace("[PVP REAL TIME] Checking pool after reshuffle");
               TweenMax.delayedCall(2,PvPConnectionMng.onMoveFinishedCheckPool);
            }
         };
         dealCardsAfterFreeReshuffle = function():void
         {
            showLoadingIcon(false,true);
            PvPConnectionMng.resetBattleDataAfterReshuffle();
            dealCardsToDeck("",true);
         };
         var battleUserInfo:UserBattleInfo = mBattleEngine.isOwnerTurn() ? mBattleEngine.getOwnerBattleInfo() : mBattleEngine.getOpponentBattleInfo();
         var playableCards:Dictionary = battleUserInfo.getPlayableCardsCatalog();
         var playableCardsLength:int = DictionaryUtils.getDictionaryLength(playableCards);
         var count:int = playableCardsLength;
         this.suggestPlayableCardOFF();
         for each(card in playableCards)
         {
            battleUserInfo.addCardSkuToCatalogs(card.getCardDef().getSku(),1);
            isEnemyCard = card.isEnemyCard(true);
            if(isEnemyCard)
            {
               coord = mOpponentCardDealingPoint ? new FSCoordinate(mOpponentCardDealingPoint.x,mOpponentCardDealingPoint.y) : new FSCoordinate(-card.width,Starling.current.stage.stageHeight / 2);
            }
            else
            {
               coord = mOwnerCardDealingPoint ? new FSCoordinate(mOwnerCardDealingPoint.x,mOwnerCardDealingPoint.y) : new FSCoordinate(-card.width,Starling.current.stage.stageHeight / 2);
            }
            onCompleteFunction = removeReturnedCard;
            if(count == playableCardsLength)
            {
               if(freeReshuffle)
               {
                  onCompleteFunction = removeLastCardAndDealCardsToDeck;
                  onCompleteParams = [card,isOwner];
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
            delay = count * 0.2;
            performReturnEffectOnCard(card,coord,delay,onCompleteFunction,onCompleteParams);
            count--;
         }
         if(playableCardsLength == 0)
         {
            if(freeReshuffle)
            {
               this.dealCardsToDeck();
            }
            else
            {
               mBattleEngine.changePlayersState();
            }
         }
      }
      
      override public function showAttackButton() : void
      {
         var _loc3_:Boolean = false;
         this.createAttackButton();
         var _loc1_:Boolean = mBattleEngine.isOnlineMatch();
         var _loc2_:Boolean = mBattleEngine.isOwnerTurn();
         if(_loc2_)
         {
            _loc3_ = mBattleEngine.getPlayersStateId() == BattleEngine.STATE_OWNER_MOVING_CARDS;
         }
         else
         {
            _loc3_ = !_loc1_ && mBattleEngine.getPlayersStateId() == BattleEngine.STATE_OPPONENT_MOVING_CARDS;
         }
         if(_loc3_)
         {
            mBattleEngine.enableAttackButton();
         }
         else
         {
            mBattleEngine.disableAttackButton();
         }
      }
      
      override protected function reset(param1:Boolean = false) : void
      {
         if(!param1)
         {
            if(mOpponentActionPointsCounter)
            {
               mOpponentActionPointsCounter.removeFromParent(true);
               mOpponentActionPointsCounter = null;
            }
         }
         DictionaryUtils.disposeCatalogCards(mOpponentSideDeckSocketCatalog,param1);
         DictionaryUtils.clearDictionary(mOwnerSideDeckSocketCatalog);
         mOwnerSideDeckSocketCatalog = null;
         DictionaryUtils.clearDictionary(mOpponentSideDeckSocketCatalog);
         mOpponentSideDeckSocketCatalog = null;
         super.reset(param1);
      }
      
      override public function getActionPointsCounter(param1:Boolean) : ActionPointsCounter
      {
         return param1 ? mOwnerActionPointsCounter : mOpponentActionPointsCounter;
      }
      
      protected function createChatIcon() : void
      {
         var _loc1_:Boolean = Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().isPvPMatch();
         if(_loc1_ && InstanceMng.getBattleEngine().isOnlineMatch() && this.mChatButton == null)
         {
            this.mChatButton = new ChatButton();
            this.mChatButton.x = mGuildsButton ? mGuildsButton.x - 2 : Starling.current.stage.stageWidth - this.mChatButton.width / 2;
            this.mChatButton.y = mGuildsButton ? mGuildsButton.y - mGuildsButton.height * 1.5 : Starling.current.stage.stageHeight - this.mChatButton.height * 2.5;
            addChild(this.mChatButton);
         }
      }
      
      protected function createTimeLeftCounter() : void
      {
         if(InstanceMng.getBattleEngine().isOnlineMatch())
         {
            if(this.mTimeLeftCounter == null)
            {
               this.mTimeLeftCounter = InstanceMng.getResourcesMng().createTimeLeftCounter(Config.smPvPTurnTime);
               this.mTimeLeftCounter.touchable = false;
               this.mTimeLeftCounter.x = 5;
               this.mTimeLeftCounter.y = mAttackButton.y - mAttackButton.height / 2 - this.mTimeLeftCounter.height / 2.15;
            }
            addChild(this.mTimeLeftCounter);
         }
      }
      
      override protected function createAttackButton() : void
      {
         super.createAttackButton();
         if(this.mTimeLeftCounter)
         {
            addChild(this.mTimeLeftCounter);
            if(this.mTimeLeftCounter.getProgressBar())
            {
               addChild(this.mTimeLeftCounter.getProgressBar());
            }
         }
      }
      
      override protected function createOpponentBattlefieldSockets() : void
      {
         if(Config.getConfig().battleUseDeckBG())
         {
            this.createOpponentDeckSocketsBG();
            createDefaultSocket(mRowsAmount,mColumnsAmount,true,true,getBFWidth(),getBFHeight(),getOpponentBFExtraSpaceX(),this.mOpponentDeckAreaBG.height,0,mOpponentBFSocketCatalog);
            if(Config.getConfig().getActivateSuggestPlayable())
            {
               createDefaultSocket(mRowsAmount,mColumnsAmount,true,true,getBFWidth(),getBFHeight(),getOpponentBFExtraSpaceX(),this.mOpponentDeckAreaBG.height,0,mOpponentBFSocketSuggestCatalog,1,true);
            }
         }
         else
         {
            super.createOpponentBattlefieldSockets();
         }
      }
      
      private function createOpponentDeckSocketsBG() : void
      {
         var _loc1_:BackgroundDef = null;
         var _loc2_:String = null;
         if(Config.getConfig().battleUseDeckBG())
         {
            if(this.mOpponentDeckAreaBG == null)
            {
               _loc1_ = BackgroundDef(InstanceMng.getBackgroundDefMng().getDefBySku(mBGName));
               if(_loc1_ != null)
               {
                  _loc2_ = _loc1_.getCardHolderBG();
                  this.mOpponentDeckAreaBG = new FSImage(Root.assets.getTexture(_loc2_));
                  this.mOpponentDeckAreaBG.touchable = false;
                  this.mOpponentDeckAreaBG.height = -getDeckAreaHeight() * 0.9;
                  this.mOpponentDeckAreaBG.x = getDeckCardsExtraSpaceX() + (getDeckAreaWidth() - mOwnerDeckAreaBG.width) / 2;
                  this.mOpponentDeckAreaBG.y = this.mOpponentDeckAreaBG.height;
                  addChild(this.mOpponentDeckAreaBG);
               }
            }
         }
      }
      
      override public function showOpponentLockedDeckSocketsBG(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Function = null;
         if(Config.getConfig().battleUseDeckBG() && Config.getConfig().battleShowRedPanelWhenNoAPLeft())
         {
            if(this.mOpponentDeckAreaBGLocked == null)
            {
               this.mOpponentDeckAreaBGLocked = new FSImage(Root.assets.getTexture("card_holder_lock"));
               this.mOpponentDeckAreaBGLocked.x = this.mOpponentDeckAreaBG.x + (this.mOpponentDeckAreaBG.width - this.mOpponentDeckAreaBGLocked.width) / 2;
               this.mOpponentDeckAreaBGLocked.y = this.mOpponentDeckAreaBG.y - this.mOpponentDeckAreaBG.height;
            }
            if(param1)
            {
               this.mOpponentDeckAreaBGLocked.alpha = 0.001;
               addChild(this.mOpponentDeckAreaBGLocked);
            }
            TweenMax.killTweensOf(this.mOpponentDeckAreaBGLocked);
            _loc2_ = param1 ? 0.999 : 0.001;
            _loc3_ = !param1 ? this.removeOpponentDeckAreBGLockedFromParent : null;
            SpecialFX.tweenToAlpha(this.mOpponentDeckAreaBGLocked,_loc2_,0.5,0,_loc3_);
         }
      }
      
      private function removeOpponentDeckAreBGLockedFromParent() : void
      {
         if(this.mOpponentDeckAreaBGLocked)
         {
            this.mOpponentDeckAreaBGLocked.removeFromParent();
         }
      }
      
      override public function getOpponentLockedDeckSocketsBG() : FSImage
      {
         return this.mOpponentDeckAreaBGLocked;
      }
      
      public function getTimeLeftCounter() : FSTimeLeftCounter
      {
         return this.mTimeLeftCounter;
      }
      
      override public function suggestPlayableCardON() : void
      {
         var _loc1_:FSCardSocket = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:PowerDef = null;
         var _loc7_:Boolean = false;
         if(Config.getConfig().getActivateSuggestPlayable() && mBattleEngine.getBattleStateId() == BattleEngine.BATTLE_STATE_PLAYER_MOVING_CARDS)
         {
            _loc2_ = 0;
            _loc3_ = mBattleEngine.getLevelDef().getRowsAmount() * mBattleEngine.getLevelDef().getColumnsAmount();
            this.suggestPlayableCardOFF();
            _loc7_ = _loc2_ < _loc3_;
            if(mBattleEngine.isOwnerTurn())
            {
               for each(_loc1_ in mOwnerBFSocketCatalog)
               {
                  if(_loc1_.getParentCard() != null && _loc1_.getParentCard().getType() == FSCard.TYPE_UNIT)
                  {
                     _loc2_ += 1;
                     _loc7_ = _loc2_ < _loc3_;
                     if(canApplyEffectPlayableToCardSocketPromote(_loc1_,mBattleEngine.isOwnerTurn()))
                     {
                        makeEffectPlayableToCardSocket(_loc1_,mOwnerBFSocketSuggestCatalog,true);
                     }
                  }
               }
               for each(_loc1_ in mOwnerSideDeckSocketCatalog)
               {
                  if(canApplyEffectPlayableToCardSocketSummon(_loc1_,mBattleEngine.isOwnerTurn()))
                  {
                     if(_loc7_ || !_loc7_ && (_loc1_.getParentCard() is FSAction || _loc1_.getParentCard() is FSAttachment))
                     {
                        makeEffectPlayableToCardSocket(_loc1_,mOwnerSideDeckSocketSuggestCatalog);
                     }
                  }
               }
               checkPowerSuggestions();
            }
            else if(!mBattleEngine.isOwnerTurn() && !mBattleEngine.isOnlineMatch())
            {
               for each(_loc1_ in mOpponentBFSocketCatalog)
               {
                  if(_loc1_.getParentCard() != null && _loc1_.getParentCard().getType() == FSCard.TYPE_UNIT)
                  {
                     _loc2_ += 1;
                     _loc7_ = _loc2_ < _loc3_;
                     if(canApplyEffectPlayableToCardSocketPromote(_loc1_,mBattleEngine.isOwnerTurn()))
                     {
                        makeEffectPlayableToCardSocket(_loc1_,mOpponentBFSocketSuggestCatalog,true);
                     }
                  }
               }
               for each(_loc1_ in mOpponentSideDeckSocketCatalog)
               {
                  if(canApplyEffectPlayableToCardSocketSummon(_loc1_,mBattleEngine.isOwnerTurn()))
                  {
                     if(_loc7_ || !_loc7_ && (_loc1_.getParentCard() is FSAction || _loc1_.getParentCard() is FSAttachment))
                     {
                        makeEffectPlayableToCardSocket(_loc1_,this.mOpponentSideDeckSocketSuggestCatalog);
                     }
                  }
               }
               checkPowerSuggestions();
            }
         }
      }
      
      override public function suggestPlayableCardOFF() : void
      {
         var _loc1_:FSCardSocket = null;
         super.suggestPlayableCardOFF();
         if(Config.getConfig().getActivateSuggestPlayable())
         {
            if(mOpponentSideDeckSocketCatalog)
            {
               for each(_loc1_ in this.mOpponentSideDeckSocketSuggestCatalog)
               {
                  _loc1_.visible = false;
                  onSuggestSocketHidden(_loc1_);
               }
            }
         }
      }
      
      override protected function onBackgroundTouch(param1:TouchEvent) : void
      {
         super.onBackgroundTouch(param1);
         if(Boolean(this.mChatButton) && this.mChatButton.isMessageCarrousselShown())
         {
            this.mChatButton.onCancel();
         }
      }
      
      public function closeChatButtonCarroussel() : void
      {
         if(Boolean(this.mChatButton) && this.mChatButton.isMessageCarrousselShown())
         {
            this.mChatButton.onCancel();
         }
      }
   }
}

