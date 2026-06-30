package com.fs.tcgengine.screens
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.buttons.FSToggleButton;
   import com.fs.tcgengine.view.components.map.SubMenuButton;
   import com.fs.tcgengine.view.components.misc.FSGoldVisor;
   import com.fs.tcgengine.view.components.misc.FSMemberOptions;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.misc.CustomizePlayerBanner;
   import com.fs.tcgengine.view.components.pvp.LeagueFrame;
   import com.fs.tcgengine.view.components.pvp.PvPRewardSlot;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.pvp.PopupPlayPvPOffline;
   import com.fs.tcgengine.view.pvp.PlayerPvPScorePortrait;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalLayout;
   import flash.utils.Dictionary;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class FSPvPScreen extends Screen
   {
      
      public static var smLeaderboardOwnerRank:int = -1;
      
      private const LEAGUE_SECTION:int = 0;
      
      private const SPLIT_SCREEN_SECTION:int = 1;
      
      private const LEADERBOARDS_SECTION:int = 2;
      
      private const REWARDS_SECTION:int = 3;
      
      private const DEFENSIVE_LEAGUE_SECTION:int = 4;
      
      private const BUTTONS_SEPARATION:Number = 1.035;
      
      private var mGoldVisor:FSGoldVisor;
      
      private var mSeasonEndTextfield:FSTextfield;
      
      private var mCustomizePlayerBanner:CustomizePlayerBanner;
      
      private var mCurrentSection:int = this.LEAGUE_SECTION;
      
      private var mLeagueMatchButton:FSToggleButton;
      
      private var mSplitScreenMatchButton:FSToggleButton;
      
      private var mLeaderboardsButton:FSToggleButton;
      
      private var mRewardsButton:FSToggleButton;
      
      private var mDefensiveLeagueButton:FSToggleButton;
      
      private var mPlayButton:FSButton;
      
      private var mLeague1Button:SubMenuButton;
      
      private var mLeague2Button:SubMenuButton;
      
      private var mLeague3Button:SubMenuButton;
      
      private var mLeagueButtonAura:FSImage;
      
      private var mLeaguesContainer:Component;
      
      private var mLeagueFrame:LeagueFrame;
      
      private var mSplitScreenContainer:Component;
      
      private var mSplitScreenTitle:FSTextfield;
      
      private var mSplitScreenSubtitle:FSTextfield;
      
      private var mSplitScreenImage:FSImage;
      
      private var mLeaderboardsContainer:Component;
      
      private var mLeaderboardsRanking:ScrollContainer;
      
      private var mLeaderboardsRatingTextfield:FSTextfield;
      
      private var mLeaderboardsVictoriesTextfield:FSTextfield;
      
      private var mLeaderboardsSelectedLeague:int;
      
      private var mLeaderboardsData:Dictionary;
      
      private var mLeaderboardsScoreSlots:Dictionary;
      
      private var mRewardsContainer:Component;
      
      private var mRewardsScrollContainer:ScrollContainer;
      
      private var mRewardsSeparatorImage:FSImage;
      
      private var mTop3RewardsSeparatorImage:FSImage;
      
      private var mDefensiveLeagueContainer:Component;
      
      private var mDefensiveLeagueTitle:FSTextfield;
      
      private var mDefensiveLeagueSubtitle:FSTextfield;
      
      private var mDefensiveLeagueImage:FSImage;
      
      private var mPvPOptions:FSMemberOptions;
      
      public function FSPvPScreen()
      {
         mNeedsLoadingBar = true;
         mBGName = Constants.PVP_BG_NAME;
         mScreenName = Constants.PVP_SCREEN_NAME;
         this.requestPvPRewards();
         this.requestRankingInfo(-1,true);
         super();
      }
      
      override protected function createBG() : void
      {
         if(mBG != null)
         {
            return;
         }
         if(mBGSprite != null)
         {
            return;
         }
         mBGSprite = Utils.createCustomBox("bg_pvp_custom",InstanceMng.getApplication().getDefaultStageWidth(),true);
         mBGSprite.touchable = false;
         if(mBGSprite != null)
         {
            if(mNeedsLoadingBar)
            {
               addChildAt(mBGSprite,0);
            }
            else
            {
               addChild(mBGSprite);
            }
         }
         addLights();
      }
      
      override protected function setResourcesToLoad() : void
      {
         if(!Config.smPvPHasFriendlyPvP)
         {
            InstanceMng.getResourcesMng().addResourceToLoad("popups/" + PopupPlayPvPOffline.BG_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
         }
         InstanceMng.getResourcesMng().addResourcesFolderByName("pvpLeagues");
         this.addPortraitResources();
         super.setResourcesToLoad();
         InstanceMng.getResourcesMng().loadAssets();
      }
      
      protected function addPortraitResources() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + FSBattlefieldUserPortrait.FRAME_BG_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
         if(Config.getConfig().hasPortraits())
         {
            if(_loc1_)
            {
               if(!Config.smPortraitFramesInAtlas)
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc1_.getCurrentPortraitBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
               }
               InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + FSResourceMng.DEFAULT_PHOTO_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
            }
         }
      }
      
      override public function notifyAssetsLoaded(param1:* = null) : void
      {
         super.notifyAssetsLoaded();
         PvPConnectionMng.smCurrentMatchId = "";
         PvPConnectionMng.smMatchActionId = -1;
         PvPConnectionMng.smMoveId = 1;
         PvPConnectionMng.smServerMatchData = null;
         this.createUI();
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            InstanceMng.getServerConnection().getServerConfig(false,PvPConnectionMng.onPvPInfoReceived,null,false);
            this.updateEndSeasonInfo();
         }
         setScreenPopupsResourcesLoaded();
      }
      
      private function createUI() : void
      {
         this.createEndSeasonTextfield();
         this.createGoldVisor();
         this.createCustomizePlayer();
         this.createLeagueMatchButton();
         this.createSplitScreenMatchButton();
         this.createLeaderboardsButton();
         this.createRewardsButton();
         this.createDefensiveLeagueButton();
         this.createPlayButton();
         this.handleCurrentSection();
      }
      
      private function createLeagueMatchButton() : void
      {
         if(this.mLeagueMatchButton == null)
         {
            this.mLeagueMatchButton = new FSToggleButton("pvp_left_button_off","pvp_left_button_on",TextManager.getText("TID_PVP_OPPONENT"));
            this.mLeagueMatchButton.x = this.mCustomizePlayerBanner.x - this.mLeagueMatchButton.width / 2;
            this.mLeagueMatchButton.y = Utils.isMobile() ? this.mCustomizePlayerBanner.y + this.mCustomizePlayerBanner.height / 2 + this.mLeagueMatchButton.height * 0.2 : this.mCustomizePlayerBanner.y + this.mCustomizePlayerBanner.height / 2 + this.mLeagueMatchButton.height / 3;
            this.mLeagueMatchButton.addEventListener(TouchEvent.TOUCH,this.onButtonTouched);
            addChild(this.mLeagueMatchButton);
         }
      }
      
      private function createSplitScreenMatchButton() : void
      {
         if(this.mSplitScreenMatchButton == null)
         {
            this.mSplitScreenMatchButton = new FSToggleButton("pvp_left_button_off","pvp_left_button_on",TextManager.getText("TID_PVP_OFFLINE"));
            this.mSplitScreenMatchButton.setToggled();
            this.mSplitScreenMatchButton.x = this.mLeagueMatchButton.x;
            this.mSplitScreenMatchButton.y = this.mLeagueMatchButton.y + this.mLeagueMatchButton.height * this.BUTTONS_SEPARATION;
            this.mSplitScreenMatchButton.addEventListener(TouchEvent.TOUCH,this.onButtonTouched);
            addChild(this.mSplitScreenMatchButton);
         }
      }
      
      private function createLeaderboardsButton() : void
      {
         if(this.mLeaderboardsButton == null)
         {
            this.mLeaderboardsButton = new FSToggleButton("pvp_left_button_off","pvp_left_button_on",TextManager.getText("TID_PVP_RANKING"));
            this.mLeaderboardsButton.setToggled();
            this.mLeaderboardsButton.x = this.mSplitScreenMatchButton.x;
            this.mLeaderboardsButton.y = this.mSplitScreenMatchButton.y + this.mSplitScreenMatchButton.height * this.BUTTONS_SEPARATION;
            this.mLeaderboardsButton.addEventListener(TouchEvent.TOUCH,this.onButtonTouched);
            addChild(this.mLeaderboardsButton);
         }
      }
      
      private function createRewardsButton() : void
      {
         if(this.mRewardsButton == null)
         {
            this.mRewardsButton = new FSToggleButton("pvp_left_button_off","pvp_left_button_on",TextManager.getText("TID_PVP_LEAGUE_REWARDS"));
            this.mRewardsButton.setToggled();
            this.mRewardsButton.x = this.mLeaderboardsButton.x;
            this.mRewardsButton.y = this.mLeaderboardsButton.y + this.mLeaderboardsButton.height * this.BUTTONS_SEPARATION;
            this.mRewardsButton.addEventListener(TouchEvent.TOUCH,this.onButtonTouched);
            addChild(this.mRewardsButton);
         }
      }
      
      private function createDefensiveLeagueButton() : void
      {
         if(this.mDefensiveLeagueButton == null)
         {
            this.mDefensiveLeagueButton = new FSToggleButton("pvp_left_button_off","pvp_left_button_on",TextManager.getText("TID_PVP_DEFENSE"));
            this.mDefensiveLeagueButton.setToggled();
            this.mDefensiveLeagueButton.x = this.mRewardsButton.x;
            this.mDefensiveLeagueButton.y = this.mRewardsButton.y + this.mRewardsButton.height * this.BUTTONS_SEPARATION;
            this.mDefensiveLeagueButton.addEventListener(TouchEvent.TOUCH,this.onButtonTouched);
            addChild(this.mDefensiveLeagueButton);
         }
      }
      
      private function createPlayButton() : void
      {
         if(this.mPlayButton == null)
         {
            this.mPlayButton = new FSButton(Root.assets.getTexture("choose_button_play"),TextManager.getText("TID_PVP_FIND_MATCH"));
            Utils.setupButton9Scale(this.mPlayButton,7.5,15,10,5,106.75,39.5);
            this.mPlayButton.x = this.mDefensiveLeagueButton.x + this.mDefensiveLeagueButton.width / 2;
            this.mPlayButton.y = Utils.isMobile() ? this.mDefensiveLeagueButton.y + this.mDefensiveLeagueButton.height + this.mDefensiveLeagueButton.height * 0.6 : this.mDefensiveLeagueButton.y + this.mDefensiveLeagueButton.height + this.mDefensiveLeagueButton.height * 0.9;
            this.mPlayButton.addEventListener(Event.TRIGGERED,this.onPlay);
            addChild(this.mPlayButton);
         }
         var _loc1_:String = this.mCurrentSection == this.SPLIT_SCREEN_SECTION ? TextManager.getText("TID_PVP_SPLITSCREEN") : TextManager.getText("TID_PVP_FIND_MATCH");
         if(this.mPlayButton)
         {
            this.mPlayButton.text = _loc1_;
         }
      }
      
      private function onPlay() : void
      {
         var _loc1_:int = 0;
         if(this.mCurrentSection == this.LEAGUE_SECTION)
         {
            PvPConnectionMng.onPlayPvPTriggered(false,"",this.mPlayButton,true,this.refreshPlayPvPButtons);
         }
         else if(!Root.assets.isLoading)
         {
            _loc1_ = DictionaryUtils.getCardsAmountPerCatalog(InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection());
            if(_loc1_ >= Config.getConfig().getDeckCardsAmount())
            {
               InstanceMng.getPopupMng().openPlayPvPOfflinePopup();
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_DECKBUILDER_DECK_CRAFT"),true);
            }
         }
      }
      
      public function refreshPlayPvPButtons(param1:Boolean = false) : void
      {
         if(this.mPlayButton)
         {
            this.mPlayButton.enabled = param1 ? false : !PvPConnectionMng.smUserInPvPQueue && InstanceMng.getServerConnection().isUserLoggedIn() && Utils.smInternetAvailable && !PvPConnectionMng.smUserSettingUpForMatch;
         }
      }
      
      private function onButtonTouched(param1:TouchEvent) : void
      {
         var _loc4_:Boolean = false;
         var _loc2_:FSToggleButton = FSToggleButton(param1.currentTarget);
         var _loc3_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc3_)
         {
            if(!_loc2_.isToggled())
            {
               _loc2_.setToggled();
            }
            _loc4_ = true;
            if(_loc2_ == this.mLeagueMatchButton && this.mCurrentSection != this.LEAGUE_SECTION)
            {
               this.mCurrentSection = this.LEAGUE_SECTION;
               _loc4_ = false;
            }
            else if(_loc2_ == this.mSplitScreenMatchButton && this.mCurrentSection != this.SPLIT_SCREEN_SECTION)
            {
               this.mCurrentSection = this.SPLIT_SCREEN_SECTION;
               _loc4_ = false;
            }
            else if(_loc2_ == this.mLeaderboardsButton && this.mCurrentSection != this.LEADERBOARDS_SECTION)
            {
               this.mCurrentSection = this.LEADERBOARDS_SECTION;
               _loc4_ = false;
            }
            else if(_loc2_ == this.mRewardsButton && this.mCurrentSection != this.REWARDS_SECTION)
            {
               this.mCurrentSection = this.REWARDS_SECTION;
               _loc4_ = false;
            }
            else if(_loc2_ == this.mDefensiveLeagueButton && this.mCurrentSection != this.DEFENSIVE_LEAGUE_SECTION)
            {
               this.mCurrentSection = this.DEFENSIVE_LEAGUE_SECTION;
               _loc4_ = false;
            }
            if(!_loc4_)
            {
               this.handleCurrentSection();
            }
         }
      }
      
      private function handleCurrentSectionButtons() : void
      {
         if(Boolean(this.mCurrentSection != this.LEAGUE_SECTION) && Boolean(this.mLeagueMatchButton) && this.mLeagueMatchButton.isToggled())
         {
            this.mLeagueMatchButton.setToggled();
         }
         if(Boolean(this.mCurrentSection != this.SPLIT_SCREEN_SECTION) && Boolean(this.mSplitScreenMatchButton) && this.mSplitScreenMatchButton.isToggled())
         {
            this.mSplitScreenMatchButton.setToggled();
         }
         if(Boolean(this.mCurrentSection != this.LEADERBOARDS_SECTION) && Boolean(this.mLeaderboardsButton) && this.mLeaderboardsButton.isToggled())
         {
            this.mLeaderboardsButton.setToggled();
         }
         if(Boolean(this.mCurrentSection != this.REWARDS_SECTION) && Boolean(this.mRewardsButton) && this.mRewardsButton.isToggled())
         {
            this.mRewardsButton.setToggled();
         }
         if(Boolean(this.mCurrentSection != this.DEFENSIVE_LEAGUE_SECTION) && Boolean(this.mDefensiveLeagueButton) && this.mDefensiveLeagueButton.isToggled())
         {
            this.mDefensiveLeagueButton.setToggled();
         }
      }
      
      private function handleCurrentSection() : void
      {
         this.handleCurrentSectionButtons();
         this.hideNonCurrentSectionContainers();
         switch(this.mCurrentSection)
         {
            case this.LEAGUE_SECTION:
               this.createLeagueSection();
               break;
            case this.SPLIT_SCREEN_SECTION:
               this.createSplitScreenSection();
               break;
            case this.LEADERBOARDS_SECTION:
               this.createLeaderboardsSection();
               break;
            case this.REWARDS_SECTION:
               this.createRewardsSection();
               break;
            case this.DEFENSIVE_LEAGUE_SECTION:
               this.createDefensiveLeagueSection();
         }
         this.handlePlayButton();
      }
      
      private function createLeaderboardsSection() : void
      {
         this.mLeaderboardsContainer = this.createSectionContainer(this.mLeaderboardsContainer);
         this.createLeaguesButtons();
         this.createLeaderboardsRanking();
      }
      
      private function createLeaderboardsRanking() : void
      {
         this.createRankingVictoriesTextfield();
         this.createRankingPunctuationTextfield();
         this.createRanking();
         this.requestRankingInfo();
      }
      
      public function getLeaderboardRankingWidth() : int
      {
         var _loc1_:Texture = Root.assets.getTexture("pvp_container_horizontal");
         return _loc1_ ? int(_loc1_.nativeWidth) : 0;
      }
      
      private function createRanking() : void
      {
         var _loc1_:VerticalLayout = null;
         if(this.mLeaderboardsRanking == null)
         {
            _loc1_ = new VerticalLayout();
            _loc1_.horizontalAlign = HorizontalAlign.CENTER;
            this.mLeaderboardsRanking = new ScrollContainer();
            this.mLeaderboardsRanking.height = this.mLeaderboardsContainer.height * 0.975 - (this.mLeaderboardsVictoriesTextfield.y + this.mLeaderboardsVictoriesTextfield.height);
            this.mLeaderboardsRanking.width = this.mLeaderboardsContainer.width;
            this.mLeaderboardsRanking.touchable = true;
            this.mLeaderboardsRanking.y = this.mLeaderboardsVictoriesTextfield.y + this.mLeaderboardsVictoriesTextfield.height * 1.025;
            this.mLeaderboardsRanking.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mLeaderboardsRanking.layout = _loc1_;
            this.mLeaderboardsContainer.addChild(this.mLeaderboardsRanking);
            this.mLeaderboardsRanking.addEventListener(TouchEvent.TOUCH,this.onRankingTouch);
            this.mLeaderboardsSelectedLeague = Utils.getOwnerUserData().getPvPCurrentLeague();
         }
         else if(this.mLeaderboardsRanking)
         {
            this.mLeaderboardsRanking.removeChildren();
         }
      }
      
      private function onRankingTouch(param1:TouchEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.BEGAN) : null;
         if(_loc2_)
         {
            if(this.mLeaderboardsRanking)
            {
               _loc3_ = 0;
               while(_loc3_ < this.mLeaderboardsRanking.numChildren)
               {
                  if(this.mLeaderboardsRanking.getChildAt(_loc3_) != null && this.mLeaderboardsRanking.getChildAt(_loc3_) is PlayerPvPScorePortrait)
                  {
                     PlayerPvPScorePortrait(this.mLeaderboardsRanking.getChildAt(_loc3_)).hidePvPMemberOptions();
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      private function requestRankingInfo(param1:int = -1, param2:Boolean = false) : void
      {
         var _loc3_:Vector.<PlayerPvPScorePortrait> = null;
         var _loc4_:int = 0;
         if(this.mLeaderboardsRanking)
         {
            this.mLeaderboardsRanking.removeChildren();
         }
         param1 = param1 == -1 ? Utils.getOwnerUserData().getPvPCurrentLeague() : param1;
         if(this.mLeaderboardsData != null && this.mLeaderboardsData[param1] != null && !param2)
         {
            _loc3_ = this.mLeaderboardsScoreSlots ? this.mLeaderboardsScoreSlots[param1] : null;
            if(_loc3_ != null)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  this.mLeaderboardsRanking.addChild(_loc3_[_loc4_]);
                  _loc4_++;
               }
            }
            else
            {
               this.onRankingReceived(this.mLeaderboardsData[param1],smLeaderboardOwnerRank,param1);
            }
            return;
         }
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            InstanceMng.getServerConnection().getPvPRanking(this.onRankingQueryResponse,param1,param2);
            if(!param2)
            {
               showLoadingIcon(true,false,Align.CENTER,Align.CENTER,1,null,this.mLeaderboardsContainer);
            }
         }
      }
      
      private function onRankingQueryResponse(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:UserData = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Boolean = false;
         if(param1 != null && param1.length > 0)
         {
            _loc3_ = param1.hasOwnProperty("ownerRank") ? int(param1["ownerRank"]) : -1;
            if(_loc3_ > 0)
            {
               smLeaderboardOwnerRank = _loc3_;
               if(this.mLeagueFrame)
               {
                  this.mLeagueFrame.updateRank(smLeaderboardOwnerRank);
               }
            }
            _loc4_ = InstanceMng.getServerConnection().getUserId();
            _loc5_ = false;
            _loc8_ = Utils.getOwnerUserData();
            if(_loc8_ == null)
            {
               return;
            }
            _loc9_ = _loc8_.getPvPCurrentLeague();
            _loc10_ = param1.hasOwnProperty("league") ? int(param1["league"]) : -1;
            _loc11_ = _loc8_.getMatchesPlayed();
            _loc12_ = _loc10_ == _loc9_ && _loc11_ > 0;
            if(this.mLeaderboardsData == null)
            {
               this.mLeaderboardsData = new Dictionary(true);
            }
            if(this.mLeaderboardsData[_loc10_] == null)
            {
               this.mLeaderboardsData[_loc10_] = new Dictionary(true);
            }
            _loc6_ = 0;
            while(_loc6_ < param1.length)
            {
               if(param1[_loc6_].hasOwnProperty("_id"))
               {
                  _loc7_ = new Object();
                  if(!_loc5_)
                  {
                     _loc5_ = Utils.getDataId(param1[_loc6_]) == _loc4_;
                  }
                  _loc7_._id = new Object();
                  _loc7_._id.$oid = Utils.getDataId(param1[_loc6_]);
                  _loc7_.playerName = param1[_loc6_].playerName;
                  _loc7_.matchesWon = param1[_loc6_].matchesWon;
                  _loc7_.elo = param1[_loc6_].elo;
                  _loc7_.guildId = param1[_loc6_].hasOwnProperty("guildId") ? param1[_loc6_].guildId : "";
                  if(this.mLeaderboardsData[_loc10_][_loc7_._id] == null)
                  {
                     this.mLeaderboardsData[_loc10_][_loc7_._id] = _loc7_;
                  }
               }
               _loc6_++;
            }
            if(!_loc5_ && _loc12_)
            {
               _loc7_ = new Object();
               _loc7_._id = new Object();
               _loc7_._id.$oid = _loc4_;
               _loc7_.elo = _loc8_.getElo();
               _loc7_.playerName = _loc8_.getName();
               _loc7_.matchesWon = _loc8_.getMatchesWon();
               if(this.mLeaderboardsData[_loc10_][Utils.getDataId(_loc7_)] == null)
               {
                  this.mLeaderboardsData[_loc10_][Utils.getDataId(_loc7_)] = _loc7_;
               }
            }
         }
         if(!param2 && Boolean(this.mLeaderboardsData))
         {
            this.onRankingReceived(this.mLeaderboardsData[_loc10_],_loc3_,_loc10_);
         }
         else
         {
            showLoadingIcon(false,false);
         }
      }
      
      private function onRankingReceived(param1:Dictionary, param2:int = -1, param3:int = -1) : void
      {
         var _loc4_:PlayerPvPScorePortrait = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:UserData = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:Boolean = false;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Boolean = false;
         var _loc17_:int = 0;
         if(InstanceMng.getCurrentScreen() is FSPvPScreen)
         {
            if(param1 != null && DictionaryUtils.getDictionaryLength(param1) > 0)
            {
               _loc5_ = new Array();
               for each(_loc6_ in param1)
               {
                  _loc5_.push(_loc6_);
               }
               _loc7_ = _loc5_ ? _loc5_.sort(DictionaryUtils.sortObjectArrByELO) : null;
               _loc8_ = _loc7_ ? int(_loc7_.length) : 0;
               if(_loc7_ != null && _loc7_.length > 0)
               {
                  _loc12_ = false;
                  _loc13_ = "";
                  _loc14_ = 1;
                  if(this.mLeaderboardsRanking)
                  {
                     this.mLeaderboardsRanking.removeChildren();
                  }
                  if(this.mLeaderboardsScoreSlots == null)
                  {
                     this.mLeaderboardsScoreSlots = new Dictionary(true);
                  }
                  _loc16_ = this.mLeaderboardsScoreSlots[param3] == null;
                  if(!_loc16_)
                  {
                     return;
                  }
                  _loc15_ = 0;
                  while(_loc15_ < _loc7_.length)
                  {
                     _loc10_ = Utils.getDataId(_loc7_[_loc15_]);
                     _loc12_ = Boolean(InstanceMng.getServerConnection().getBackendUserProfile()) && _loc10_ == InstanceMng.getServerConnection().getUserId();
                     if(_loc7_[_loc15_] != null)
                     {
                        _loc13_ = _loc12_ ? TextManager.getText("TID_SOCIAL_ME") : _loc7_[_loc15_].playerName;
                        _loc11_ = _loc7_[_loc15_].hasOwnProperty("guildId") ? _loc7_[_loc15_]["guildId"] : "";
                        _loc11_ = _loc11_ ? _loc11_ : "";
                        if(_loc12_ && _loc15_ == _loc7_.length - 1 && param2 != -1)
                        {
                           _loc17_ = _loc15_ >= _loc8_ - 1 ? param2 : _loc14_;
                           _loc17_ = _loc17_ == 0 ? 1 : _loc17_;
                           _loc4_ = new PlayerPvPScorePortrait(_loc10_,_loc17_,_loc13_,_loc7_[_loc15_].elo,_loc7_[_loc15_].matchesWon,_loc12_,false,_loc11_);
                        }
                        else
                        {
                           _loc4_ = new PlayerPvPScorePortrait(_loc10_,_loc14_,_loc13_,_loc7_[_loc15_].elo,_loc7_[_loc15_].matchesWon,_loc12_,false,_loc11_);
                        }
                        if(_loc4_)
                        {
                           if(this.mLeaderboardsScoreSlots[param3] == null)
                           {
                              this.mLeaderboardsScoreSlots[param3] = new Vector.<PlayerPvPScorePortrait>();
                           }
                           this.mLeaderboardsScoreSlots[param3].push(_loc4_);
                           if(this.mLeaderboardsRanking != null)
                           {
                              this.mLeaderboardsRanking.addChild(_loc4_);
                           }
                           _loc14_++;
                        }
                     }
                     _loc15_++;
                  }
                  if(Boolean(this.mLeaderboardsRanking) && Boolean(this.mLeaderboardsRanking.numChildren > 0) && _loc4_ != null)
                  {
                     showLoadingIcon(false,false);
                  }
               }
            }
            else
            {
               showLoadingIcon(false,false);
            }
         }
      }
      
      private function createRankingVictoriesTextfield() : void
      {
         if(this.mLeaderboardsVictoriesTextfield == null)
         {
            this.mLeaderboardsVictoriesTextfield = new FSTextfield(this.mLeaderboardsContainer.width / 5,this.mLeague1Button.height / 4,TextManager.getText("TID_PVP_VICTORIES"),16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
         }
         this.mLeaderboardsVictoriesTextfield.fontName = FSResourceMng.getFontByType();
         this.mLeaderboardsVictoriesTextfield.x = this.mLeaderboardsContainer.width - this.mLeaderboardsVictoriesTextfield.width;
         this.mLeaderboardsVictoriesTextfield.y = this.mLeague1Button.y + this.mLeague1Button.height / 2 + 5;
         this.mLeaderboardsContainer.addChild(this.mLeaderboardsVictoriesTextfield);
      }
      
      private function createRankingPunctuationTextfield() : void
      {
         if(this.mLeaderboardsRatingTextfield == null)
         {
            this.mLeaderboardsRatingTextfield = new FSTextfield(this.mLeaderboardsVictoriesTextfield.width,this.mLeaderboardsVictoriesTextfield.height,TextManager.getText("TID_PVP_RATING"),16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
         }
         this.mLeaderboardsRatingTextfield.fontName = FSResourceMng.getFontByType();
         this.mLeaderboardsRatingTextfield.x = this.mLeaderboardsVictoriesTextfield.x - this.mLeaderboardsRatingTextfield.width;
         this.mLeaderboardsRatingTextfield.y = this.mLeaderboardsVictoriesTextfield.y;
         this.mLeaderboardsContainer.addChild(this.mLeaderboardsRatingTextfield);
      }
      
      private function createDefensiveLeagueSection() : void
      {
         this.mDefensiveLeagueContainer = this.createSectionContainer(this.mDefensiveLeagueContainer);
         this.createDefensiveLeagueTextfields();
         this.createDefensiveLeagueImage();
      }
      
      private function createDefensiveLeagueImage() : void
      {
         if(this.mDefensiveLeagueImage == null)
         {
            this.mDefensiveLeagueImage = new FSImage(Root.assets.getTexture("pvp_offline_image"));
            this.mDefensiveLeagueImage.scale = 0.75;
            this.mDefensiveLeagueImage.x = (this.mDefensiveLeagueContainer.width - this.mDefensiveLeagueImage.width) / 2;
            this.mDefensiveLeagueImage.y = this.mDefensiveLeagueSubtitle.y + this.mDefensiveLeagueSubtitle.height;
            this.mDefensiveLeagueContainer.addChild(this.mDefensiveLeagueImage);
         }
      }
      
      private function createDefensiveLeagueTextfields() : void
      {
         if(this.mDefensiveLeagueTitle == null)
         {
            this.mDefensiveLeagueTitle = new FSTextfield(this.mDefensiveLeagueContainer.width * 0.95,this.mDefensiveLeagueContainer.height / 6,TextManager.getText("TID_PVP_DEFENSE"),16777215,FSResourceMng.FONT_STD_BIG_XL_TITLE_SIZE);
            this.mDefensiveLeagueTitle.x = (this.mDefensiveLeagueContainer.width - this.mDefensiveLeagueTitle.width) / 2;
            this.mDefensiveLeagueContainer.addChild(this.mDefensiveLeagueTitle);
         }
         if(this.mDefensiveLeagueSubtitle == null)
         {
            this.mDefensiveLeagueSubtitle = new FSTextfield(this.mDefensiveLeagueTitle.width,this.mDefensiveLeagueTitle.height * 2.5,TextManager.getText("TID_PVP_DEFENSE_INFO",true));
            this.mDefensiveLeagueSubtitle.x = this.mDefensiveLeagueTitle.x;
            this.mDefensiveLeagueSubtitle.y = this.mDefensiveLeagueTitle.y + this.mDefensiveLeagueTitle.height;
            this.mDefensiveLeagueContainer.addChild(this.mDefensiveLeagueSubtitle);
         }
      }
      
      private function createSplitScreenSection() : void
      {
         this.mSplitScreenContainer = this.createSectionContainer(this.mSplitScreenContainer);
         this.createSplitScreenTextfields();
         this.createSplitScreenImage();
      }
      
      private function createSplitScreenImage() : void
      {
         if(this.mSplitScreenImage == null)
         {
            this.mSplitScreenImage = new FSImage(Root.assets.getTexture("pvp_splitscreen_image"));
            this.mSplitScreenImage.x = (this.mSplitScreenContainer.width - this.mSplitScreenImage.width) / 2;
            this.mSplitScreenImage.y = this.mSplitScreenSubtitle.y + this.mSplitScreenSubtitle.height;
            this.mSplitScreenContainer.addChild(this.mSplitScreenImage);
         }
      }
      
      private function createSplitScreenTextfields() : void
      {
         if(this.mSplitScreenTitle == null)
         {
            this.mSplitScreenTitle = new FSTextfield(this.mSplitScreenContainer.width * 0.95,this.mSplitScreenContainer.height / 6,TextManager.getText("TID_PVP_OFFLINE"),16777215,FSResourceMng.FONT_STD_BIG_XL_TITLE_SIZE);
            this.mSplitScreenTitle.x = (this.mSplitScreenContainer.width - this.mSplitScreenTitle.width) / 2;
            this.mSplitScreenContainer.addChild(this.mSplitScreenTitle);
         }
         if(this.mSplitScreenSubtitle == null)
         {
            this.mSplitScreenSubtitle = new FSTextfield(this.mSplitScreenTitle.width,this.mSplitScreenTitle.height * 1.5,TextManager.getText("TID_PVP_OFFLINE_DESC",true));
            this.mSplitScreenSubtitle.x = this.mSplitScreenTitle.x;
            this.mSplitScreenSubtitle.y = this.mSplitScreenTitle.y + this.mSplitScreenTitle.height;
            this.mSplitScreenContainer.addChild(this.mSplitScreenSubtitle);
         }
      }
      
      private function hideNonCurrentSectionContainers() : void
      {
         if(this.mLeaguesContainer != null && this.mCurrentSection != this.LEAGUE_SECTION)
         {
            this.mLeaguesContainer.removeFromParent();
         }
         if(this.mSplitScreenContainer != null && this.mCurrentSection != this.SPLIT_SCREEN_SECTION)
         {
            this.mSplitScreenContainer.removeFromParent();
         }
         if(this.mLeaderboardsContainer != null && this.mCurrentSection != this.LEADERBOARDS_SECTION)
         {
            this.mLeaderboardsContainer.removeFromParent();
         }
         if(this.mRewardsContainer != null && this.mCurrentSection != this.REWARDS_SECTION)
         {
            this.mRewardsContainer.removeFromParent();
         }
         if(this.mDefensiveLeagueContainer != null && this.mCurrentSection != this.DEFENSIVE_LEAGUE_SECTION)
         {
            this.mDefensiveLeagueContainer.removeFromParent();
         }
      }
      
      private function createSectionContainer(param1:Component) : Component
      {
         var _loc2_:FSImage = null;
         var _loc3_:FSImage = null;
         if(param1 == null)
         {
            param1 = new Component();
            _loc2_ = new FSImage(Root.assets.getTexture("pvp_container_horizontal"));
            _loc3_ = new FSImage(Root.assets.getTexture("pvp_container_vertical"));
            param1.addChild(_loc2_);
            param1.addChild(_loc3_);
            param1.x = width - param1.width - mBackButton.width * 1.25;
            param1.y = mBackButton.height * 1.9;
         }
         addChild(param1);
         return param1;
      }
      
      private function createLeaguesButtons() : void
      {
         var _loc1_:String = "_disabled";
         var _loc2_:Boolean = this.mCurrentSection == this.LEADERBOARDS_SECTION;
         var _loc3_:Component = this.mCurrentSection == this.LEADERBOARDS_SECTION ? this.mLeaderboardsContainer : this.mRewardsContainer;
         var _loc4_:int = Utils.getOwnerUserData().getPvPCurrentLeague();
         if(this.mLeague1Button == null)
         {
            this.mLeague1Button = new SubMenuButton("pvp_league_icon_1","pvp_league_icon_1" + _loc1_,this.onLeague1Triggered,TextManager.getText("TID_PVP_LEAGUE_1"));
            Utils.alignComponentAndFixPosition(this.mLeague1Button);
            this.mLeague1Button.x = _loc3_.width * 0.25;
            this.mLeague1Button.y = this.mLeague1Button.height / 2;
         }
         this.mLeague1Button.touchable = _loc2_;
         if(_loc2_)
         {
            this.mLeague1Button.updateOnTriggeredFunction(this.onLeague1Triggered);
         }
         if(this.mCurrentSection == this.LEADERBOARDS_SECTION)
         {
            this.mLeague1Button.setEnabled(_loc4_ == 1);
         }
         else
         {
            this.mLeague1Button.setEnabled(true);
         }
         _loc3_.addChild(this.mLeague1Button);
         if(this.mLeague2Button == null)
         {
            this.mLeague2Button = new SubMenuButton("pvp_league_icon_2","pvp_league_icon_2" + _loc1_,this.onLeague2Triggered,TextManager.getText("TID_PVP_LEAGUE_2"));
            Utils.alignComponentAndFixPosition(this.mLeague2Button);
            this.mLeague2Button.x = _loc3_.width * 0.5;
            this.mLeague2Button.y = this.mLeague1Button.y;
         }
         this.mLeague2Button.touchable = _loc2_;
         if(_loc2_)
         {
            this.mLeague2Button.updateOnTriggeredFunction(this.onLeague2Triggered);
         }
         _loc3_.addChild(this.mLeague2Button);
         if(this.mCurrentSection == this.LEADERBOARDS_SECTION)
         {
            this.mLeague2Button.setEnabled(_loc4_ == 2);
         }
         else
         {
            this.mLeague2Button.setEnabled(true);
         }
         if(this.mLeague3Button == null)
         {
            this.mLeague3Button = new SubMenuButton("pvp_league_icon_3","pvp_league_icon_3" + _loc1_,this.onLeague3Triggered,TextManager.getText("TID_PVP_LEAGUE_3"));
            Utils.alignComponentAndFixPosition(this.mLeague3Button);
            this.mLeague3Button.x = _loc3_.width * 0.75;
            this.mLeague3Button.y = this.mLeague1Button.y;
         }
         this.mLeague3Button.touchable = _loc2_;
         if(_loc2_)
         {
            this.mLeague3Button.updateOnTriggeredFunction(this.onLeague3Triggered);
         }
         _loc3_.addChild(this.mLeague3Button);
         if(this.mCurrentSection == this.LEADERBOARDS_SECTION)
         {
            this.mLeague3Button.setEnabled(_loc4_ == 3);
         }
         else
         {
            this.mLeague3Button.setEnabled(true);
         }
      }
      
      private function onLeague1Triggered() : void
      {
         if(this.mLeague1Button)
         {
            this.mLeague1Button.setEnabled(true);
         }
         if(this.mLeague2Button)
         {
            this.mLeague2Button.setEnabled(false);
         }
         if(this.mLeague3Button)
         {
            this.mLeague3Button.setEnabled(false);
         }
         this.requestRankingInfo(1);
      }
      
      private function onLeague2Triggered() : void
      {
         if(this.mLeague1Button)
         {
            this.mLeague1Button.setEnabled(false);
         }
         if(this.mLeague2Button)
         {
            this.mLeague2Button.setEnabled(true);
         }
         if(this.mLeague3Button)
         {
            this.mLeague3Button.setEnabled(false);
         }
         this.requestRankingInfo(2);
      }
      
      private function onLeague3Triggered() : void
      {
         if(this.mLeague1Button)
         {
            this.mLeague1Button.setEnabled(false);
         }
         if(this.mLeague2Button)
         {
            this.mLeague2Button.setEnabled(false);
         }
         if(this.mLeague3Button)
         {
            this.mLeague3Button.setEnabled(true);
         }
         this.requestRankingInfo(3);
      }
      
      private function createRewardsScrollContainer() : void
      {
         var _loc1_:VerticalLayout = null;
         if(this.mRewardsScrollContainer == null)
         {
            this.mRewardsScrollContainer = new ScrollContainer();
            _loc1_ = new VerticalLayout();
            _loc1_.horizontalAlign = HorizontalAlign.CENTER;
            _loc1_.gap = 5;
            this.mRewardsScrollContainer.layout = _loc1_;
            this.mRewardsScrollContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mRewardsScrollContainer.width = this.mRewardsContainer.width;
            this.mRewardsScrollContainer.height = this.mRewardsContainer.height - this.mLeague1Button.height * 1.125;
            this.mRewardsScrollContainer.x = 0;
            this.mRewardsScrollContainer.y = this.mLeague1Button.y + this.mLeague1Button.height / 1.9;
            this.mRewardsContainer.addChild(this.mRewardsScrollContainer);
         }
      }
      
      private function createLeagueSection() : void
      {
         this.mLeaguesContainer = this.createSectionContainer(this.mLeaguesContainer);
         this.createLeagueFrame();
      }
      
      private function createLeagueFrame() : void
      {
         var _loc1_:FSImage = null;
         if(this.mLeagueFrame == null)
         {
            this.mLeagueFrame = new LeagueFrame();
            _loc1_ = new FSImage(Root.assets.getTexture("pvp_container_vertical"));
            this.mLeagueFrame.x = this.mLeaguesContainer.width / 2;
            this.mLeagueFrame.y = _loc1_.height / 2;
            this.mLeaguesContainer.addChild(this.mLeagueFrame);
         }
         else
         {
            this.mLeagueFrame.updateUI();
         }
      }
      
      public function updateLeagueFrame() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FSImage = null;
         if(this.mLeagueFrame)
         {
            _loc1_ = this.mLeagueFrame.height;
            this.mLeagueFrame.updateUI();
            _loc2_ = this.mLeagueFrame.height;
            _loc3_ = this.mLeagueFrame.y;
            _loc4_ = new FSImage(Root.assets.getTexture("pvp_container_vertical"));
            this.mLeagueFrame.y = _loc4_.height / 2;
            FSDebug.debugTrace("Height: [" + _loc1_ + " / " + _loc2_ + "] PosY: [" + _loc3_ + " / " + this.mLeagueFrame.y + "]");
         }
      }
      
      private function createRewardsSection() : void
      {
         this.mRewardsContainer = this.createSectionContainer(this.mRewardsContainer);
         this.createLeaguesButtons();
         this.createRewardsScrollContainer();
         this.handleRewards();
      }
      
      private function handleRewards() : void
      {
         var rewardsLeague1:Array = null;
         var rewardsLeague2:Array = null;
         var rewardsLeague3:Array = null;
         var reachLeagueRewardsArr:Array = null;
         var ratingsArr:Array = null;
         var reachLeagueRewards:Object = null;
         var top3Rewards:Object = null;
         var rewardsArr:Array = null;
         var league:int = 0;
         var reward:String = null;
         var position:int = 0;
         var minRating:int = 0;
         var maxRating:int = 0;
         var pvpRewardSlot:PvPRewardSlot = null;
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         var l1RewardsLength:int = 0;
         var l2RewardsLength:int = 0;
         var l3RewardsLength:int = 0;
         var r1:Object = null;
         var r2:Object = null;
         var r3:Object = null;
         var storeFormattedRewardInfo:Function = function(param1:Array, param2:int, param3:int, param4:int, param5:String, param6:Boolean):Array
         {
            if(param1 == null)
            {
               param1 = new Array();
            }
            param1.push({
               "minRating":param3,
               "maxRating":param4,
               "reward":param5,
               "league":param2,
               "isReachLeagueReward":param6
            });
            return param1;
         };
         var storeFormattedTop3RewardInfo:Function = function(param1:Array, param2:int, param3:String, param4:int):Array
         {
            if(param1 == null)
            {
               param1 = new Array();
            }
            param1.push({
               "reward":param3,
               "league":param2,
               "position":param4,
               "isReachLeagueReward":false,
               "isTop3Reward":true
            });
            return param1;
         };
         if(Boolean(PvPConnectionMng.smPvPRewardsInfo) && this.mRewardsScrollContainer.numChildren == 0)
         {
            ratingsArr = PvPConnectionMng.smPvPRewardsInfo["positions"];
            reachLeagueRewards = PvPConnectionMng.smPvPRewardsInfo["reachLeagueRewards"];
            top3Rewards = PvPConnectionMng.smPvPRewardsInfo["top3Rewards"];
            maxRating = -1;
            if(reachLeagueRewards != null)
            {
               r1 = {
                  "reward":reachLeagueRewards["1"],
                  "league":1,
                  "isReachLeagueReward":true
               };
               r2 = {
                  "reward":reachLeagueRewards["2"],
                  "league":2,
                  "isReachLeagueReward":true
               };
               r3 = {
                  "reward":reachLeagueRewards["3"],
                  "league":3,
                  "isReachLeagueReward":true
               };
               pvpRewardSlot = new PvPRewardSlot(r1,r2,r3);
               this.mRewardsScrollContainer.addChild(pvpRewardSlot);
               if(this.mRewardsSeparatorImage == null)
               {
                  this.mRewardsSeparatorImage = new FSImage(Root.assets.getTexture("pvp_rewards_separator"));
                  this.mRewardsScrollContainer.addChild(this.mRewardsSeparatorImage);
               }
            }
            if(top3Rewards != null)
            {
               i = 0;
               while(i < top3Rewards.length)
               {
                  rewardsArr = top3Rewards[i]["rewards"];
                  if(rewardsArr != null)
                  {
                     j = 0;
                     while(j < rewardsArr.length)
                     {
                        league = int(rewardsArr[j]["league"]);
                        reward = rewardsArr[j]["reward"];
                        position = i;
                        switch(league)
                        {
                           case 1:
                              rewardsLeague1 = storeFormattedTop3RewardInfo(rewardsLeague1,league,reward,position);
                              break;
                           case 2:
                              rewardsLeague2 = storeFormattedTop3RewardInfo(rewardsLeague2,league,reward,position);
                              break;
                           case 3:
                              rewardsLeague3 = storeFormattedTop3RewardInfo(rewardsLeague3,league,reward,position);
                        }
                        j++;
                     }
                  }
                  i++;
               }
               rewardsLeague1.sort(DictionaryUtils.sortPvPRewardByPosition);
               rewardsLeague2.sort(DictionaryUtils.sortPvPRewardByPosition);
               rewardsLeague3.sort(DictionaryUtils.sortPvPRewardByPosition);
               rewardsLeague1[0]["firstPos"] = true;
               rewardsLeague2[0]["firstPos"] = true;
               rewardsLeague3[0]["firstPos"] = true;
               l1RewardsLength = int(rewardsLeague1.length);
               l2RewardsLength = int(rewardsLeague2.length);
               l3RewardsLength = int(rewardsLeague3.length);
               if(l1RewardsLength <= 0)
               {
                  throw new Error("Leagues rewards must exist and be the same length for all Leagues!");
               }
               k = 0;
               while(k < l1RewardsLength)
               {
                  pvpRewardSlot = new PvPRewardSlot(rewardsLeague1[k],rewardsLeague2[k],rewardsLeague3[k]);
                  this.mRewardsScrollContainer.addChild(pvpRewardSlot);
                  k++;
               }
               if(this.mTop3RewardsSeparatorImage == null)
               {
                  this.mTop3RewardsSeparatorImage = new FSImage(Root.assets.getTexture("pvp_rewards_separator"));
                  this.mRewardsScrollContainer.addChild(this.mTop3RewardsSeparatorImage);
               }
            }
            if(ratingsArr != null)
            {
               if(rewardsLeague1)
               {
                  rewardsLeague1.length = 0;
               }
               if(rewardsLeague2)
               {
                  rewardsLeague2.length = 0;
               }
               if(rewardsLeague3)
               {
                  rewardsLeague3.length = 0;
               }
               i = 0;
               while(i < ratingsArr.length)
               {
                  minRating = int(ratingsArr[i]["minRating"]);
                  maxRating = ratingsArr[i].hasOwnProperty("maxRating") ? int(ratingsArr[i]["maxRating"]) : -1;
                  rewardsArr = ratingsArr[i]["rewards"];
                  if(rewardsArr != null)
                  {
                     j = 0;
                     while(j < rewardsArr.length)
                     {
                        league = int(rewardsArr[j]["league"]);
                        reward = rewardsArr[j]["reward"];
                        switch(league)
                        {
                           case 1:
                              rewardsLeague1 = storeFormattedRewardInfo(rewardsLeague1,league,minRating,maxRating,reward,false);
                              break;
                           case 2:
                              rewardsLeague2 = storeFormattedRewardInfo(rewardsLeague2,league,minRating,maxRating,reward,false);
                              break;
                           case 3:
                              rewardsLeague3 = storeFormattedRewardInfo(rewardsLeague3,league,minRating,maxRating,reward,false);
                        }
                        j++;
                     }
                  }
                  i++;
               }
               rewardsLeague1.sort(DictionaryUtils.sortPvPRewardByMinRating);
               rewardsLeague2.sort(DictionaryUtils.sortPvPRewardByMinRating);
               rewardsLeague3.sort(DictionaryUtils.sortPvPRewardByMinRating);
               rewardsLeague1[0]["firstPos"] = true;
               rewardsLeague2[0]["firstPos"] = true;
               rewardsLeague3[0]["firstPos"] = true;
               l1RewardsLength = int(rewardsLeague1.length);
               l2RewardsLength = int(rewardsLeague2.length);
               l3RewardsLength = int(rewardsLeague3.length);
               if(l1RewardsLength <= 0)
               {
                  throw new Error("Leagues rewards must exist and be the same length for all Leagues!");
               }
               k = 0;
               while(k < l1RewardsLength)
               {
                  pvpRewardSlot = new PvPRewardSlot(rewardsLeague1[k],rewardsLeague2[k],rewardsLeague3[k]);
                  this.mRewardsScrollContainer.addChild(pvpRewardSlot);
                  k++;
               }
            }
         }
         else
         {
            this.requestPvPRewards();
         }
      }
      
      private function handlePlayButton() : void
      {
         if(this.mPlayButton)
         {
            this.createPlayButton();
            this.mPlayButton.visible = this.mCurrentSection == this.LEAGUE_SECTION || this.mCurrentSection == this.SPLIT_SCREEN_SECTION;
         }
      }
      
      private function createCustomizePlayer() : void
      {
         if(this.mCustomizePlayerBanner == null)
         {
            this.mCustomizePlayerBanner = new CustomizePlayerBanner();
            this.mCustomizePlayerBanner.x = this.mCustomizePlayerBanner.width / 2 + this.mCustomizePlayerBanner.width / 6;
            this.mCustomizePlayerBanner.y = !Utils.isTablet() ? mBackButton.height * 2.35 : this.mCustomizePlayerBanner.height / 2 + this.mCustomizePlayerBanner.height;
            if(Utils.isIOS() && !Utils.isIphone())
            {
               this.mCustomizePlayerBanner.y += this.mCustomizePlayerBanner.height / 3;
            }
            addChild(this.mCustomizePlayerBanner);
         }
      }
      
      public function updateCustomizePlayerInfo() : void
      {
         if(this.mCustomizePlayerBanner)
         {
            this.mCustomizePlayerBanner.updateName();
         }
      }
      
      private function createGoldVisor() : void
      {
         if(Boolean(mBGSprite) && Boolean(mBackButton) && this.mGoldVisor == null)
         {
            this.mGoldVisor = new FSGoldVisor("gold_button_DB","",true);
            this.mGoldVisor.x = mBackButton.x - this.mGoldVisor.width;
            this.mGoldVisor.y = this.mGoldVisor.height / 2;
            addChild(this.mGoldVisor);
         }
      }
      
      private function createEndSeasonTextfield() : void
      {
         if(this.mSeasonEndTextfield == null)
         {
            this.mSeasonEndTextfield = new FSTextfield(width / 3,height * 0.065,"");
            this.mSeasonEndTextfield.format.horizontalAlign = Align.CENTER;
            this.mSeasonEndTextfield.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
            this.mSeasonEndTextfield.x = (width - this.mSeasonEndTextfield.width) / 2;
            addChild(this.mSeasonEndTextfield);
         }
      }
      
      private function updateEndSeasonInfo() : void
      {
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            this.updateServerTimeMS();
         }
         else
         {
            if(InstanceMng.getApplication())
            {
               InstanceMng.getServerConnection().refreshServerTime();
            }
            TweenMax.delayedCall(2,this.updateEndSeasonInfo);
         }
      }
      
      private function updateServerTimeMS() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = false;
         if(ServerConnection.smServerTimeMS != -1)
         {
            TweenMax.delayedCall(1,this.updateServerTimeMS);
            if(this.mSeasonEndTextfield)
            {
               _loc1_ = Config.smServerConfig;
               if(Boolean(_loc1_) && Boolean(_loc1_.hasOwnProperty("pvp_seasonStartingTime")) && _loc1_.hasOwnProperty("pvp_seasonEndingTime"))
               {
                  _loc2_ = Utils.isSeasonActive(_loc1_["pvp_seasonStartingTime"],_loc1_["pvp_seasonEndingTime"]);
                  if(_loc2_)
                  {
                     this.mSeasonEndTextfield.text = TextManager.getText("TID_SEASON_END") + " " + Utils.getSeasonTimeLeftString(_loc1_["pvp_seasonStartingTime"],_loc1_["pvp_seasonEndingTime"],_loc2_);
                  }
                  else
                  {
                     this.mSeasonEndTextfield.text = TextManager.getText("TID_SEASON_STARTS") + " " + Utils.getSeasonTimeLeftString(_loc1_["pvp_seasonStartingTime"],_loc1_["pvp_seasonEndingTime"],_loc2_);
                  }
               }
            }
         }
      }
      
      override public function lockUI(param1:Boolean) : void
      {
         if(this.mGoldVisor)
         {
            this.mGoldVisor.setEnabled(!param1);
         }
         if(this.mCustomizePlayerBanner)
         {
            this.mCustomizePlayerBanner.touchable = !param1;
         }
         if(this.mLeagueMatchButton)
         {
            this.mLeagueMatchButton.setEnabled(!param1);
            this.mLeagueMatchButton.touchable = !param1;
         }
         if(this.mSplitScreenMatchButton)
         {
            this.mSplitScreenMatchButton.setEnabled(!param1);
            this.mSplitScreenMatchButton.touchable = !param1;
         }
         if(this.mLeaderboardsButton)
         {
            this.mLeaderboardsButton.setEnabled(!param1);
            this.mLeaderboardsButton.touchable = !param1;
         }
         if(this.mRewardsButton)
         {
            this.mRewardsButton.setEnabled(!param1);
            this.mRewardsButton.touchable = !param1;
         }
         if(this.mDefensiveLeagueButton)
         {
            this.mDefensiveLeagueButton.setEnabled(!param1);
            this.mDefensiveLeagueButton.touchable = !param1;
         }
         if(this.mPlayButton)
         {
            this.mPlayButton.setEnabled(!param1);
            this.mPlayButton.touchable = !param1;
         }
         if(this.mLeague1Button)
         {
            this.mLeague1Button.setEnabled(!param1);
            this.mLeague1Button.touchable = !param1;
         }
         if(this.mLeague2Button)
         {
            this.mLeague2Button.setEnabled(!param1);
            this.mLeague2Button.touchable = !param1;
         }
         if(this.mLeague3Button)
         {
            this.mLeague3Button.setEnabled(!param1);
            this.mLeague3Button.touchable = !param1;
         }
         super.lockUI(param1);
      }
      
      public function showMap() : void
      {
         dispatchEventWith(Screen.GO_TO_MAP,true);
      }
      
      override public function getGoldVisor() : *
      {
         return this.mGoldVisor;
      }
      
      public function getSeasonEndTime() : String
      {
         return this.mSeasonEndTextfield.text;
      }
      
      private function requestPvPRewards() : void
      {
         var onRewardsReceived:Function;
         if(PvPConnectionMng.smPvPRewardsInfo == null)
         {
            onRewardsReceived = function(param1:Object):void
            {
               PvPConnectionMng.smPvPRewardsInfo = param1[0];
            };
            InstanceMng.getServerConnection().searchInCollection("pvpLeagueAwards","{}",onRewardsReceived);
         }
      }
      
      public function createPvPMemberOptions(param1:String, param2:String) : FSMemberOptions
      {
         if(stage != null)
         {
            if(this.mPvPOptions == null)
            {
               this.mPvPOptions = new FSMemberOptions(FSMemberOptions.TYPE_CHAT,param1,"","",param2);
            }
            else
            {
               this.mPvPOptions.updateData(param1,param2);
            }
         }
         return this.mPvPOptions;
      }
      
      public function hidePvPMemberOptions() : void
      {
         if(this.mPvPOptions)
         {
            this.mPvPOptions.removeFromParent();
         }
      }
      
      override public function unload() : void
      {
         if(this.mSeasonEndTextfield)
         {
            this.mSeasonEndTextfield.removeFromParent(true);
            this.mSeasonEndTextfield = null;
         }
         if(this.mGoldVisor)
         {
            this.mGoldVisor.removeFromParent(true);
            this.mGoldVisor = null;
         }
         if(this.mCustomizePlayerBanner)
         {
            this.mCustomizePlayerBanner.removeFromParent(true);
            this.mCustomizePlayerBanner = null;
         }
         if(this.mLeagueMatchButton)
         {
            this.mLeagueMatchButton.removeFromParent(true);
            this.mLeagueMatchButton = null;
         }
         if(this.mSplitScreenMatchButton)
         {
            this.mSplitScreenMatchButton.removeFromParent(true);
            this.mSplitScreenMatchButton = null;
         }
         if(this.mLeaderboardsButton)
         {
            this.mLeaderboardsButton.removeFromParent(true);
            this.mLeaderboardsButton = null;
         }
         if(this.mRewardsButton)
         {
            this.mRewardsButton.removeFromParent(true);
            this.mRewardsButton = null;
         }
         if(this.mDefensiveLeagueButton)
         {
            this.mDefensiveLeagueButton.removeFromParent(true);
            this.mDefensiveLeagueButton = null;
         }
         if(this.mPlayButton)
         {
            this.mPlayButton.removeFromParent(true);
            this.mPlayButton = null;
         }
         if(this.mLeague1Button)
         {
            this.mLeague1Button.removeFromParent(true);
            this.mLeague1Button = null;
         }
         if(this.mLeague2Button)
         {
            this.mLeague2Button.removeFromParent(true);
            this.mLeague2Button = null;
         }
         if(this.mLeague3Button)
         {
            this.mLeague3Button.removeFromParent(true);
            this.mLeague3Button = null;
         }
         if(this.mLeagueButtonAura)
         {
            this.mLeagueButtonAura.removeFromParent(true);
            this.mLeagueButtonAura = null;
         }
         if(this.mLeaguesContainer)
         {
            this.mLeaguesContainer.removeFromParent(true);
            this.mLeaguesContainer = null;
         }
         if(this.mLeagueFrame)
         {
            this.mLeagueFrame.removeFromParent(true);
            this.mLeagueFrame = null;
         }
         if(this.mSplitScreenContainer)
         {
            this.mSplitScreenContainer.removeFromParent(true);
            this.mSplitScreenContainer = null;
         }
         if(this.mSplitScreenTitle)
         {
            this.mSplitScreenTitle.removeFromParent(true);
            this.mSplitScreenTitle = null;
         }
         if(this.mSplitScreenSubtitle)
         {
            this.mSplitScreenSubtitle.removeFromParent(true);
            this.mSplitScreenSubtitle = null;
         }
         if(this.mSplitScreenImage)
         {
            this.mSplitScreenImage.removeFromParent(true);
            this.mSplitScreenImage = null;
         }
         if(this.mLeaderboardsContainer)
         {
            this.mLeaderboardsContainer.removeFromParent(true);
            this.mLeaderboardsContainer = null;
         }
         if(this.mLeaderboardsRanking)
         {
            this.mLeaderboardsRanking.removeFromParent(true);
            this.mLeaderboardsRanking = null;
         }
         if(this.mLeaderboardsRatingTextfield)
         {
            this.mLeaderboardsRatingTextfield.removeFromParent(true);
            this.mLeaderboardsRatingTextfield = null;
         }
         if(this.mLeaderboardsVictoriesTextfield)
         {
            this.mLeaderboardsVictoriesTextfield.removeFromParent(true);
            this.mLeaderboardsVictoriesTextfield = null;
         }
         if(this.mLeaderboardsData)
         {
            DictionaryUtils.clearDictionary(this.mLeaderboardsData);
            this.mLeaderboardsData = null;
         }
         if(this.mLeaderboardsScoreSlots)
         {
            DictionaryUtils.clearDictionary(this.mLeaderboardsScoreSlots);
            this.mLeaderboardsScoreSlots = null;
         }
         if(this.mRewardsContainer)
         {
            this.mRewardsContainer.removeFromParent(true);
            this.mRewardsContainer = null;
         }
         if(this.mRewardsScrollContainer)
         {
            this.mRewardsScrollContainer.removeFromParent(true);
            this.mRewardsScrollContainer = null;
         }
         if(this.mRewardsSeparatorImage)
         {
            this.mRewardsSeparatorImage.removeFromParent(true);
            this.mRewardsSeparatorImage = null;
         }
         if(this.mTop3RewardsSeparatorImage)
         {
            this.mTop3RewardsSeparatorImage.removeFromParent(true);
            this.mTop3RewardsSeparatorImage = null;
         }
         if(this.mDefensiveLeagueContainer)
         {
            this.mDefensiveLeagueContainer.removeFromParent(true);
            this.mDefensiveLeagueContainer = null;
         }
         if(this.mDefensiveLeagueTitle)
         {
            this.mDefensiveLeagueTitle.removeFromParent(true);
            this.mDefensiveLeagueTitle = null;
         }
         if(this.mDefensiveLeagueSubtitle)
         {
            this.mDefensiveLeagueSubtitle.removeFromParent(true);
            this.mDefensiveLeagueSubtitle = null;
         }
         if(this.mDefensiveLeagueImage)
         {
            this.mDefensiveLeagueImage.removeFromParent(true);
            this.mDefensiveLeagueImage = null;
         }
         if(this.mPvPOptions)
         {
            this.mPvPOptions.removeFromParent(true);
            this.mPvPOptions = null;
         }
         this.mCurrentSection = -1;
         this.mLeaderboardsSelectedLeague = -1;
         smLeaderboardOwnerRank = -1;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            Root.assets.removeTexture(InstanceMng.getUserDataMng().getOwnerUserData().getCurrentPortraitBGImageName());
         }
         Root.assets.removeTexture(FSBattlefieldUserPortrait.FRAME_BG_NAME);
         InstanceMng.getResourcesMng().removeResourcesFromFolder("pvpLeagues");
         if(Config.getConfig().battleEnemyPortraitSpecial())
         {
            Root.assets.removeTexture(FSBattlefieldUserPortrait.ENEMY_FRAME_BG_NAME);
         }
         if(!Config.smPvPHasFriendlyPvP)
         {
            Root.assets.removeTexture(PopupPlayPvPOffline.BG_NAME);
         }
         super.unload();
      }
   }
}

