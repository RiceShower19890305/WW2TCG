package com.fs.tcgengine.screens
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.CategoriesDefMng;
   import com.fs.tcgengine.model.rules.DungeonDef;
   import com.fs.tcgengine.model.rules.DungeonLevelDef;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSGoldVisor;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.dungeons.PlayerDungeonsScorePortrait;
   import com.fs.tcgengine.view.misc.FSCardSlotInfo;
   import com.fs.tcgengine.view.misc.FSDungeonSlotDifficultyInfo;
   import com.fs.tcgengine.view.misc.FSDungeonSlotInfo;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.pvp.PlayerPvPScorePortrait;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalLayout;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class FSDungeonsScreen extends Screen
   {
      
      private var mLeftContainer:Component;
      
      private var mLeftPanelImage:FSImage;
      
      private var mRightContainer:Component;
      
      private var mRightPanelImage:CustomComponent;
      
      private var mGoldVisor:FSGoldVisor;
      
      private var mMissionNameTextfield:FSTextfield;
      
      private var mChooseMissionImage:FSImage;
      
      private var mChooseMissionTextfield:FSTextfield;
      
      private var mDungeonsScrollContainer:ScrollContainer;
      
      private var mDungeonsSlots:Vector.<FSDungeonSlotInfo>;
      
      private var mDungeonImageXL:FSImage;
      
      private var mDungeonPlayerFactionFlag:FSImage;
      
      private var mDungeonAIFactionFlag:FSImage;
      
      private var mDungeonImageSeparator:FSImage;
      
      private var mDungeonDescriptionPanel:FSImage;
      
      private var mDungeonDescriptionTextfield:FSTextfield;
      
      private var mSelectedDungeonDef:DungeonDef;
      
      private var mChooseButton:FSButton;
      
      private var mInfoButton:FSButton;
      
      private var mCurrentDifficultySelected:int = -1;
      
      private var mRewardsBG:Quad;
      
      private var mBattlesAmountBG:Quad;
      
      private var mBattlesAmountTextfield:FSTextfield;
      
      private var mGoldReward:FSButton;
      
      private var mCardsReward:FSButton;
      
      private var mPacksReward:FSButton;
      
      private var mPortraitsReward:FSButton;
      
      private var mSkinsReward:FSButton;
      
      protected var mDeckCardsLoaded:Dictionary;
      
      private var mDungeonPayed:Boolean = false;
      
      private var mLadderButton:MovieClip;
      
      private var mLadderTextfield:FSTextfield;
      
      private var mShowingLadder:Boolean = false;
      
      private var mRankingContainer:Component;
      
      private var mPvPRankingScrollContainer:ScrollContainer;
      
      private var mRankingScoresVector:Vector.<PlayerDungeonsScorePortrait>;
      
      private var mRankingTitleTextfield:FSTextfield;
      
      private var mRankingVictoriesTextfield:FSTextfield;
      
      private var mServerResponseReceived:Boolean = false;
      
      private var mPowerIcon:FSImage;
      
      private var mRewardsInfoButton:FSButton;
      
      private var mSeasonEndTextfield:FSTextfield;
      
      public function FSDungeonsScreen()
      {
         mNeedsLoadingBar = true;
         mBGName = Constants.DUNGEONS_BG_NAME;
         mScreenName = Constants.DUNGEONS_SCREEN_NAME;
         super();
      }
      
      override protected function setResourcesToLoad() : void
      {
         super.setResourcesToLoad();
         InstanceMng.getResourcesMng().addResourcesFolderByName("customBGs");
         if(!Utils.isBrowser())
         {
            InstanceMng.getResourcesMng().addSpecialScreenResources("customBGs",null,FSResourceMng.PREFIX_TEXTURE);
         }
         if(Config.getConfig().useDeckBuilderThumbnails())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("cards_thumbs");
         }
         if(Config.getConfig().gameHasTierFrames())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("frames");
         }
         if(Config.getConfig().gameHasPowers())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("powers_thumbs");
         }
         InstanceMng.getResourcesMng().addResourcesFolderByName("framesFactionsRarities");
         if(Config.getConfig().cardsHaveCustomAuras())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("anims/animAuras");
         }
         InstanceMng.getResourcesMng().loadAssets();
      }
      
      override public function notifyAssetsLoaded(param1:* = null) : void
      {
         InstanceMng.getDungeonsMng().resetDungeonsMng(false,false);
         super.notifyAssetsLoaded();
         InstanceMng.getServerConnection().getServerConfig(false,this.onDungeonsInfoReceived,null,false);
         this.updateEndSeasonInfo();
         this.createUI();
         var _loc2_:UserData = InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().getOwnerUserData() : null;
         if(_loc2_ != null)
         {
            if(_loc2_.isInBlackList())
            {
               InstanceMng.getPopupMng().openConfirmationPopup(TextManager.getText("TID_GEN_FRAUD_PURCHASE"),this.showMap,this.showMap);
            }
            if(_loc2_.isInDuplicatedList())
            {
               InstanceMng.getPopupMng().openConfirmationPopup(TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"),this.showMap,this.showMap);
            }
         }
      }
      
      private function createUI() : void
      {
         if(!Root.assets.isLoading && isFullyLoaded())
         {
            this.createLeftSection();
            this.createLadderButton();
            this.createRightSection();
            this.createChooseButton();
            this.createInfoButton();
            this.createEndSeasonTextfield();
         }
      }
      
      private function createEndSeasonTextfield() : void
      {
         if(Config.getConfig().getDungeonSeasonRewardsActive())
         {
            if(this.mSeasonEndTextfield == null)
            {
               this.mSeasonEndTextfield = new FSTextfield(width / 3,height * 0.065,"");
               this.mSeasonEndTextfield.format.horizontalAlign = Align.CENTER;
               this.mSeasonEndTextfield.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
               this.mSeasonEndTextfield.x = (width - this.mSeasonEndTextfield.width) / 2;
               addChild(this.mSeasonEndTextfield);
            }
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
            if(this.mSeasonEndTextfield != null)
            {
               _loc1_ = Config.smServerConfig;
               if(_loc1_ != null)
               {
                  _loc2_ = Utils.isSeasonActive(_loc1_["dungeons_seasonStartingTime"],_loc1_["dungeons_seasonEndingTime"]);
                  if(_loc2_)
                  {
                     this.mSeasonEndTextfield.text = TextManager.getText("TID_SEASON_END") + " " + Utils.getSeasonTimeLeftString(_loc1_["dungeons_seasonStartingTime"],_loc1_["dungeons_seasonEndingTime"],_loc2_);
                  }
                  else
                  {
                     this.mSeasonEndTextfield.text = TextManager.getText("TID_SEASON_STARTS") + " " + Utils.getSeasonTimeLeftString(_loc1_["dungeons_seasonStartingTime"],_loc1_["dungeons_seasonEndingTime"],_loc2_);
                  }
               }
            }
         }
      }
      
      private function createDungeonRewardButton() : void
      {
         if(Boolean(this.mGoldVisor) && this.mRewardsInfoButton == null)
         {
            this.mRewardsInfoButton = new FSButton(Root.assets.getTexture("league_popup_button"),TextManager.getText("TID_GEN_MORE_INFO"));
            this.mRewardsInfoButton.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
            this.mRewardsInfoButton.x = mBGSprite.x + this.mRewardsInfoButton.width / 2;
            this.mRewardsInfoButton.y = mBGSprite.y + this.mRewardsInfoButton.height / 2.1;
            this.mRewardsInfoButton.addEventListener(Event.TRIGGERED,this.onRewardsInfoTriggered);
            addChild(this.mRewardsInfoButton);
         }
      }
      
      private function createDungeonReward() : void
      {
         if(Config.getConfig().getDungeonSeasonRewardsActive())
         {
            this.createDungeonRewardButton();
         }
      }
      
      private function onRewardsInfoTriggered() : void
      {
         InstanceMng.getPopupMng().openDungeonRewardsInfoPopup();
      }
      
      private function createLadderButton() : void
      {
         if(this.mLadderButton == null)
         {
            this.mLadderButton = new MovieClip(Root.assets.getTextures("cup_anim_"),20);
            this.mLadderButton.touchable = true;
            Utils.alignComponentAndFixPosition(this.mLadderButton);
            this.mLadderButton.x = this.mLeftContainer.x + this.mLeftPanelImage.x - this.mLadderButton.width / 3;
            this.mLadderButton.y = this.mLeftContainer.y + this.mLeftPanelImage.y + this.mLadderButton.height;
            this.mLadderButton.addEventListener(TouchEvent.TOUCH,this.onLadderIconTouch);
            addChild(this.mLadderButton);
            Starling.juggler.add(this.mLadderButton);
            this.mLadderButton.play();
         }
         if(this.mLadderTextfield == null)
         {
            this.mLadderTextfield = new FSTextfield(this.mLadderButton.width,24,TextManager.getText("TID_DUNGEON_LADDER"));
            this.mLadderTextfield.touchable = false;
            Utils.alignComponentAndFixPosition(this.mLadderTextfield);
            this.mLadderTextfield.x = this.mLadderButton.x;
            this.mLadderTextfield.y = this.mLadderButton.y;
            addChild(this.mLadderTextfield);
         }
      }
      
      private function onLadderIconTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            if(!this.mDungeonPayed)
            {
               if(!this.mShowingLadder)
               {
                  this.mShowingLadder = true;
                  this.removeDungeonInfoSection();
                  this.onDifficultyReset();
                  this.createLeftPanelImage();
                  this.createRankingContainer();
               }
               else if(!Root.assets.isLoading && this.mSelectedDungeonDef != null)
               {
                  this.fillInfoByDungeon(this.mSelectedDungeonDef,null);
               }
            }
         }
         _loc2_ = param1 ? param1.getTouch(this.mLadderButton,TouchPhase.HOVER) : null;
         this.mLadderButton.alpha = _loc2_ ? 0.8 : 1;
         this.mLadderButton.scale = _loc2_ ? 1.04 : 1;
         if(_loc2_)
         {
            this.mLadderButton.pause();
         }
         else
         {
            this.mLadderButton.play();
         }
      }
      
      private function createRankingContainer() : void
      {
         var _loc1_:CustomComponent = null;
         if(this.mRankingContainer == null)
         {
            this.mRankingContainer = new Component();
            _loc1_ = Utils.createCustomBox("dungeon_ladder_bg",1140);
            this.mRankingContainer.addChild(_loc1_);
            this.createRankingTitleTextfield();
            this.createRankingVictoriesTextfield();
            this.createPvPRankingScrollContainer();
            this.mRankingContainer.x = (this.mLeftPanelImage.width - this.mRankingContainer.width) / 2;
            this.mRankingContainer.y = (this.mLeftPanelImage.height - this.mRankingContainer.height) / 2;
            this.mLeftContainer.addChild(this.mRankingContainer);
         }
      }
      
      private function createRankingTitleTextfield() : void
      {
         if(this.mRankingTitleTextfield == null)
         {
            this.mRankingTitleTextfield = new FSTextfield(this.mRankingContainer.width / 1.9,this.mLadderButton.height,TextManager.getText("TID_DUNGEON_LADDER_HARD"),16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
         }
         this.mRankingTitleTextfield.fontName = FSResourceMng.getFontByType();
         this.mRankingTitleTextfield.x = this.mRankingContainer.width * 0.05;
         this.mRankingTitleTextfield.y = this.mRankingTitleTextfield.height * 0.25;
         this.mRankingContainer.addChild(this.mRankingTitleTextfield);
      }
      
      private function createRankingVictoriesTextfield() : void
      {
         if(this.mRankingVictoriesTextfield == null)
         {
            this.mRankingVictoriesTextfield = new FSTextfield(this.mRankingContainer.width / 3.6,this.mLadderButton.height,TextManager.getText("TID_PVP_VICTORIES"),16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
         }
         this.mRankingVictoriesTextfield.fontName = FSResourceMng.getFontByType();
         this.mRankingVictoriesTextfield.x = this.mRankingContainer.width - this.mRankingVictoriesTextfield.width - this.mRankingContainer.width * 0.05;
         this.mRankingVictoriesTextfield.y = this.mRankingTitleTextfield.y;
         this.mRankingContainer.addChild(this.mRankingVictoriesTextfield);
      }
      
      private function createPvPRankingScrollContainer() : void
      {
         var _loc1_:VerticalLayout = null;
         if(this.mPvPRankingScrollContainer == null)
         {
            this.mPvPRankingScrollContainer = new ScrollContainer();
            this.mPvPRankingScrollContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            _loc1_ = new VerticalLayout();
            _loc1_.horizontalAlign = HorizontalAlign.CENTER;
            this.mPvPRankingScrollContainer.layout = _loc1_;
         }
         this.mPvPRankingScrollContainer.height = this.mRankingContainer.height * 0.975 - (this.mRankingVictoriesTextfield.y + this.mRankingVictoriesTextfield.height);
         if(!this.mRankingContainer.contains(this.mPvPRankingScrollContainer))
         {
            this.mRankingContainer.addChild(this.mPvPRankingScrollContainer);
         }
         this.mPvPRankingScrollContainer.y = this.mRankingVictoriesTextfield.y + this.mRankingVictoriesTextfield.height;
         this.processPvPScores();
      }
      
      private function processPvPScores() : void
      {
         var _loc1_:PlayerDungeonsScorePortrait = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:Boolean = false;
         if(_loc2_)
         {
            if(this.mRankingScoresVector == null)
            {
               this.mRankingScoresVector = new Vector.<PlayerDungeonsScorePortrait>();
            }
            _loc3_ = 50;
            showLoadingIcon(false,false);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc1_ = new PlayerDungeonsScorePortrait("0",_loc4_ + 1,"FS_" + Utils.generateRandomString(Config.getConfig().getMaxPlayerNameChars() - "FS_".length),-1,Utils.randomInt(50,3500),false,false);
               this.mRankingScoresVector.push(_loc1_);
               if(this.mPvPRankingScrollContainer != null)
               {
                  this.mPvPRankingScrollContainer.addChild(_loc1_);
               }
               _loc4_++;
            }
            if(this.mPvPRankingScrollContainer.numChildren > 0)
            {
               this.mPvPRankingScrollContainer.width = this.mRankingContainer.width;
            }
         }
         else if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            showLoadingIcon(true,false,Align.CENTER,Align.CENTER,1,null,this.mRankingContainer);
            InstanceMng.getServerConnection().getDungeonsRanking(this.onDungeonsRankingResponse);
         }
         if(this.mPvPRankingScrollContainer)
         {
            this.mPvPRankingScrollContainer.validate();
         }
      }
      
      private function onDungeonsRankingResponse(param1:Object) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:UserData = null;
         if(param1 != null && param1.length > 0)
         {
            _loc3_ = param1.hasOwnProperty("ownerRank") ? int(param1["ownerRank"]) : -1;
            _loc2_ = new Dictionary(true);
            _loc4_ = InstanceMng.getServerConnection().getUserId();
            _loc5_ = false;
            _loc6_ = 0;
            while(_loc6_ < param1.length)
            {
               _loc7_ = new Object();
               if(!_loc5_)
               {
                  _loc5_ = Utils.getDataId(param1[_loc6_]) == _loc4_;
               }
               _loc7_._id = new Object();
               _loc7_._id.$oid = Utils.getDataId(param1[_loc6_]);
               _loc7_.playerName = param1[_loc6_].playerName;
               _loc7_.dungeonsWon = param1[_loc6_].dungeonsWon;
               if(_loc2_[Utils.getDataId(_loc7_)] == null)
               {
                  _loc2_[Utils.getDataId(_loc7_)] = _loc7_;
               }
               _loc6_++;
            }
            if(!_loc5_)
            {
               _loc8_ = Utils.getOwnerUserData();
               _loc7_ = new Object();
               _loc7_._id = new Object();
               _loc7_._id.$oid = _loc4_;
               _loc7_.playerName = _loc8_.getName();
               _loc7_.dungeonsWon = _loc8_.getDungeonsWon();
               if(_loc2_[Utils.getDataId(_loc7_)] == null)
               {
                  _loc2_[Utils.getDataId(_loc7_)] = _loc7_;
               }
            }
         }
         this.onRankingReceived(_loc2_,_loc3_);
      }
      
      private function onRankingReceived(param1:Dictionary, param2:int = -1) : void
      {
         var _loc3_:PlayerPvPScorePortrait = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:UserData = null;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         if(this.mPvPRankingScrollContainer)
         {
            this.mPvPRankingScrollContainer.removeChildren();
         }
         showLoadingIcon(false,false);
         if(InstanceMng.getCurrentScreen() is FSDungeonsScreen)
         {
            if(param1 != null && DictionaryUtils.getDictionaryLength(param1) > 0)
            {
               _loc4_ = new Array();
               for each(_loc5_ in param1)
               {
                  _loc4_.push(_loc5_);
               }
               _loc6_ = _loc4_.sort(DictionaryUtils.sortObjectArrByDungeonsWon);
               _loc7_ = _loc6_ ? int(_loc6_.length) : 0;
               if(_loc6_ != null && _loc6_.length > 0)
               {
                  _loc10_ = false;
                  _loc11_ = "";
                  _loc12_ = 1;
                  _loc13_ = 0;
                  while(_loc13_ < _loc6_.length)
                  {
                     _loc9_ = Utils.getDataId(_loc6_[_loc13_]);
                     _loc10_ = _loc9_ == InstanceMng.getServerConnection().getUserId();
                     if(_loc6_[_loc13_] != null)
                     {
                        _loc11_ = _loc10_ ? TextManager.getText("TID_SOCIAL_ME") : _loc6_[_loc13_].playerName;
                        if(_loc10_ && _loc13_ == _loc6_.length - 1)
                        {
                           _loc14_ = _loc13_ >= _loc7_ ? param2 : _loc12_;
                           _loc14_ = _loc14_ == 0 ? 1 : _loc14_;
                           _loc3_ = new PlayerDungeonsScorePortrait(_loc9_,_loc14_,_loc11_,-1,_loc6_[_loc13_].dungeonsWon,_loc10_,false);
                        }
                        else
                        {
                           _loc3_ = new PlayerDungeonsScorePortrait(_loc9_,_loc12_,_loc11_,-1,_loc6_[_loc13_].dungeonsWon,_loc10_,false);
                        }
                        if(this.mPvPRankingScrollContainer != null)
                        {
                           this.mPvPRankingScrollContainer.addChild(_loc3_);
                        }
                        _loc12_++;
                     }
                     _loc13_++;
                  }
                  if(Boolean(this.mPvPRankingScrollContainer) && Boolean(this.mPvPRankingScrollContainer.numChildren > 0) && _loc3_ != null)
                  {
                     this.mPvPRankingScrollContainer.width = this.mRankingContainer.width;
                     showLoadingIcon(false,false);
                  }
               }
            }
            else
            {
               showLoadingIcon(false,false);
            }
            if(this.mPvPRankingScrollContainer)
            {
               this.mPvPRankingScrollContainer.validate();
            }
         }
      }
      
      private function createInfoButton() : void
      {
         if(this.mInfoButton == null)
         {
            this.mInfoButton = new FSButton(Root.assets.getTexture("dungeon_info_button"));
            this.mInfoButton.x = this.mLeftContainer.x;
            this.mInfoButton.y = this.mLeftContainer.y + this.mLeftPanelImage.height;
            this.mInfoButton.scaleWhenDown = 1;
            this.mInfoButton.enableScaleOnMouseOver(false);
            this.mInfoButton.setTooltipText(TextManager.getText("TID_DUNGEON_INFO"));
            addChild(this.mInfoButton);
         }
      }
      
      private function createLeftSection() : void
      {
         if(this.mLeftContainer == null)
         {
            this.mLeftContainer = new Component();
            addChild(this.mLeftContainer);
         }
         this.createLeftPanelImage();
         if(!this.mShowingLadder)
         {
            this.createMissionNameSection();
         }
      }
      
      private function createLeftPanelImage() : void
      {
         if(this.mLeftPanelImage == null)
         {
            this.mLeftPanelImage = new FSImage(Root.assets.getTexture("dungeon_info_panel"));
         }
         if(!this.mLeftContainer.contains(this.mLeftPanelImage))
         {
            this.mLeftContainer.addChild(this.mLeftPanelImage);
            this.mLeftContainer.x = width / 3 - this.mLeftContainer.width / 2;
            this.mLeftContainer.y = (height - this.mLeftContainer.height) / 2;
         }
      }
      
      private function createMissionNameSection() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.mMissionNameTextfield == null)
         {
            this.mMissionNameTextfield = new FSTextfield(this.mLeftPanelImage.width * 0.85,this.mLeftPanelImage.height / 10,"");
            _loc1_ = this.mLeftPanelImage.x + (this.mLeftPanelImage.width - this.mMissionNameTextfield.width) / 2;
            _loc2_ = this.mLeftPanelImage.y + this.mMissionNameTextfield.height / 2;
            this.mMissionNameTextfield.x = _loc1_;
            this.mMissionNameTextfield.y = _loc2_;
            this.mMissionNameTextfield.format.verticalAlign = Align.BOTTOM;
         }
         this.mLeftContainer.addChild(this.mMissionNameTextfield);
         this.mMissionNameTextfield.text = this.mSelectedDungeonDef ? this.mSelectedDungeonDef.getName() : "";
      }
      
      private function createRightSection() : void
      {
         if(this.mRightContainer == null)
         {
            this.mRightContainer = new Component();
            addChild(this.mRightContainer);
         }
         if(this.mRightPanelImage == null)
         {
            this.mRightPanelImage = Utils.createCustomBox("dungeon_right_panel",571);
            this.mRightContainer.addChild(this.mRightPanelImage);
         }
         this.mRightContainer.x = width / 1.5;
         this.mRightContainer.y = this.mLeftContainer.y + this.mLeftPanelImage.y;
         this.createChooseMissionNameSection();
         this.createDungeonsScrollContainer();
         this.createGoldVisor(true);
         this.createDungeonReward();
         this.fillScrollContainer();
      }
      
      private function createChooseButton() : void
      {
         if(this.mChooseButton == null)
         {
            this.mChooseButton = new FSButton(Root.assets.getTexture("choose_button_disabled"),TextManager.getText("TID_DUNGEON_CHOOSE_BUTTON"));
            Utils.setupButton9Scale(this.mChooseButton,7.5,15,10,5,106.75,39.5);
            this.mChooseButton.fontName = FSResourceMng.getFontByType();
            this.mChooseButton.fontColor = 16777215;
            this.mChooseButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mChooseButton.x = this.mRightContainer.x + this.mRightContainer.width / 2;
            this.mChooseButton.y = this.mRightContainer.y + this.mRightContainer.height - this.mChooseButton.height / 1.65;
            this.mChooseButton.addEventListener(Event.TRIGGERED,this.onChooseTriggered);
            addChild(this.mChooseButton);
         }
      }
      
      public function disableChooseButtonTemporarily() : void
      {
         this.setChooseButtonEnabled(false);
         TweenMax.delayedCall(1,this.setChooseButtonEnabled,[true]);
      }
      
      public function setChooseButtonEnabled(param1:Boolean) : void
      {
         if(this.mChooseButton)
         {
            this.mChooseButton.enabled = param1;
         }
      }
      
      private function onChooseTriggered() : void
      {
         if(this.mSelectedDungeonDef != null && this.mCurrentDifficultySelected != -1)
         {
            if(InstanceMng.getServerConnection().isUserLoggedIn())
            {
               this.mChooseButton.enabled = false;
               this.mServerResponseReceived = false;
               this.enableRightPanel(false);
               showLoadingIcon(true,false);
               InstanceMng.getServerConnection().getServerConfig(false,this.onDungeonsInfoReceived,[true],false);
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_GEN_LOG_NEEDED"));
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_DUNGEON_DIFFICULTY_REQUIRED"),true);
         }
      }
      
      public function enableRightPanel(param1:Boolean) : void
      {
         if(this.mDungeonsScrollContainer)
         {
            this.mDungeonsScrollContainer.touchable = param1;
         }
      }
      
      private function payAndProceedWithDungeon() : void
      {
         var _loc1_:FSNumber = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:GoldDef = null;
         if(this.mSelectedDungeonDef)
         {
            _loc1_ = this.mSelectedDungeonDef.getGoldCostByDifficultyIndexEncripted(this.mCurrentDifficultySelected);
            if(_loc1_.value >= 0)
            {
               this.mChooseButton.enabled = false;
               _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getGold();
               if(_loc2_ >= _loc1_.value)
               {
                  _loc3_ = TextManager.getText("TID_DUNGEON_CONFIRM");
                  InstanceMng.getPopupMng().openDungeonPaymentConfirmationPopup(_loc3_,_loc1_);
               }
               else
               {
                  _loc4_ = GoldDef(InstanceMng.getGoldDefMng().getDefBySku("gold_01"));
                  if(_loc4_)
                  {
                     Utils.setLogText(TextManager.getText("TID_GOLD_NOT_ENOUGH"),true);
                     InstanceMng.getPopupMng().openBuyGoldBagPopup(_loc4_);
                  }
               }
            }
         }
      }
      
      private function fillScrollContainer() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Dictionary = null;
         var _loc3_:Array = null;
         var _loc4_:DungeonDef = null;
         var _loc5_:int = 0;
         var _loc6_:FSDungeonSlotInfo = null;
         if(InstanceMng.getServerConnection().isUserLoggedIn() && Config.smDungeonsAvailables != null && Config.smDungeonsAvailables != "")
         {
            _loc1_ = Config.smDungeonsAvailables.split(",");
            _loc2_ = InstanceMng.getDungeonsDefMng().getDefsBySkuArray(_loc1_);
         }
         if(_loc2_)
         {
            for each(_loc4_ in _loc2_)
            {
               if(_loc3_ == null)
               {
                  _loc3_ = new Array();
               }
               if(_loc4_)
               {
                  _loc3_.push(_loc4_);
               }
            }
            if(_loc3_)
            {
               _loc3_.sort(DictionaryUtils.sortByIndexAsc);
            }
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc6_ = new FSDungeonSlotInfo(DungeonDef(_loc3_[_loc5_]).getSku());
               if(_loc5_ == 0)
               {
                  this.fillInfoByDungeon(DungeonDef(_loc3_[_loc5_]),null);
               }
               this.addDungeonToContainer(_loc6_);
               _loc5_++;
            }
         }
         if(this.mDungeonsScrollContainer)
         {
            this.mDungeonsScrollContainer.validate();
            this.mDungeonsScrollContainer.x = (this.mRightContainer.width - this.mDungeonsScrollContainer.width) / 2;
         }
      }
      
      private function addDungeonToContainer(param1:FSDungeonSlotInfo) : void
      {
         if(param1)
         {
            if(this.mDungeonsScrollContainer)
            {
               this.mDungeonsScrollContainer.addChild(param1);
               if(this.mDungeonsSlots == null)
               {
                  this.mDungeonsSlots = new Vector.<FSDungeonSlotInfo>();
               }
               this.mDungeonsSlots.push(param1);
            }
         }
      }
      
      private function createDungeonsScrollContainer() : void
      {
         if(this.mDungeonsScrollContainer == null)
         {
            this.mDungeonsScrollContainer = new ScrollContainer();
            this.mDungeonsScrollContainer.layout = this.getContainerLayout();
            this.mDungeonsScrollContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mDungeonsScrollContainer.height = this.mRightPanelImage.height * 0.72;
            this.mDungeonsScrollContainer.y = this.mChooseMissionTextfield.y + this.mChooseMissionTextfield.height * 1.25;
            this.mRightContainer.addChild(this.mDungeonsScrollContainer);
         }
      }
      
      private function getContainerLayout() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.horizontalAlign = HorizontalAlign.CENTER;
         return _loc1_;
      }
      
      protected function createGoldVisor(param1:Boolean = true) : void
      {
         if(this.mGoldVisor == null)
         {
            this.mGoldVisor = new FSGoldVisor("gold_button_DB","",param1);
            this.mGoldVisor.x = mBackButton.x - this.mGoldVisor.width;
            this.mGoldVisor.y = this.mGoldVisor.height / 2;
            addChild(this.mGoldVisor);
         }
      }
      
      private function createChooseMissionNameSection() : void
      {
         if(this.mChooseMissionImage == null)
         {
            this.mChooseMissionImage = new FSImage(Root.assets.getTexture("dungeon_right_name"));
            this.mChooseMissionImage.x = (this.mRightContainer.width - this.mChooseMissionImage.width) / 2;
            this.mChooseMissionImage.y = this.mChooseMissionImage.height * 0.2;
            this.mRightContainer.addChild(this.mChooseMissionImage);
         }
         if(this.mChooseMissionTextfield == null)
         {
            this.mChooseMissionTextfield = new FSTextfield(this.mChooseMissionImage.width,this.mChooseMissionImage.height,TextManager.getText("TID_DUNGEON_CHOOSE_MENU"));
            this.mChooseMissionTextfield.x = this.mChooseMissionImage.x;
            this.mChooseMissionTextfield.y = this.mChooseMissionImage.y;
            this.mRightContainer.addChild(this.mChooseMissionTextfield);
         }
      }
      
      public function getDungeonsScrollContainer() : ScrollContainer
      {
         return this.mDungeonsScrollContainer;
      }
      
      public function fillInfoByDungeon(param1:DungeonDef, param2:FSDungeonSlotInfo) : void
      {
         if(this.mShowingLadder)
         {
            this.mShowingLadder = false;
            this.removeLadderSection();
         }
         if(this.mSelectedDungeonDef == null || this.mSelectedDungeonDef.getSku() != param1.getSku())
         {
            this.mSelectedDungeonDef = param1;
            if(this.mSelectedDungeonDef)
            {
               this.createLeftSection();
               this.createMissionNameSection();
               this.createDungeonImage();
               this.createSeparator();
               this.createDungeonFlags();
               this.createDescriptionSection();
               if(param2)
               {
                  this.collapseUnselectedDungeons(param2);
               }
            }
         }
         this.onDifficultySelected(-1);
      }
      
      private function resetDungeonInfo() : void
      {
         this.mCurrentDifficultySelected = -1;
         if(this.mRewardsBG)
         {
            this.mRewardsBG.alpha = 0.0001;
         }
         if(this.mBattlesAmountBG)
         {
            this.mBattlesAmountBG.alpha = 0.0001;
         }
         if(this.mBattlesAmountTextfield)
         {
            this.mBattlesAmountTextfield.alpha = 0.0001;
         }
         if(this.mGoldReward)
         {
            this.mGoldReward.removeFromParent();
            this.mGoldReward.destroy();
            this.mGoldReward = null;
         }
         if(this.mCardsReward)
         {
            this.mCardsReward.removeFromParent();
            this.mCardsReward.destroy();
            this.mCardsReward = null;
         }
         if(this.mPacksReward)
         {
            this.mPacksReward.removeFromParent();
            this.mPacksReward.destroy();
            this.mPacksReward = null;
         }
         if(this.mPortraitsReward)
         {
            this.mPortraitsReward.removeFromParent();
            this.mPortraitsReward.destroy();
            this.mPortraitsReward = null;
         }
         if(this.mSkinsReward)
         {
            this.mSkinsReward.removeFromParent();
            this.mSkinsReward.destroy();
            this.mSkinsReward = null;
         }
      }
      
      private function createDungeonRewards() : void
      {
         if(this.mSelectedDungeonDef)
         {
            if(this.mRewardsBG == null)
            {
               this.mRewardsBG = new Quad(this.mDungeonImageXL.width * 0.94,this.mDungeonImageXL.height * 0.2,0);
               this.mRewardsBG.x = this.mDungeonImageXL.x + (this.mDungeonImageXL.width - this.mRewardsBG.width) / 2;
               this.mRewardsBG.y = this.mDungeonImageXL.y + this.mDungeonImageXL.height * 0.96 - this.mRewardsBG.height;
            }
            this.mRewardsBG.alpha = 0.5;
            SpecialFX.tweenToAlpha(this.mRewardsBG,0.5,0.25,0);
            this.mLeftContainer.addChild(this.mRewardsBG);
            if(this.mDungeonPlayerFactionFlag)
            {
               this.mLeftContainer.addChild(this.mDungeonPlayerFactionFlag);
            }
            if(this.mDungeonAIFactionFlag)
            {
               this.mLeftContainer.addChild(this.mDungeonAIFactionFlag);
            }
            this.createRewardsButtons();
         }
      }
      
      private function createRewardsButtons() : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:FSCoordinate = null;
         var _loc1_:Object = this.mSelectedDungeonDef.getRewardsSummaryByDifficultyIndex(this.mCurrentDifficultySelected);
         if(_loc1_)
         {
            _loc2_ = "";
            _loc3_ = int(_loc1_.totalRewards);
            _loc4_ = 0;
            if(_loc1_.hasGold)
            {
               if(this.mGoldReward == null)
               {
                  this.mGoldReward = new FSButton(Root.assets.getTexture("dungeon_small_gold"));
                  this.mGoldReward.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
                  this.mGoldReward.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
                  this.mGoldReward.scaleWhenDown = 1;
                  this.mGoldReward.enableScaleOnMouseOver(false);
                  this.mGoldReward.setTooltipText(TextManager.getText("TID_DUNGEON_INFO_GOLD"));
               }
               _loc5_ = Utils.getXYPositionInContainer(_loc4_,this.mGoldReward.width,this.mGoldReward.height,this.mRewardsBG.width,this.mRewardsBG.height,_loc3_,1,true);
               this.mGoldReward.x = this.mRewardsBG.x + _loc5_.getX() + this.mGoldReward.width / 2;
               this.mGoldReward.y = this.mRewardsBG.y + _loc5_.getY() + this.mGoldReward.height / 2;
               this.mLeftContainer.addChild(this.mGoldReward);
               _loc4_++;
               this.mGoldReward.text = _loc1_.minGold + "-" + _loc1_.maxGold;
            }
            else if(this.mGoldReward)
            {
               this.mGoldReward.removeFromParent();
            }
            if(_loc1_.hasCards)
            {
               if(this.mCardsReward == null)
               {
                  this.mCardsReward = new FSButton(Root.assets.getTexture("dungeon_random_card"));
                  this.mCardsReward.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
                  this.mCardsReward.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
                  this.mCardsReward.scaleWhenDown = 1;
                  this.mCardsReward.enableScaleOnMouseOver(false);
                  this.mCardsReward.setTooltipText(TextManager.getText("TID_DUNGEON_INFO_RANDOM_CARDS"));
               }
               _loc5_ = Utils.getXYPositionInContainer(_loc4_,this.mCardsReward.width,this.mCardsReward.height,this.mRewardsBG.width,this.mRewardsBG.height,_loc3_,1,true);
               this.mCardsReward.x = this.mRewardsBG.x + _loc5_.getX() + this.mCardsReward.width / 2;
               this.mCardsReward.y = this.mRewardsBG.y + _loc5_.getY() + this.mCardsReward.height / 2;
               this.mLeftContainer.addChild(this.mCardsReward);
               _loc4_++;
               _loc2_ = _loc1_.minCards == _loc1_.maxCards ? _loc1_.maxCards : _loc1_.minCards + "-" + _loc1_.maxCards;
               this.mCardsReward.text = _loc2_;
            }
            else if(this.mCardsReward)
            {
               this.mCardsReward.removeFromParent();
            }
            if(_loc1_.hasPacks)
            {
               if(this.mPacksReward == null)
               {
                  this.mPacksReward = new FSButton(Root.assets.getTexture(this.mSelectedDungeonDef.getPackBGByDifficultyIndex(this.mCurrentDifficultySelected)));
                  this.mPacksReward.readjustSize();
                  this.mPacksReward.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
                  this.mPacksReward.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
                  this.mPacksReward.scaleWhenDown = 1;
                  this.mPacksReward.enableScaleOnMouseOver(false);
               }
               else
               {
                  this.mPacksReward.upState = Root.assets.getTexture(this.mSelectedDungeonDef.getPackBGByDifficultyIndex(this.mCurrentDifficultySelected));
                  this.mPacksReward.readjustSize();
               }
               this.mPacksReward.setTooltipText(this.mSelectedDungeonDef.getPackInfoByDifficultyIndex(this.mCurrentDifficultySelected));
               _loc5_ = Utils.getXYPositionInContainer(_loc4_,this.mPacksReward.width,this.mPacksReward.height,this.mRewardsBG.width,this.mRewardsBG.height,_loc3_,1,true);
               this.mPacksReward.x = this.mRewardsBG.x + _loc5_.getX() + this.mPacksReward.width / 2;
               this.mPacksReward.y = this.mRewardsBG.y + _loc5_.getY() + this.mPacksReward.height / 2;
               this.mLeftContainer.addChild(this.mPacksReward);
               _loc4_++;
               _loc2_ = _loc1_.minPacks == _loc1_.maxPacks ? _loc1_.maxPacks : _loc1_.minPacks + "-" + _loc1_.maxPacks;
               this.mPacksReward.text = _loc2_;
            }
            else if(this.mPacksReward)
            {
               this.mPacksReward.removeFromParent();
            }
            if(_loc1_.hasPortraits)
            {
               if(this.mPortraitsReward == null)
               {
                  this.mPortraitsReward = new FSButton(Root.assets.getTexture("dungeon_portrait"));
                  this.mPortraitsReward.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
                  this.mPortraitsReward.scaleWhenDown = 1;
                  this.mPortraitsReward.enableScaleOnMouseOver(false);
                  this.mPortraitsReward.setTooltipText(TextManager.getText("TID_DUNGEON_INFO_PORTRAITS"));
               }
               _loc5_ = Utils.getXYPositionInContainer(_loc4_,this.mPortraitsReward.width,this.mPortraitsReward.height,this.mRewardsBG.width,this.mRewardsBG.height,_loc3_,1,true);
               this.mPortraitsReward.x = this.mRewardsBG.x + _loc5_.getX() + this.mPortraitsReward.width / 2;
               this.mPortraitsReward.y = this.mRewardsBG.y + _loc5_.getY() + this.mPortraitsReward.height / 2;
               this.mLeftContainer.addChild(this.mPortraitsReward);
               _loc4_++;
               _loc2_ = _loc1_.minPortraits == _loc1_.maxPortraits ? _loc1_.maxPortraits : _loc1_.minPortraits + "-" + _loc1_.maxPortraits;
               this.mPortraitsReward.text = _loc2_;
            }
            else if(this.mPortraitsReward)
            {
               this.mPortraitsReward.removeFromParent();
            }
            if(_loc1_.hasSkins)
            {
               if(this.mSkinsReward == null)
               {
                  this.mSkinsReward = new FSButton(Root.assets.getTexture("skin_portrait"));
                  this.mSkinsReward.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
                  this.mSkinsReward.scaleWhenDown = 1;
                  this.mSkinsReward.enableScaleOnMouseOver(false);
                  this.mSkinsReward.setTooltipText(TextManager.getText("TID_DUNGEON_INFO_PORTRAITS"));
               }
               _loc5_ = Utils.getXYPositionInContainer(_loc4_,this.mSkinsReward.width,this.mSkinsReward.height,this.mRewardsBG.width,this.mRewardsBG.height,_loc3_,1,true);
               this.mSkinsReward.x = this.mRewardsBG.x + _loc5_.getX() + this.mSkinsReward.width / 2;
               this.mSkinsReward.y = this.mRewardsBG.y + _loc5_.getY() + this.mSkinsReward.height / 2;
               this.mLeftContainer.addChild(this.mSkinsReward);
               _loc4_++;
               _loc2_ = _loc1_.minSkins == _loc1_.maxSkins ? _loc1_.maxSkins : _loc1_.minSkins + "-" + _loc1_.maxSkins;
               this.mSkinsReward.text = _loc2_;
            }
            else if(this.mSkinsReward)
            {
               this.mSkinsReward.removeFromParent();
            }
         }
         else
         {
            if(this.mGoldReward)
            {
               this.mGoldReward.removeFromParent();
            }
            if(this.mCardsReward)
            {
               this.mCardsReward.removeFromParent();
            }
            if(this.mPacksReward)
            {
               this.mPacksReward.removeFromParent();
            }
            if(this.mPortraitsReward)
            {
               this.mPortraitsReward.removeFromParent();
            }
            if(this.mSkinsReward)
            {
               this.mSkinsReward.removeFromParent();
            }
         }
      }
      
      private function createDungeonBattlesAmount() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         if(this.mSelectedDungeonDef)
         {
            if(this.mBattlesAmountBG == null)
            {
               this.mBattlesAmountBG = new Quad(this.mDungeonImageXL.width * 0.3,this.mDungeonImageXL.height * 0.1,0);
               this.mBattlesAmountBG.x = this.mRewardsBG.x;
               this.mBattlesAmountBG.y = this.mRewardsBG.y - this.mBattlesAmountBG.height * 1.2;
            }
            this.mBattlesAmountBG.setVertexAlpha(1,0.25);
            this.mBattlesAmountBG.setVertexAlpha(3,0.25);
            this.mBattlesAmountBG.alpha = 0.75;
            SpecialFX.tweenToAlpha(this.mBattlesAmountBG,0.75,0.25,0);
            this.mLeftContainer.addChild(this.mBattlesAmountBG);
            if(this.mBattlesAmountTextfield == null)
            {
               this.mBattlesAmountTextfield = new FSTextfield(this.mBattlesAmountBG.width,this.mBattlesAmountBG.height);
               this.mBattlesAmountTextfield.x = this.mBattlesAmountBG.x;
               this.mBattlesAmountTextfield.y = this.mBattlesAmountBG.y;
            }
            _loc1_ = this.mSelectedDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDifficultySelected);
            _loc2_ = _loc1_ ? int(_loc1_.length) : 0;
            this.mBattlesAmountTextfield.text = TextManager.replaceParameters(TextManager.getText("TID_DUNGEON_BATTLES"),[_loc2_]);
            SpecialFX.tweenToAlpha(this.mBattlesAmountTextfield,0.999,0.25,0);
            this.mLeftContainer.addChild(this.mBattlesAmountTextfield);
         }
      }
      
      private function collapseUnselectedDungeons(param1:FSDungeonSlotInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSDungeonSlotInfo = null;
         if(this.mDungeonsScrollContainer)
         {
            if(this.mDungeonsSlots)
            {
               if(param1)
               {
                  _loc2_ = 0;
                  while(_loc2_ < this.mDungeonsSlots.length)
                  {
                     _loc3_ = this.mDungeonsSlots[_loc2_];
                     if(_loc3_ != param1)
                     {
                        _loc3_.setExpanded(false);
                     }
                     _loc2_++;
                  }
               }
               else
               {
                  _loc2_ = 0;
                  while(_loc2_ < this.mDungeonsSlots.length)
                  {
                     _loc3_ = this.mDungeonsSlots[_loc2_];
                     _loc3_.setExpanded(false);
                     _loc2_++;
                  }
               }
            }
         }
      }
      
      private function createDungeonImage() : void
      {
         if(this.mSelectedDungeonDef)
         {
            if(this.mDungeonImageXL == null)
            {
               this.mDungeonImageXL = new FSImage(Root.assets.getTexture(this.mSelectedDungeonDef.getBGXLImageName()));
            }
            else
            {
               this.mDungeonImageXL.texture = Root.assets.getTexture(this.mSelectedDungeonDef.getBGXLImageName());
            }
            if(!this.mLeftContainer.contains(this.mDungeonImageXL))
            {
               this.mDungeonImageXL.scale = 1.33;
               this.mLeftContainer.addChild(this.mDungeonImageXL);
               if(this.mMissionNameTextfield)
               {
                  this.mLeftContainer.addChild(this.mMissionNameTextfield);
               }
               this.mDungeonImageXL.x = this.mLeftPanelImage.x + (this.mLeftPanelImage.width - this.mDungeonImageXL.width) / 2;
               this.mDungeonImageXL.y = 15;
            }
         }
      }
      
      protected function createSeparator() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.mSelectedDungeonDef)
         {
            _loc1_ = this.mSelectedDungeonDef.getBGPlayerFactionFlag();
            _loc2_ = this.mSelectedDungeonDef.getBGAIFactionFlag();
            if(_loc1_ != null && _loc1_ != "" && _loc2_ != null && _loc2_ != "")
            {
               if(this.mDungeonImageSeparator == null)
               {
                  this.mDungeonImageSeparator = new FSImage(Root.assets.getTexture("separator_vs"));
                  this.mDungeonImageSeparator.x = this.mDungeonImageXL.x + (this.mDungeonImageXL.width - this.mDungeonImageSeparator.width) / 2;
                  this.mDungeonImageSeparator.y = this.mDungeonImageXL.y + this.mDungeonImageXL.height - this.mDungeonImageSeparator.height / 2.5;
               }
               this.mLeftContainer.addChild(this.mDungeonImageSeparator);
            }
         }
      }
      
      protected function createDungeonFlags() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.mSelectedDungeonDef)
         {
            _loc1_ = this.mSelectedDungeonDef.getBGPlayerFactionFlag();
            _loc2_ = this.mSelectedDungeonDef.getBGAIFactionFlag();
            if(_loc1_ != null && _loc1_ != "" && _loc2_ != null && _loc2_ != "")
            {
               if(this.mDungeonPlayerFactionFlag == null)
               {
                  this.mDungeonPlayerFactionFlag = new FSImage(Root.assets.getTexture(this.mSelectedDungeonDef.getBGPlayerFactionFlag()));
               }
               else
               {
                  this.mDungeonPlayerFactionFlag.texture = Root.assets.getTexture(this.mSelectedDungeonDef.getBGPlayerFactionFlag());
               }
               this.mDungeonPlayerFactionFlag.x = this.mDungeonImageXL.x + this.mDungeonImageXL.width / 2 - this.mDungeonPlayerFactionFlag.width * 1.5;
               this.mDungeonPlayerFactionFlag.y = this.mDungeonImageSeparator.y;
               this.mLeftContainer.addChild(this.mDungeonPlayerFactionFlag);
               if(this.mDungeonAIFactionFlag == null)
               {
                  this.mDungeonAIFactionFlag = new FSImage(Root.assets.getTexture(this.mSelectedDungeonDef.getBGAIFactionFlag()));
               }
               else
               {
                  this.mDungeonAIFactionFlag.texture = Root.assets.getTexture(this.mSelectedDungeonDef.getBGAIFactionFlag());
               }
               this.mDungeonAIFactionFlag.x = this.mDungeonImageXL.x + this.mDungeonImageXL.width / 2 + this.mDungeonAIFactionFlag.width / 2;
               this.mDungeonAIFactionFlag.y = this.mDungeonImageSeparator.y;
               this.mLeftContainer.addChild(this.mDungeonAIFactionFlag);
            }
         }
      }
      
      private function createDescriptionSection() : void
      {
         var _loc1_:int = 0;
         if(this.mSelectedDungeonDef)
         {
            if(this.mDungeonDescriptionPanel == null)
            {
               this.mDungeonDescriptionPanel = new FSImage(Root.assets.getTexture("dungeon_description_panel"));
               this.mDungeonDescriptionPanel.x = this.mDungeonImageXL.x;
               this.mDungeonDescriptionPanel.y = this.mDungeonImageSeparator ? this.mDungeonImageSeparator.y + this.mDungeonImageSeparator.height / 1.5 : this.mDungeonImageXL.y + this.mDungeonImageXL.height;
            }
            if(!this.mLeftContainer.contains(this.mDungeonDescriptionPanel))
            {
               if(this.mDungeonImageSeparator)
               {
                  _loc1_ = this.mDungeonImageSeparator ? this.mLeftContainer.getChildIndex(this.mDungeonImageSeparator) : 0;
                  this.mLeftContainer.addChildAt(this.mDungeonDescriptionPanel,_loc1_);
               }
               else
               {
                  this.mLeftContainer.addChild(this.mDungeonDescriptionPanel);
               }
            }
            if(this.mDungeonDescriptionTextfield == null)
            {
               this.mDungeonDescriptionTextfield = new FSTextfield(this.mDungeonDescriptionPanel.width * 0.9,this.mDungeonDescriptionPanel.height * 0.8);
               this.mDungeonDescriptionTextfield.x = this.mDungeonDescriptionPanel.x + (this.mDungeonDescriptionPanel.width - this.mDungeonDescriptionTextfield.width) / 2;
               this.mDungeonDescriptionTextfield.y = this.mDungeonDescriptionPanel.y + (this.mDungeonDescriptionPanel.height - this.mDungeonDescriptionTextfield.height) / 2;
            }
            if(!this.mLeftContainer.contains(this.mDungeonDescriptionTextfield))
            {
               this.mLeftContainer.addChild(this.mDungeonDescriptionTextfield);
            }
            this.mDungeonDescriptionTextfield.text = this.mSelectedDungeonDef.getDesc();
         }
      }
      
      public function showMap() : void
      {
         dispatchEventWith(Screen.GO_TO_MAP,true);
      }
      
      private function removeLadderSection() : void
      {
         this.mLeftContainer.removeChildren();
         if(this.mRankingScoresVector)
         {
            this.mRankingScoresVector.length = 0;
            this.mRankingScoresVector = null;
         }
         if(this.mRankingTitleTextfield)
         {
            this.mRankingTitleTextfield.removeFromParent();
            this.mRankingTitleTextfield = null;
         }
         if(this.mRankingVictoriesTextfield)
         {
            this.mRankingVictoriesTextfield.removeFromParent();
            this.mRankingVictoriesTextfield = null;
         }
         if(this.mPvPRankingScrollContainer)
         {
            this.mPvPRankingScrollContainer.removeChildren();
            this.mPvPRankingScrollContainer = null;
         }
         if(this.mRankingContainer)
         {
            this.mRankingContainer.removeFromParent();
            this.mRankingContainer = null;
         }
      }
      
      private function removeDungeonInfoSection() : void
      {
         this.mSelectedDungeonDef = null;
         this.resetDungeonInfo();
         this.collapseUnselectedDungeons(null);
         this.mLeftContainer.removeChildren();
      }
      
      public function onDifficultySelected(param1:int) : void
      {
         var _loc2_:String = null;
         if(this.mShowingLadder)
         {
            this.mShowingLadder = false;
            this.removeLadderSection();
         }
         Utils.removeLog();
         if(Boolean(this.mChooseButton) && this.mCurrentDifficultySelected != param1)
         {
            if(this.mSelectedDungeonDef)
            {
               this.mCurrentDifficultySelected = param1;
               _loc2_ = this.getCurrentGoldToPay().toString();
               if(_loc2_ != null && _loc2_ != "")
               {
                  _loc2_ = _loc2_ == "0" ? TextManager.getText("TID_GEN_FREE") : _loc2_;
               }
               this.mChooseButton.text = _loc2_;
               this.mChooseButton.upState = Root.assets.getTexture("choose_button");
               Utils.removeButton9Scale(this.mChooseButton,106.75,39.5);
               this.mChooseButton.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            }
            if(param1 == -1)
            {
               this.onDifficultyReset();
            }
            else if(!this.mShowingLadder)
            {
               this.createLeftSection();
               this.createDungeonRewards();
               this.createDungeonBattlesAmount();
            }
         }
      }
      
      private function onDifficultyReset() : void
      {
         this.mChooseButton.text = TextManager.getText("TID_DUNGEON_CHOOSE_BUTTON");
         this.mChooseButton.upState = Root.assets.getTexture("choose_button_disabled");
         Utils.setupButton9Scale(this.mChooseButton,7.5,15,10,5,106.75,39.5);
         this.mChooseButton.fontName = FSResourceMng.getFontByType();
         this.resetDungeonInfo();
      }
      
      public function getCurrentGoldToPay() : int
      {
         var _loc1_:int = -1;
         if(Boolean(this.mSelectedDungeonDef) && this.mCurrentDifficultySelected != -1)
         {
            _loc1_ = this.mSelectedDungeonDef.getGoldCostByDifficultyIndex(this.mCurrentDifficultySelected);
         }
         return _loc1_;
      }
      
      override public function getGoldVisor() : *
      {
         return this.mGoldVisor;
      }
      
      public function cleanScrollContainer(param1:Function) : void
      {
         var _loc2_:Component = null;
         var _loc3_:int = 0;
         var _loc4_:Number = 0.25;
         if(this.mDungeonsScrollContainer)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mDungeonsScrollContainer.numChildren)
            {
               _loc2_ = Component(this.mDungeonsScrollContainer.getChildAt(_loc3_));
               if(_loc2_ != null)
               {
                  if(_loc2_ is FSDungeonSlotInfo || _loc2_ is FSDungeonSlotDifficultyInfo)
                  {
                     SpecialFX.tweenToAlpha(_loc2_,0.001,_loc4_,0,this.removeComponentFromParent,[_loc2_]);
                  }
               }
               _loc3_++;
            }
         }
         TweenMax.delayedCall(_loc4_ + 0.25,param1);
      }
      
      private function removeComponentFromParent(param1:Component) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      override public function unload() : void
      {
         var _loc1_:int = 0;
         if(this.mLeftContainer)
         {
            this.mLeftContainer.removeFromParent(true);
            this.mLeftContainer = null;
         }
         if(this.mLeftPanelImage)
         {
            this.mLeftPanelImage.removeFromParent(true);
            this.mLeftPanelImage = null;
         }
         if(this.mRightContainer)
         {
            this.mRightContainer.removeFromParent(true);
            this.mRightContainer = null;
         }
         if(this.mRightPanelImage)
         {
            this.mRightPanelImage.removeFromParent(true);
            this.mRightPanelImage = null;
         }
         if(this.mGoldVisor)
         {
            this.mGoldVisor.removeFromParent(true);
            this.mGoldVisor = null;
         }
         if(this.mMissionNameTextfield)
         {
            this.mMissionNameTextfield.removeFromParent(true);
            this.mMissionNameTextfield = null;
         }
         if(this.mChooseMissionImage)
         {
            this.mChooseMissionImage.removeFromParent(true);
            this.mChooseMissionImage = null;
         }
         if(this.mChooseMissionTextfield)
         {
            this.mChooseMissionTextfield.removeFromParent(true);
            this.mChooseMissionTextfield = null;
         }
         if(this.mDungeonsScrollContainer)
         {
            this.mDungeonsScrollContainer.removeFromParent(true);
            this.mDungeonsScrollContainer = null;
         }
         if(this.mDungeonImageXL)
         {
            this.mDungeonImageXL.removeFromParent(true);
            this.mDungeonImageXL = null;
         }
         if(this.mDungeonPlayerFactionFlag)
         {
            this.mDungeonPlayerFactionFlag.removeFromParent(true);
            this.mDungeonPlayerFactionFlag = null;
         }
         if(this.mDungeonAIFactionFlag)
         {
            this.mDungeonAIFactionFlag.removeFromParent(true);
            this.mDungeonAIFactionFlag = null;
         }
         if(this.mDungeonsSlots)
         {
            _loc1_ = 0;
            _loc1_ = 0;
            while(_loc1_ < this.mDungeonsSlots.length)
            {
               this.mDungeonsSlots[_loc1_].removeFromParent();
               _loc1_++;
            }
            this.mDungeonsSlots.length = 0;
            this.mDungeonsSlots = null;
         }
         if(this.mDungeonAIFactionFlag)
         {
            this.mDungeonAIFactionFlag.removeFromParent(true);
            this.mDungeonAIFactionFlag = null;
         }
         if(this.mDungeonImageSeparator)
         {
            this.mDungeonImageSeparator.removeFromParent(true);
            this.mDungeonImageSeparator = null;
         }
         if(this.mDungeonDescriptionPanel)
         {
            this.mDungeonDescriptionPanel.removeFromParent(true);
            this.mDungeonDescriptionPanel = null;
         }
         if(this.mDungeonDescriptionTextfield)
         {
            this.mDungeonDescriptionTextfield.removeFromParent(true);
            this.mDungeonDescriptionTextfield = null;
         }
         if(this.mChooseButton)
         {
            this.mChooseButton.removeFromParent(true);
            this.mChooseButton = null;
         }
         if(this.mInfoButton)
         {
            this.mInfoButton.removeFromParent(true);
            this.mInfoButton = null;
         }
         if(this.mRewardsBG)
         {
            this.mRewardsBG.removeFromParent(true);
            this.mRewardsBG = null;
         }
         if(this.mBattlesAmountBG)
         {
            this.mBattlesAmountBG.removeFromParent(true);
            this.mBattlesAmountBG = null;
         }
         if(this.mBattlesAmountTextfield)
         {
            this.mBattlesAmountTextfield.removeFromParent(true);
            this.mBattlesAmountTextfield = null;
         }
         if(this.mGoldReward)
         {
            this.mGoldReward.removeFromParent(true);
            this.mGoldReward = null;
         }
         if(this.mCardsReward)
         {
            this.mCardsReward.removeFromParent(true);
            this.mCardsReward = null;
         }
         if(this.mPacksReward)
         {
            this.mPacksReward.removeFromParent(true);
            this.mPacksReward = null;
         }
         if(this.mPortraitsReward)
         {
            this.mPortraitsReward.removeFromParent(true);
            this.mPortraitsReward = null;
         }
         if(this.mSkinsReward)
         {
            this.mSkinsReward.removeFromParent();
            this.mSkinsReward = null;
         }
         if(this.mLadderButton)
         {
            Starling.juggler.remove(this.mLadderButton);
            this.mLadderButton.removeFromParent(true);
            this.mLadderButton = null;
         }
         if(this.mLadderTextfield)
         {
            this.mLadderTextfield.removeFromParent(true);
            this.mLadderTextfield = null;
         }
         if(this.mRankingVictoriesTextfield)
         {
            this.mRankingVictoriesTextfield.removeFromParent(true);
            this.mRankingVictoriesTextfield = null;
         }
         if(this.mRankingTitleTextfield)
         {
            this.mRankingTitleTextfield.removeFromParent(true);
            this.mRankingTitleTextfield = null;
         }
         if(this.mSeasonEndTextfield)
         {
            this.mSeasonEndTextfield.removeFromParent(true);
            this.mSeasonEndTextfield = null;
         }
         if(this.mRewardsInfoButton)
         {
            this.mRewardsInfoButton.removeFromParent(true);
            this.mRewardsInfoButton = null;
         }
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("frames",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesXL",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesFactionsRarities",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("cards_thumbs",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("powers_thumbs",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         if(Config.getConfig().cardsHaveCustomAuras())
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("anims/animAuras",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         }
         InstanceMng.getResourcesMng().removeSpecialScreenResources("customBGs");
         InstanceMng.getResourcesMng().removeResourcesFromFolder("customBGs");
         mSelectedCard = null;
         this.mCurrentDifficultySelected = -1;
         DictionaryUtils.clearDictionary(this.mDeckCardsLoaded);
         this.mDeckCardsLoaded = null;
         this.mSelectedDungeonDef = null;
         super.unload();
      }
      
      public function onPaymentCompleted(param1:FSNumber) : void
      {
         this.mDungeonPayed = true;
         if(this.mLadderButton)
         {
            if(this.mLadderButton.hasOwnProperty("touchable"))
            {
               this.mLadderButton.touchable = false;
            }
         }
         if(this.mSelectedDungeonDef)
         {
            FSTracker.trackMiscAction(FSTracker.CATEGORY_DUNGEONS,FSTracker.ACTION_DUNGEON_PAYED,{
               "dungeon":this.mSelectedDungeonDef.getIndex(),
               "difficulty":this.mCurrentDifficultySelected,
               "goldCost":param1.value
            });
            if(this.mGoldVisor)
            {
               InstanceMng.getUserDataMng().getOwnerUserData().substractGold(-param1.value,this.cleanScrollContainer,[this.onDungeonsContainerEmpty],Utils.showNotEnoughCurrencyMessage,[ServerConnection.CURRENCY_GOLD,true]);
            }
         }
      }
      
      private function onDungeonsContainerEmpty() : void
      {
         this.sortPanelByCategory();
         this.enableRightPanel(true);
         if(this.mChooseButton)
         {
            this.mChooseButton.enabled = true;
            this.mChooseButton.text = TextManager.getText("TID_GEN_PLAY");
            this.mChooseButton.upState = Root.assets.getTexture(Constants.ACCEPT_GREEN_BUTTON_UP_NAME);
            Utils.setupButton9Scale(this.mChooseButton,7.5,15,10,5,106.6,39.4);
            this.mChooseButton.fontName = FSResourceMng.getFontByType();
            this.mChooseButton.enableScaleOnMouseOver(false);
            SpecialFX.createYoYoZoomTransition(this.mChooseButton,1.2,2,-1,null,null,false);
            this.mChooseButton.removeEventListener(Event.TRIGGERED,this.onChooseTriggered);
            this.mChooseButton.addEventListener(Event.TRIGGERED,this.onPlayMission);
         }
         if(this.mChooseMissionTextfield)
         {
            this.mChooseMissionTextfield.text = TextManager.getText("TID_GEN_MENU_DECK");
         }
      }
      
      private function onPlayMission(param1:Event) : void
      {
         if(this.mSelectedDungeonDef)
         {
            if(!Utils.smInternetAvailable || !InstanceMng.getServerConnection().isUserLoggedIn())
            {
               Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
               onConnectionLost();
            }
            else if(this.mSelectedDungeonDef)
            {
               InstanceMng.getDungeonsMng().onDungeonStart(this.mSelectedDungeonDef,this.mCurrentDifficultySelected);
            }
         }
      }
      
      public function sortPanelByCategory() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:Dictionary = null;
         var _loc10_:DungeonLevelDef = null;
         var _loc3_:UserData = Utils.getOwnerUserData();
         var _loc4_:Number = 0.1;
         var _loc9_:int = 0;
         var _loc11_:Array = this.mSelectedDungeonDef ? this.mSelectedDungeonDef.getLevelsByDifficultyIndex(this.mCurrentDifficultySelected) : null;
         if(_loc11_)
         {
            _loc10_ = DungeonLevelDef(InstanceMng.getDungeonLevelsDefMng().getLevelDefByLevelIndex(_loc11_[0]));
            if(Config.getConfig().gameHasPowers())
            {
               this.createPowerIcon(_loc10_);
            }
         }
         var _loc12_:Dictionary = _loc10_ ? _loc10_.getPlayerCards() : null;
         if(_loc12_)
         {
            _loc1_ = 0;
            while(_loc1_ < CategoriesDefMng.smCategoriesVec.length)
            {
               _loc8_ = DictionaryUtils.getCatalogFilteredByCategory(_loc12_,CategoriesDefMng.smCategoriesVec[_loc1_]);
               if(_loc8_ != null)
               {
                  _loc5_ = DictionaryUtils.getKeys(_loc8_);
                  if(_loc5_)
                  {
                     _loc5_.sort(DictionaryUtils.sortCardsByValueAndSubcategory);
                     _loc2_ = 0;
                     while(_loc2_ < _loc5_.length)
                     {
                        _loc6_ = _loc5_[_loc2_];
                        _loc7_ = int(_loc8_[_loc6_]);
                        this.addCardSlotInfo(_loc6_,_loc7_,_loc4_,_loc9_);
                        _loc4_ += 0.1;
                        _loc9_++;
                        _loc2_++;
                     }
                     this.resetContainerPos();
                  }
               }
               _loc1_++;
            }
         }
      }
      
      private function createPowerIcon(param1:DungeonLevelDef) : void
      {
         var _loc2_:PowerDef = param1 ? InstanceMng.getPowerDefMng().getDefBySku(param1.getPowerSku()) as PowerDef : null;
         if(_loc2_)
         {
            if(this.mPowerIcon == null)
            {
               this.mPowerIcon = new FSImage(Root.assets.getTexture(_loc2_.getBgIcon()));
            }
         }
         this.mRightContainer.addChild(this.mPowerIcon);
      }
      
      private function resetContainerPos() : void
      {
         var _loc1_:FSCardSlotInfo = null;
         if(this.mDungeonsScrollContainer != null)
         {
            _loc1_ = FSCardSlotInfo(this.mDungeonsScrollContainer.getChildAt(0));
            if(_loc1_ != null)
            {
               this.mDungeonsScrollContainer.width = _loc1_.width;
               this.mDungeonsScrollContainer.validate();
               this.mDungeonsScrollContainer.x = -((this.mDungeonsScrollContainer.width - this.mRightPanelImage.width) / 2);
            }
         }
      }
      
      public function addCardSlotInfo(param1:String, param2:int, param3:Number, param4:int = 0) : void
      {
         FSDebug.debugTrace("ADD CARD SLOT INFO: INDEX -> " + param4);
         var _loc5_:FSCardSlotInfo = this.getSlotByCardSku(param1);
         if(_loc5_ == null)
         {
            this.addCardInfoToCatalog(param1,param2);
            _loc5_ = InstanceMng.getResourcesMng().createCardSlotInfoItem(param1,param2,null,this.mDungeonsScrollContainer);
            if(!Utils.isLowPerformanceDevice() && param4 < 10)
            {
               _loc5_.alpha = 0.001;
               _loc5_.touchable = false;
            }
            if(this.mDungeonsScrollContainer != null)
            {
               this.mDungeonsScrollContainer.addChild(_loc5_);
            }
            this.mDungeonsScrollContainer.validate();
            if(!Utils.isLowPerformanceDevice() && param4 < 10)
            {
               TweenMax.delayedCall(param3,SpecialFX.tweenToAlpha,[_loc5_,0.999,param3,0,this.setCardSlotTouchable,[_loc5_]]);
            }
         }
         else
         {
            this.mDeckCardsLoaded[param1] += param2;
            _loc5_.addCardAmount(param2);
            _loc5_.updateAmountTextfield();
         }
      }
      
      private function setCardSlotTouchable(param1:FSCardSlotInfo) : void
      {
         if(param1)
         {
            param1.setTouchable();
         }
      }
      
      private function addCardInfoToCatalog(param1:String, param2:int) : void
      {
         if(this.mDeckCardsLoaded == null)
         {
            this.mDeckCardsLoaded = new Dictionary(true);
         }
         if(this.mDeckCardsLoaded[param1] == null)
         {
            this.mDeckCardsLoaded[param1] = param2;
         }
         else
         {
            this.mDeckCardsLoaded[param1] += param2;
         }
      }
      
      public function getSlotByCardSku(param1:String) : FSCardSlotInfo
      {
         var _loc2_:FSCardSlotInfo = null;
         var _loc3_:FSCardSlotInfo = null;
         var _loc4_:int = 0;
         if(this.mDungeonsScrollContainer != null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.mDungeonsScrollContainer.numChildren)
            {
               _loc3_ = FSCardSlotInfo(this.mDungeonsScrollContainer.getChildAt(_loc4_));
               if(_loc3_ != null)
               {
                  if(_loc3_.getCardDef().getSku() == param1)
                  {
                     return _loc3_;
                  }
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      override public function removeTranslucentBG(param1:Boolean = false, param2:Boolean = false) : void
      {
         super.removeTranslucentBG(param1,param2);
         if(Boolean(mSelectedCard) && !param2)
         {
            SpecialFX.zoomOut(mSelectedCard);
            mSelectedCard = null;
         }
      }
      
      public function isDungeonPayed() : Boolean
      {
         return this.mDungeonPayed;
      }
      
      public function getSelectedDungeonDef() : DungeonDef
      {
         return this.mSelectedDungeonDef;
      }
      
      public function getSelectedDifficulty() : int
      {
         return this.mCurrentDifficultySelected;
      }
      
      private function onDungeonsInfoReceived(param1:Object, param2:Boolean = false) : void
      {
         showLoadingIcon(false,false);
         Utils.removeLog();
         var _loc3_:int = int(Config.smServerConfig["dungeons_season"]);
         var _loc4_:int = InstanceMng.getUserDataMng().getOwnerUserData().getDungeonsSeason();
         if(_loc4_ < _loc3_)
         {
            InstanceMng.getPopupMng().openNewSeasonPopup(_loc3_,false,true);
         }
         else if(param2 == true)
         {
            if(!this.mServerResponseReceived)
            {
               this.mServerResponseReceived = true;
               onConnectionChange();
               this.payAndProceedWithDungeon();
            }
         }
      }
      
      public function getSeasonEndTime() : String
      {
         return this.mSeasonEndTextfield.text;
      }
      
      override public function addLights(param1:Boolean = false, param2:Boolean = false) : void
      {
         super.addLights(false,true);
      }
   }
}

