package com.fs.tcgengine.view.popups.guilds
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.GuildsMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.guilds.Guild;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.buttons.FSMenuButton;
   import com.fs.tcgengine.view.components.buttons.FSTextToggleButton;
   import com.fs.tcgengine.view.components.misc.FSTextInput;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.misc.FSTextfieldTwoColors;
   import com.fs.tcgengine.view.guilds.GuildEmblem;
   import com.fs.tcgengine.view.guilds.GuildEmblemBrowser;
   import com.fs.tcgengine.view.guilds.GuildMemberSlot;
   import com.fs.tcgengine.view.guilds.GuildRankingSlot;
   import com.fs.tcgengine.view.guilds.GuildRequestSlot;
   import com.fs.tcgengine.view.guilds.GuildScoreBatch;
   import com.fs.tcgengine.view.guilds.GuildSlot;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.FSVisualCounter;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.gamesparks.api.types.Player;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.controls.ScrollText;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalLayout;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import mx.utils.StringUtil;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.text.TextFormat;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class PopupGuilds extends PopupStandard
   {
      
      public static const BG_NAME:String = "popup_large";
      
      public static const JOIN_SECTION:int = 0;
      
      public static const CREATE_SECTION:int = 1;
      
      public static const TOP_RANKING_SECTION:int = 2;
      
      public static const WEEKLY_RANKING_SECTION:int = 3;
      
      public static const INFO_SECTION:int = 4;
      
      public static const REWARDS_SECTION:int = 5;
      
      public static const MANAGE_SECTION:int = 6;
      
      private var mCurrentSectionIndex:int;
      
      private var mTopContainer:Component;
      
      private var mJoinGuildTab:FSMenuButton;
      
      private var mCreateGuildTab:FSMenuButton;
      
      private var mTopRankingTab:FSMenuButton;
      
      private var mWeeklyRankingTab:FSMenuButton;
      
      private var mGuildInfoTab:FSMenuButton;
      
      private var mRewardsTab:FSMenuButton;
      
      private var mJoinContainer:Component;
      
      private var mJoinSearchBG:FSImage;
      
      private var mJoinTextfield:FSTextfield;
      
      private var mJoinSearchTextfield:FSTextInput;
      
      private var mJoinSearchButton:FSButton;
      
      private var mJoinRefreshButton:FSButton;
      
      private var mGuilds:Vector.<Guild>;
      
      private var mGuildSlots:Vector.<GuildSlot>;
      
      private var mJoinGuildScrollContainer:ScrollContainer;
      
      private var mCreateGuildContainer:Component;
      
      private var mCreateGuildBG:FSImage;
      
      private var mCreateGuildChooseNameTextfield:FSTextfield;
      
      private var mCreateGuildChooseNameTextInput:FSTextInput;
      
      private var mCreateGuildChooseEmblemTextfield:FSTextfield;
      
      private var mCreateGuildEmblemPreview:GuildEmblem;
      
      private var mCreateGuildButton:FSButton;
      
      private var mCreateGuildAccessByInvitationCheckBox:FSTextToggleButton;
      
      private var mCreateGuildChooseEmblemFGTextfield:FSTextfield;
      
      private var mCreateGuildChooseEmblemBGTextfield:FSTextfield;
      
      private var mCreateGuildEmblemFGBrowser:GuildEmblemBrowser;
      
      private var mCreateGuildEmblemBGBrowser:GuildEmblemBrowser;
      
      private var mGuildInfoContainer:Component;
      
      private var mGuildInfoTopBG:FSImage;
      
      private var mGuildInfoEmblem:GuildEmblem;
      
      private var mGuildInfoNameTextfield:FSTextfield;
      
      private var mGuildInfoMembersTextfield:FSTextfield;
      
      private var mGuildInfoAccessTypeTextfield:FSTextfield;
      
      private var mGuildInfoTopScore:GuildScoreBatch;
      
      private var mGuildInfoWeeklyScore:GuildScoreBatch;
      
      private var mGuildInfoExtraInfoTextfield:FSTextfield;
      
      private var mGuildInfoManageButton:FSButton;
      
      private var mGuildInfoRequestsCounter:FSVisualCounter;
      
      private var mGuildInfoBackButton:FSButton;
      
      private var mGuildInfoMembersVector:Vector.<UserData>;
      
      private var mGuildInfoMembersSlotsVector:Vector.<GuildMemberSlot>;
      
      private var mGuildInfoMembersSlotsContainer:ScrollContainer;
      
      private var mGuildRewardsContainer:Component;
      
      private var mGuildRewardsTopBG:FSImage;
      
      private var mGuildRewardsLeftImage:FSImage;
      
      private var mGuildRewardsInfoButton:FSButton;
      
      private var mGuildRewardsTitleTextfield:FSTextfield;
      
      private var mGuildRewardsSubtitleTextfield:FSTextfield;
      
      private var mGuildRewardsContainerTitleTextfield:ScrollText;
      
      private var mGuildRewardsInfoTextfield:FSTextfield;
      
      private var mGuildRewardsInfoImage:FSImage;
      
      private var mGuildRewardsEditButton:FSButton;
      
      private var mGuildRewardsDescTextInput:FSTextInput;
      
      private var mTopRankingContainer:Component;
      
      private var mTopRankingTopBG:FSImage;
      
      private var mTopRankingLeftImage:FSImage;
      
      private var mTopRankingTitleTextfield:FSTextfield;
      
      private var mTopRankingGuildEventPanel:CustomComponent;
      
      private var mTopRankingTopPvPGuildTextfield:FSTextfieldTwoColors;
      
      private var mTopRankingTopDungeonGuildTextfield:FSTextfieldTwoColors;
      
      private var mTopRankingTopWeeklyScoreTextfield:FSTextfieldTwoColors;
      
      private var mTopRankingTopContributorPlayerTextfield:FSTextfieldTwoColors;
      
      private var mTopRankingGuildsVector:Vector.<Guild>;
      
      private var mTopRankingGuildsSlotsVector:Vector.<GuildSlot>;
      
      private var mTopRankingGuildsSlotsContainer:ScrollContainer;
      
      private var mWeeklyRankingContainer:Component;
      
      private var mWeeklyRankingTopBG:FSImage;
      
      private var mWeeklyRankingLeftImage:FSImage;
      
      private var mWeeklyRankingTitleTextfield:FSTextfield;
      
      private var mWeeklyRankingSubtitleTextfield:FSTextfield;
      
      private var mWeeklyRankingGuildEventPanel:CustomComponent;
      
      private var mWeeklyRankingEventStartingTextfield:FSTextfieldTwoColors;
      
      private var mWeeklyRankingEventStartingDescTextfield:FSTextfield;
      
      private var mWeeklyRankingGuildsVector:Vector.<Guild>;
      
      private var mWeeklyRankingGuildsSlotsVector:Vector.<GuildSlot>;
      
      private var mWeeklyRankingGuildsSlotsContainer:ScrollContainer;
      
      private var mManageContainer:Component;
      
      private var mManageTopBG:FSImage;
      
      private var mManageEmblem:GuildEmblem;
      
      private var mManageNameTextfield:FSTextfield;
      
      private var mManageMembersTextfield:FSTextfield;
      
      private var mManageAccessTypeTextfield:FSTextfield;
      
      private var mManageTopScore:GuildScoreBatch;
      
      private var mManageWeeklyScore:GuildScoreBatch;
      
      private var mManageMemberInfoTextfield:FSTextfield;
      
      private var mManageBackButton:FSButton;
      
      private var mManageAccessByInvitationCheckBox:FSTextToggleButton;
      
      private var mManageEmblemFGBrowser:GuildEmblemBrowser;
      
      private var mManageEmblemBGBrowser:GuildEmblemBrowser;
      
      private var mManageEmblemPayButton:FSButton;
      
      private var mManageRequestsTextfield:FSTextfield;
      
      private var mManageRequestsContainer:ScrollContainer;
      
      private var mManageNoRequestsFoundTextfield:FSTextfield;
      
      private var mManageRequestsVector:Vector.<Object>;
      
      private var mManageLeaveGuildTextfield:FSTextfield;
      
      private var mManageLeaveGuildButton:FSButton;
      
      private var mSelectedGuild:Guild;
      
      private var mRefreshTimer:uint;
      
      public function PopupGuilds(param1:Boolean = true)
      {
         var _loc2_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().hasGuild();
         this.mCurrentSectionIndex = _loc2_ ? INFO_SECTION : JOIN_SECTION;
         super(param1);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      override public function setMainFieldText(param1:String = "") : void
      {
      }
      
      override protected function createFields() : void
      {
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = BG_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,1969);
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.createFields();
         this.init();
      }
      
      private function init() : void
      {
         this.createTopSection();
         this.createTabsSection();
      }
      
      public function refreshGuildInfo(param1:String) : void
      {
         if(param1 != "")
         {
            if(this.mGuildInfoMembersSlotsContainer)
            {
               this.mGuildInfoMembersSlotsContainer.removeChildren();
               this.mGuildInfoMembersSlotsContainer = null;
            }
            if(this.mGuildInfoMembersVector)
            {
               this.mGuildInfoMembersVector.length = 0;
               this.mGuildInfoMembersVector = null;
            }
            if(this.mGuildInfoMembersSlotsVector)
            {
               this.mGuildInfoMembersSlotsVector.length = 0;
               this.mGuildInfoMembersSlotsVector = null;
            }
            InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.CENTER,Align.CENTER,1,null,this);
            InstanceMng.getServerConnection().getGuildInfo(param1,this.onGuildInfoReceived,this.onGuildInfoFailed);
         }
      }
      
      private function onGuildInfoReceived(param1:*) : void
      {
         this.mSelectedGuild = param1;
         this.updateSelectedSection(INFO_SECTION);
         this.onGuildMembersInfoReceived(this.mSelectedGuild.getMembersUserDataVector());
      }
      
      private function onGuildMembersInfoReceived(param1:Vector.<UserData>) : void
      {
         var _loc2_:GuildMemberSlot = null;
         var _loc3_:int = 0;
         var _loc4_:UserData = null;
         var _loc5_:Object = null;
         var _loc6_:Vector.<UserData> = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Guild = null;
         var _loc12_:Boolean = false;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         if(this.mSelectedGuild)
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
            this.mGuildInfoMembersVector = param1;
            if(this.mGuildInfoMembersSlotsContainer)
            {
               this.mGuildInfoMembersSlotsContainer.removeChildren();
            }
            if(this.mGuildInfoMembersVector != null)
            {
               _loc7_ = 0;
               _loc8_ = 0;
               _loc9_ = 0;
               _loc10_ = 0;
               _loc3_ = 0;
               while(_loc3_ < this.mGuildInfoMembersVector.length)
               {
                  if(_loc6_ == null)
                  {
                     _loc6_ = new Vector.<UserData>();
                  }
                  _loc4_ = this.mGuildInfoMembersVector[_loc3_];
                  _loc5_ = this.mSelectedGuild.getActiveMemberDataByMemberId(_loc4_.getGuildMemberId());
                  _loc13_ = (Boolean(_loc5_)) && Boolean(_loc5_ is Player) && Player(_loc5_).getOnline() ? ServerConnection.smServerTimeMS : 0;
                  _loc13_ = _loc13_ > _loc4_.getCurrentDateMS() ? _loc13_ : _loc4_.getCurrentDateMS();
                  _loc4_.setCurrentDateMS(_loc13_);
                  _loc6_.push(_loc4_);
                  _loc3_++;
               }
               _loc6_.sort(DictionaryUtils.sortGuildMembersWeeklyScore);
               _loc11_ = InstanceMng.getGuildsMng().getMyGuild();
               _loc12_ = Boolean(this.mSelectedGuild) && Boolean(_loc11_) && _loc11_.getId() == this.mSelectedGuild.getId();
               _loc3_ = 0;
               while(_loc3_ < _loc6_.length)
               {
                  _loc4_ = _loc6_[_loc3_];
                  _loc2_ = new GuildMemberSlot(_loc4_);
                  _loc14_ = _loc4_.getGuildRank() == -1 ? GuildsMng.RANK_UNCONFIRMED : _loc4_.getGuildRank();
                  this.mSelectedGuild.updateMemberRank(_loc4_.getAccountId(),_loc14_);
                  if(this.mGuildInfoMembersSlotsVector == null)
                  {
                     this.mGuildInfoMembersSlotsVector = new Vector.<GuildMemberSlot>();
                  }
                  this.mGuildInfoMembersSlotsVector.push(_loc2_);
                  this.addGuildMemberSlotToContainer(_loc2_);
                  _loc3_++;
               }
            }
            InstanceMng.getServerConnection().getGuildPositionByGuildId(this.mSelectedGuild.getId(),this.onGuildPositionACK);
         }
      }
      
      private function onGuildPositionACK(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1)
         {
            if(param1.hasOwnProperty("G") && Boolean(this.mGuildInfoTopScore))
            {
               _loc2_ = param1["G"] != -1 ? param1["G"].toString() : "100+";
               this.mGuildInfoTopScore.updateScore(_loc2_);
            }
            if(param1.hasOwnProperty("W") && Boolean(this.mGuildInfoWeeklyScore))
            {
               _loc2_ = param1["W"] != -1 ? param1["W"].toString() : "100+";
               this.mGuildInfoWeeklyScore.updateScore(_loc2_);
            }
         }
      }
      
      private function addGuildMemberSlotToContainer(param1:GuildMemberSlot) : void
      {
         var _loc2_:VerticalLayout = null;
         if(Boolean(this.mGuildInfoMembersSlotsContainer == null) && Boolean(mBox) && Boolean(this.mGuildInfoTopBG))
         {
            this.mGuildInfoMembersSlotsContainer = new ScrollContainer();
            this.mGuildInfoMembersSlotsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            _loc2_ = new VerticalLayout();
            _loc2_.paddingBottom = param1.height * 1.35;
            _loc2_.horizontalAlign = HorizontalAlign.CENTER;
            this.mGuildInfoMembersSlotsContainer.layout = _loc2_;
            this.mGuildInfoMembersSlotsContainer.x = this.mGuildInfoTopBG.x;
            this.mGuildInfoMembersSlotsContainer.y = this.mGuildInfoTopBG.y + this.mGuildInfoTopBG.height * 1.035;
            this.mGuildInfoMembersSlotsContainer.setSize(param1.width,mBox.height * 0.92 - this.mGuildInfoTopBG.height);
            this.mGuildInfoMembersSlotsContainer.x = mBox.x + (mBox.width - this.mGuildInfoMembersSlotsContainer.width) / 2;
            this.mGuildInfoMembersSlotsContainer.addEventListener(TouchEvent.TOUCH,this.onGuildInfoContainerTouched);
            this.mGuildInfoContainer.addChild(this.mGuildInfoMembersSlotsContainer);
         }
         if(this.mGuildInfoMembersSlotsContainer)
         {
            param1.addParentScrollContainer(this.mGuildInfoMembersSlotsContainer);
            this.mGuildInfoMembersSlotsContainer.addChild(param1);
         }
      }
      
      private function onGuildInfoContainerTouched(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.BEGAN) : null;
         if(_loc2_)
         {
            this.hideAllMemberRankOptions();
         }
      }
      
      private function hideAllMemberRankOptions() : void
      {
         var _loc1_:int = 0;
         if(this.mGuildInfoMembersSlotsContainer)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mGuildInfoMembersSlotsContainer.numChildren)
            {
               if(GuildMemberSlot(this.mGuildInfoMembersSlotsContainer.getChildAt(_loc1_)) != null)
               {
                  GuildMemberSlot(this.mGuildInfoMembersSlotsContainer.getChildAt(_loc1_)).hideMemberRankOptions();
               }
               _loc1_++;
            }
         }
      }
      
      public function getGuildMembersScrollContainer() : ScrollContainer
      {
         return this.mGuildInfoMembersSlotsContainer;
      }
      
      private function onGuildInfoFailed() : void
      {
         if(this.mGuildInfoBackButton)
         {
            this.mGuildInfoBackButton.enabled = true;
         }
         Utils.setLogText(TextManager.getText("TID_GUILD_RETRIEVE_ERROR"),true);
      }
      
      private function createTopSection() : void
      {
         if(this.mTopContainer == null)
         {
            this.mTopContainer = new Component();
         }
         this.mTopContainer.x = mBox.x;
         this.mTopContainer.y = mBox.y - this.mTopContainer.height;
         addChild(this.mTopContainer);
      }
      
      override protected function performOpeningTransition(param1:FSCoordinate = null) : void
      {
         if(this.mTopContainer)
         {
            y += this.mTopContainer.height / 1.5;
         }
         super.performOpeningTransition(param1);
      }
      
      public function onGuildCreatedPerformOps(param1:Guild) : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         this.mSelectedGuild = param1;
         SpecialFX.tweenToAlpha(this.mJoinGuildTab,0.001,0.5,0,this.removeTabButtonFromParent,[this.mJoinGuildTab]);
         SpecialFX.tweenToAlpha(this.mCreateGuildTab,0.001,0.5,0,this.removeTabButtonFromParent,[this.mCreateGuildTab]);
         this.createInfoAndRewardsTabs();
         SpecialFX.tweenToAlpha(this.mGuildInfoTab,0.999,0.2,0);
         SpecialFX.tweenToAlpha(this.mRewardsTab,0.999,0.5,0);
         this.updateSelectedSection(INFO_SECTION);
         this.refreshGuildInfo(param1.getId());
      }
      
      private function removeTabButtonFromParent(param1:FSMenuButton) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      public function onGuildJoinedPerformOps() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         SpecialFX.tweenToAlpha(this.mJoinGuildTab,0.001,0.5,0,this.removeTabButtonFromParent,[this.mJoinGuildTab]);
         SpecialFX.tweenToAlpha(this.mCreateGuildTab,0.001,0.5,0,this.removeTabButtonFromParent,[this.mCreateGuildTab]);
         this.createInfoAndRewardsTabs();
         SpecialFX.tweenToAlpha(this.mGuildInfoTab,0.999,0.2,0);
         SpecialFX.tweenToAlpha(this.mRewardsTab,0.999,0.5,0);
         this.mSelectedGuild = null;
         this.updateSelectedSection(INFO_SECTION);
      }
      
      private function createCreateGuildAndJoinGuildTabs() : void
      {
         var _loc1_:FSCoordinate = null;
         if(this.mJoinGuildTab == null)
         {
            this.mJoinGuildTab = new FSMenuButton("guild_button_options_up",TextManager.getText("TID_GEN_JOIN"),this.onJoinGuildTabTriggered,"guild_join_icon");
            _loc1_ = Utils.getXYPositionInContainer(0,this.mJoinGuildTab.width,this.mJoinGuildTab.height,mBox.width,this.mJoinGuildTab.height,4,1,true);
            this.mJoinGuildTab.x = this.mJoinGuildTab.width / 2 + _loc1_.getX();
            this.mJoinGuildTab.y = this.mJoinGuildTab.height / 2 + _loc1_.getY();
            this.mJoinGuildTab.alpha = 0.001;
            this.mTopContainer.addChild(this.mJoinGuildTab);
         }
         else
         {
            this.mTopContainer.addChild(this.mJoinGuildTab);
            this.mJoinGuildTab.alpha = 0.999;
            this.mJoinGuildTab.visible = true;
         }
         if(this.mCreateGuildTab == null)
         {
            this.mCreateGuildTab = new FSMenuButton("guild_button_options_up",TextManager.getText("TID_GEN_CREATE"),this.onCreateGuildTriggered,"guild_create_icon");
            _loc1_ = Utils.getXYPositionInContainer(1,this.mCreateGuildTab.width,this.mCreateGuildTab.height,mBox.width,this.mCreateGuildTab.height,4,1,true);
            this.mCreateGuildTab.x = this.mCreateGuildTab.width / 2 + _loc1_.getX();
            this.mCreateGuildTab.y = this.mCreateGuildTab.height / 2 + _loc1_.getY();
            this.mCreateGuildTab.alpha = 0.001;
            this.mTopContainer.addChild(this.mCreateGuildTab);
         }
         else
         {
            this.mTopContainer.addChild(this.mCreateGuildTab);
            this.mCreateGuildTab.alpha = 0.999;
            this.mCreateGuildTab.visible = true;
         }
      }
      
      private function createInfoAndRewardsTabs() : void
      {
         var _loc1_:FSCoordinate = null;
         if(this.mGuildInfoTab == null)
         {
            this.mGuildInfoTab = new FSMenuButton("guild_button_options_up",TextManager.getText("TID_GUILD_NAME_SINGLE"),this.onMyGuildTabTriggered,"guild_icon");
            _loc1_ = Utils.getXYPositionInContainer(0,this.mGuildInfoTab.width,this.mGuildInfoTab.height,mBox.width,this.mGuildInfoTab.height,4,1,true);
            this.mGuildInfoTab.x = this.mGuildInfoTab.width / 2 + _loc1_.getX();
            this.mGuildInfoTab.y = this.mGuildInfoTab.height / 2 + _loc1_.getY();
            this.mGuildInfoTab.alpha = 0.001;
            this.mTopContainer.addChild(this.mGuildInfoTab);
         }
         else
         {
            this.mTopContainer.addChild(this.mGuildInfoTab);
            this.mGuildInfoTab.alpha = 0.999;
            this.mGuildInfoTab.visible = true;
         }
         if(this.mRewardsTab == null)
         {
            this.mRewardsTab = new FSMenuButton("guild_button_options_up",TextManager.getText("TID_GUILD_DESC_INFO"),this.onRewardsGuildTabTriggered,"guild_reward_icon");
            _loc1_ = Utils.getXYPositionInContainer(1,this.mRewardsTab.width,this.mRewardsTab.height,mBox.width,this.mRewardsTab.height,4,1,true);
            this.mRewardsTab.x = this.mRewardsTab.width / 2 + _loc1_.getX();
            this.mRewardsTab.y = this.mRewardsTab.height / 2 + _loc1_.getY();
            this.mRewardsTab.alpha = 0.001;
            this.mTopContainer.addChild(this.mRewardsTab);
         }
         else
         {
            this.mTopContainer.addChild(this.mRewardsTab);
            this.mRewardsTab.alpha = 0.999;
            this.mRewardsTab.visible = true;
         }
      }
      
      private function createTabsSection() : void
      {
         var _loc1_:FSCoordinate = null;
         var _loc2_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().hasGuild();
         if(!_loc2_)
         {
            this.createCreateGuildAndJoinGuildTabs();
         }
         else
         {
            this.createInfoAndRewardsTabs();
         }
         if(this.mTopRankingTab == null)
         {
            this.mTopRankingTab = new FSMenuButton("guild_button_options_up",TextManager.getText("TID_GUILD_TOP_RANKING"),this.onTopRankingTabTriggered,"guild_ranking_top_icon");
            _loc1_ = Utils.getXYPositionInContainer(2,this.mTopRankingTab.width,this.mTopRankingTab.height,mBox.width,this.mTopRankingTab.height,4,1,true);
            this.mTopRankingTab.x = this.mTopRankingTab.width / 2 + _loc1_.getX();
            this.mTopRankingTab.y = this.mTopRankingTab.height / 2 + _loc1_.getY();
            this.mTopRankingTab.alpha = 0.001;
            this.mTopContainer.addChild(this.mTopRankingTab);
         }
         if(this.mWeeklyRankingTab == null)
         {
            this.mWeeklyRankingTab = new FSMenuButton("guild_button_options_up",TextManager.getText("TID_GUILD_WEEKLY_RANKING"),this.onWeeklyRankingTabTriggered,"guild_ranking_weekly_icon");
            _loc1_ = Utils.getXYPositionInContainer(3,this.mWeeklyRankingTab.width,this.mWeeklyRankingTab.height,mBox.width,this.mWeeklyRankingTab.height,4,1,true);
            this.mWeeklyRankingTab.x = this.mWeeklyRankingTab.width / 2 + _loc1_.getX();
            this.mWeeklyRankingTab.y = this.mWeeklyRankingTab.height / 2 + _loc1_.getY();
            this.mWeeklyRankingTab.alpha = 0.001;
            this.mTopContainer.addChild(this.mWeeklyRankingTab);
         }
         this.mTopContainer.y = -this.mTopContainer.height;
      }
      
      private function onMyGuildTabTriggered() : void
      {
         this.mSelectedGuild = null;
         if(this.mManageBackButton)
         {
            this.mManageBackButton.disableTemporarily();
         }
         this.refreshGuildInfo(InstanceMng.getUserDataMng().getOwnerUserData().getGuildId());
      }
      
      private function onRewardsGuildTabTriggered() : void
      {
         this.updateSelectedSection(REWARDS_SECTION);
      }
      
      private function onJoinGuildTabTriggered() : void
      {
         this.updateSelectedSection(JOIN_SECTION);
      }
      
      private function onCreateGuildTriggered() : void
      {
         this.updateSelectedSection(CREATE_SECTION);
      }
      
      private function onTopRankingTabTriggered() : void
      {
         this.updateSelectedSection(TOP_RANKING_SECTION);
      }
      
      private function onWeeklyRankingTabTriggered() : void
      {
         this.updateSelectedSection(WEEKLY_RANKING_SECTION);
      }
      
      private function createGuildInfoSection() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Function = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         if(!InstanceMng.getServerConnection().isUserLoggedIn() || InstanceMng.getServerConnection().getBackendUserProfile() == null || InstanceMng.getUserDataMng() == null || mBox == null)
         {
            return;
         }
         if(this.mGuildInfoContainer == null)
         {
            this.mGuildInfoContainer = new Component();
         }
         if(this.mSelectedGuild)
         {
            _loc1_ = this.mSelectedGuild.hasPrivilegesForManaging();
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getGuildId() == this.mSelectedGuild.getId();
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().hasGuild();
            if(this.mGuildInfoTopBG == null)
            {
               this.mGuildInfoTopBG = new FSImage(Root.assets.getTexture("guild_layer_large"));
               this.mGuildInfoTopBG.x = (mBox.width - this.mGuildInfoTopBG.width) / 2;
               this.mGuildInfoTopBG.y = 10;
               this.mGuildInfoTopBG.addEventListener(TouchEvent.TOUCH,this.onGuildInfoContainerTouched);
               this.mGuildInfoContainer.addChild(this.mGuildInfoTopBG);
            }
            if(this.mGuildInfoEmblem == null)
            {
               this.mGuildInfoEmblem = new GuildEmblem(this.mSelectedGuild.getEmblemBG(),this.mSelectedGuild.getEmblemFG());
               this.mGuildInfoEmblem.x = this.mGuildInfoTopBG.x + this.mGuildInfoTopBG.width * 0.02;
               this.mGuildInfoEmblem.y = this.mGuildInfoTopBG.y + (this.mGuildInfoTopBG.height - this.mGuildInfoEmblem.height) / 2;
               this.mGuildInfoContainer.addChild(this.mGuildInfoEmblem);
            }
            else
            {
               this.mGuildInfoEmblem.changeBGTexture(Root.assets.getTexture(this.mSelectedGuild.getEmblemBG()));
               this.mGuildInfoEmblem.changeFGTexture(Root.assets.getTexture(this.mSelectedGuild.getEmblemFG()));
            }
            if(this.mGuildInfoNameTextfield == null)
            {
               this.mGuildInfoNameTextfield = new FSTextfield(this.mGuildInfoTopBG.width / 3,this.mGuildInfoTopBG.height / 3,this.mSelectedGuild.getName(),16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
               this.mGuildInfoNameTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
               if(FSResourceMng.isOriental(this.mSelectedGuild.getName()))
               {
                  this.mGuildInfoNameTextfield.color = 65280;
               }
               this.mGuildInfoNameTextfield.format.horizontalAlign = Align.LEFT;
               this.mGuildInfoNameTextfield.x = this.mGuildInfoEmblem.x + this.mGuildInfoEmblem.width * 1.1;
               this.mGuildInfoNameTextfield.y = this.mGuildInfoTopBG.y + 3.25;
               this.mGuildInfoContainer.addChild(this.mGuildInfoNameTextfield);
            }
            else
            {
               this.mGuildInfoNameTextfield.text = this.mSelectedGuild.getName();
               this.mGuildInfoNameTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
            }
            if(this.mGuildInfoMembersTextfield == null)
            {
               this.mGuildInfoMembersTextfield = new FSTextfield(this.mGuildInfoNameTextfield.width,this.mGuildInfoNameTextfield.height * 0.9,TextManager.getText("TID_GUILD_MEMBERS") + " " + this.mSelectedGuild.getMembersAmount() + "/" + GuildsMng.smMaxMembers,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mGuildInfoMembersTextfield.format.horizontalAlign = Align.LEFT;
               this.mGuildInfoMembersTextfield.x = this.mGuildInfoNameTextfield.x;
               this.mGuildInfoMembersTextfield.y = this.mGuildInfoNameTextfield.y + this.mGuildInfoNameTextfield.height;
               this.mGuildInfoContainer.addChild(this.mGuildInfoMembersTextfield);
            }
            else
            {
               this.mGuildInfoMembersTextfield.text = TextManager.getText("TID_GUILD_MEMBERS") + " " + this.mSelectedGuild.getMembersAmount() + "/" + GuildsMng.smMaxMembers;
            }
            _loc4_ = this.mSelectedGuild.getAccessType() == GuildsMng.GUILD_ACCESS_ANYONE_CAN_JOIN ? TextManager.getText("TID_GUILD_ACCESS_ANYONE") : TextManager.getText("TID_GUILD_VIA_REQUEST");
            if(this.mGuildInfoAccessTypeTextfield == null)
            {
               this.mGuildInfoAccessTypeTextfield = new FSTextfield(this.mGuildInfoMembersTextfield.width,this.mGuildInfoMembersTextfield.height,_loc4_,16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
               this.mGuildInfoAccessTypeTextfield.format.horizontalAlign = Align.LEFT;
               this.mGuildInfoAccessTypeTextfield.x = this.mGuildInfoNameTextfield.x;
               this.mGuildInfoAccessTypeTextfield.y = this.mGuildInfoMembersTextfield.y + this.mGuildInfoMembersTextfield.height;
               this.mGuildInfoContainer.addChild(this.mGuildInfoAccessTypeTextfield);
            }
            else
            {
               this.mGuildInfoAccessTypeTextfield.text = _loc4_;
            }
            if(this.mGuildInfoTopScore == null)
            {
               this.mGuildInfoTopScore = new GuildScoreBatch("guild_rank_plate",-1);
               this.mGuildInfoTopScore.x = this.mGuildInfoNameTextfield.x + this.mGuildInfoNameTextfield.width * 1.05;
               this.mGuildInfoTopScore.y = this.mGuildInfoNameTextfield.y + this.mGuildInfoTopScore.height * 0.1;
               this.mGuildInfoContainer.addChild(this.mGuildInfoTopScore);
            }
            else
            {
               this.mGuildInfoTopScore.updateScore("???");
            }
            if(this.mGuildInfoWeeklyScore == null)
            {
               this.mGuildInfoWeeklyScore = new GuildScoreBatch("guild_weekly_rank_plate",-1);
               this.mGuildInfoWeeklyScore.x = this.mGuildInfoTopScore.x;
               this.mGuildInfoWeeklyScore.y = this.mGuildInfoTopScore.y + this.mGuildInfoTopScore.height * 1.1;
               this.mGuildInfoContainer.addChild(this.mGuildInfoWeeklyScore);
            }
            else
            {
               this.mGuildInfoWeeklyScore.updateScore("???");
            }
            _loc4_ = this.getExtraGuildInfoText(_loc2_);
            _loc4_ = _loc4_ != null ? _loc4_ : "";
            if(this.mGuildInfoExtraInfoTextfield == null)
            {
               _loc10_ = this.mGuildInfoTopBG.width - (this.mGuildInfoTopScore.x + this.mGuildInfoTopScore.width * 1.05) - mCloseButton.width * 0.25;
               this.mGuildInfoExtraInfoTextfield = new FSTextfield(_loc10_,this.mGuildInfoNameTextfield.height,_loc4_,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mGuildInfoExtraInfoTextfield.x = this.mGuildInfoTopScore.x + this.mGuildInfoTopScore.width * 1.05;
               this.mGuildInfoExtraInfoTextfield.y = this.mGuildInfoTopScore.y;
               this.mGuildInfoContainer.addChild(this.mGuildInfoExtraInfoTextfield);
            }
            else
            {
               this.mGuildInfoExtraInfoTextfield.text = _loc4_;
            }
            if(this.mGuildInfoBackButton == null)
            {
               this.mGuildInfoBackButton = new FSButton(Root.assets.getTexture("guild_button_back"));
               this.mGuildInfoBackButton.x = this.mGuildInfoExtraInfoTextfield.x + this.mGuildInfoBackButton.width / 2;
               this.mGuildInfoBackButton.y = this.mGuildInfoTopBG.y + this.mGuildInfoTopBG.height - this.mGuildInfoBackButton.height / 1.5;
               this.mGuildInfoBackButton.addEventListener(Event.TRIGGERED,this.onBackGuildInfoButton);
               this.mGuildInfoBackButton.enabled = !_loc2_;
               this.mGuildInfoContainer.addChild(this.mGuildInfoBackButton);
            }
            else
            {
               this.mGuildInfoBackButton.enabled = !_loc2_;
            }
            _loc8_ = false;
            if(_loc2_)
            {
               _loc5_ = this.mSelectedGuild.hasPrivilegesForManaging() ? "button_join" : "button_leave";
               _loc6_ = this.mSelectedGuild.hasPrivilegesForManaging() ? this.onGuildManageButtonTriggered : this.onGuildLeaveButtonTriggered;
               _loc7_ = this.mSelectedGuild.hasPrivilegesForManaging() ? TextManager.getText("TID_GEN_MANAGE") : TextManager.getText("TID_GEN_LEAVE");
               if(_loc1_)
               {
                  InstanceMng.getServerConnection().getGuildRequestsCount(this.mSelectedGuild.getId(),this.onGuildsRequestCountACK);
               }
            }
            else
            {
               _loc8_ = InstanceMng.getGuildsMng().hasPlayerAlreadySentRequest(this.mSelectedGuild.getId());
               if(_loc8_)
               {
                  _loc5_ = "button_join";
                  _loc6_ = null;
                  _loc7_ = TextManager.getText("TID_GEN_WAITING");
               }
               else
               {
                  _loc5_ = "button_join";
                  _loc6_ = this.onJoinGuildButtonTriggered;
                  _loc7_ = this.mSelectedGuild.getAccessType() == GuildsMng.GUILD_ACCESS_ANYONE_CAN_JOIN ? TextManager.getText("TID_GEN_JOIN") : TextManager.getText("TID_GEN_REQUEST");
               }
            }
            _loc9_ = !_loc3_ && this.mSelectedGuild.getMembersAmount() < GuildsMng.smMaxMembers || _loc3_ && this.mSelectedGuild.getId() == InstanceMng.getUserDataMng().getOwnerUserData().getGuildId();
            if(this.mGuildInfoManageButton == null)
            {
               this.mGuildInfoManageButton = new FSButton(Root.assets.getTexture(_loc5_),_loc7_);
               Utils.setupButton9Scale(this.mGuildInfoManageButton,7.5,15,5,5,90.25,33.75);
               this.mGuildInfoManageButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
               this.mGuildInfoManageButton.x = this.mGuildInfoBackButton.x + this.mGuildInfoBackButton.width + this.mGuildInfoManageButton.width / 1.85;
               this.mGuildInfoManageButton.y = this.mGuildInfoBackButton.y;
               if(_loc6_ != null)
               {
                  this.mGuildInfoManageButton.addEventListener(Event.TRIGGERED,_loc6_);
               }
               this.mGuildInfoManageButton.enabled = !_loc8_ && _loc9_;
               this.mGuildInfoContainer.addChild(this.mGuildInfoManageButton);
            }
            else
            {
               this.mGuildInfoManageButton.removeEventListeners(Event.TRIGGERED);
               this.mGuildInfoManageButton.upState = Root.assets.getTexture(_loc5_);
               if(_loc6_ != null)
               {
                  this.mGuildInfoManageButton.addEventListener(Event.TRIGGERED,_loc6_);
               }
               this.mGuildInfoManageButton.text = _loc7_;
               this.mGuildInfoManageButton.enabled = !_loc8_ && _loc9_;
            }
         }
         if(this.mSelectedGuild == null)
         {
            this.refreshGuildInfo(InstanceMng.getUserDataMng().getOwnerUserData().getGuildId());
         }
         else
         {
            addChild(this.mGuildInfoContainer);
            this.mGuildInfoContainer.alpha = 0.001;
            SpecialFX.tweenToAlpha(this.mGuildInfoContainer,0.99,0.5,0);
         }
      }
      
      private function onGuildsRequestCountACK(param1:Number) : void
      {
         if(!isNaN(param1))
         {
            if(this.mGuildInfoManageButton)
            {
               if(this.mGuildInfoRequestsCounter == null && param1 > 0)
               {
                  this.mGuildInfoRequestsCounter = new FSVisualCounter(param1.toString(),16711680);
                  this.mGuildInfoRequestsCounter.x = this.mGuildInfoManageButton.x + this.mGuildInfoManageButton.width / 2;
                  this.mGuildInfoRequestsCounter.y = this.mGuildInfoManageButton.y - this.mGuildInfoManageButton.height / 2.25;
                  this.mGuildInfoContainer.addChild(this.mGuildInfoRequestsCounter);
               }
               else if(param1 > 0)
               {
                  this.mGuildInfoContainer.addChild(this.mGuildInfoRequestsCounter);
                  this.mGuildInfoRequestsCounter.updateText(param1.toString());
               }
               else if(this.mGuildInfoRequestsCounter)
               {
                  this.mGuildInfoRequestsCounter.removeFromParent();
               }
            }
         }
      }
      
      private function getExtraGuildInfoText(param1:Boolean) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         if(param1)
         {
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getGuildRank();
            _loc2_ = InstanceMng.getGuildsMng().getMemberTitleByRankId(_loc3_);
         }
         else
         {
            _loc4_ = this.mSelectedGuild.getLastActivityDateMS();
            _loc5_ = _loc4_ != -1 ? TimerUtil.msToDays(ServerConnection.smServerTimeMS - _loc4_) : -1;
            if(_loc5_ >= 1)
            {
               _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_GUILD_LAST_ACTIVITY"),[_loc5_]);
            }
            else if(_loc5_ != -1)
            {
               _loc2_ = TextManager.getText("TID_GUILD_LAST_ACTIVITY_TODAY");
            }
            else
            {
               _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_GUILD_LAST_ACTIVITY"),["???"]);
            }
         }
         return _loc2_;
      }
      
      private function onJoinGuildButtonTriggered(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(!InstanceMng.getUserDataMng().getOwnerUserData().isInBlackList())
         {
            if(!InstanceMng.getUserDataMng().getOwnerUserData().isInDuplicatedList())
            {
               if(this.mSelectedGuild)
               {
                  if(this.mGuildInfoManageButton)
                  {
                     this.mGuildInfoManageButton.enabled = false;
                  }
                  if(this.mGuildInfoBackButton)
                  {
                     this.mGuildInfoBackButton.enabled = false;
                  }
                  _loc2_ = this.mSelectedGuild.getAccessType();
                  switch(_loc2_)
                  {
                     case GuildsMng.GUILD_ACCESS_ANYONE_CAN_JOIN:
                        InstanceMng.getServerConnection().getGuildInfo(this.mSelectedGuild.getId(),this.onJoinGuildInfoReceived,this.onGuildInfoFailed);
                        break;
                     case GuildsMng.GUILD_ACCESS_VIA_REQUEST:
                        InstanceMng.getServerConnection().joinGuild(this.mSelectedGuild.getId(),this.onGuildRequestCreated,this.onGuildRequestFailed,true);
                  }
               }
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
      
      private function onGuildRequestCreated(param1:Object) : void
      {
         if(param1)
         {
            Utils.setLogText(TextManager.getText("TID_GUILD_REQUEST_SENT"));
            InstanceMng.getGuildsMng().addPlayerGuildRequestSent(param1.guildId);
            if(this.mGuildInfoManageButton)
            {
               this.mGuildInfoManageButton.text = TextManager.getText("TID_GEN_WAITING");
               this.mGuildInfoManageButton.removeEventListeners(Event.TRIGGERED);
            }
            if(this.mGuildInfoBackButton)
            {
               this.mGuildInfoBackButton.enabled = true;
            }
         }
      }
      
      private function onGuildRequestFailed() : void
      {
         this.onGuildInfoFailed();
         if(this.mGuildInfoManageButton)
         {
            this.mGuildInfoManageButton.enabled = true;
         }
         if(this.mGuildInfoBackButton)
         {
            this.mGuildInfoBackButton.enabled = true;
         }
      }
      
      private function onJoinGuildInfoReceived(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         if(param1)
         {
            this.mSelectedGuild = Guild(param1);
            _loc2_ = !InstanceMng.getUserDataMng().getOwnerUserData().hasGuild() && Boolean(InstanceMng.getServerConnection().getBackendUserProfile()) && !this.mSelectedGuild.existsMemberByAccountId(InstanceMng.getServerConnection().getUserId());
            if(_loc2_ && this.mSelectedGuild.getMembersAmount() < GuildsMng.smMaxMembers)
            {
               InstanceMng.getGuildsMng().joinGuild(this.mSelectedGuild.getId());
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_GUILD_FULL"),true);
            }
         }
      }
      
      private function onBackGuildInfoButton(param1:Event) : void
      {
         this.mSelectedGuild = null;
         var _loc2_:UserData = Utils.getOwnerUserData();
         var _loc3_:Boolean = _loc2_.hasGuild();
         var _loc4_:int = _loc3_ ? INFO_SECTION : JOIN_SECTION;
         if(_loc3_)
         {
            this.refreshGuildInfo(_loc2_.getGuildId());
         }
         else
         {
            this.updateSelectedSection(_loc4_);
         }
      }
      
      private function onGuildLeaveButtonTriggered() : void
      {
         this.hideAllMemberRankOptions();
         this.mGuildInfoManageButton.enabled = false;
         InstanceMng.getPopupMng().getPopupShown().hideTemporarily(InstanceMng.getPopupMng().openConfirmationPopup,[TextManager.getText("TID_GUILD_LEAVE_CONFIRMATION"),this.performMemberGuildLeaving,this.onMemberGuildLeaveCancel]);
      }
      
      private function performMemberGuildLeaving() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.CENTER,Align.CENTER,1,null,this);
         InstanceMng.getGuildsMng().leaveGuild();
      }
      
      private function onMemberGuildLeaveCancel() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false,Align.CENTER,Align.CENTER,1,null,this);
         if(this.mGuildInfoManageButton)
         {
            this.mGuildInfoManageButton.enabled = true;
         }
         InstanceMng.getPopupMng().closePopupShown();
      }
      
      private function onGuildManageButtonTriggered() : void
      {
         this.hideAllMemberRankOptions();
         this.updateSelectedSection(MANAGE_SECTION);
      }
      
      private function createManageSection() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         if(Boolean(mBox) && Boolean(this.mSelectedGuild))
         {
            if(this.mManageContainer == null)
            {
               this.mManageContainer = new Component();
            }
            if(this.mManageTopBG == null)
            {
               this.mManageTopBG = new FSImage(Root.assets.getTexture("guild_layer_large"));
               this.mManageTopBG.x = (mBox.width - this.mManageTopBG.width) / 2;
               this.mManageTopBG.y = 10;
               this.mManageContainer.addChild(this.mManageTopBG);
            }
            if(this.mManageEmblem == null)
            {
               this.mManageEmblem = new GuildEmblem(this.mSelectedGuild.getEmblemBG(),this.mSelectedGuild.getEmblemFG());
               this.mManageEmblem.x = this.mManageTopBG.x + this.mManageTopBG.width * 0.02;
               this.mManageEmblem.y = this.mManageTopBG.y + (this.mManageTopBG.height - this.mManageEmblem.height) / 2;
               this.mManageContainer.addChild(this.mManageEmblem);
            }
            else
            {
               this.mManageEmblem.changeBGTexture(Root.assets.getTexture(this.mSelectedGuild.getEmblemBG()));
               this.mManageEmblem.changeFGTexture(Root.assets.getTexture(this.mSelectedGuild.getEmblemFG()));
            }
            if(this.mManageNameTextfield == null)
            {
               this.mManageNameTextfield = new FSTextfield(this.mManageTopBG.width / 3,this.mManageTopBG.height / 3,this.mSelectedGuild.getName(),16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
               this.mManageNameTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
               this.mManageNameTextfield.format.horizontalAlign = Align.LEFT;
               this.mManageNameTextfield.x = this.mManageEmblem.x + this.mManageEmblem.width * 1.1;
               this.mManageNameTextfield.y = this.mManageTopBG.y + 5;
               this.mManageContainer.addChild(this.mManageNameTextfield);
            }
            else
            {
               this.mManageNameTextfield.text = this.mSelectedGuild.getName();
            }
            if(this.mManageMembersTextfield == null)
            {
               this.mManageMembersTextfield = new FSTextfield(this.mManageNameTextfield.width,this.mManageNameTextfield.height * 0.9,TextManager.getText("TID_GUILD_MEMBERS") + " " + this.mSelectedGuild.getMembersAmount() + "/" + GuildsMng.smMaxMembers,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mManageMembersTextfield.format.horizontalAlign = Align.LEFT;
               this.mManageMembersTextfield.x = this.mManageNameTextfield.x;
               this.mManageMembersTextfield.y = this.mManageNameTextfield.y + this.mManageNameTextfield.height;
               this.mManageContainer.addChild(this.mManageMembersTextfield);
            }
            else
            {
               this.mManageMembersTextfield.text = TextManager.getText("TID_GUILD_MEMBERS") + " " + this.mSelectedGuild.getMembersAmount() + "/" + GuildsMng.smMaxMembers;
            }
            if(this.mManageAccessTypeTextfield == null)
            {
               _loc4_ = this.mSelectedGuild.getAccessType() == GuildsMng.GUILD_ACCESS_ANYONE_CAN_JOIN ? TextManager.getText("TID_GUILD_ACCESS_ANYONE") : TextManager.getText("TID_GUILD_VIA_REQUEST");
               this.mManageAccessTypeTextfield = new FSTextfield(this.mManageMembersTextfield.width,this.mManageMembersTextfield.height,_loc4_,16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
               this.mManageAccessTypeTextfield.format.horizontalAlign = Align.LEFT;
               this.mManageAccessTypeTextfield.x = this.mManageNameTextfield.x;
               this.mManageAccessTypeTextfield.y = this.mManageMembersTextfield.y + this.mManageMembersTextfield.height;
               this.mManageContainer.addChild(this.mManageAccessTypeTextfield);
            }
            else
            {
               this.mManageAccessTypeTextfield.text = this.mSelectedGuild.getAccessType() == GuildsMng.GUILD_ACCESS_ANYONE_CAN_JOIN ? TextManager.getText("TID_GUILD_ACCESS_ANYONE") : TextManager.getText("TID_GUILD_VIA_REQUEST");
            }
            if(this.mManageTopScore == null)
            {
               this.mManageTopScore = new GuildScoreBatch("guild_points_plate_large",this.mSelectedGuild.getGlobalTotalScore());
               this.mManageTopScore.x = this.mManageNameTextfield.x + this.mManageNameTextfield.width * 1.05;
               this.mManageTopScore.y = this.mManageNameTextfield.y + this.mManageTopScore.height * 0.1;
               this.mManageContainer.addChild(this.mManageTopScore);
            }
            else
            {
               this.mManageTopScore.updateScore(this.mSelectedGuild.getGlobalTotalScore().toString());
            }
            if(this.mManageWeeklyScore == null)
            {
               this.mManageWeeklyScore = new GuildScoreBatch("guild_weekly_points_plate_large",this.mSelectedGuild.getWeeklyTotalScore());
               this.mManageWeeklyScore.x = this.mManageTopScore.x;
               this.mManageWeeklyScore.y = this.mManageTopScore.y + this.mManageTopScore.height * 1.1;
               this.mManageContainer.addChild(this.mManageWeeklyScore);
            }
            else
            {
               this.mManageWeeklyScore.updateScore(this.mSelectedGuild.getWeeklyTotalScore().toString());
            }
            if(this.mManageMemberInfoTextfield == null)
            {
               _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getGuildRank();
               _loc6_ = InstanceMng.getGuildsMng().getMemberTitleByRankId(_loc5_);
               this.mManageMemberInfoTextfield = new FSTextfield(this.mGuildInfoNameTextfield.width / 1.8,this.mGuildInfoNameTextfield.height,_loc6_,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mManageMemberInfoTextfield.x = this.mManageTopScore.x + this.mManageTopScore.width * 1.05;
               this.mManageMemberInfoTextfield.y = this.mManageTopScore.y;
               this.mManageContainer.addChild(this.mManageMemberInfoTextfield);
            }
            else
            {
               this.mManageMemberInfoTextfield.text = InstanceMng.getGuildsMng().getMemberTitleByRankId(InstanceMng.getUserDataMng().getOwnerUserData().getGuildRank());
            }
            if(this.mManageBackButton == null)
            {
               this.mManageBackButton = new FSButton(Root.assets.getTexture("button_join"),TextManager.getText("TID_GEN_BACK"));
               Utils.setupButton9Scale(this.mManageBackButton,7.5,15,5,5,90.25,33.75);
               this.mManageBackButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
               this.mManageBackButton.x = this.mManageMemberInfoTextfield.x + this.mManageBackButton.width / 2;
               this.mManageBackButton.y = this.mManageTopBG.y + this.mManageTopBG.height - this.mManageBackButton.height / 1.5;
               this.mManageBackButton.addEventListener(Event.TRIGGERED,this.onMyGuildTabTriggered);
               this.mManageContainer.addChild(this.mManageBackButton);
            }
            if(this.mManageAccessByInvitationCheckBox == null)
            {
               this.mManageAccessByInvitationCheckBox = new FSTextToggleButton(TextManager.getText("TID_GUILD_VIA_REQUEST"),false);
               this.mManageAccessByInvitationCheckBox.setTextfieldWidth(mBox.width / 3);
               this.mManageAccessByInvitationCheckBox.x = this.mManageTopBG.x + 15;
               this.mManageAccessByInvitationCheckBox.y = this.mManageTopBG.y + this.mManageTopBG.height * 1.05;
               _loc1_ = this.mSelectedGuild.getAccessType() == GuildsMng.GUILD_ACCESS_VIA_REQUEST ? true : false;
               _loc2_ = !_loc1_;
               this.mManageAccessByInvitationCheckBox.setToggled(_loc1_,_loc2_);
               this.mManageAccessByInvitationCheckBox.setOnToggledFunction(this.onManageAccessToggled);
               this.mManageAccessByInvitationCheckBox.setOnUntoggledFunction(this.onManageAccessUntoggled);
               this.mManageContainer.addChild(this.mManageAccessByInvitationCheckBox);
            }
            else
            {
               _loc1_ = this.mSelectedGuild.getAccessType() == GuildsMng.GUILD_ACCESS_VIA_REQUEST ? true : false;
               _loc2_ = !_loc1_;
               this.mManageAccessByInvitationCheckBox.setToggled(_loc1_,_loc2_);
            }
            _loc3_ = 0;
            if(this.mManageEmblemFGBrowser == null)
            {
               _loc3_ = Root.assets.getTextures("guild_logo_") ? int(Root.assets.getTextures("guild_logo_").length) : 0;
               this.mManageEmblemFGBrowser = new GuildEmblemBrowser("guild_logo_","mini_square_socket_highlight","mini_square_socket",_loc3_);
               this.mManageEmblemFGBrowser.setOnEmblemSelectedTriggerFunction(this.onManageEmblemSelected);
               this.mManageEmblemFGBrowser.setComponentSize(mBox.width / 2.5,mBox.height / 5);
               this.mManageEmblemFGBrowser.selectItemByName(this.mSelectedGuild.getEmblemFG());
               this.mManageEmblemFGBrowser.x = this.mManageAccessByInvitationCheckBox.x + this.mManageAccessByInvitationCheckBox.width / 5;
               this.mManageEmblemFGBrowser.y = this.mManageAccessByInvitationCheckBox.y + this.mManageAccessByInvitationCheckBox.height * 1.05;
               this.mManageContainer.addChild(this.mManageEmblemFGBrowser);
            }
            else
            {
               this.mManageEmblemFGBrowser.selectItemByName(this.mSelectedGuild.getEmblemFG());
            }
            if(this.mManageEmblemBGBrowser == null)
            {
               _loc3_ = Root.assets.getTextures("guild_frame_") ? int(Root.assets.getTextures("guild_frame_").length) : 0;
               this.mManageEmblemBGBrowser = new GuildEmblemBrowser("guild_frame_","mini_square_socket_highlight","mini_square_socket",_loc3_);
               this.mManageEmblemBGBrowser.setOnEmblemSelectedTriggerFunction(this.onManageEmblemSelected);
               this.mManageEmblemBGBrowser.setComponentSize(mBox.width / 2.5,this.mManageEmblemFGBrowser.height);
               this.mManageEmblemBGBrowser.selectItemByName(this.mSelectedGuild.getEmblemBG());
               this.mManageEmblemBGBrowser.x = this.mManageEmblemFGBrowser.x;
               this.mManageEmblemBGBrowser.y = this.mManageEmblemFGBrowser.y + this.mManageEmblemFGBrowser.height;
               this.mManageContainer.addChild(this.mManageEmblemBGBrowser);
            }
            else
            {
               this.mManageEmblemBGBrowser.selectItemByName(this.mSelectedGuild.getEmblemBG());
            }
            if(this.mManageEmblemPayButton == null)
            {
               this.mManageEmblemPayButton = new FSButton(Root.assets.getTexture("choose_button"),GuildsMng.CHANGE_EMBLEM_GOLD_COST.toString());
               this.mManageEmblemPayButton.fontName = FSResourceMng.getFontByType();
               this.mManageEmblemPayButton.fontColor = 16777215;
               this.mManageEmblemPayButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
               this.mManageEmblemPayButton.x = this.mManageEmblemBGBrowser.x + this.mManageEmblemBGBrowser.width / 2 - this.mManageEmblemPayButton.width / 3;
               this.mManageEmblemPayButton.y = this.mManageEmblemBGBrowser.y + this.mManageEmblemBGBrowser.height * 1.05 + this.mManageEmblemPayButton.height / 2;
               this.mManageEmblemPayButton.addEventListener(Event.TRIGGERED,this.onManageEmblemPayButtonPressed);
               this.mManageContainer.addChild(this.mManageEmblemPayButton);
            }
            else
            {
               this.mManageEmblemPayButton.alpha = 0.999;
               this.mManageEmblemPayButton.enabled = true;
               this.mManageEmblemPayButton.visible = true;
               this.mManageContainer.addChild(this.mManageEmblemPayButton);
            }
            if(this.mManageRequestsTextfield == null)
            {
               this.mManageRequestsTextfield = new FSTextfield(mBox.width / 2.5,this.mManageAccessByInvitationCheckBox.height,TextManager.getText("TID_GUILD_MANAGE_INIVITATIONS"));
               this.mManageRequestsTextfield.x = mBox.width / 1.8;
               this.mManageRequestsTextfield.y = this.mManageAccessByInvitationCheckBox.y;
               this.mManageContainer.addChild(this.mManageRequestsTextfield);
            }
            if(this.mManageLeaveGuildTextfield == null)
            {
               this.mManageLeaveGuildTextfield = new FSTextfield(mBox.width / 4,this.mManageAccessByInvitationCheckBox.height * 1.5,TextManager.getText("TID_GUILD_LEAVE_CONFIRMATION"));
               this.mManageLeaveGuildTextfield.x = this.mManageRequestsTextfield.x - 20;
               this.mManageLeaveGuildTextfield.y = mBox.height - this.mManageLeaveGuildTextfield.height * 1.5;
               this.mManageContainer.addChild(this.mManageLeaveGuildTextfield);
            }
            if(this.mManageNoRequestsFoundTextfield == null)
            {
               this.mManageNoRequestsFoundTextfield = new FSTextfield(this.mManageRequestsTextfield.width,this.mManageRequestsTextfield.height,TextManager.getText("TID_GUILD_NO_REQUESTS"));
               this.mManageNoRequestsFoundTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
               this.mManageNoRequestsFoundTextfield.x = this.mManageRequestsTextfield.x;
               this.mManageNoRequestsFoundTextfield.y = this.mManageRequestsTextfield.y + this.mManageRequestsTextfield.height * 3.5;
               this.mManageContainer.addChild(this.mManageNoRequestsFoundTextfield);
            }
            if(this.mManageLeaveGuildButton == null)
            {
               this.mManageLeaveGuildButton = new FSButton(Root.assets.getTexture("button_leave"),TextManager.getText("TID_GEN_LEAVE"));
               Utils.setupButton9Scale(this.mManageLeaveGuildButton,7.5,15,5,5,90.25,33.75);
               this.mManageLeaveGuildButton.fontName = FSResourceMng.getFontByType();
               this.mManageLeaveGuildButton.fontColor = 16777215;
               this.mManageLeaveGuildButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
               this.mManageLeaveGuildButton.x = this.mManageLeaveGuildTextfield.x + this.mManageLeaveGuildTextfield.width + this.mManageLeaveGuildButton.width / 2;
               this.mManageLeaveGuildButton.y = this.mManageLeaveGuildTextfield.y + this.mManageLeaveGuildButton.height / 3;
               this.mManageLeaveGuildButton.addEventListener(Event.TRIGGERED,this.onManageLeaveGuildTriggered);
               this.mManageContainer.addChild(this.mManageLeaveGuildButton);
            }
            else
            {
               this.mManageLeaveGuildButton.enabled = true;
            }
            this.refreshGuildRequests();
            addChild(this.mManageContainer);
            this.mManageContainer.alpha = 0.001;
            SpecialFX.tweenToAlpha(this.mManageContainer,0.99,0.5,0);
         }
      }
      
      private function refreshGuildRequests() : void
      {
         if(this.mGuildInfoMembersSlotsContainer)
         {
            this.mGuildInfoMembersSlotsContainer.removeChildren();
         }
         if(this.mGuildInfoMembersVector)
         {
            this.mGuildInfoMembersVector.length = 0;
            this.mGuildInfoMembersVector = null;
         }
         if(this.mGuildInfoMembersSlotsVector)
         {
            this.mGuildInfoMembersSlotsVector.length = 0;
            this.mGuildInfoMembersSlotsVector = null;
         }
         if(this.mManageRequestsVector)
         {
            this.mManageRequestsVector.length = 0;
            this.mManageRequestsVector = null;
         }
         if(this.mManageRequestsContainer)
         {
            this.mManageRequestsContainer.removeChildren();
         }
         InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.CENTER,Align.CENTER,1,null,this);
         InstanceMng.getServerConnection().getGuildRequests(this.mSelectedGuild.getId(),this.onGuildRequestsInfoReceived,this.onGuildRequestsInfoFailed);
      }
      
      private function onGuildRequestsInfoReceived(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Guild = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<String> = null;
         var _loc6_:Vector.<UserData> = null;
         var _loc7_:Object = null;
         var _loc8_:UserData = null;
         if(Boolean(this.mManageNoRequestsFoundTextfield) && Boolean(param1 != null) && param1.length > 0)
         {
            this.mManageNoRequestsFoundTextfield.visible = false;
         }
         if(param1)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc2_ = param1[_loc4_];
               if(this.mManageRequestsVector == null)
               {
                  this.mManageRequestsVector = new Vector.<Object>();
               }
               if(_loc5_ == null)
               {
                  _loc5_ = new Vector.<String>();
               }
               _loc5_.push(_loc2_.playerId);
               this.mManageRequestsVector.push(_loc2_);
               _loc7_ = new Object();
               _loc7_.accountId = _loc2_.playerId;
               _loc7_.currentLevelSku = _loc2_.currentLevelSku;
               _loc7_.playerName = _loc2_.playerName;
               _loc7_.elo = _loc2_.elo;
               _loc8_ = InstanceMng.getServerConnection().getUserDataByUserProfile(_loc7_);
               if(_loc6_ == null)
               {
                  _loc6_ = new Vector.<UserData>();
               }
               _loc6_.push(_loc8_);
               _loc4_++;
            }
            if(param1.length == 0)
            {
               InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
            }
            if(_loc6_)
            {
               this.onUsersRequestsProfilesACK(_loc6_);
            }
         }
         else
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         }
      }
      
      private function onUsersRequestsProfilesACK(param1:Vector.<UserData>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:UserData = null;
         var _loc6_:GuildRequestSlot = null;
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         if(param1)
         {
            if(this.mManageRequestsVector)
            {
               _loc3_ = 0;
               while(_loc3_ < this.mManageRequestsVector.length)
               {
                  _loc4_ = this.mManageRequestsVector[_loc3_];
                  if(_loc4_)
                  {
                     _loc2_ = 0;
                     while(_loc2_ < param1.length)
                     {
                        _loc5_ = param1[_loc2_];
                        if((Boolean(_loc5_)) && _loc5_.getAccountId() == _loc4_.playerId)
                        {
                           if(_loc5_.hasGuild())
                           {
                              InstanceMng.getServerConnection().deleteGuildRequest(Utils.getDataId(_loc4_));
                              this.mManageRequestsVector.splice(_loc3_,1);
                           }
                           else
                           {
                              _loc6_ = new GuildRequestSlot(_loc5_,_loc4_);
                              this.addRequestSlotToContainer(_loc6_);
                           }
                        }
                        _loc2_++;
                     }
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      private function addRequestSlotToContainer(param1:GuildRequestSlot) : void
      {
         var _loc2_:VerticalLayout = null;
         if(Boolean(param1) && Boolean(this.mManageRequestsTextfield) && Boolean(mBox))
         {
            if(this.mManageRequestsContainer == null)
            {
               this.mManageRequestsContainer = new ScrollContainer();
               this.mManageRequestsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
               _loc2_ = new VerticalLayout();
               _loc2_.horizontalAlign = HorizontalAlign.CENTER;
               this.mManageRequestsContainer.layout = _loc2_;
               this.mManageRequestsContainer.y = this.mManageRequestsTextfield.y + this.mManageRequestsTextfield.height * 1.05;
               this.mManageRequestsContainer.setSize(param1.width,mBox.height / 2.1);
               this.mManageRequestsContainer.x = this.mManageRequestsTextfield.x + this.mManageRequestsTextfield.width - this.mManageRequestsContainer.width;
               this.mManageContainer.addChild(this.mManageRequestsContainer);
            }
            this.mManageRequestsContainer.addChild(param1);
         }
      }
      
      public function deleteRequestReceived(param1:GuildRequestSlot) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(param1)
         {
            if(this.mManageRequestsVector)
            {
               _loc3_ = param1.getRequestData();
               _loc2_ = 0;
               while(_loc2_ < this.mManageRequestsVector.length)
               {
                  if(this.mManageRequestsVector[_loc2_] == _loc3_)
                  {
                     this.mManageRequestsVector.splice(_loc2_,1);
                     return;
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      public function onGuildRequestSlotDeleted() : void
      {
         if(this.mManageRequestsContainer)
         {
            if(this.mManageRequestsContainer.numChildren == 0)
            {
               if(this.mManageNoRequestsFoundTextfield)
               {
                  this.mManageNoRequestsFoundTextfield.visible = true;
               }
            }
         }
      }
      
      private function onGuildRequestsInfoFailed() : void
      {
         if(this.mManageNoRequestsFoundTextfield)
         {
            this.mManageNoRequestsFoundTextfield.visible = true;
         }
      }
      
      private function onManageLeaveGuildTriggered() : void
      {
         this.mManageLeaveGuildButton.enabled = false;
         InstanceMng.getPopupMng().getPopupShown().hideTemporarily(InstanceMng.getPopupMng().openConfirmationPopup,[TextManager.getText("TID_GUILD_LEAVE_CONFIRMATION"),this.performGMGuildLeaving,this.onGMGuildLeaveCancel]);
      }
      
      private function performGMGuildLeaving() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.CENTER,Align.CENTER,1,null,this);
         InstanceMng.getGuildsMng().leaveGuild();
      }
      
      private function onGMGuildLeaveCancel() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false,Align.CENTER,Align.CENTER,1,null,this);
         if(this.mManageLeaveGuildButton)
         {
            this.mManageLeaveGuildButton.enabled = true;
         }
         InstanceMng.getPopupMng().closePopupShown();
      }
      
      private function onManageEmblemPayButtonPressed() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:GuildEmblem = null;
         var _loc4_:GuildEmblem = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:GoldDef = null;
         if(Boolean(this.mSelectedGuild) && this.mSelectedGuild.hasPrivilegesForManaging())
         {
            _loc1_ = GuildsMng.CHANGE_EMBLEM_GOLD_COST;
            if(this.mManageEmblemPayButton)
            {
               this.mManageEmblemPayButton.enabled = false;
            }
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getGold();
            if(_loc2_ >= _loc1_)
            {
               _loc3_ = this.mManageEmblemBGBrowser.getSelectedEmblem();
               _loc4_ = this.mManageEmblemFGBrowser.getSelectedEmblem();
               _loc5_ = _loc3_ ? _loc3_.getBGName() : "";
               _loc6_ = _loc4_ ? _loc4_.getBGName() : "";
               if(_loc5_ == "guild_frame_00" && _loc6_ == "guild_logo_00")
               {
                  Utils.setLogText(TextManager.getText("TID_GUILD_EMBLEM_EMPTY"));
                  if(this.mManageEmblemPayButton)
                  {
                     this.mManageEmblemPayButton.enabled = true;
                  }
               }
               else
               {
                  this.mSelectedGuild.setEmblemBG(_loc5_);
                  this.mSelectedGuild.setEmblemFG(_loc6_);
                  _loc7_ = this.mSelectedGuild.getId();
                  InstanceMng.getServerConnection().guildsEditInfo(_loc7_,_loc6_,_loc5_,this.mSelectedGuild.getAccessType(),"",InstanceMng.getGuildsMng().onGuildEmblemChanged,null,InstanceMng.getGuildsMng().onGuildEmblemChangedError);
               }
            }
            else
            {
               _loc8_ = GoldDef(InstanceMng.getGoldDefMng().getDefBySku("gold_01"));
               if(_loc8_)
               {
                  Utils.setLogText(TextManager.getText("TID_GOLD_NOT_ENOUGH"),true);
                  InstanceMng.getPopupMng().openBuyGoldBagPopup(_loc8_);
               }
            }
         }
         else
         {
            InstanceMng.getGuildsMng().notifyPlayerIsTemporaryOwner();
         }
      }
      
      public function onManageEmblemChanged() : void
      {
         if(this.mManageEmblemPayButton)
         {
            this.mManageEmblemPayButton.visible = false;
         }
      }
      
      public function onManageEmblemChangedFailed() : void
      {
         if(this.mManageEmblemPayButton)
         {
            this.mManageEmblemPayButton.enabled = true;
         }
      }
      
      private function onManageAccessToggled() : void
      {
         var _loc1_:String = null;
         if(this.mSelectedGuild)
         {
            if(this.mSelectedGuild.hasPrivilegesForManaging())
            {
               this.mSelectedGuild.setAccessType(GuildsMng.GUILD_ACCESS_VIA_REQUEST);
               _loc1_ = this.mSelectedGuild.getId();
               InstanceMng.getServerConnection().guildsEditInfo(_loc1_,"-1","-1",this.mSelectedGuild.getAccessType());
               this.updateManageAccessTypeTextfield();
            }
            else
            {
               InstanceMng.getGuildsMng().notifyPlayerIsTemporaryOwner();
            }
         }
      }
      
      private function onManageAccessUntoggled() : void
      {
         var _loc1_:String = null;
         if(this.mSelectedGuild)
         {
            if(this.mSelectedGuild.hasPrivilegesForManaging())
            {
               this.mSelectedGuild.setAccessType(GuildsMng.GUILD_ACCESS_ANYONE_CAN_JOIN);
               _loc1_ = this.mSelectedGuild.getId();
               InstanceMng.getServerConnection().guildsEditInfo(_loc1_,"-1","-1",this.mSelectedGuild.getAccessType());
               this.updateManageAccessTypeTextfield();
            }
            else
            {
               InstanceMng.getGuildsMng().notifyPlayerIsTemporaryOwner();
            }
         }
      }
      
      private function updateManageAccessTypeTextfield() : void
      {
         var _loc1_:String = null;
         if(this.mManageAccessTypeTextfield)
         {
            _loc1_ = this.mSelectedGuild.getAccessType() == GuildsMng.GUILD_ACCESS_ANYONE_CAN_JOIN ? TextManager.getText("TID_GUILD_ACCESS_ANYONE") : TextManager.getText("TID_GUILD_VIA_REQUEST");
            this.mManageAccessTypeTextfield.text = _loc1_;
         }
      }
      
      private function createRewardsSection() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Guild = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         if(mBox)
         {
            if(this.mGuildRewardsContainer == null)
            {
               this.mGuildRewardsContainer = new Component();
            }
            if(this.mGuildRewardsTopBG == null)
            {
               this.mGuildRewardsTopBG = new FSImage(Root.assets.getTexture("guild_layer_large"));
               this.mGuildRewardsTopBG.x = (mBox.width - this.mGuildRewardsTopBG.width) / 2;
               this.mGuildRewardsTopBG.y = 10;
               this.mGuildRewardsContainer.addChild(this.mGuildRewardsTopBG);
            }
            if(this.mGuildRewardsLeftImage == null)
            {
               this.mGuildRewardsLeftImage = new FSImage(Root.assets.getTexture("guild_reward_icon_large"));
               this.mGuildRewardsLeftImage.x = mBox.height * 0.05;
               this.mGuildRewardsLeftImage.y = (this.mGuildRewardsTopBG.height - this.mGuildRewardsLeftImage.height) / 2;
               this.mGuildRewardsLeftImage.x = this.mGuildRewardsTopBG.x + 10;
               this.mGuildRewardsLeftImage.y = this.mGuildRewardsTopBG.y + (this.mGuildRewardsTopBG.height - this.mGuildRewardsLeftImage.height) / 2;
               this.mGuildRewardsContainer.addChild(this.mGuildRewardsLeftImage);
            }
            if(this.mGuildRewardsInfoButton == null)
            {
               this.mGuildRewardsInfoButton = new FSButton(Root.assets.getTexture("guild_info_button"));
               this.mGuildRewardsInfoButton.scale = 0.5;
               this.mGuildRewardsInfoButton.x = this.mGuildRewardsTopBG.x;
               this.mGuildRewardsInfoButton.y = this.mGuildRewardsTopBG.y;
               this.mGuildRewardsInfoButton.scaleWhenDown = 1;
               this.mGuildRewardsInfoButton.enableScaleOnMouseOver(false);
               _loc7_ = TextManager.getText("TID_GUILD_REWARDS_INFO_1") + ", " + TextManager.getText("TID_GUILD_REWARDS_INFO_2") + ", " + TextManager.getText("TID_GUILD_REWARDS_INFO_3");
               this.mGuildRewardsInfoButton.setTooltipText(_loc7_);
               SpecialFX.createYoYoZoomTransition(this.mGuildRewardsInfoButton,1.15,1,-1);
               this.mGuildRewardsContainer.addChild(this.mGuildRewardsInfoButton);
            }
            if(this.mGuildRewardsTitleTextfield == null)
            {
               this.mGuildRewardsTitleTextfield = new FSTextfield(this.mGuildRewardsTopBG.width * 0.75,this.mGuildRewardsTopBG.height * 0.5,TextManager.getText("TID_GUILD_WEEKLY_REWARDS") + " & " + TextManager.getText("TID_GEN_MORE_INFO"));
               this.mGuildRewardsTitleTextfield.format.horizontalAlign = Align.LEFT;
               this.mGuildRewardsTitleTextfield.x = this.mGuildRewardsLeftImage.x + this.mGuildRewardsLeftImage.width * 1.05;
               this.mGuildRewardsTitleTextfield.y = this.mGuildRewardsTopBG.y + 5;
               this.mGuildRewardsContainer.addChild(this.mGuildRewardsTitleTextfield);
            }
            if(this.mGuildRewardsSubtitleTextfield == null)
            {
               _loc8_ = InstanceMng.getGuildsMng().getWeeklySeasonTimeLeft();
               _loc9_ = TextManager.getText("TID_GUILD_REWARDS_ASSIGNED") + " " + _loc8_;
               this.mGuildRewardsSubtitleTextfield = new FSTextfield(this.mGuildRewardsTitleTextfield.width * 0.7,this.mGuildRewardsTopBG.height * 0.325,_loc9_,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mGuildRewardsSubtitleTextfield.format.horizontalAlign = Align.LEFT;
               this.mGuildRewardsSubtitleTextfield.x = this.mGuildRewardsTitleTextfield.x;
               this.mGuildRewardsSubtitleTextfield.y = this.mGuildRewardsTitleTextfield.y + this.mGuildRewardsTitleTextfield.height;
               this.mGuildRewardsContainer.addChild(this.mGuildRewardsSubtitleTextfield);
            }
            _loc1_ = mBox.width / 2.45;
            _loc2_ = mBox.height / 1.45;
            _loc3_ = InstanceMng.getGuildsMng() ? InstanceMng.getGuildsMng().getMyGuild() : null;
            _loc4_ = Boolean(_loc3_) && Boolean(this.mSelectedGuild) && _loc3_.getId() == this.mSelectedGuild.getId();
            _loc5_ = this.getPlatoonPersonalInformationPreffix();
            _loc6_ = Boolean(_loc4_ && this.mSelectedGuild) && Boolean(this.mSelectedGuild.getDescription() != null) && this.mSelectedGuild.getDescription() != "" ? _loc5_ + this.mSelectedGuild.getDescription() : _loc5_;
            _loc6_ = _loc6_ ? _loc6_.toUpperCase() : _loc6_;
            if(this.mGuildRewardsContainerTitleTextfield == null)
            {
               _loc10_ = FSResourceMng.FONT_STD_DEFAULT_SIZE;
               this.mGuildRewardsContainerTitleTextfield = new ScrollText();
               this.mGuildRewardsContainerTitleTextfield.setSize(_loc1_,_loc2_);
               this.mGuildRewardsContainerTitleTextfield.text = _loc6_;
               this.mGuildRewardsContainerTitleTextfield.embedFonts = true;
               this.mGuildRewardsContainerTitleTextfield.fontStyles = new TextFormat();
               this.mGuildRewardsContainerTitleTextfield.fontStyles.font = Main.getGameFont().fontName;
               this.mGuildRewardsContainerTitleTextfield.fontStyles.size = _loc10_;
               this.mGuildRewardsContainerTitleTextfield.fontStyles.color = 16777215;
               this.mGuildRewardsContainerTitleTextfield.x = mBox.width * 0.64 - _loc1_ / 4;
               this.mGuildRewardsContainerTitleTextfield.y = this.mGuildRewardsTopBG.y + this.mGuildRewardsTopBG.height;
               this.mGuildRewardsContainer.addChild(this.mGuildRewardsContainerTitleTextfield);
            }
            else
            {
               this.mGuildRewardsContainerTitleTextfield.text = _loc6_;
            }
            if(Boolean(this.mGuildRewardsDescTextInput == null) && Boolean(this.mSelectedGuild) && this.mSelectedGuild.hasPrivilegesForManaging())
            {
               this.mGuildRewardsDescTextInput = new FSTextInput();
               this.mGuildRewardsDescTextInput.restrict = "^ªº·$%&/()=\'¡`+*[]{}´;<>|\"\\^#~€¬¨@\\\\";
               this.mGuildRewardsDescTextInput.maxChars = 1000;
               _loc11_ = mBox ? int(mBox.width) : Starling.current.stage.stageWidth;
               _loc12_ = mBox ? int(mBox.height) : Starling.current.stage.stageHeight;
               _loc13_ = mBox ? int(mBox.x) : 0;
               _loc14_ = _loc12_ / 2;
               if(Utils.isDesktop())
               {
                  _loc11_ = _loc1_;
                  _loc12_ = _loc2_;
                  _loc13_ = this.mGuildRewardsContainerTitleTextfield.x;
                  _loc14_ = this.mGuildRewardsContainerTitleTextfield.y;
               }
               this.mGuildRewardsDescTextInput.setSize(_loc11_,FSResourceMng.FONT_STD_TITLE_SIZE);
               this.mGuildRewardsDescTextInput.x = _loc13_ + (_loc11_ - this.mGuildRewardsDescTextInput.width) / 2;
               this.mGuildRewardsDescTextInput.y = _loc12_ / 2;
               this.mGuildRewardsDescTextInput.visible = false;
               this.mGuildRewardsDescTextInput.addEventListener(FeathersEventType.ENTER,this.descInputEnterHandler);
               if(!Utils.isMobile())
               {
                  this.mGuildRewardsDescTextInput.addEventListener(FeathersEventType.FOCUS_OUT,this.descInputFocusOutHandler);
               }
               this.mGuildRewardsContainer.addChild(this.mGuildRewardsDescTextInput);
            }
            if(this.mGuildRewardsEditButton == null)
            {
               if(Boolean(_loc3_ && this.mSelectedGuild) && Boolean(_loc3_.getId() == this.mSelectedGuild.getId()) && this.mSelectedGuild.hasPrivilegesForManaging())
               {
                  _loc15_ = Utils.isDesktop() ? TextManager.getText("TID_GUILD_DESC_INFO") + " (" + TextManager.getText("TID_GEN_EDIT") + ")" : TextManager.getText("TID_GUILD_DESC_INFO");
                  this.mGuildRewardsEditButton = new FSButton(Root.assets.getTexture("button_join"),_loc15_,null,false,null,null,1,1.04,-1,0.6);
                  Utils.setupButton9Scale(this.mGuildRewardsEditButton,7.5,15,5,5,90.25,33.75);
                  this.mGuildRewardsEditButton.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
                  this.mGuildRewardsEditButton.x = this.mGuildRewardsTopBG.x + this.mGuildRewardsTopBG.width * 0.985 - this.mGuildRewardsEditButton.width / 2;
                  this.mGuildRewardsEditButton.y = this.mGuildRewardsContainerTitleTextfield.y - this.mGuildRewardsEditButton.height / 1.7;
                  this.mGuildRewardsContainer.addChild(this.mGuildRewardsEditButton);
                  this.mGuildRewardsEditButton.addEventListener(Event.TRIGGERED,this.onEditDescTriggered);
               }
            }
            if(Boolean(this.mGuildRewardsEditButton) && Boolean(this.mSelectedGuild))
            {
               this.mGuildRewardsEditButton.visible = _loc4_ && this.mSelectedGuild.hasPrivilegesForManaging();
            }
            if(Boolean(this.mGuildRewardsInfoTextfield == null) && Boolean(this.mGuildRewardsTopBG) && Boolean(this.mGuildRewardsContainerTitleTextfield))
            {
               this.mGuildRewardsInfoTextfield = new FSTextfield(mBox.width / 2 - this.mGuildRewardsTopBG.x,this.mGuildRewardsTopBG.height * 0.5,TextManager.getText("TID_GUILD_SPECIAL_REWARDS"));
               this.mGuildRewardsInfoTextfield.format.horizontalAlign = Align.LEFT;
               this.mGuildRewardsInfoTextfield.x = this.mGuildRewardsTopBG.x + 15;
               this.mGuildRewardsInfoTextfield.y = this.mGuildRewardsContainerTitleTextfield.y;
               this.mGuildRewardsContainer.addChild(this.mGuildRewardsInfoTextfield);
            }
            if(this.mGuildRewardsInfoImage == null)
            {
               this.mGuildRewardsInfoImage = new FSImage(Root.assets.getTexture("special_reward_ranking"));
               this.mGuildRewardsInfoImage.x = this.mGuildRewardsInfoTextfield.x;
               this.mGuildRewardsInfoImage.y = this.mGuildRewardsInfoTextfield.y + this.mGuildRewardsInfoTextfield.height * 0.98;
               this.mGuildRewardsContainer.addChild(this.mGuildRewardsInfoImage);
            }
            addChild(this.mGuildRewardsContainer);
            this.mGuildRewardsContainer.alpha = 0.001;
            SpecialFX.tweenToAlpha(this.mGuildRewardsContainer,0.99,0.5,0);
         }
      }
      
      private function getPlatoonPersonalInformationPreffix() : String
      {
         return "";
      }
      
      private function onEditDescTriggered() : void
      {
         if(this.mGuildRewardsContainerTitleTextfield)
         {
            this.mGuildRewardsContainerTitleTextfield.visible = false;
         }
         if(this.mGuildRewardsDescTextInput)
         {
            this.mGuildRewardsDescTextInput.visible = true;
            this.mGuildRewardsDescTextInput.text = this.mGuildRewardsContainerTitleTextfield.text;
            this.mGuildRewardsContainer.addChild(this.mGuildRewardsDescTextInput);
         }
      }
      
      private function descInputEnterHandler(param1:Event) : void
      {
         this.onSaveTextInputData();
      }
      
      private function descInputFocusOutHandler(param1:Event) : void
      {
         this.onSaveTextInputData();
      }
      
      private function onSaveTextInputData() : void
      {
         var _loc1_:Guild = null;
         var _loc2_:String = null;
         if(this.mGuildRewardsDescTextInput != null)
         {
            if(this.mGuildRewardsContainerTitleTextfield != null)
            {
               this.mGuildRewardsDescTextInput.visible = false;
               this.mGuildRewardsContainerTitleTextfield.visible = true;
               InstanceMng.getServerConnection().guildsEditInfo(this.mSelectedGuild.getId(),"-1","-1",-1,this.mGuildRewardsDescTextInput.text.toUpperCase(),InstanceMng.getGuildsMng().onGuildDescChanged,null,InstanceMng.getGuildsMng().onDescChangeFailed);
               _loc1_ = InstanceMng.getGuildsMng().getMyGuild();
               if(this.mSelectedGuild != null && _loc1_ != null && this.mSelectedGuild.getId() == _loc1_.getId())
               {
                  this.mSelectedGuild.setDescription(this.mGuildRewardsDescTextInput.text.toUpperCase());
               }
               _loc2_ = this.getPlatoonPersonalInformationPreffix();
               this.mGuildRewardsContainerTitleTextfield.text = _loc2_ + this.mGuildRewardsDescTextInput.text.toUpperCase();
            }
         }
      }
      
      private function createJoinSection() : void
      {
         if(this.mJoinContainer == null && Boolean(mBox))
         {
            this.mJoinContainer = new Component();
            if(this.mJoinSearchBG == null)
            {
               this.mJoinSearchBG = new FSImage(Root.assets.getTexture("guild_layer_large"));
               this.mJoinSearchBG.x = (mBox.width - this.mJoinSearchBG.width) / 2;
               this.mJoinSearchBG.y = 10;
               this.mJoinContainer.addChild(this.mJoinSearchBG);
            }
            if(this.mJoinTextfield == null)
            {
               this.mJoinTextfield = new FSTextfield(this.mJoinSearchBG.width * 0.9,this.mJoinSearchBG.height / 3.15,TextManager.getText("TID_GUILD_SEARCH_GUILD"));
               this.mJoinTextfield.x = this.mJoinSearchBG.x + this.mJoinSearchBG.width * 0.04;
               this.mJoinTextfield.y = this.mJoinSearchBG.y + 10;
               this.mJoinTextfield.format.horizontalAlign = Align.LEFT;
               this.mJoinContainer.addChild(this.mJoinTextfield);
            }
            if(this.mJoinSearchTextfield == null)
            {
               this.mJoinSearchTextfield = new FSTextInput();
               this.mJoinSearchTextfield.setSize(this.mJoinSearchBG.width * 0.5,this.mJoinSearchBG.height / 2);
               this.mJoinSearchTextfield.x = this.mJoinSearchBG.x + this.mJoinSearchBG.width * 0.04;
               this.mJoinSearchTextfield.y = this.mJoinTextfield.y + this.mJoinTextfield.height;
               this.mJoinSearchTextfield.textEditorProperties.restrict = "^.,¿?ªº!·$%&/()=\'¡`+*[]{}´:;<>|\"\\^#~€¬¨@\\\\";
               this.mJoinSearchTextfield.maxChars = GuildsMng.smMaxGuildNameLength;
               this.mJoinSearchTextfield.addEventListener(FeathersEventType.ENTER,this.inputEnterHandler);
               this.mJoinContainer.addChild(this.mJoinSearchTextfield);
            }
            if(this.mJoinSearchButton == null)
            {
               this.mJoinSearchButton = new FSButton(Root.assets.getTexture("button_search"));
               this.mJoinSearchButton.x = this.mJoinSearchTextfield.x + this.mJoinSearchTextfield.width * 1.1;
               this.mJoinSearchButton.y = this.mJoinSearchTextfield.y + this.mJoinSearchTextfield.height / 2;
               this.mJoinSearchButton.addEventListener(Event.TRIGGERED,this.onJoinGuildSearchButtonTriggered);
               this.mJoinContainer.addChild(this.mJoinSearchButton);
            }
            if(this.mJoinRefreshButton == null)
            {
               this.mJoinRefreshButton = new FSButton(Root.assets.getTexture("button_refresh"));
               this.mJoinRefreshButton.x = this.mJoinSearchBG.x + this.mJoinSearchBG.width - this.mJoinRefreshButton.width * 1.2;
               this.mJoinRefreshButton.y = this.mJoinSearchButton.y;
               this.mJoinRefreshButton.addEventListener(Event.TRIGGERED,this.refreshJoinGuilds);
               this.mJoinContainer.addChild(this.mJoinRefreshButton);
            }
         }
         this.refreshJoinGuilds();
         if(this.mJoinContainer)
         {
            addChild(this.mJoinContainer);
            this.mJoinContainer.alpha = 0.001;
            SpecialFX.tweenToAlpha(this.mJoinContainer,0.99,0.5,0);
         }
      }
      
      private function inputEnterHandler(param1:Event) : void
      {
         this.onJoinGuildSearchButtonTriggered();
      }
      
      private function onJoinGuildSearchButtonTriggered() : void
      {
         if(this.mJoinGuildScrollContainer)
         {
            this.mJoinGuildScrollContainer.removeChildren();
         }
         if(this.mGuilds)
         {
            this.mGuilds.length = 0;
         }
         if(this.mGuildSlots)
         {
            this.mGuildSlots.length = 0;
         }
         if(this.mJoinSearchButton)
         {
            this.mJoinSearchButton.disableTemporarily();
         }
         InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.CENTER,Align.CENTER,1,null,this);
         InstanceMng.getServerConnection().getGuilds(this.onGuildsInfoReceived,this.onJoinGuildsInfoFailed,"",false,this.mJoinSearchTextfield.text,false);
      }
      
      private function refreshJoinGuilds() : void
      {
         if(this.mJoinGuildScrollContainer)
         {
            this.mJoinGuildScrollContainer.removeChildren();
         }
         if(this.mGuilds)
         {
            this.mGuilds.length = 0;
         }
         if(this.mGuildSlots)
         {
            this.mGuildSlots.length = 0;
         }
         if(this.mJoinRefreshButton)
         {
            this.mJoinRefreshButton.disableTemporarily();
         }
         InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.CENTER,Align.CENTER,1,null,this);
         InstanceMng.getServerConnection().getJoinableGuilds(this.onGuildsInfoReceived,null,this.onJoinGuildsInfoFailed);
      }
      
      private function onGuildsInfoReceived(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         if(param1)
         {
            _loc4_ = 25;
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if(_loc2_ < _loc4_)
               {
                  _loc3_ = param1[_loc2_];
                  _loc3_.name = _loc3_.guildName;
                  _loc3_._id.$oid = _loc3_.guildId;
                  this.addGuildInVector(_loc3_);
               }
               _loc2_++;
            }
            this.processJoinGuildsReceived();
         }
      }
      
      private function processJoinGuildsReceived() : void
      {
         var _loc1_:int = 0;
         var _loc2_:GuildSlot = null;
         if(this.mGuilds)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mGuilds.length)
            {
               if(this.mGuildSlots == null)
               {
                  this.mGuildSlots = new Vector.<GuildSlot>();
               }
               _loc2_ = new GuildSlot(this.mGuilds[_loc1_]);
               this.mGuildSlots.push(_loc2_);
               this.addGuildSlotToContainer(_loc2_);
               _loc1_++;
            }
         }
      }
      
      private function onJoinGuildsInfoFailed() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
      }
      
      private function addGuildSlotToContainer(param1:GuildSlot) : void
      {
         var _loc2_:VerticalLayout = null;
         if(Boolean(this.mJoinSearchBG) && Boolean(mBox))
         {
            if(this.mJoinGuildScrollContainer == null)
            {
               this.mJoinGuildScrollContainer = new ScrollContainer();
               this.mJoinGuildScrollContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
               _loc2_ = new VerticalLayout();
               _loc2_.horizontalAlign = HorizontalAlign.CENTER;
               this.mJoinGuildScrollContainer.layout = _loc2_;
               this.mJoinGuildScrollContainer.x = this.mJoinSearchBG.x;
               this.mJoinGuildScrollContainer.y = this.mJoinSearchBG.y + this.mJoinSearchBG.height * 1.035;
               this.mJoinGuildScrollContainer.setSize(param1.width,mBox.height * 0.92 - this.mJoinSearchBG.height);
               this.mJoinContainer.addChild(this.mJoinGuildScrollContainer);
            }
            this.mJoinGuildScrollContainer.x = mBox.x + (mBox.width - this.mJoinGuildScrollContainer.width) / 2;
            param1.addParentScrollContainer(this.mJoinGuildScrollContainer);
            this.mJoinGuildScrollContainer.addChild(param1);
         }
      }
      
      private function addGuildInVector(param1:Object) : void
      {
         if(this.mGuilds == null)
         {
            this.mGuilds = new Vector.<Guild>();
         }
         var _loc2_:Guild = InstanceMng.getGuildsMng().createGuildByServerInfo(param1);
         this.mGuilds.push(_loc2_);
      }
      
      private function createCreateGuildSection() : void
      {
         var _loc1_:int = 0;
         if(mBox)
         {
            if(this.mCreateGuildContainer == null)
            {
               this.mCreateGuildContainer = new Component();
               if(this.mCreateGuildChooseNameTextfield == null)
               {
                  this.mCreateGuildChooseNameTextfield = new FSTextfield(mBox.width / 3,mBox.height * 0.1,TextManager.getText("TID_GUILD_CHOOSE_NAME"));
                  this.mCreateGuildChooseNameTextfield.format.horizontalAlign = Align.LEFT;
                  this.mCreateGuildChooseNameTextfield.x = mBox.height * 0.05;
                  this.mCreateGuildChooseNameTextfield.y = 22;
                  this.mCreateGuildContainer.addChild(this.mCreateGuildChooseNameTextfield);
               }
               if(this.mCreateGuildChooseNameTextInput == null)
               {
                  this.mCreateGuildChooseNameTextInput = new FSTextInput();
                  this.mCreateGuildChooseNameTextInput.textEditorProperties.restrict = "^.,¿?ªº!·$%&/()=\'¡`+*[]{}´:;<>|\"\\^#~€¬¨@\\\\";
                  this.mCreateGuildChooseNameTextInput.maxChars = GuildsMng.smMaxGuildNameLength;
                  this.mCreateGuildChooseNameTextInput.setSize(this.mCreateGuildChooseNameTextfield.width,this.mCreateGuildChooseNameTextfield.height * 1.15);
                  this.mCreateGuildChooseNameTextInput.x = this.mCreateGuildChooseNameTextfield.x;
                  this.mCreateGuildChooseNameTextInput.y = this.mCreateGuildChooseNameTextfield.y + this.mCreateGuildChooseNameTextfield.height;
                  this.mCreateGuildContainer.addChild(this.mCreateGuildChooseNameTextInput);
               }
               if(this.mCreateGuildAccessByInvitationCheckBox == null)
               {
                  this.mCreateGuildAccessByInvitationCheckBox = new FSTextToggleButton(TextManager.getText("TID_GUILD_VIA_REQUEST"),false);
                  this.mCreateGuildAccessByInvitationCheckBox.setTextfieldWidth(this.mCreateGuildChooseNameTextfield.width * 0.85);
                  this.mCreateGuildAccessByInvitationCheckBox.x = this.mCreateGuildChooseNameTextInput.x;
                  this.mCreateGuildAccessByInvitationCheckBox.y = this.mCreateGuildChooseNameTextInput.y + this.mCreateGuildChooseNameTextInput.height * 1.25;
                  this.mCreateGuildAccessByInvitationCheckBox.setToggled(false,true);
                  this.mCreateGuildContainer.addChild(this.mCreateGuildAccessByInvitationCheckBox);
               }
               if(this.mCreateGuildChooseEmblemTextfield == null)
               {
                  this.mCreateGuildChooseEmblemTextfield = new FSTextfield(this.mCreateGuildChooseNameTextfield.width,this.mCreateGuildChooseNameTextfield.height,TextManager.getText("TID_GUILD_CHOOSE_EMBLEM"));
                  this.mCreateGuildChooseEmblemTextfield.format.horizontalAlign = Align.LEFT;
                  this.mCreateGuildChooseEmblemTextfield.x = this.mCreateGuildAccessByInvitationCheckBox.x;
                  this.mCreateGuildChooseEmblemTextfield.y = this.mCreateGuildAccessByInvitationCheckBox.y + this.mCreateGuildAccessByInvitationCheckBox.height * 1.7;
                  this.mCreateGuildContainer.addChild(this.mCreateGuildChooseEmblemTextfield);
               }
               if(this.mCreateGuildEmblemPreview == null)
               {
                  this.mCreateGuildEmblemPreview = new GuildEmblem("guild_frame_01","guild_logo_01");
                  this.mCreateGuildEmblemPreview.scaleX *= 1.5;
                  this.mCreateGuildEmblemPreview.scaleY *= 1.5;
                  this.mCreateGuildEmblemPreview.x = this.mCreateGuildChooseEmblemTextfield.x + (this.mCreateGuildChooseEmblemTextfield.width - this.mCreateGuildEmblemPreview.width) / 2;
                  this.mCreateGuildEmblemPreview.y = this.mCreateGuildChooseEmblemTextfield.y + this.mCreateGuildChooseEmblemTextfield.height * 1.15;
                  this.mCreateGuildContainer.addChild(this.mCreateGuildEmblemPreview);
               }
               if(this.mCreateGuildButton == null)
               {
                  this.mCreateGuildButton = new FSButton(Root.assets.getTexture("choose_button"),GuildsMng.smGoldCost.toString());
                  this.mCreateGuildButton.fontName = FSResourceMng.getFontByType();
                  this.mCreateGuildButton.fontColor = 16777215;
                  this.mCreateGuildButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
                  this.mCreateGuildButton.x = this.mCreateGuildChooseNameTextfield.x + this.mCreateGuildChooseNameTextfield.width / 2;
                  this.mCreateGuildButton.y = mBox.height - this.mCreateGuildButton.height * 0.8;
                  this.mCreateGuildButton.addEventListener(Event.TRIGGERED,this.onCreateGuildButtonPressed);
                  this.mCreateGuildContainer.addChild(this.mCreateGuildButton);
               }
               if(this.mCreateGuildChooseEmblemFGTextfield == null)
               {
                  this.mCreateGuildChooseEmblemFGTextfield = new FSTextfield(this.mCreateGuildChooseNameTextfield.width * 1.45,this.mCreateGuildChooseNameTextfield.height / 2,TextManager.getText("TID_GUILD_CHOOSE_PATCH"));
                  this.mCreateGuildChooseEmblemFGTextfield.x = this.mCreateGuildChooseNameTextfield.x + this.mCreateGuildChooseNameTextfield.width * 1.3;
                  this.mCreateGuildChooseEmblemFGTextfield.y = this.mCreateGuildChooseNameTextfield.y;
                  this.mCreateGuildContainer.addChild(this.mCreateGuildChooseEmblemFGTextfield);
               }
               _loc1_ = 0;
               if(this.mCreateGuildEmblemFGBrowser == null)
               {
                  _loc1_ = Root.assets.getTextures("guild_logo_") ? int(Root.assets.getTextures("guild_logo_").length) : 0;
                  this.mCreateGuildEmblemFGBrowser = new GuildEmblemBrowser("guild_logo_","mini_square_socket_highlight","mini_square_socket",_loc1_);
                  this.mCreateGuildEmblemFGBrowser.setOnEmblemSelectedTriggerFunction(this.onCreateGuildEmblemSelected);
                  this.mCreateGuildEmblemFGBrowser.x = this.mCreateGuildChooseEmblemFGTextfield.x;
                  this.mCreateGuildEmblemFGBrowser.y = this.mCreateGuildChooseEmblemFGTextfield.y + this.mCreateGuildChooseEmblemFGTextfield.height;
                  this.mCreateGuildContainer.addChild(this.mCreateGuildEmblemFGBrowser);
               }
               if(this.mCreateGuildChooseEmblemBGTextfield == null)
               {
                  this.mCreateGuildChooseEmblemBGTextfield = new FSTextfield(this.mCreateGuildChooseEmblemFGTextfield.width,this.mCreateGuildChooseNameTextfield.height / 2,TextManager.getText("TID_GUILD_CHOOSE_FRAME"));
                  this.mCreateGuildChooseEmblemBGTextfield.x = this.mCreateGuildChooseEmblemFGTextfield.x;
                  this.mCreateGuildChooseEmblemBGTextfield.y = this.mCreateGuildEmblemFGBrowser.y + this.mCreateGuildEmblemFGBrowser.height;
                  this.mCreateGuildContainer.addChild(this.mCreateGuildChooseEmblemBGTextfield);
               }
               if(this.mCreateGuildEmblemBGBrowser == null)
               {
                  _loc1_ = Root.assets.getTextures("guild_frame_") ? int(Root.assets.getTextures("guild_frame_").length) : 0;
                  this.mCreateGuildEmblemBGBrowser = new GuildEmblemBrowser("guild_frame_","mini_square_socket_highlight","mini_square_socket",_loc1_);
                  this.mCreateGuildEmblemBGBrowser.setOnEmblemSelectedTriggerFunction(this.onCreateGuildEmblemSelected);
                  this.mCreateGuildEmblemBGBrowser.x = this.mCreateGuildEmblemFGBrowser.x;
                  this.mCreateGuildEmblemBGBrowser.y = this.mCreateGuildChooseEmblemBGTextfield.y + this.mCreateGuildChooseEmblemBGTextfield.height;
                  this.mCreateGuildContainer.addChild(this.mCreateGuildEmblemBGBrowser);
               }
            }
            else
            {
               if(this.mCreateGuildChooseNameTextInput)
               {
                  this.mCreateGuildChooseNameTextInput.text = "";
               }
               if(this.mCreateGuildButton)
               {
                  this.mCreateGuildButton.enabled = true;
               }
            }
            if(this.mCreateGuildContainer)
            {
               addChild(this.mCreateGuildContainer);
               this.mCreateGuildContainer.alpha = 0.001;
               SpecialFX.tweenToAlpha(this.mCreateGuildContainer,0.99,0.5,0);
            }
         }
      }
      
      private function onCreateGuildEmblemSelected(param1:GuildEmblemBrowser, param2:GuildEmblem) : void
      {
         if(param1 == this.mCreateGuildEmblemFGBrowser)
         {
            if(this.mCreateGuildEmblemPreview)
            {
               this.mCreateGuildEmblemPreview.changeFGTexture(param2.getBGTexture());
            }
         }
         else if(this.mCreateGuildEmblemPreview)
         {
            this.mCreateGuildEmblemPreview.changeBGTexture(param2.getBGTexture());
         }
      }
      
      private function onManageEmblemSelected(param1:GuildEmblemBrowser, param2:GuildEmblem) : void
      {
         if(param1 == this.mManageEmblemFGBrowser)
         {
            if(this.mManageEmblem)
            {
               this.mManageEmblem.changeFGTexture(param2.getBGTexture());
            }
         }
         else if(this.mManageEmblem)
         {
            this.mManageEmblem.changeBGTexture(param2.getBGTexture());
         }
      }
      
      private function onCreateGuildButtonPressed(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:GuildEmblem = null;
         var _loc7_:GuildEmblem = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         if(!InstanceMng.getUserDataMng().getOwnerUserData().isInBlackList())
         {
            if(!InstanceMng.getUserDataMng().getOwnerUserData().isInDuplicatedList())
            {
               _loc2_ = GuildsMng.smGoldCost;
               _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getGold();
               if(_loc3_ >= _loc2_)
               {
                  this.mCreateGuildButton.enabled = false;
                  _loc4_ = this.mCreateGuildChooseNameTextInput ? this.mCreateGuildChooseNameTextInput.text : "";
                  _loc5_ = _loc4_.length > 4 && _loc4_.length < GuildsMng.smMaxGuildNameLength;
                  _loc4_ = StringUtil.trim(_loc4_);
                  if(_loc4_.length < 4)
                  {
                     Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_GUILD_NAME_MIN_CHARACTERS"),[4]),true);
                     this.mCreateGuildButton.enabled = true;
                  }
                  else
                  {
                     _loc6_ = this.mCreateGuildEmblemBGBrowser.getSelectedEmblem();
                     _loc7_ = this.mCreateGuildEmblemFGBrowser.getSelectedEmblem();
                     _loc8_ = _loc6_ ? _loc6_.getBGName() : "";
                     _loc9_ = _loc7_ ? _loc7_.getBGName() : "";
                     _loc10_ = this.mCreateGuildAccessByInvitationCheckBox.isToggled() ? GuildsMng.GUILD_ACCESS_VIA_REQUEST : GuildsMng.GUILD_ACCESS_ANYONE_CAN_JOIN;
                     if(_loc8_ != "" && _loc9_ != "")
                     {
                        if(_loc8_ == "guild_frame_00" && _loc9_ == "guild_logo_00")
                        {
                           Utils.setLogText(TextManager.getText("TID_GUILD_EMBLEM_EMPTY"));
                           this.mCreateGuildButton.enabled = true;
                        }
                        else
                        {
                           InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.CENTER,Align.CENTER,1,null,this);
                           InstanceMng.getGuildsMng().createGuild(_loc4_,_loc8_,_loc9_,_loc10_,this.onGuildCreationFailed);
                        }
                     }
                     else
                     {
                        Utils.setLogText(TextManager.getText("TID_GUILD_TRY_AGAIN"),true);
                        this.mCreateGuildButton.enabled = true;
                     }
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_GOLD_NOT_ENOUGH"),true);
               }
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
      
      public function onGuildCreationFailed() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         if(this.mCreateGuildButton)
         {
            this.mCreateGuildButton.enabled = true;
         }
      }
      
      private function createTopRankingSection() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.mTopRankingContainer == null && Boolean(mBox))
         {
            this.mTopRankingContainer = new Component();
            if(this.mTopRankingTopBG == null)
            {
               this.mTopRankingTopBG = new FSImage(Root.assets.getTexture("guild_layer_large"));
               this.mTopRankingTopBG.x = (mBox.width - this.mTopRankingTopBG.width) / 2;
               this.mTopRankingTopBG.y = 10;
               this.mTopRankingContainer.addChild(this.mTopRankingTopBG);
            }
            if(this.mTopRankingLeftImage == null)
            {
               this.mTopRankingLeftImage = new FSImage(Root.assets.getTexture("guild_ranking_top_icon_large"));
               this.mTopRankingLeftImage.x = mBox.height * 0.05;
               this.mTopRankingLeftImage.y = (this.mTopRankingTopBG.height - this.mTopRankingLeftImage.height) / 2;
               this.mTopRankingLeftImage.x = this.mTopRankingTopBG.x + 10;
               this.mTopRankingLeftImage.y = this.mTopRankingTopBG.y + (this.mTopRankingTopBG.height - this.mTopRankingLeftImage.height) / 2;
               this.mTopRankingContainer.addChild(this.mTopRankingLeftImage);
            }
            if(this.mTopRankingTitleTextfield == null)
            {
               this.mTopRankingTitleTextfield = new FSTextfield(this.mTopRankingTopBG.width / 3,this.mTopRankingTopBG.height,TextManager.getText("TID_GUILD_TOP_RANKING"));
               this.mTopRankingTitleTextfield.format.horizontalAlign = Align.LEFT;
               this.mTopRankingTitleTextfield.x = this.mTopRankingLeftImage.x + this.mTopRankingLeftImage.width * 1.05;
               this.mTopRankingTitleTextfield.y = this.mTopRankingTopBG.y;
               this.mTopRankingContainer.addChild(this.mTopRankingTitleTextfield);
            }
            if(this.mTopRankingGuildEventPanel == null)
            {
               this.mTopRankingGuildEventPanel = Utils.createCustomBox("guild_event_panel",872);
               this.mTopRankingGuildEventPanel.width = this.mTopRankingTopBG.width - (this.mTopRankingTitleTextfield.x + this.mTopRankingTitleTextfield.width);
               this.mTopRankingGuildEventPanel.x = this.mTopRankingTopBG.x + this.mTopRankingTopBG.width - this.mTopRankingGuildEventPanel.width * 1.025;
               this.mTopRankingGuildEventPanel.y = this.mTopRankingTopBG.y + (this.mTopRankingTopBG.height - this.mTopRankingGuildEventPanel.height) / 2;
               this.mTopRankingContainer.addChild(this.mTopRankingGuildEventPanel);
            }
            if(this.mTopRankingTopPvPGuildTextfield == null)
            {
               this.mTopRankingTopPvPGuildTextfield = new FSTextfieldTwoColors(TextManager.getText("TID_GUILD_TOP_PVP"),16777215,FSResourceMng.getFontByType()," ???",16777215,FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN),this.mTopRankingGuildEventPanel.width / 2,this.mTopRankingGuildEventPanel.width / 2 - 10);
               _loc1_ = this.mTopRankingTopPvPGuildTextfield.height / 2;
               _loc2_ = this.mTopRankingTopPvPGuildTextfield.height * 4;
               _loc3_ = _loc1_ + (this.mTopRankingGuildEventPanel.y + (this.mTopRankingGuildEventPanel.height - _loc2_) / 2);
               this.mTopRankingTopPvPGuildTextfield.x = this.mTopRankingGuildEventPanel.x + 10;
               this.mTopRankingTopPvPGuildTextfield.y = _loc3_;
               this.mTopRankingContainer.addChild(this.mTopRankingTopPvPGuildTextfield);
            }
            if(this.mTopRankingTopDungeonGuildTextfield == null)
            {
               this.mTopRankingTopDungeonGuildTextfield = new FSTextfieldTwoColors(TextManager.getText("TID_GUILD_TOP_DUNGEON"),16777215,FSResourceMng.getFontByType()," ???",16777215,FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN),this.mTopRankingGuildEventPanel.width / 2,this.mTopRankingGuildEventPanel.width / 2 - 10);
               this.mTopRankingTopDungeonGuildTextfield.x = this.mTopRankingTopPvPGuildTextfield.x;
               this.mTopRankingTopDungeonGuildTextfield.y = this.mTopRankingTopPvPGuildTextfield.y + this.mTopRankingTopPvPGuildTextfield.height;
               this.mTopRankingContainer.addChild(this.mTopRankingTopDungeonGuildTextfield);
            }
            if(this.mTopRankingTopContributorPlayerTextfield == null)
            {
               this.mTopRankingTopContributorPlayerTextfield = new FSTextfieldTwoColors(TextManager.getText("TID_GUILD_TOP_PLAYER"),16777215,FSResourceMng.getFontByType()," ???",16777215,FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD),this.mTopRankingGuildEventPanel.width / 2,this.mTopRankingGuildEventPanel.width / 2 - 10);
               this.mTopRankingTopContributorPlayerTextfield.x = this.mTopRankingTopPvPGuildTextfield.x;
               this.mTopRankingTopContributorPlayerTextfield.y = this.mTopRankingTopWeeklyScoreTextfield ? this.mTopRankingTopWeeklyScoreTextfield.y + this.mTopRankingTopWeeklyScoreTextfield.height : this.mTopRankingTopDungeonGuildTextfield.y + this.mTopRankingTopDungeonGuildTextfield.height;
               this.mTopRankingContainer.addChild(this.mTopRankingTopContributorPlayerTextfield);
            }
         }
         this.refreshTopRankingGuildsInfo();
         if(this.mTopRankingContainer)
         {
            addChild(this.mTopRankingContainer);
            this.mTopRankingContainer.alpha = 0.001;
            SpecialFX.tweenToAlpha(this.mTopRankingContainer,0.99,0.5,0);
         }
      }
      
      private function refreshTopRankingGuildsInfo() : void
      {
         if(this.mTopRankingGuildsSlotsContainer)
         {
            this.mTopRankingGuildsSlotsContainer.removeChildren();
         }
         if(this.mTopRankingGuildsVector)
         {
            this.mTopRankingGuildsVector.length = 0;
            this.mTopRankingGuildsVector = null;
         }
         if(this.mTopRankingGuildsSlotsVector)
         {
            this.mTopRankingGuildsSlotsVector.length = 0;
            this.mTopRankingGuildsSlotsVector = null;
         }
         InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.CENTER,Align.CENTER,1,null,this);
         InstanceMng.getServerConnection().getLeaderboardData("GUILD_GLOBAL_TOTAL_LB",25,this.onTopRankingGuildsInfoReceived,null,this.onTopRankingGuildsInfoFailed);
         InstanceMng.getServerConnection().getGuildsTopScores(true,true,true,this.onTopGuildScoresReceived);
      }
      
      private function onTopGuildScoresReceived(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         if(param1 != null && param1.hasOwnProperty("TOP_PVP") && Boolean(param1["TOP_PVP"]))
         {
            if(this.mTopRankingTopPvPGuildTextfield)
            {
               _loc2_ = param1["TOP_PVP"].hasOwnProperty("teamName") ? String(param1["TOP_PVP"]["teamName"]).toUpperCase() : "";
               this.mTopRankingTopPvPGuildTextfield.setTextfield2Text(" " + _loc2_);
            }
         }
         if(param1 != null && param1.hasOwnProperty("TOP_PVE") && Boolean(param1["TOP_PVE"]))
         {
            if(this.mTopRankingTopDungeonGuildTextfield)
            {
               _loc3_ = param1["TOP_PVE"].hasOwnProperty("teamName") ? String(param1["TOP_PVE"]["teamName"]).toUpperCase() : "";
               this.mTopRankingTopDungeonGuildTextfield.setTextfield2Text(" " + _loc3_);
            }
         }
         if(param1 != null && param1.hasOwnProperty("CONTRIBUTOR") && Boolean(param1["CONTRIBUTOR"]))
         {
            _loc4_ = param1["CONTRIBUTOR"].hasOwnProperty("country") ? "[" + param1["CONTRIBUTOR"]["country"] + "]" : "";
            _loc5_ = param1["CONTRIBUTOR"].hasOwnProperty("userName") ? param1["CONTRIBUTOR"]["userName"] : "";
            _loc6_ = param1["CONTRIBUTOR"].hasOwnProperty("SUM-SCORE") ? Number(param1["CONTRIBUTOR"]["SUM-SCORE"]) : 0;
            this.fillTopContributorInfo(_loc6_,_loc4_ + " " + _loc5_);
         }
      }
      
      private function onTopPvPGuildInfoReceived(param1:Object) : void
      {
         if(param1 != null && param1[0] != null)
         {
            if(this.mTopRankingTopPvPGuildTextfield)
            {
               this.mTopRankingTopPvPGuildTextfield.setTextfield2Text(" " + String(param1[0].name).toUpperCase());
            }
         }
      }
      
      private function onTopDungeonsGuildInfoReceived(param1:Object) : void
      {
         if(param1 != null && param1[0] != null)
         {
            if(this.mTopRankingTopDungeonGuildTextfield)
            {
               this.mTopRankingTopDungeonGuildTextfield.setTextfield2Text(" " + String(param1[0].name).toUpperCase());
            }
         }
      }
      
      private function onWeeklyHighestScoreGuildInfoReceived(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 != null && param1[0] != null)
         {
            if(this.mTopRankingTopWeeklyScoreTextfield)
            {
               _loc2_ = Utils.coolFormat(param1[0].weeklyHighestScore,0);
               this.mTopRankingTopWeeklyScoreTextfield.setTextfield2Text(" " + String(param1[0].name).toUpperCase() + " (" + _loc2_ + ")");
               this.mTopRankingTopWeeklyScoreTextfield.setTooltipText(Utils.formatNumber(Number(param1[0].weeklyHighestScore)));
            }
         }
      }
      
      private function onTopContributorPlayerInfoReceived(param1:Object) : void
      {
         if(param1 != null && param1[0] != null)
         {
            this.fillTopContributorInfo(param1[0].score,param1[0].playerName);
         }
      }
      
      private function onTopContributorProfileACK(param1:UserData) : void
      {
         var _loc2_:String = null;
         if(param1)
         {
            _loc2_ = Utils.coolFormat(param1.getGuildGlobalTotalScore(),0);
            this.fillTopContributorInfo(param1.getGuildGlobalTotalScore(),param1.getName());
         }
      }
      
      private function fillTopContributorInfo(param1:Number, param2:String) : void
      {
         var _loc3_:String = null;
         if(this.mTopRankingTopContributorPlayerTextfield)
         {
            _loc3_ = Utils.coolFormat(param1,0);
            this.mTopRankingTopContributorPlayerTextfield.setTextfield2Text(" " + param2.toUpperCase() + " (" + _loc3_ + ")");
            this.mTopRankingTopContributorPlayerTextfield.setTooltipText(Utils.formatNumber(param1));
         }
      }
      
      private function onTopRankingGuildsInfoReceived(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Guild = null;
         var _loc4_:GuildRankingSlot = null;
         var _loc5_:int = 0;
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         if(param1)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc2_ = param1[_loc5_];
               _loc3_ = InstanceMng.getGuildsMng().createGuildByServerInfo(_loc2_);
               if(this.mTopRankingGuildsVector == null)
               {
                  this.mTopRankingGuildsVector = new Vector.<Guild>();
               }
               this.mTopRankingGuildsVector.push(_loc3_);
               _loc4_ = new GuildRankingSlot(_loc3_,_loc5_ + 1,"guild_points_plate_large",GuildRankingSlot.TYPE_TOP);
               this.addTopRankingGuildSlotToContainer(_loc4_);
               _loc5_++;
            }
         }
      }
      
      private function addTopRankingGuildSlotToContainer(param1:GuildRankingSlot) : void
      {
         var _loc2_:VerticalLayout = null;
         if(param1)
         {
            if(Boolean(this.mTopRankingGuildsSlotsContainer == null) && Boolean(mBox) && Boolean(this.mTopRankingTopBG))
            {
               this.mTopRankingGuildsSlotsContainer = new ScrollContainer();
               this.mTopRankingGuildsSlotsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
               _loc2_ = new VerticalLayout();
               _loc2_.horizontalAlign = HorizontalAlign.CENTER;
               this.mTopRankingGuildsSlotsContainer.layout = _loc2_;
               this.mTopRankingGuildsSlotsContainer.x = mBox.x;
               this.mTopRankingGuildsSlotsContainer.y = this.mTopRankingTopBG.y + this.mTopRankingTopBG.height * 1.035;
               this.mTopRankingGuildsSlotsContainer.setSize(mBox.width,mBox.height * 0.92 - this.mTopRankingTopBG.height);
               this.mTopRankingContainer.addChild(this.mTopRankingGuildsSlotsContainer);
            }
            param1.addParentScrollContainer(this.mTopRankingGuildsSlotsContainer);
            if(this.mTopRankingGuildsSlotsContainer)
            {
               this.mTopRankingGuildsSlotsContainer.addChild(param1);
            }
         }
      }
      
      private function onTopRankingGuildsInfoFailed() : void
      {
         Utils.setLogText(TextManager.getText("TID_GUILD_RETRIEVE_ERROR"),true);
      }
      
      private function createWeeklyRankingSection() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(mBox)
         {
            if(this.mWeeklyRankingContainer == null)
            {
               this.mWeeklyRankingContainer = new Component();
            }
            if(this.mWeeklyRankingTopBG == null)
            {
               this.mWeeklyRankingTopBG = new FSImage(Root.assets.getTexture("guild_layer_large"));
               this.mWeeklyRankingTopBG.x = (mBox.width - this.mWeeklyRankingTopBG.width) / 2;
               this.mWeeklyRankingTopBG.y = 10;
               this.mWeeklyRankingContainer.addChild(this.mWeeklyRankingTopBG);
            }
            if(this.mWeeklyRankingLeftImage == null)
            {
               this.mWeeklyRankingLeftImage = new FSImage(Root.assets.getTexture("guild_ranking_weekly_icon_large"));
               this.mWeeklyRankingLeftImage.x = mBox.height * 0.05;
               this.mWeeklyRankingLeftImage.y = (this.mWeeklyRankingTopBG.height - this.mWeeklyRankingLeftImage.height) / 2;
               this.mWeeklyRankingLeftImage.x = this.mWeeklyRankingTopBG.x + 10;
               this.mWeeklyRankingLeftImage.y = this.mWeeklyRankingTopBG.y + (this.mWeeklyRankingTopBG.height - this.mWeeklyRankingLeftImage.height) / 2;
               this.mWeeklyRankingContainer.addChild(this.mWeeklyRankingLeftImage);
            }
            if(this.mWeeklyRankingTitleTextfield == null)
            {
               this.mWeeklyRankingTitleTextfield = new FSTextfield(this.mWeeklyRankingTopBG.width / 2.7,this.mWeeklyRankingTopBG.height * 0.6,TextManager.getText("TID_GUILD_WEEKLY_RANKING"));
               this.mWeeklyRankingTitleTextfield.format.horizontalAlign = Align.LEFT;
               this.mWeeklyRankingTitleTextfield.x = this.mWeeklyRankingLeftImage.x + this.mWeeklyRankingLeftImage.width * 1.05;
               this.mWeeklyRankingTitleTextfield.y = this.mWeeklyRankingTopBG.y;
               this.mWeeklyRankingContainer.addChild(this.mWeeklyRankingTitleTextfield);
            }
            if(this.mWeeklyRankingSubtitleTextfield == null)
            {
               _loc2_ = InstanceMng.getGuildsMng().getWeeklySeasonTimeLeft();
               _loc3_ = TextManager.getText("TID_GUILD_WEEK_ENDS") + " " + _loc2_;
               this.mWeeklyRankingSubtitleTextfield = new FSTextfield(this.mWeeklyRankingTitleTextfield.width,this.mWeeklyRankingTopBG.height * 0.35,_loc3_,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mWeeklyRankingSubtitleTextfield.format.horizontalAlign = Align.LEFT;
               this.mWeeklyRankingSubtitleTextfield.x = this.mWeeklyRankingTitleTextfield.x;
               this.mWeeklyRankingSubtitleTextfield.y = this.mWeeklyRankingTitleTextfield.y + this.mWeeklyRankingTitleTextfield.height;
               this.mWeeklyRankingContainer.addChild(this.mWeeklyRankingSubtitleTextfield);
            }
            _loc1_ = InstanceMng.getGuildsMng().isWeeklyEventActive();
            if(this.mWeeklyRankingGuildEventPanel == null)
            {
               this.mWeeklyRankingGuildEventPanel = Utils.createCustomBox("guild_event_panel",872);
               this.mWeeklyRankingGuildEventPanel.width = this.mWeeklyRankingTopBG.width - (this.mWeeklyRankingTitleTextfield.x + this.mWeeklyRankingTitleTextfield.width);
               this.mWeeklyRankingGuildEventPanel.x = this.mWeeklyRankingTopBG.x + this.mWeeklyRankingTopBG.width - this.mWeeklyRankingGuildEventPanel.width * 1.025;
               this.mWeeklyRankingGuildEventPanel.y = this.mWeeklyRankingTopBG.y + (this.mWeeklyRankingTopBG.height - this.mWeeklyRankingGuildEventPanel.height) / 2;
               this.mWeeklyRankingContainer.addChild(this.mWeeklyRankingGuildEventPanel);
            }
            if(this.mWeeklyRankingEventStartingTextfield == null)
            {
               _loc4_ = _loc1_ ? TextManager.getText("TID_GUILD_EVENT_END") : TextManager.getText("TID_GUILD_EVENT_START");
               _loc5_ = " " + InstanceMng.getGuildsMng().getWeeklyEventTimeLeft();
               _loc6_ = _loc1_ ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED) : FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_BLUE);
               this.mWeeklyRankingEventStartingTextfield = new FSTextfieldTwoColors(_loc4_,16777215,FSResourceMng.getFontByType(),_loc5_,16777215,_loc6_,this.mWeeklyRankingGuildEventPanel.width / 2,this.mWeeklyRankingGuildEventPanel.width / 2.15);
               this.mWeeklyRankingEventStartingTextfield.setHeight(this.mWeeklyRankingGuildEventPanel.height / 3);
               this.mWeeklyRankingEventStartingTextfield.x = this.mWeeklyRankingGuildEventPanel.x + 5;
               this.mWeeklyRankingEventStartingTextfield.y = this.mWeeklyRankingGuildEventPanel.y + this.mWeeklyRankingGuildEventPanel.height / 5;
               this.mWeeklyRankingContainer.addChild(this.mWeeklyRankingEventStartingTextfield);
            }
            if(this.mWeeklyRankingEventStartingDescTextfield == null)
            {
               _loc7_ = "";
               if(GuildsMng.smWeeklyEventType != -1)
               {
                  switch(GuildsMng.smWeeklyEventType)
                  {
                     case GuildsMng.WEEKLY_EVENT_PVP:
                        _loc7_ = TextManager.getText("TID_GUILD_EVENT_PVP_INFO");
                        break;
                     case GuildsMng.WEEKLY_EVENT_DUNGEONS:
                        _loc7_ = TextManager.getText("TID_GUILD_EVENT_DUNGEON_INFO");
                  }
               }
               this.mWeeklyRankingEventStartingDescTextfield = new FSTextfield(this.mWeeklyRankingGuildEventPanel.width * 0.98,this.mWeeklyRankingGuildEventPanel.height / 3,_loc7_);
               this.mWeeklyRankingEventStartingDescTextfield.x = this.mWeeklyRankingEventStartingTextfield.x;
               this.mWeeklyRankingEventStartingDescTextfield.y = this.mWeeklyRankingEventStartingTextfield.y + this.mWeeklyRankingEventStartingTextfield.height;
               this.mWeeklyRankingContainer.addChild(this.mWeeklyRankingEventStartingDescTextfield);
            }
            this.refreshWeeklyRankingGuildsInfo();
            addChild(this.mWeeklyRankingContainer);
            this.mWeeklyRankingContainer.alpha = 0.001;
            SpecialFX.tweenToAlpha(this.mWeeklyRankingContainer,0.99,0.5,0);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(!isClosing() && !mClosed && this.mRefreshTimer == 0)
         {
            this.managePopup();
         }
      }
      
      private function managePopup() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(!mClosed)
         {
            this.mRefreshTimer = setTimeout(this.managePopup,1000);
         }
         else
         {
            clearTimeout(this.mRefreshTimer);
         }
         if(!isClosing())
         {
            _loc2_ = "";
            if(this.mCurrentSectionIndex == WEEKLY_RANKING_SECTION)
            {
               if(GuildsMng.smWeeklyEventType != -1)
               {
                  _loc3_ = InstanceMng.getGuildsMng().isWeeklyEventExpired();
                  if(this.mWeeklyRankingGuildEventPanel)
                  {
                     this.mWeeklyRankingGuildEventPanel.visible = !_loc3_;
                  }
                  if(this.mWeeklyRankingEventStartingTextfield)
                  {
                     this.mWeeklyRankingEventStartingTextfield.visible = !_loc3_;
                  }
                  if(this.mWeeklyRankingEventStartingDescTextfield)
                  {
                     this.mWeeklyRankingEventStartingDescTextfield.visible = !_loc3_;
                  }
                  if(!_loc3_)
                  {
                     if(this.mWeeklyRankingEventStartingTextfield)
                     {
                        _loc4_ = InstanceMng.getGuildsMng().isWeeklyEventActive();
                        _loc5_ = _loc4_ ? TextManager.getText("TID_GUILD_EVENT_END") : TextManager.getText("TID_GUILD_EVENT_START");
                        _loc6_ = " " + InstanceMng.getGuildsMng().getWeeklyEventTimeLeft();
                        this.mWeeklyRankingEventStartingTextfield.setTextfield1Text(_loc5_);
                        this.mWeeklyRankingEventStartingTextfield.setTextfield2Text(_loc6_);
                        _loc7_ = _loc4_ ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED) : FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
                        this.mWeeklyRankingEventStartingTextfield.setTextfield2FontName(_loc7_);
                     }
                     if(this.mWeeklyRankingEventStartingDescTextfield)
                     {
                        _loc8_ = GuildsMng.smWeeklyEventType == GuildsMng.WEEKLY_EVENT_PVP ? TextManager.getText("TID_GUILD_EVENT_PVP_INFO") : TextManager.getText("TID_GUILD_EVENT_DUNGEON_INFO");
                        this.mWeeklyRankingEventStartingDescTextfield.text = _loc8_;
                     }
                  }
                  _loc1_ = InstanceMng.getGuildsMng().getWeeklySeasonTimeLeft();
                  _loc2_ = TextManager.getText("TID_GUILD_WEEK_ENDS") + " " + _loc1_;
                  if(this.mWeeklyRankingSubtitleTextfield)
                  {
                     this.mWeeklyRankingSubtitleTextfield.text = _loc2_;
                  }
               }
               else
               {
                  if(this.mWeeklyRankingGuildEventPanel)
                  {
                     this.mWeeklyRankingGuildEventPanel.visible = false;
                  }
                  if(this.mWeeklyRankingEventStartingTextfield)
                  {
                     this.mWeeklyRankingEventStartingTextfield.visible = false;
                  }
                  if(this.mWeeklyRankingEventStartingDescTextfield)
                  {
                     this.mWeeklyRankingEventStartingDescTextfield.visible = false;
                  }
               }
            }
            else if(this.mCurrentSectionIndex == REWARDS_SECTION)
            {
               if(this.mGuildRewardsSubtitleTextfield)
               {
                  _loc1_ = InstanceMng.getGuildsMng().getWeeklySeasonTimeLeft();
                  _loc2_ = TextManager.getText("TID_GUILD_REWARDS_ASSIGNED") + " " + _loc1_;
                  this.mGuildRewardsSubtitleTextfield.text = _loc2_;
               }
            }
         }
      }
      
      private function refreshWeeklyRankingGuildsInfo() : void
      {
         if(this.mWeeklyRankingGuildsSlotsContainer)
         {
            this.mWeeklyRankingGuildsSlotsContainer.removeChildren();
         }
         if(this.mWeeklyRankingGuildsVector)
         {
            this.mWeeklyRankingGuildsVector.length = 0;
            this.mWeeklyRankingGuildsVector = null;
         }
         if(this.mWeeklyRankingGuildsSlotsVector)
         {
            this.mWeeklyRankingGuildsSlotsVector.length = 0;
            this.mWeeklyRankingGuildsSlotsVector = null;
         }
         InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.CENTER,Align.CENTER,1,null,this);
         InstanceMng.getServerConnection().getLeaderboardData("GUILD_WEEKLY_TOTAL_LB_Display",25,this.onWeeklyRankingGuildsInfoReceived);
      }
      
      private function onWeeklyRankingGuildsInfoReceived(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Guild = null;
         var _loc4_:GuildRankingSlot = null;
         var _loc5_:int = 0;
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         if(param1)
         {
            param1.sort(DictionaryUtils.sortGuildsByWeekTotalScore);
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc2_ = param1[_loc5_];
               _loc3_ = InstanceMng.getGuildsMng().createGuildByServerInfo(_loc2_);
               if(this.mWeeklyRankingGuildsVector == null)
               {
                  this.mWeeklyRankingGuildsVector = new Vector.<Guild>();
               }
               this.mWeeklyRankingGuildsVector.push(_loc3_);
               _loc4_ = new GuildRankingSlot(_loc3_,_loc5_ + 1,"guild_weekly_points_plate_large",GuildRankingSlot.TYPE_WEEKLY);
               this.addWeeklyRankingGuildSlotToContainer(_loc4_);
               _loc5_++;
            }
         }
      }
      
      private function addWeeklyRankingGuildSlotToContainer(param1:GuildRankingSlot) : void
      {
         var _loc2_:VerticalLayout = null;
         if(this.mWeeklyRankingTopBG)
         {
            if(this.mWeeklyRankingGuildsSlotsContainer == null)
            {
               this.mWeeklyRankingGuildsSlotsContainer = new ScrollContainer();
               this.mWeeklyRankingGuildsSlotsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
               _loc2_ = new VerticalLayout();
               _loc2_.horizontalAlign = HorizontalAlign.CENTER;
               this.mWeeklyRankingGuildsSlotsContainer.layout = _loc2_;
               this.mWeeklyRankingGuildsSlotsContainer.x = mBox.x;
               this.mWeeklyRankingGuildsSlotsContainer.y = this.mWeeklyRankingTopBG.y + this.mWeeklyRankingTopBG.height * 1.035;
               this.mWeeklyRankingGuildsSlotsContainer.setSize(mBox.width,mBox.height * 0.92 - this.mWeeklyRankingTopBG.height);
               this.mWeeklyRankingContainer.addChild(this.mWeeklyRankingGuildsSlotsContainer);
            }
            param1.addParentScrollContainer(this.mWeeklyRankingGuildsSlotsContainer);
            this.mWeeklyRankingGuildsSlotsContainer.addChild(param1);
         }
      }
      
      public function updateSelectedSection(param1:int) : void
      {
         this.mCurrentSectionIndex = param1;
         var _loc2_:Texture = Root.assets.getTexture("guild_create_icon");
         var _loc3_:Texture = Root.assets.getTexture("guild_button_options_up");
         var _loc4_:Number = 0.99;
         var _loc5_:Number = 0.5;
         this.hideAllMemberRankOptions();
         switch(this.mCurrentSectionIndex)
         {
            case INFO_SECTION:
               this.updateSelectedTab(true,this.mGuildInfoTab);
               this.updateSelectedTab(false,this.mRewardsTab);
               this.updateSelectedTab(false,this.mJoinGuildTab);
               this.updateSelectedTab(false,this.mCreateGuildTab);
               this.updateSelectedTab(false,this.mTopRankingTab);
               this.updateSelectedTab(false,this.mWeeklyRankingTab);
               this.removeChildrenFromUnselectedSection(this.mGuildRewardsContainer);
               this.removeChildrenFromUnselectedSection(this.mJoinContainer);
               this.removeChildrenFromUnselectedSection(this.mCreateGuildContainer);
               this.removeChildrenFromUnselectedSection(this.mTopRankingContainer);
               this.removeChildrenFromUnselectedSection(this.mWeeklyRankingContainer);
               this.removeChildrenFromUnselectedSection(this.mManageContainer);
               if(this.mGuildInfoTab)
               {
                  this.mGuildInfoTab.disableTemporarily();
               }
               this.createGuildInfoSection();
               break;
            case REWARDS_SECTION:
               this.updateSelectedTab(false,this.mGuildInfoTab);
               this.updateSelectedTab(true,this.mRewardsTab);
               this.updateSelectedTab(false,this.mJoinGuildTab);
               this.updateSelectedTab(false,this.mCreateGuildTab);
               this.updateSelectedTab(false,this.mTopRankingTab);
               this.updateSelectedTab(false,this.mWeeklyRankingTab);
               this.removeChildrenFromUnselectedSection(this.mGuildInfoContainer);
               this.removeChildrenFromUnselectedSection(this.mJoinContainer);
               this.removeChildrenFromUnselectedSection(this.mCreateGuildContainer);
               this.removeChildrenFromUnselectedSection(this.mTopRankingContainer);
               this.removeChildrenFromUnselectedSection(this.mWeeklyRankingContainer);
               this.removeChildrenFromUnselectedSection(this.mManageContainer);
               if(this.mRewardsTab)
               {
                  this.mRewardsTab.disableTemporarily();
               }
               this.createRewardsSection();
               break;
            case JOIN_SECTION:
               this.updateSelectedTab(false,this.mGuildInfoTab);
               this.updateSelectedTab(false,this.mRewardsTab);
               this.updateSelectedTab(true,this.mJoinGuildTab);
               this.updateSelectedTab(false,this.mCreateGuildTab);
               this.updateSelectedTab(false,this.mTopRankingTab);
               this.updateSelectedTab(false,this.mWeeklyRankingTab);
               this.removeChildrenFromUnselectedSection(this.mGuildInfoContainer);
               this.removeChildrenFromUnselectedSection(this.mGuildRewardsContainer);
               this.removeChildrenFromUnselectedSection(this.mCreateGuildContainer);
               this.removeChildrenFromUnselectedSection(this.mTopRankingContainer);
               this.removeChildrenFromUnselectedSection(this.mWeeklyRankingContainer);
               this.removeChildrenFromUnselectedSection(this.mManageContainer);
               if(this.mJoinGuildTab)
               {
                  this.mJoinGuildTab.disableTemporarily();
               }
               this.createJoinSection();
               break;
            case CREATE_SECTION:
               this.updateSelectedTab(false,this.mGuildInfoTab);
               this.updateSelectedTab(false,this.mRewardsTab);
               this.updateSelectedTab(false,this.mJoinGuildTab);
               this.updateSelectedTab(true,this.mCreateGuildTab);
               this.updateSelectedTab(false,this.mTopRankingTab);
               this.updateSelectedTab(false,this.mWeeklyRankingTab);
               this.removeChildrenFromUnselectedSection(this.mGuildInfoContainer);
               this.removeChildrenFromUnselectedSection(this.mGuildRewardsContainer);
               this.removeChildrenFromUnselectedSection(this.mJoinContainer);
               this.removeChildrenFromUnselectedSection(this.mTopRankingContainer);
               this.removeChildrenFromUnselectedSection(this.mWeeklyRankingContainer);
               this.removeChildrenFromUnselectedSection(this.mManageContainer);
               if(this.mCreateGuildTab)
               {
                  this.mCreateGuildTab.disableTemporarily();
               }
               this.createCreateGuildSection();
               break;
            case TOP_RANKING_SECTION:
               this.updateSelectedTab(false,this.mGuildInfoTab);
               this.updateSelectedTab(false,this.mRewardsTab);
               this.updateSelectedTab(false,this.mJoinGuildTab);
               this.updateSelectedTab(false,this.mCreateGuildTab);
               this.updateSelectedTab(true,this.mTopRankingTab);
               this.updateSelectedTab(false,this.mWeeklyRankingTab);
               this.removeChildrenFromUnselectedSection(this.mGuildInfoContainer);
               this.removeChildrenFromUnselectedSection(this.mGuildRewardsContainer);
               this.removeChildrenFromUnselectedSection(this.mJoinContainer);
               this.removeChildrenFromUnselectedSection(this.mCreateGuildContainer);
               this.removeChildrenFromUnselectedSection(this.mWeeklyRankingContainer);
               this.removeChildrenFromUnselectedSection(this.mManageContainer);
               if(this.mTopRankingTab)
               {
                  this.mTopRankingTab.disableTemporarily();
               }
               this.createTopRankingSection();
               break;
            case WEEKLY_RANKING_SECTION:
               this.updateSelectedTab(false,this.mGuildInfoTab);
               this.updateSelectedTab(false,this.mRewardsTab);
               this.updateSelectedTab(false,this.mJoinGuildTab);
               this.updateSelectedTab(false,this.mCreateGuildTab);
               this.updateSelectedTab(false,this.mTopRankingTab);
               this.updateSelectedTab(true,this.mWeeklyRankingTab);
               this.removeChildrenFromUnselectedSection(this.mGuildInfoContainer);
               this.removeChildrenFromUnselectedSection(this.mGuildRewardsContainer);
               this.removeChildrenFromUnselectedSection(this.mJoinContainer);
               this.removeChildrenFromUnselectedSection(this.mCreateGuildContainer);
               this.removeChildrenFromUnselectedSection(this.mTopRankingContainer);
               this.removeChildrenFromUnselectedSection(this.mManageContainer);
               if(this.mWeeklyRankingTab)
               {
                  this.mWeeklyRankingTab.disableTemporarily();
               }
               this.createWeeklyRankingSection();
               break;
            case MANAGE_SECTION:
               this.removeChildrenFromUnselectedSection(this.mGuildInfoContainer);
               this.removeChildrenFromUnselectedSection(this.mGuildRewardsContainer);
               this.removeChildrenFromUnselectedSection(this.mJoinContainer);
               this.removeChildrenFromUnselectedSection(this.mCreateGuildContainer);
               this.removeChildrenFromUnselectedSection(this.mTopRankingContainer);
               this.removeChildrenFromUnselectedSection(this.mWeeklyRankingContainer);
               this.createManageSection();
         }
         if(mCloseButton)
         {
            addChild(mCloseButton);
         }
      }
      
      private function removeChildrenFromUnselectedSection(param1:Component) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      private function updateSelectedTab(param1:Boolean, param2:FSMenuButton) : void
      {
         if(param2)
         {
            if(param1)
            {
               param2.getButton().alpha = 0.99;
               param2.getExtraLeftImage().alpha = 0.99;
               param2.setFontColor(16777215);
            }
            else
            {
               param2.getButton().alpha = 0.5;
               param2.getExtraLeftImage().alpha = 0.5;
               param2.setFontColor(8421504);
            }
         }
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         super.onPopupOpenTransitionOver();
         if(!mClosed)
         {
            SpecialFX.tweenToAlpha(this.mGuildInfoTab,0.999,0.25,0);
            SpecialFX.tweenToAlpha(this.mRewardsTab,0.999,0.45,0);
            SpecialFX.tweenToAlpha(this.mJoinGuildTab,0.999,0.25,0);
            SpecialFX.tweenToAlpha(this.mCreateGuildTab,0.999,0.45,0);
            SpecialFX.tweenToAlpha(this.mTopRankingTab,0.999,0.7,0);
            SpecialFX.tweenToAlpha(this.mWeeklyRankingTab,0.999,1,0);
         }
      }
      
      public function onGuildLeft() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         if(this.mGuildInfoTab)
         {
            this.removeTabButtonFromParent(this.mGuildInfoTab);
         }
         if(this.mRewardsTab)
         {
            this.removeTabButtonFromParent(this.mRewardsTab);
         }
         this.createCreateGuildAndJoinGuildTabs();
         if(this.mJoinGuildTab)
         {
            SpecialFX.tweenToAlpha(this.mJoinGuildTab,0.999,0.2,0);
         }
         if(this.mCreateGuildTab)
         {
            SpecialFX.tweenToAlpha(this.mCreateGuildTab,0.999,0.5,0);
         }
         this.updateSelectedSection(JOIN_SECTION);
      }
      
      public function onRankModifiedExternally() : void
      {
         if(this.mCurrentSectionIndex == INFO_SECTION)
         {
            this.mSelectedGuild = null;
            this.updateSelectedSection(INFO_SECTION);
         }
      }
      
      public function onMemberKicked(param1:String) : void
      {
         if(this.mGuildInfoMembersTextfield)
         {
            this.mSelectedGuild.removeMemberById(param1);
            this.mGuildInfoMembersTextfield.text = TextManager.getText("TID_GUILD_MEMBERS") + " " + this.mSelectedGuild.getMembersAmount() + "/" + GuildsMng.smMaxMembers;
         }
      }
      
      public function getSelectedGuild() : Guild
      {
         return this.mSelectedGuild;
      }
      
      override protected function removeFromStage() : void
      {
         var _loc1_:int = 0;
         if(this.mTopContainer)
         {
            this.mTopContainer.removeFromParent(true);
            this.mTopContainer = null;
         }
         if(this.mJoinGuildTab)
         {
            this.mJoinGuildTab.removeFromParent(true);
            this.mJoinGuildTab = null;
         }
         if(this.mCreateGuildTab)
         {
            this.mCreateGuildTab.removeFromParent(true);
            this.mCreateGuildTab = null;
         }
         if(this.mTopRankingTab)
         {
            this.mTopRankingTab.removeFromParent(true);
            this.mTopRankingTab = null;
         }
         if(this.mWeeklyRankingTab)
         {
            this.mWeeklyRankingTab.removeFromParent(true);
            this.mWeeklyRankingTab = null;
         }
         if(this.mGuildInfoTab)
         {
            this.mGuildInfoTab.removeFromParent(true);
            this.mGuildInfoTab = null;
         }
         if(this.mRewardsTab)
         {
            this.mRewardsTab.removeFromParent(true);
            this.mRewardsTab = null;
         }
         if(this.mJoinContainer)
         {
            this.mJoinContainer.removeFromParent(true);
            this.mJoinContainer = null;
         }
         if(this.mJoinSearchBG)
         {
            this.mJoinSearchBG.removeFromParent(true);
            this.mJoinSearchBG = null;
         }
         if(this.mJoinTextfield)
         {
            this.mJoinTextfield.removeFromParent(true);
            this.mJoinTextfield = null;
         }
         if(this.mJoinSearchTextfield)
         {
            this.mJoinSearchTextfield.removeFromParent(true);
            this.mJoinSearchTextfield = null;
         }
         if(this.mJoinSearchButton)
         {
            this.mJoinSearchButton.removeFromParent(true);
            this.mJoinSearchButton = null;
         }
         if(this.mJoinRefreshButton)
         {
            this.mJoinRefreshButton.removeFromParent(true);
            this.mJoinRefreshButton = null;
         }
         if(this.mJoinGuildScrollContainer)
         {
            this.mJoinGuildScrollContainer.removeFromParent(true);
            this.mJoinGuildScrollContainer = null;
         }
         if(this.mCreateGuildContainer)
         {
            this.mCreateGuildContainer.removeFromParent(true);
            this.mCreateGuildContainer = null;
         }
         if(this.mCreateGuildBG)
         {
            this.mCreateGuildBG.removeFromParent(true);
            this.mCreateGuildBG = null;
         }
         if(this.mCreateGuildChooseNameTextfield)
         {
            this.mCreateGuildChooseNameTextfield.removeFromParent(true);
            this.mCreateGuildChooseNameTextfield = null;
         }
         if(this.mCreateGuildChooseNameTextInput)
         {
            this.mCreateGuildChooseNameTextInput.removeFromParent(true);
            this.mCreateGuildChooseNameTextInput = null;
         }
         if(this.mCreateGuildChooseEmblemTextfield)
         {
            this.mCreateGuildChooseEmblemTextfield.removeFromParent(true);
            this.mCreateGuildChooseEmblemTextfield = null;
         }
         if(this.mCreateGuildEmblemPreview)
         {
            this.mCreateGuildEmblemPreview.removeFromParent(true);
            this.mCreateGuildEmblemPreview = null;
         }
         if(this.mCreateGuildButton)
         {
            this.mCreateGuildButton.removeFromParent(true);
            this.mCreateGuildButton = null;
         }
         if(this.mCreateGuildAccessByInvitationCheckBox)
         {
            this.mCreateGuildAccessByInvitationCheckBox.removeFromParent(true);
            this.mCreateGuildAccessByInvitationCheckBox = null;
         }
         if(this.mCreateGuildChooseEmblemFGTextfield)
         {
            this.mCreateGuildChooseEmblemFGTextfield.removeFromParent(true);
            this.mCreateGuildChooseEmblemFGTextfield = null;
         }
         if(this.mCreateGuildChooseEmblemBGTextfield)
         {
            this.mCreateGuildChooseEmblemBGTextfield.removeFromParent(true);
            this.mCreateGuildChooseEmblemBGTextfield = null;
         }
         if(this.mCreateGuildEmblemBGBrowser)
         {
            this.mCreateGuildEmblemBGBrowser.removeFromParent(true);
            this.mCreateGuildEmblemBGBrowser = null;
         }
         if(this.mGuildInfoContainer)
         {
            this.mGuildInfoContainer.removeFromParent(true);
            this.mGuildInfoContainer = null;
         }
         if(this.mGuildInfoTopBG)
         {
            this.mGuildInfoTopBG.removeFromParent(true);
            this.mGuildInfoTopBG = null;
         }
         if(this.mGuildInfoEmblem)
         {
            this.mGuildInfoEmblem.removeFromParent(true);
            this.mGuildInfoEmblem = null;
         }
         if(this.mGuildInfoNameTextfield)
         {
            this.mGuildInfoNameTextfield.removeFromParent(true);
            this.mGuildInfoNameTextfield = null;
         }
         if(this.mGuildInfoMembersTextfield)
         {
            this.mGuildInfoMembersTextfield.removeFromParent(true);
            this.mGuildInfoMembersTextfield = null;
         }
         if(this.mGuildInfoAccessTypeTextfield)
         {
            this.mGuildInfoAccessTypeTextfield.removeFromParent(true);
            this.mGuildInfoAccessTypeTextfield = null;
         }
         if(this.mGuildInfoTopScore)
         {
            this.mGuildInfoTopScore.removeFromParent(true);
            this.mGuildInfoTopScore = null;
         }
         if(this.mGuildInfoWeeklyScore)
         {
            this.mGuildInfoWeeklyScore.removeFromParent(true);
            this.mGuildInfoWeeklyScore = null;
         }
         if(this.mGuildInfoExtraInfoTextfield)
         {
            this.mGuildInfoExtraInfoTextfield.removeFromParent(true);
            this.mGuildInfoExtraInfoTextfield = null;
         }
         if(this.mGuildInfoManageButton)
         {
            this.mGuildInfoManageButton.removeFromParent(true);
            this.mGuildInfoManageButton = null;
         }
         if(this.mGuildInfoRequestsCounter)
         {
            this.mGuildInfoRequestsCounter.removeFromParent(true);
            this.mGuildInfoRequestsCounter = null;
         }
         if(this.mGuildInfoBackButton)
         {
            this.mGuildInfoBackButton.removeFromParent(true);
            this.mGuildInfoBackButton = null;
         }
         if(this.mGuildInfoMembersSlotsContainer)
         {
            this.mGuildInfoMembersSlotsContainer.removeFromParent(true);
            this.mGuildInfoMembersSlotsContainer = null;
         }
         if(this.mGuildRewardsContainer)
         {
            this.mGuildRewardsContainer.removeFromParent(true);
            this.mGuildRewardsContainer = null;
         }
         if(this.mGuildRewardsTopBG)
         {
            this.mGuildRewardsTopBG.removeFromParent(true);
            this.mGuildRewardsTopBG = null;
         }
         if(this.mGuildRewardsLeftImage)
         {
            this.mGuildRewardsLeftImage.removeFromParent(true);
            this.mGuildRewardsLeftImage = null;
         }
         if(this.mGuildRewardsInfoButton)
         {
            this.mGuildRewardsInfoButton.removeFromParent(true);
            this.mGuildRewardsInfoButton = null;
         }
         if(this.mGuildRewardsTitleTextfield)
         {
            this.mGuildRewardsTitleTextfield.removeFromParent(true);
            this.mGuildRewardsTitleTextfield = null;
         }
         if(this.mGuildRewardsSubtitleTextfield)
         {
            this.mGuildRewardsSubtitleTextfield.removeFromParent(true);
            this.mGuildRewardsSubtitleTextfield = null;
         }
         if(this.mGuildRewardsContainerTitleTextfield)
         {
            this.mGuildRewardsContainerTitleTextfield.removeFromParent(true);
            this.mGuildRewardsContainerTitleTextfield = null;
         }
         if(this.mGuildRewardsDescTextInput)
         {
            if(Utils.isMobile())
            {
               this.mGuildRewardsDescTextInput.removeEventListener(FeathersEventType.ENTER,this.descInputEnterHandler);
            }
            if(!Utils.isMobile())
            {
               this.mGuildRewardsDescTextInput.removeEventListener(FeathersEventType.FOCUS_OUT,this.descInputFocusOutHandler);
            }
            this.mGuildRewardsDescTextInput.removeFromParent(true);
            this.mGuildRewardsDescTextInput = null;
         }
         if(this.mGuildRewardsEditButton)
         {
            this.mGuildRewardsEditButton.removeFromParent(true);
            this.mGuildRewardsEditButton = null;
         }
         if(this.mGuildRewardsInfoTextfield)
         {
            this.mGuildRewardsInfoTextfield.removeFromParent(true);
            this.mGuildRewardsInfoTextfield = null;
         }
         if(this.mGuildRewardsInfoImage)
         {
            this.mGuildRewardsInfoImage.removeFromParent(true);
            this.mGuildRewardsInfoImage = null;
         }
         if(this.mTopRankingContainer)
         {
            this.mTopRankingContainer.removeFromParent(true);
            this.mTopRankingContainer = null;
         }
         if(this.mTopRankingTopBG)
         {
            this.mTopRankingTopBG.removeFromParent(true);
            this.mTopRankingTopBG = null;
         }
         if(this.mTopRankingTitleTextfield)
         {
            this.mTopRankingTitleTextfield.removeFromParent(true);
            this.mTopRankingTitleTextfield = null;
         }
         if(this.mTopRankingGuildEventPanel)
         {
            this.mTopRankingGuildEventPanel.removeFromParent(true);
            this.mTopRankingGuildEventPanel = null;
         }
         if(this.mTopRankingTopPvPGuildTextfield)
         {
            this.mTopRankingTopPvPGuildTextfield.removeFromParent(true);
            this.mTopRankingTopPvPGuildTextfield = null;
         }
         if(this.mTopRankingTopDungeonGuildTextfield)
         {
            this.mTopRankingTopDungeonGuildTextfield.removeFromParent(true);
            this.mTopRankingTopDungeonGuildTextfield = null;
         }
         if(this.mTopRankingTopWeeklyScoreTextfield)
         {
            this.mTopRankingTopWeeklyScoreTextfield.removeFromParent(true);
            this.mTopRankingTopWeeklyScoreTextfield = null;
         }
         if(this.mTopRankingTopContributorPlayerTextfield)
         {
            this.mTopRankingTopContributorPlayerTextfield.removeFromParent(true);
            this.mTopRankingTopContributorPlayerTextfield = null;
         }
         if(this.mTopRankingGuildsSlotsContainer)
         {
            this.mTopRankingGuildsSlotsContainer.removeFromParent(true);
            this.mTopRankingGuildsSlotsContainer = null;
         }
         if(this.mWeeklyRankingContainer)
         {
            this.mWeeklyRankingContainer.removeFromParent(true);
            this.mWeeklyRankingContainer = null;
         }
         if(this.mWeeklyRankingTopBG)
         {
            this.mWeeklyRankingTopBG.removeFromParent(true);
            this.mWeeklyRankingTopBG = null;
         }
         if(this.mWeeklyRankingLeftImage)
         {
            this.mWeeklyRankingLeftImage.removeFromParent(true);
            this.mWeeklyRankingLeftImage = null;
         }
         if(this.mWeeklyRankingTitleTextfield)
         {
            this.mWeeklyRankingTitleTextfield.removeFromParent(true);
            this.mWeeklyRankingTitleTextfield = null;
         }
         if(this.mWeeklyRankingSubtitleTextfield)
         {
            this.mWeeklyRankingSubtitleTextfield.removeFromParent(true);
            this.mWeeklyRankingSubtitleTextfield = null;
         }
         if(this.mWeeklyRankingGuildEventPanel)
         {
            this.mWeeklyRankingGuildEventPanel.removeFromParent(true);
            this.mWeeklyRankingGuildEventPanel = null;
         }
         if(this.mWeeklyRankingEventStartingTextfield)
         {
            this.mWeeklyRankingEventStartingTextfield.removeFromParent(true);
            this.mWeeklyRankingEventStartingTextfield = null;
         }
         if(this.mWeeklyRankingEventStartingDescTextfield)
         {
            this.mWeeklyRankingEventStartingDescTextfield.removeFromParent(true);
            this.mWeeklyRankingEventStartingDescTextfield = null;
         }
         if(this.mWeeklyRankingGuildsSlotsContainer)
         {
            this.mWeeklyRankingGuildsSlotsContainer.removeFromParent(true);
            this.mWeeklyRankingGuildsSlotsContainer = null;
         }
         if(this.mManageContainer)
         {
            this.mManageContainer.removeFromParent(true);
            this.mManageContainer = null;
         }
         if(this.mManageTopBG)
         {
            this.mManageTopBG.removeFromParent(true);
            this.mManageTopBG = null;
         }
         if(this.mManageEmblem)
         {
            this.mManageEmblem.removeFromParent(true);
            this.mManageEmblem = null;
         }
         if(this.mManageNameTextfield)
         {
            this.mManageNameTextfield.removeFromParent(true);
            this.mManageNameTextfield = null;
         }
         if(this.mManageMembersTextfield)
         {
            this.mManageMembersTextfield.removeFromParent(true);
            this.mManageMembersTextfield = null;
         }
         if(this.mManageAccessTypeTextfield)
         {
            this.mManageAccessTypeTextfield.removeFromParent(true);
            this.mManageAccessTypeTextfield = null;
         }
         if(this.mManageTopScore)
         {
            this.mManageTopScore.removeFromParent(true);
            this.mManageTopScore = null;
         }
         if(this.mManageWeeklyScore)
         {
            this.mManageWeeklyScore.removeFromParent(true);
            this.mManageWeeklyScore = null;
         }
         if(this.mManageMemberInfoTextfield)
         {
            this.mManageMemberInfoTextfield.removeFromParent(true);
            this.mManageMemberInfoTextfield = null;
         }
         if(this.mManageBackButton)
         {
            this.mManageBackButton.removeFromParent(true);
            this.mManageBackButton = null;
         }
         if(this.mManageAccessByInvitationCheckBox)
         {
            this.mManageAccessByInvitationCheckBox.removeFromParent(true);
            this.mManageAccessByInvitationCheckBox = null;
         }
         if(this.mManageEmblemFGBrowser)
         {
            this.mManageEmblemFGBrowser.removeFromParent(true);
            this.mManageEmblemFGBrowser = null;
         }
         if(this.mManageEmblemBGBrowser)
         {
            this.mManageEmblemBGBrowser.removeFromParent(true);
            this.mManageEmblemBGBrowser = null;
         }
         if(this.mManageEmblemPayButton)
         {
            this.mManageEmblemPayButton.removeFromParent(true);
            this.mManageEmblemPayButton = null;
         }
         if(this.mManageRequestsTextfield)
         {
            this.mManageRequestsTextfield.removeFromParent(true);
            this.mManageRequestsTextfield = null;
         }
         if(this.mManageRequestsContainer)
         {
            this.mManageRequestsContainer.removeFromParent(true);
            this.mManageRequestsContainer = null;
         }
         if(this.mManageNoRequestsFoundTextfield)
         {
            this.mManageNoRequestsFoundTextfield.removeFromParent(true);
            this.mManageNoRequestsFoundTextfield = null;
         }
         if(this.mManageLeaveGuildTextfield)
         {
            this.mManageLeaveGuildTextfield.removeFromParent(true);
            this.mManageLeaveGuildTextfield = null;
         }
         if(this.mManageLeaveGuildButton)
         {
            this.mManageLeaveGuildButton.removeFromParent(true);
            this.mManageLeaveGuildButton = null;
         }
         this.mSelectedGuild = null;
         if(this.mGuilds)
         {
            Utils.destroyArray(this.mGuilds);
            this.mGuilds = null;
         }
         if(this.mGuildSlots)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mGuildSlots.length)
            {
               this.mGuildSlots[_loc1_].removeFromParent(true);
               _loc1_++;
            }
            Utils.destroyArray(this.mGuildSlots);
            this.mGuildSlots = null;
         }
         if(this.mGuildInfoMembersVector)
         {
            Utils.destroyArray(this.mGuildInfoMembersVector);
            this.mGuildInfoMembersVector = null;
         }
         if(this.mGuildInfoMembersSlotsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mGuildInfoMembersSlotsVector.length)
            {
               this.mGuildInfoMembersSlotsVector[_loc1_].removeFromParent(true);
               _loc1_++;
            }
            Utils.destroyArray(this.mGuildInfoMembersSlotsVector);
            this.mGuildInfoMembersSlotsVector = null;
         }
         if(this.mTopRankingGuildsVector)
         {
            Utils.destroyArray(this.mTopRankingGuildsVector);
            this.mTopRankingGuildsVector = null;
         }
         if(this.mTopRankingGuildsSlotsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mTopRankingGuildsSlotsVector.length)
            {
               this.mTopRankingGuildsSlotsVector[_loc1_].removeFromParent(true);
               _loc1_++;
            }
            Utils.destroyArray(this.mTopRankingGuildsSlotsVector);
            this.mTopRankingGuildsSlotsVector = null;
         }
         if(this.mWeeklyRankingGuildsVector)
         {
            Utils.destroyArray(this.mWeeklyRankingGuildsVector);
            this.mWeeklyRankingGuildsVector = null;
         }
         if(this.mWeeklyRankingGuildsSlotsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mWeeklyRankingGuildsSlotsVector.length)
            {
               this.mWeeklyRankingGuildsSlotsVector[_loc1_].removeFromParent(true);
               _loc1_++;
            }
            Utils.destroyArray(this.mWeeklyRankingGuildsSlotsVector);
            this.mWeeklyRankingGuildsSlotsVector = null;
         }
         if(this.mManageRequestsVector)
         {
            Utils.destroyArray(this.mManageRequestsVector);
            this.mManageRequestsVector = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.GUILDS_POPUP_NAME);
         removeChildren(0,-1);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.removeFromStage();
      }
      
      override public function onClose(param1:Event) : void
      {
         super.onClose(param1);
         mOnClosedFunction = InstanceMng.getApplication().openGuildsPanel;
      }
   }
}

