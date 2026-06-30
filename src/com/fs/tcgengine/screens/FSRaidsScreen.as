package com.fs.tcgengine.screens
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.BoostsMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.BattleEventDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.RaidDef;
   import com.fs.tcgengine.model.rules.RaidLevelDef;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSGoldVisor;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.misc.FSBattleEventInfo;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.raids.FSRaidBoss;
   import com.fs.tcgengine.view.raids.FSRaidCompleteInfo;
   import com.fs.tcgengine.view.raids.FSRaidSlotDifficultyInfo;
   import com.fs.tcgengine.view.raids.FSRaidSlotInfo;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalLayout;
   import flash.utils.Dictionary;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class FSRaidsScreen extends Screen
   {
      
      private const TICKET_SINGLE_PLAYER_BG:String = "raid_ticket_sp_counter";
      
      private const TICKET_MULTI_PLAYER_BG:String = "raid_ticket_mp_counter";
      
      private const TIMER_LAYER:String = "raid_timer_layer";
      
      private const TIMER_TICKET_IMG:String = "raid_timer_tickets";
      
      private const TIMER_RAID_IMG:String = "raid_timer_reset";
      
      private var mLeftContainer:Component;
      
      private var mLeftPanelImage:FSImage;
      
      private var mRightContainer:Component;
      
      private var mRightPanelImage:CustomComponent;
      
      private var mGoldVisor:FSGoldVisor;
      
      private var mChooseMissionImage:FSImage;
      
      private var mChooseMissionTextfield:FSTextfield;
      
      private var mRaidsScrollContainer:ScrollContainer;
      
      private var mRaidsSlots:Vector.<FSRaidSlotInfo>;
      
      private var mRaidImageXL:FSImage;
      
      private var mRaidImageSeparator:FSImage;
      
      private var mRaidDescriptionPanel:FSImage;
      
      private var mSelectedRaidDef:RaidDef;
      
      private var mChooseButton:FSButton;
      
      private var mInfoButton:FSButton;
      
      private var mCurrentDifficultySelected:int = -1;
      
      private var mRewardsBG:Quad;
      
      private var mBattlesEventBG:Quad;
      
      private var mBattlesAmountBG:Quad;
      
      private var mBattlesAmountTextfield:FSTextfield;
      
      private var mGoldReward:FSButton;
      
      private var mPacksReward:FSButton;
      
      private var mPackImage:PackAnimation;
      
      private var mPackImageTextfield:FSTextfield;
      
      private var mRaidCoinReward:FSButton;
      
      private var mLadderButton:FSButton;
      
      private var mLadderTextfield:FSTextfield;
      
      private var mLadderRaidStatusActive:Boolean = false;
      
      private var mServerResponseReceived:Boolean = false;
      
      private var mTicketsCounterSPImage:FSButton;
      
      private var mTicketsCounterMPImage:FSButton;
      
      private var mTicketsCounterSPTextfield:FSTextfield;
      
      private var mTicketsCounterMPTextfield:FSTextfield;
      
      private var mRaidBoss:FSRaidBoss;
      
      private var mBattleEventInfo:FSBattleEventInfo;
      
      private var mRaidCompleteInfo:FSRaidCompleteInfo;
      
      private var mRaidIncompleteInfo:FSRaidCompleteInfo;
      
      private var mTimerTicketsLayer:FSImage;
      
      private var mTimerTicketsImage:FSImage;
      
      private var mTimerTicketsTextfield:FSTextfield;
      
      private var mTimerRaidLayer:FSImage;
      
      private var mTimerRaidImage:FSImage;
      
      private var mTimerRaidTextfield:FSTextfield;
      
      private var mRecommendedTextfield:FSTextfield;
      
      private var mRecommendedNumbertextfield:FSTextfield;
      
      private var mGuildSizeTextfield:FSTextfield;
      
      private var mRaidDefArray:Array;
      
      private var mPortraitReward:FSButton;
      
      private var mSkinReward:FSButton;
      
      private var mRaidsConfigReceived:Boolean = false;
      
      public var mUICreated:Boolean = false;
      
      public function FSRaidsScreen()
      {
         mNeedsLoadingBar = true;
         mBGName = Constants.RAIDS_BG_NAME;
         mScreenName = Constants.RAIDS_SCREEN_NAME;
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
         InstanceMng.getResourcesMng().addResourcesFolderByName("framesFactionsRarities");
         if(Config.getConfig().cardsHaveCustomAuras())
         {
            InstanceMng.getResourcesMng().addResourcesFolderByName("anims/animAuras");
         }
         InstanceMng.getResourcesMng().loadAssets();
      }
      
      override public function notifyAssetsLoaded(param1:* = null) : void
      {
         InstanceMng.getRaidsMng().resetRaidsMng(false,false);
         super.notifyAssetsLoaded();
         InstanceMng.getRaidsMng().getRaidsConfiguration();
         if(this.mRaidsConfigReceived)
         {
            this.createUI();
         }
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
      
      public function setRaidsConfigAsReceived(param1:Boolean) : void
      {
         this.mRaidsConfigReceived = param1;
         if(this.mRaidsConfigReceived)
         {
            this.createUI();
         }
      }
      
      private function createUI() : void
      {
         if(!this.mUICreated && !Root.assets.isLoading && isFullyLoaded())
         {
            this.createLeftSection();
            this.createLadderButton();
            this.createRightSection();
            this.createChooseButton();
            this.createInfoButton();
            this.createTimers();
            this.refreshTimers();
            this.mUICreated = true;
         }
      }
      
      private function refreshTimers() : void
      {
         if(Boolean(this.mTimerTicketsLayer && this.mTimerTicketsImage && this.mTimerTicketsTextfield && this.mTimerRaidLayer) && Boolean(this.mTimerRaidImage) && Boolean(this.mTimerTicketsTextfield))
         {
            this.mTimerTicketsTextfield.text = Utils.getDailyKeyTimeResetText();
            this.mTimerRaidTextfield.text = InstanceMng.getRaidsMng().getWeeklySeasonTimeLeft();
            this.mTimerRaidTextfield.fontName = InstanceMng.getRaidsMng().isWeeklySeasonActive() ? FSResourceMng.getFontByType() : FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
            TweenMax.delayedCall(1,this.refreshTimers);
         }
         else
         {
            this.createTimers();
            TweenMax.delayedCall(5,this.refreshTimers);
         }
      }
      
      private function createTimers() : void
      {
         if(this.mTimerTicketsLayer == null && this.mTicketsCounterMPImage != null)
         {
            this.mTimerTicketsLayer = new FSImage(Root.assets.getTexture(this.TIMER_LAYER));
            this.mTimerTicketsLayer.x = this.mTicketsCounterMPImage.x + this.mTicketsCounterMPImage.width / 1.25;
            this.mTimerTicketsLayer.y = this.mTicketsCounterMPImage.y - this.mTicketsCounterMPImage.height / 2;
            addChild(this.mTimerTicketsLayer);
         }
         if(Boolean(this.mTimerTicketsLayer) && this.mTimerRaidLayer == null)
         {
            this.mTimerRaidLayer = new FSImage(Root.assets.getTexture(this.TIMER_LAYER));
            this.mTimerRaidLayer.x = this.mTimerTicketsLayer.x + this.mTimerTicketsLayer.width * 1.05;
            this.mTimerRaidLayer.y = this.mTimerTicketsLayer.y;
            addChild(this.mTimerRaidLayer);
         }
         if(Boolean(this.mTimerTicketsLayer) && this.mTimerTicketsImage == null)
         {
            this.mTimerTicketsImage = new FSImage(Root.assets.getTexture(this.TIMER_TICKET_IMG));
            this.mTimerTicketsImage.x = this.mTimerTicketsLayer.x;
            this.mTimerTicketsImage.y = this.mTimerTicketsLayer.y;
            this.mTimerTicketsImage.setTooltipText(TextManager.getText("TID_RAID_INFO_RESET_TICKETS"));
            this.mTimerTicketsImage.addEventListener(TouchEvent.TOUCH,this.onTimerTicketsTouch);
            addChild(this.mTimerTicketsImage);
         }
         if(Boolean(this.mTimerRaidLayer) && this.mTimerRaidImage == null)
         {
            this.mTimerRaidImage = new FSImage(Root.assets.getTexture(this.TIMER_RAID_IMG));
            this.mTimerRaidImage.x = this.mTimerRaidLayer.x;
            this.mTimerRaidImage.y = this.mTimerRaidLayer.y;
            this.mTimerRaidImage.setTooltipText(TextManager.getText("TID_RAID_INFO_RESET_RAIDS"));
            this.mTimerRaidImage.addEventListener(TouchEvent.TOUCH,this.onTimerRaidTouch);
            addChild(this.mTimerRaidImage);
         }
         if(Boolean(this.mTimerTicketsLayer) && Boolean(this.mTimerTicketsImage) && this.mTimerTicketsTextfield == null)
         {
            this.mTimerTicketsTextfield = new FSTextfield(this.mTimerTicketsLayer.width,this.mTimerTicketsLayer.height,Utils.getDailyKeyTimeResetText());
            this.mTimerTicketsTextfield.x = this.mTimerTicketsLayer.x + this.mTimerTicketsImage.width * 0.6;
            this.mTimerTicketsTextfield.y = this.mTimerTicketsLayer.y;
            addChild(this.mTimerTicketsTextfield);
         }
         if(Boolean(this.mTimerRaidLayer) && Boolean(this.mTimerRaidImage) && this.mTimerRaidTextfield == null)
         {
            this.mTimerRaidTextfield = new FSTextfield(this.mTimerRaidLayer.width,this.mTimerRaidLayer.height,InstanceMng.getRaidsMng().getWeeklySeasonTimeLeft());
            this.mTimerRaidTextfield.x = this.mTimerRaidLayer.x + this.mTimerRaidImage.width * 0.6;
            this.mTimerRaidTextfield.y = this.mTimerRaidLayer.y;
            addChild(this.mTimerRaidTextfield);
         }
      }
      
      private function onTimerRaidTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mTimerRaidImage);
         if(_loc2_)
         {
            this.mTimerRaidImage.showTooltip();
         }
         else
         {
            this.mTimerRaidImage.closeTooltip();
         }
      }
      
      private function onTimerTicketsTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mTimerTicketsImage);
         if(_loc2_)
         {
            this.mTimerTicketsImage.showTooltip();
         }
         else
         {
            this.mTimerTicketsImage.closeTooltip();
         }
      }
      
      private function createLadderButton() : void
      {
         if(this.mLadderButton == null)
         {
            this.mLadderButton = new FSButton(Root.assets.getTexture("raid_info_switch_button"));
            this.mLadderButton.touchable = true;
            Utils.alignComponentAndFixPosition(this.mLadderButton);
            this.mLadderButton.x = this.mLeftContainer.x + this.mLeftPanelImage.x - this.mLadderButton.width / 3;
            this.mLadderButton.y = this.mLeftContainer.y + this.mLeftPanelImage.y + this.mLadderButton.height;
            this.mLadderButton.visible = false;
            this.mLadderButton.addEventListener(Event.TRIGGERED,this.onLadderButtonTriggered);
            addChild(this.mLadderButton);
         }
         if(this.mLadderTextfield == null)
         {
            this.mLadderTextfield = new FSTextfield(this.mLadderButton.width,24,TextManager.getText("TID_RAID_STATUS"));
            Utils.alignComponentAndFixPosition(this.mLadderTextfield);
            this.mLadderTextfield.touchable = false;
            this.mLadderTextfield.alignPivot();
            this.mLadderTextfield.x = this.mLadderButton.x;
            this.mLadderTextfield.y = this.mLadderButton.y;
            this.mLadderTextfield.visible = false;
            addChild(this.mLadderTextfield);
         }
      }
      
      private function onLadderButtonTriggered(param1:Event) : void
      {
         if(Boolean(InstanceMng.getGuildsMng() && InstanceMng.getGuildsMng().getMyGuild() && InstanceMng.getGuildsMng().getMyGuild().isGuildInfoMemberOk() && this.mSelectedRaidDef) && Boolean(this.mSelectedRaidDef.getIsMultiPlayer()) || Boolean(this.mSelectedRaidDef) && Boolean(!this.mSelectedRaidDef.getIsMultiPlayer()))
         {
            this.changeNameLadder();
            this.createRaidIncompleteInfo();
         }
         else if(InstanceMng.getGuildsMng())
         {
            if(InstanceMng.getGuildsMng().getMyGuild())
            {
               InstanceMng.getGuildsMng().getMyGuild().refreshGuildMembersInfo();
            }
         }
      }
      
      public function changeNameLadder() : void
      {
         if(this.mLadderRaidStatusActive)
         {
            this.mLadderRaidStatusActive = false;
            this.mLadderTextfield.text = TextManager.getText("TID_RAID_STATUS");
         }
         else
         {
            this.mLadderRaidStatusActive = true;
            this.mLadderTextfield.text = TextManager.getText("TID_RAID_INFO");
         }
      }
      
      private function createRaidIncompleteInfo() : void
      {
         if(this.mRaidIncompleteInfo == null)
         {
            this.mRaidIncompleteInfo = new FSRaidCompleteInfo(this.mSelectedRaidDef.getSku(),this.mCurrentDifficultySelected,false);
            this.mRaidIncompleteInfo.x = this.mRaidImageXL.parent.x + this.mRaidImageXL.x + (this.mRaidImageXL.width - this.mRaidIncompleteInfo.width) / 2;
            this.mRaidIncompleteInfo.y = this.mRaidImageXL.parent.y + this.mRaidImageXL.y;
            addChild(this.mRaidIncompleteInfo);
         }
         else
         {
            this.mRaidIncompleteInfo.removeFromParent();
            this.mRaidIncompleteInfo = null;
         }
         if(Boolean(this.mLadderButton) && Boolean(this.mLadderTextfield))
         {
            addChild(this.mLadderButton);
            addChild(this.mLadderTextfield);
         }
      }
      
      private function createInfoButton() : void
      {
         if(Boolean(this.mInfoButton == null) && Boolean(this.mLeftContainer) && Boolean(this.mLeftPanelImage))
         {
            this.mInfoButton = new FSButton(Root.assets.getTexture("dungeon_info_button"));
            this.mInfoButton.x = this.mLeftContainer.x;
            this.mInfoButton.y = this.mLeftContainer.y + this.mLeftPanelImage.height;
            this.mInfoButton.scaleWhenDown = 1;
            this.mInfoButton.enableScaleOnMouseOver(false);
            this.mInfoButton.setTooltipText(TextManager.getText("TID_RAID_INFO_BUTTON"));
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
      
      public function createRightSection() : void
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
         this.mRightContainer.y = this.mLeftContainer ? this.mLeftContainer.y + this.mLeftPanelImage.y : width - this.mRightContainer.width;
         this.createChooseMissionNameSection();
         this.createRaidsScrollContainer();
         this.createGoldVisor(true);
         if(this.mRaidDefArray)
         {
            this.mRaidDefArray.length = 0;
            this.mRaidDefArray = null;
         }
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
      
      private function onServerTimeACK(param1:Object) : void
      {
         if(!this.mServerResponseReceived)
         {
            this.mServerResponseReceived = true;
            showLoadingIcon(false,false);
            this.payAndProceed();
         }
      }
      
      private function onChooseTriggered() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:UserData = null;
         if(this.mSelectedRaidDef != null && this.mCurrentDifficultySelected != -1)
         {
            if(InstanceMng.getUserDataMng().getOwnerUserData())
            {
               _loc1_ = this.mSelectedRaidDef.getIsMultiPlayer();
               _loc2_ = Utils.getOwnerUserData();
               if(_loc1_ && !InstanceMng.getUserDataMng().getOwnerUserData().hasGuild())
               {
                  Utils.setLogText(TextManager.getText("TID_RAID_GUILD_REQUIRED"),true);
                  return;
               }
            }
            if(InstanceMng.getServerConnection().isUserLoggedIn())
            {
               this.mChooseButton.enabled = false;
               this.mServerResponseReceived = false;
               this.enableRightPanel(false);
               showLoadingIcon(true,false);
               InstanceMng.getServerConnection().getServerTime(this.onServerTimeACK);
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_GEN_LOG_NEEDED"));
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_DUNGEON_DIFFICULTY_REQUIRED"));
         }
      }
      
      private function payAndProceed() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:UserData = null;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         if(Boolean(this.mSelectedRaidDef) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) && (InstanceMng.getUserDataMng().getOwnerUserData().isUnlockedRaid(this.mSelectedRaidDef.getSku()) || !this.mSelectedRaidDef.getIsMultiPlayer()))
         {
            _loc1_ = this.mSelectedRaidDef.getIsMultiPlayer();
            _loc2_ = Utils.getOwnerUserData();
            _loc3_ = _loc1_ ? _loc2_.getRaidTicketsMultiPlayer() : _loc2_.getRaidTicketsSinglePlayer();
            _loc4_ = this.mSelectedRaidDef.getKeyCostByDifficultyIndex(this.mCurrentDifficultySelected);
            _loc5_ = InstanceMng.getRaidsMng().isBossDefeated(this.mSelectedRaidDef,this.mCurrentDifficultySelected);
            if(!_loc5_)
            {
               if(_loc1_ && InstanceMng.getUserDataMng().getOwnerUserData().hasGuild() || !_loc1_)
               {
                  if(_loc3_ > 0)
                  {
                     this.mChooseButton.enabled = false;
                     if(_loc3_ >= _loc4_)
                     {
                        this.enableRightPanel(false);
                        this.cleanScrollContainer(this.onRaidsContainerEmpty);
                     }
                     else
                     {
                        Utils.setLogText(TextManager.getText("TID_RAID_ENOUGH_TICKETS"),true);
                        if(_loc1_)
                        {
                           this.onTicketMPClick();
                        }
                        else
                        {
                           this.onTicketSPClick();
                        }
                     }
                  }
                  else
                  {
                     Utils.setLogText(TextManager.getText("TID_RAID_ENOUGH_TICKETS"),true);
                     this.mChooseButton.enabled = true;
                     this.enableRightPanel(true);
                     if(_loc1_)
                     {
                        this.onTicketMPClick();
                     }
                     else
                     {
                        this.onTicketSPClick();
                     }
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_RAID_GUILD_REQUIRED"),true);
                  this.mChooseButton.enabled = true;
               }
            }
            else
            {
               this.mChooseButton.enabled = true;
            }
         }
      }
      
      public function updateTicketsRaidMultiplayerTextfield(param1:Boolean = false, param2:uint = 65280) : void
      {
         if(Boolean(this.mTicketsCounterMPTextfield) && Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            this.mTicketsCounterMPTextfield.text = InstanceMng.getUserDataMng().getOwnerUserData().getRaidTicketsMultiPlayer().toString() + "/" + Config.getConfig().getRaidTicketsMultiPlayer().value.toString();
         }
         if(Boolean(param1 && this.mTicketsCounterMPTextfield) && Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            InstanceMng.getTextParticlesMng().showTextParticle("+ " + InstanceMng.getUserDataMng().getOwnerUserData().getRaidTicketsMultiPlayer().toString(),param2,this.mTicketsCounterMPTextfield);
         }
      }
      
      public function updateTicketsRaidSingleplayerTextfield(param1:Boolean = false, param2:uint = 65280) : void
      {
         if(Boolean(this.mTicketsCounterSPTextfield) && Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            this.mTicketsCounterSPTextfield.text = InstanceMng.getUserDataMng().getOwnerUserData().getRaidTicketsSinglePlayer().toString() + "/" + Config.getConfig().getRaidTicketsSinglePlayer().value.toString();
         }
         if(Boolean(param1 && this.mTicketsCounterSPTextfield) && Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            InstanceMng.getTextParticlesMng().showTextParticle("+ " + InstanceMng.getUserDataMng().getOwnerUserData().getRaidTicketsSinglePlayer().toString(),param2,this.mTicketsCounterSPTextfield);
         }
      }
      
      private function fillScrollContainer() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Dictionary = null;
         var _loc3_:RaidDef = null;
         var _loc4_:int = 0;
         if(InstanceMng.getServerConnection().isUserLoggedIn() && Config.smRaidsAvailables != null && Config.smRaidsAvailables != "")
         {
            _loc1_ = Config.smRaidsAvailables.split(",");
            _loc2_ = InstanceMng.getRaidsDefMng().getDefsBySkuArray(_loc1_);
         }
         if(_loc2_)
         {
            for each(_loc3_ in _loc2_)
            {
               if(this.mRaidDefArray == null)
               {
                  this.mRaidDefArray = new Array();
               }
               this.mRaidDefArray.push(_loc3_);
            }
            if(Boolean(this.mRaidDefArray) && this.mRaidDefArray.length > 0)
            {
               this.mRaidDefArray.sort(DictionaryUtils.sortByIndexAsc);
            }
            if(Boolean(this.mRaidDefArray) && this.mRaidDefArray.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < this.mRaidDefArray.length)
               {
                  this.createRaidSlot(_loc4_);
                  this.fillInfoByRaid(RaidDef(this.mRaidDefArray[_loc4_]),null,_loc4_ == 0);
                  _loc4_++;
               }
            }
         }
         if(this.mRaidsScrollContainer)
         {
            this.mRaidsScrollContainer.validate();
            this.mRaidsScrollContainer.x = (this.mRightContainer.width - this.mRaidsScrollContainer.width) / 2;
         }
      }
      
      public function createRaidSlot(param1:int) : void
      {
         var _loc2_:FSRaidSlotInfo = null;
         if(Boolean(this.mRaidDefArray) && Boolean(this.mRaidDefArray.length > 0) && param1 < this.mRaidDefArray.length)
         {
            _loc2_ = new FSRaidSlotInfo(RaidDef(this.mRaidDefArray[param1]).getSku(),param1);
            this.addRaidToContainer(_loc2_);
         }
      }
      
      private function addRaidToContainer(param1:FSRaidSlotInfo) : void
      {
         if(param1)
         {
            if(this.mRaidsScrollContainer)
            {
               this.mRaidsScrollContainer.addChild(param1);
               if(this.mRaidsSlots == null)
               {
                  this.mRaidsSlots = new Vector.<FSRaidSlotInfo>();
               }
               this.mRaidsSlots.push(param1);
            }
         }
      }
      
      private function createRaidsScrollContainer() : void
      {
         if(Boolean(this.mRaidsScrollContainer == null) && Boolean(this.mRightPanelImage) && Boolean(this.mChooseMissionTextfield))
         {
            this.mRaidsScrollContainer = new ScrollContainer();
            this.mRaidsScrollContainer.layout = this.getContainerLayout();
            this.mRaidsScrollContainer.height = this.mRightPanelImage.height * 0.72;
            this.mRaidsScrollContainer.y = this.mChooseMissionTextfield.y + this.mChooseMissionTextfield.height * 1.25;
            this.mRightContainer.addChild(this.mRaidsScrollContainer);
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
         if(Boolean(this.mGoldVisor == null) && Boolean(mBackButton) && Boolean(this.mRightContainer))
         {
            this.mGoldVisor = new FSGoldVisor("gold_button_DB","",param1);
            this.mGoldVisor.x = mBackButton.x - this.mGoldVisor.width;
            this.mGoldVisor.y = this.mGoldVisor.height / 2;
            addChild(this.mGoldVisor);
         }
      }
      
      private function createChooseMissionNameSection() : void
      {
         if(this.mChooseMissionImage == null && Boolean(this.mRightContainer))
         {
            this.mChooseMissionImage = new FSImage(Root.assets.getTexture("dungeon_right_name"));
            this.mChooseMissionImage.x = (this.mRightContainer.width - this.mChooseMissionImage.width) / 2;
            this.mChooseMissionImage.y = this.mChooseMissionImage.height * 0.2;
            this.mRightContainer.addChild(this.mChooseMissionImage);
         }
         if(this.mChooseMissionTextfield == null && Boolean(this.mChooseMissionImage))
         {
            this.mChooseMissionTextfield = new FSTextfield(this.mChooseMissionImage.width,this.mChooseMissionImage.height,TextManager.getText("TID_RAID_CHOOSE"));
            this.mChooseMissionTextfield.x = this.mChooseMissionImage.x;
            this.mChooseMissionTextfield.y = this.mChooseMissionImage.y;
            this.mRightContainer.addChild(this.mChooseMissionTextfield);
         }
      }
      
      public function getRaidsScrollContainer() : ScrollContainer
      {
         return this.mRaidsScrollContainer;
      }
      
      public function fillInfoByRaid(param1:RaidDef, param2:FSRaidSlotInfo, param3:Boolean = true) : void
      {
         if(this.mSelectedRaidDef == null || this.mSelectedRaidDef.getSku() != param1.getSku())
         {
            this.mSelectedRaidDef = param1;
            if(Boolean(this.mSelectedRaidDef) && param3)
            {
               this.createLeftSection();
               this.createRaidTicketsCounters();
               this.createRaidTicketsTextfield();
               this.createRaidImage();
               this.createRaidOwnerInfoSection();
               this.collapseUnselectedRaids(param2);
            }
         }
         this.onDifficultySelected(-1);
      }
      
      private function createRaidTicketsTextfield() : void
      {
         this.createTicketSinglePlayerTextfield();
         this.createTicketMultiPlayerTextfield();
      }
      
      private function createTicketSinglePlayerTextfield() : void
      {
         if(Boolean(this.mTicketsCounterSPImage) && this.mTicketsCounterSPTextfield == null)
         {
            this.mTicketsCounterSPTextfield = new FSTextfield(this.mTicketsCounterSPImage.width * 0.6,this.mTicketsCounterSPImage.height,"0/0");
            this.mTicketsCounterSPTextfield.x = this.mTicketsCounterSPImage.x - this.mTicketsCounterSPImage.width * 0.3;
            this.mTicketsCounterSPTextfield.y = this.mTicketsCounterSPImage.y - this.mTicketsCounterSPImage.height * 0.5;
            if(InstanceMng.getUserDataMng().getOwnerUserData())
            {
               this.mTicketsCounterSPTextfield.text = InstanceMng.getUserDataMng().getOwnerUserData().getRaidTicketsSinglePlayer().toString() + "/" + Config.getConfig().getRaidTicketsSinglePlayer().value.toString();
            }
            addChild(this.mTicketsCounterSPTextfield);
         }
      }
      
      public function updateRaidTicketVisors() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_)
         {
            if(this.mTicketsCounterSPTextfield)
            {
               this.mTicketsCounterSPTextfield.text = _loc1_.getRaidTicketsSinglePlayer().toString() + "/" + Config.getConfig().getRaidTicketsSinglePlayer().value.toString();
            }
            if(this.mTicketsCounterMPTextfield)
            {
               this.mTicketsCounterMPTextfield.text = _loc1_.getRaidTicketsMultiPlayer().toString() + "/" + Config.getConfig().getRaidTicketsMultiPlayer().value.toString();
            }
         }
      }
      
      private function onTicketSPClick() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:ShopBoostDef = null;
         var _loc3_:FSShopItem = null;
         var _loc4_:Popup = null;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getRaidTicketsSinglePlayer() == 0;
         }
         if(!_loc1_)
         {
            Utils.setLogText(TextManager.getText("TID_RAID_TICKETS_UNSPEND"));
         }
         else
         {
            _loc2_ = ShopBoostDef(InstanceMng.getShopBoostsDefMng().getShopBoostDefByKeyname(BoostsMng.BOOST_ID_RESET_TECKETS_RAID_SINGLE_PLAYER));
            if(_loc2_ != null)
            {
               _loc3_ = new FSShopItem(_loc2_,false,null,true);
               _loc4_ = InstanceMng.getPopupMng().getPopupShown();
               if(_loc4_)
               {
                  _loc4_.hideTemporarily(InstanceMng.getPopupMng().openShopItemPopup,[_loc3_]);
               }
               else
               {
                  InstanceMng.getPopupMng().openShopItemPopup(_loc3_);
               }
            }
         }
      }
      
      private function createTicketMultiPlayerTextfield() : void
      {
         if(Boolean(this.mTicketsCounterMPImage) && this.mTicketsCounterMPTextfield == null)
         {
            this.mTicketsCounterMPTextfield = new FSTextfield(this.mTicketsCounterMPImage.width * 0.6,this.mTicketsCounterMPImage.height,"0/0");
            this.mTicketsCounterMPTextfield.x = this.mTicketsCounterMPImage.x - this.mTicketsCounterSPImage.width * 0.3;
            this.mTicketsCounterMPTextfield.y = this.mTicketsCounterMPImage.y - this.mTicketsCounterSPImage.height * 0.5;
            if(InstanceMng.getUserDataMng().getOwnerUserData())
            {
               this.mTicketsCounterMPTextfield.text = InstanceMng.getUserDataMng().getOwnerUserData().getRaidTicketsMultiPlayer().toString() + "/" + Config.getConfig().getRaidTicketsMultiPlayer().value.toString();
            }
            this.mTicketsCounterMPTextfield.addEventListener(Event.TRIGGERED,this.onTicketMPClick);
            addChild(this.mTicketsCounterMPTextfield);
         }
      }
      
      private function onTicketMPClick() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:ShopBoostDef = null;
         var _loc3_:FSShopItem = null;
         var _loc4_:Popup = null;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getRaidTicketsMultiPlayer() == 0;
         }
         if(!_loc1_)
         {
            Utils.setLogText(TextManager.getText("TID_RAID_TICKETS_UNSPEND"));
         }
         else
         {
            _loc2_ = ShopBoostDef(InstanceMng.getShopBoostsDefMng().getShopBoostDefByKeyname(BoostsMng.BOOST_ID_RESET_TECKETS_RAID_MULTI_PLAYER));
            if(_loc2_ != null)
            {
               _loc3_ = new FSShopItem(_loc2_,false,null,true);
               _loc4_ = InstanceMng.getPopupMng().getPopupShown();
               if(_loc4_)
               {
                  _loc4_.hideTemporarily(InstanceMng.getPopupMng().openShopItemPopup,[_loc3_]);
               }
               else
               {
                  InstanceMng.getPopupMng().openShopItemPopup(_loc3_);
               }
            }
         }
      }
      
      private function createRaidTicketsCounters() : void
      {
         this.createRaidTicketsSinglePlayer();
         this.createRaidTicketsMultiPlayer();
      }
      
      private function createRaidTicketsSinglePlayer() : void
      {
         if(Boolean(this.mLeftContainer) && this.mTicketsCounterSPImage == null)
         {
            this.mTicketsCounterSPImage = new FSButton(Root.assets.getTexture(this.TICKET_SINGLE_PLAYER_BG));
            this.mTicketsCounterSPImage.addEventListener(Event.TRIGGERED,this.onTicketSPClick);
            this.mTicketsCounterSPImage.x = this.mLeftContainer.x;
            this.mTicketsCounterSPImage.y = this.mTicketsCounterSPImage.height * 0.65;
            addChild(this.mTicketsCounterSPImage);
         }
      }
      
      private function createRaidTicketsMultiPlayer() : void
      {
         if(Boolean(this.mLeftContainer) && this.mTicketsCounterMPImage == null)
         {
            this.mTicketsCounterMPImage = new FSButton(Root.assets.getTexture(this.TICKET_MULTI_PLAYER_BG));
            this.mTicketsCounterMPImage.addEventListener(Event.TRIGGERED,this.onTicketMPClick);
            this.mTicketsCounterMPImage.x = this.mTicketsCounterSPImage.x + this.mTicketsCounterSPImage.width * 1.05;
            this.mTicketsCounterMPImage.y = this.mTicketsCounterSPImage.y;
            addChild(this.mTicketsCounterMPImage);
         }
      }
      
      private function resetRaidInfo() : void
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
         if(this.mPacksReward)
         {
            this.mPacksReward.removeFromParent();
            this.mPacksReward.destroy();
            this.mPacksReward = null;
         }
         if(this.mPackImage)
         {
            this.mPackImage.removeFromParent();
            this.mPackImage.destroy();
            this.mPackImage = null;
         }
         if(this.mPackImageTextfield)
         {
            this.mPackImageTextfield.removeFromParent();
            this.mPackImageTextfield = null;
         }
         if(this.mGoldReward)
         {
            this.mGoldReward.removeFromParent(true);
            this.mGoldReward = null;
         }
         if(this.mSkinReward)
         {
            this.mSkinReward.removeFromParent(true);
            this.mSkinReward = null;
         }
         if(this.mRaidCoinReward)
         {
            this.mRaidCoinReward.removeFromParent(true);
            this.mRaidCoinReward = null;
         }
         if(this.mBattlesEventBG)
         {
            this.mBattlesEventBG.alpha = 0.0001;
         }
         if(this.mBattleEventInfo)
         {
            this.mBattleEventInfo.removeFromParent();
            this.mBattleEventInfo.destroy();
            this.mBattleEventInfo = null;
         }
         if(this.mRaidBoss)
         {
            this.mRaidBoss.removeFromParent();
            this.mRaidBoss.destroy();
            this.mRaidBoss = null;
         }
         if(this.mRecommendedTextfield)
         {
            this.mRecommendedTextfield.removeFromParent();
            this.mRecommendedTextfield = null;
         }
         if(this.mRecommendedNumbertextfield)
         {
            this.mRecommendedNumbertextfield.removeFromParent();
            this.mRecommendedNumbertextfield = null;
         }
         if(this.mGuildSizeTextfield)
         {
            this.mGuildSizeTextfield.removeFromParent();
            this.mGuildSizeTextfield = null;
         }
         if(this.mPortraitReward)
         {
            this.mPortraitReward.removeFromParent();
            this.mPortraitReward.destroy();
            this.mPortraitReward = null;
         }
      }
      
      private function createRaidRewards() : void
      {
         if(this.mSelectedRaidDef)
         {
            if(this.mRewardsBG == null && Boolean(this.mRaidImageXL))
            {
               this.mRewardsBG = new Quad(this.mRaidImageXL.width * 0.94,this.mRaidImageXL.height * 0.2,0);
               this.mRewardsBG.x = this.mRaidImageXL.x + (this.mRaidImageXL.width - this.mRewardsBG.width) / 2;
               this.mRewardsBG.y = this.mRaidImageXL.y + this.mRaidImageXL.height * 0.96 - this.mRewardsBG.height;
            }
            this.mRewardsBG.alpha = 0.5;
            SpecialFX.tweenToAlpha(this.mRewardsBG,0.5,0.25,0);
            this.mLeftContainer.addChild(this.mRewardsBG);
            this.createRewardsButtons();
         }
      }
      
      private function createRewardsButtons() : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:FSCoordinate = null;
         var _loc6_:String = null;
         var _loc7_:PackDef = null;
         var _loc8_:String = null;
         var _loc1_:Object = this.mSelectedRaidDef ? this.mSelectedRaidDef.getRewardsSummaryByDifficultyIndex(this.mCurrentDifficultySelected) : null;
         if(Boolean(_loc1_) && Boolean(this.mRewardsBG))
         {
            _loc2_ = "";
            _loc3_ = int(_loc1_.totalRewards);
            _loc4_ = 0;
            if(_loc1_.hasRaidCoin)
            {
               if(this.mRaidCoinReward == null)
               {
                  this.mRaidCoinReward = new FSButton(Root.assets.getTexture("raid_points_icon"));
                  this.mRaidCoinReward.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
                  this.mRaidCoinReward.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
                  this.mRaidCoinReward.scaleWhenDown = 1;
                  this.mRaidCoinReward.enableScaleOnMouseOver(false);
                  if(this.mSelectedRaidDef.getIsMultiPlayer())
                  {
                     this.mRaidCoinReward.setTooltipText(TextManager.getText("TID_RAID_INFO_RAIDPOINTS_TOTAL"));
                  }
                  else
                  {
                     this.mRaidCoinReward.setTooltipText(TextManager.getText("TID_RAID_INFO_RAIDPOINTS"));
                  }
               }
               _loc5_ = Utils.getXYPositionInContainer(_loc4_,this.mRaidCoinReward.width,this.mRaidCoinReward.height,this.mRewardsBG.width,this.mRewardsBG.height,_loc3_,1,true);
               this.mRaidCoinReward.x = this.mRewardsBG.x + _loc5_.getX() + this.mRaidCoinReward.width / 2;
               this.mRaidCoinReward.y = this.mRewardsBG.y + _loc5_.getY() + this.mRaidCoinReward.height / 2;
               if(this.mLeftContainer)
               {
                  this.mLeftContainer.addChild(this.mRaidCoinReward);
               }
               _loc4_++;
               this.mRaidCoinReward.text = _loc1_.raidCoin;
            }
            else if(this.mRaidCoinReward)
            {
               this.mRaidCoinReward.removeFromParent();
            }
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
            if(_loc1_.hasPacks)
            {
               if(this.mSelectedRaidDef.getIsMultiPlayer())
               {
                  if(this.mPacksReward == null)
                  {
                     this.mPacksReward = new FSButton(Root.assets.getTexture(this.mSelectedRaidDef.getPackBGByDifficultyIndex(this.mCurrentDifficultySelected)));
                     this.mPacksReward.readjustSize();
                     this.mPacksReward.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
                     this.mPacksReward.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
                     this.mPacksReward.scaleWhenDown = 1;
                     this.mPacksReward.enableScaleOnMouseOver(false);
                  }
                  else
                  {
                     this.mPacksReward.upState = Root.assets.getTexture(this.mSelectedRaidDef.getPackBGByDifficultyIndex(this.mCurrentDifficultySelected));
                     this.mPacksReward.readjustSize();
                  }
                  this.mPacksReward.setTooltipText(this.mSelectedRaidDef.getPackInfoByDifficultyIndex(this.mCurrentDifficultySelected));
                  _loc5_ = Utils.getXYPositionInContainer(_loc4_,this.mPacksReward.width,this.mPacksReward.height,this.mRewardsBG.width,this.mRewardsBG.height,_loc3_,1,true);
                  this.mPacksReward.x = this.mRewardsBG.x + _loc5_.getX() + this.mPacksReward.width / 2;
                  this.mPacksReward.y = this.mRewardsBG.y + _loc5_.getY() + this.mPacksReward.height / 2;
                  if(this.mLeftContainer)
                  {
                     this.mLeftContainer.addChild(this.mPacksReward);
                  }
                  _loc4_++;
                  _loc2_ = _loc1_.minPacks == _loc1_.maxPacks ? _loc1_.maxPacks : _loc1_.minPacks + "-" + _loc1_.maxPacks;
                  this.mPacksReward.text = _loc2_;
               }
               else
               {
                  _loc6_ = this.mSelectedRaidDef.getSPVGoodPackRewardByDifficulty(this.mCurrentDifficultySelected);
                  _loc7_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc6_.toLowerCase()));
                  _loc8_ = _loc7_ ? _loc7_.getAnimBG() : "";
                  if(this.mPackImage == null)
                  {
                     this.mPackImage = new PackAnimation(_loc8_);
                  }
                  else if(_loc8_ != "")
                  {
                     this.mPackImage.restart(_loc8_);
                  }
                  if(this.mPackImage)
                  {
                     this.mPackImage.alignPivot();
                     this.mPackImage.setTooltipText(this.mSelectedRaidDef.getPackInfoByDifficultyIndex(this.mCurrentDifficultySelected));
                     this.mPackImage.scale = 0.45;
                     _loc5_ = Utils.getXYPositionInContainer(_loc4_,this.mPackImage.width,this.mPackImage.height,this.mRewardsBG.width,this.mRewardsBG.height,_loc3_,1,true);
                     this.mPackImage.x = this.mRewardsBG.x + _loc5_.getX() + this.mPackImage.width / 2;
                     this.mPackImage.y = this.mRewardsBG.y + _loc5_.getY() + this.mPackImage.height / 3;
                     if(this.mPackImageTextfield == null)
                     {
                        this.mPackImageTextfield = new FSTextfield(this.mPackImage.width,this.mPackImage.height / 2);
                     }
                     this.mPackImageTextfield.alignPivot();
                     this.mPackImageTextfield.x = this.mPackImage.x;
                     this.mPackImageTextfield.y = this.mPackImage.y + this.mPackImageTextfield.height / 2;
                     if(this.mLeftContainer)
                     {
                        this.mLeftContainer.addChild(this.mPackImage);
                        this.mLeftContainer.addChild(this.mPackImageTextfield);
                     }
                     _loc4_++;
                     _loc2_ = _loc1_.minPacks == _loc1_.maxPacks ? _loc1_.maxPacks : _loc1_.minPacks + "-" + _loc1_.maxPacks;
                     this.mPackImageTextfield.text = _loc2_;
                  }
               }
            }
            else
            {
               if(this.mPacksReward)
               {
                  this.mPacksReward.removeFromParent();
               }
               if(this.mPackImage)
               {
                  this.mPackImage.removeFromParent();
               }
               if(this.mPackImageTextfield)
               {
                  this.mPackImageTextfield.removeFromParent();
               }
            }
            if(_loc1_.hasPortraits)
            {
               if(this.mPortraitReward == null)
               {
                  this.mPortraitReward = new FSButton(Root.assets.getTexture("dungeon_portrait"));
                  this.mPortraitReward.readjustSize();
                  this.mPortraitReward.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
                  this.mPortraitReward.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
                  this.mPortraitReward.scaleWhenDown = 1;
                  this.mPortraitReward.enableScaleOnMouseOver(false);
               }
               else
               {
                  this.mPortraitReward.upState = Root.assets.getTexture("dungeon_portrait");
                  this.mPortraitReward.readjustSize();
               }
               this.mPortraitReward.setTooltipText(TextManager.getText("TID_RAIDS_INFO_PORTRAITS"));
               _loc5_ = Utils.getXYPositionInContainer(_loc4_,this.mPortraitReward.width,this.mPortraitReward.height,this.mRewardsBG.width,this.mRewardsBG.height,_loc3_,1,true);
               this.mPortraitReward.x = this.mRewardsBG.x + _loc5_.getX() + this.mPortraitReward.width / 2;
               this.mPortraitReward.y = this.mRewardsBG.y + _loc5_.getY() + this.mPortraitReward.height / 2;
               if(this.mLeftContainer)
               {
                  this.mLeftContainer.addChild(this.mPortraitReward);
               }
               _loc4_++;
               _loc2_ = _loc1_.minPortraits == _loc1_.maxPortraits ? _loc1_.maxPortraits : _loc1_.minPortraits + "-" + _loc1_.maxPortraits;
               this.mPortraitReward.text = _loc2_;
            }
            else if(this.mPortraitReward)
            {
               this.mPortraitReward.removeFromParent();
            }
            if(_loc1_.hasSkins)
            {
               if(this.mSkinReward == null)
               {
                  this.mSkinReward = new FSButton(Root.assets.getTexture("skin_portrait"));
                  this.mSkinReward.readjustSize();
                  this.mSkinReward.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
                  this.mSkinReward.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
                  this.mSkinReward.scaleWhenDown = 1;
                  this.mSkinReward.enableScaleOnMouseOver(false);
               }
               else
               {
                  this.mSkinReward.upState = Root.assets.getTexture("skin_portrait");
                  this.mSkinReward.readjustSize();
               }
               this.mSkinReward.setTooltipText(TextManager.getText("TID_RAID_INFO_SKIN"));
               _loc5_ = Utils.getXYPositionInContainer(_loc4_,this.mSkinReward.width,this.mSkinReward.height,this.mRewardsBG.width,this.mRewardsBG.height,_loc3_,1,true);
               this.mSkinReward.x = this.mRewardsBG.x + _loc5_.getX() + this.mSkinReward.width / 2;
               this.mSkinReward.y = this.mRewardsBG.y + _loc5_.getY() + this.mSkinReward.height / 2;
               if(this.mLeftContainer)
               {
                  this.mLeftContainer.addChild(this.mSkinReward);
               }
               _loc4_++;
               _loc2_ = _loc1_.minSkins == _loc1_.maxSkins ? _loc1_.maxSkins : _loc1_.minSkins + "-" + _loc1_.maxSkins;
               this.mSkinReward.text = _loc2_;
            }
            else if(this.mSkinReward)
            {
               this.mSkinReward.removeFromParent();
            }
         }
         else
         {
            if(this.mPacksReward)
            {
               this.mPacksReward.removeFromParent();
            }
            if(this.mPackImage)
            {
               this.mPackImage.removeFromParent();
            }
            if(this.mPackImageTextfield)
            {
               this.mPackImageTextfield.removeFromParent();
            }
         }
      }
      
      public function collapseUnselectedRaids(param1:FSRaidSlotInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSRaidSlotInfo = null;
         if(this.mRaidsScrollContainer)
         {
            if(this.mRaidsSlots)
            {
               if(param1)
               {
                  _loc2_ = 0;
                  while(_loc2_ < this.mRaidsSlots.length)
                  {
                     _loc3_ = this.mRaidsSlots[_loc2_];
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
                  while(_loc2_ < this.mRaidsSlots.length)
                  {
                     _loc3_ = this.mRaidsSlots[_loc2_];
                     _loc3_.setExpanded(false);
                     _loc2_++;
                  }
               }
            }
         }
      }
      
      public function getCurrentRaidSlotInfo() : FSRaidSlotInfo
      {
         var _loc2_:int = 0;
         var _loc1_:FSRaidSlotInfo = null;
         _loc2_ = 0;
         while(_loc2_ < this.mRaidsSlots.length)
         {
            if(this.mRaidsSlots[_loc2_].getRaidDef().getSku() == InstanceMng.getRaidsMng().getCurrentRaidDef().getSku())
            {
               return this.mRaidsSlots[_loc2_];
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function unlockRaidSlotsInfo() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.mRaidsSlots.length)
         {
            this.mRaidsSlots[_loc1_].unlockItem();
            _loc1_++;
         }
      }
      
      private function createRaidImage() : void
      {
         if(this.mSelectedRaidDef)
         {
            if(this.mRaidImageXL == null)
            {
               this.mRaidImageXL = new FSImage(Root.assets.getTexture(this.mSelectedRaidDef.getBGXLImageName()));
            }
            else
            {
               this.mRaidImageXL.texture = Root.assets.getTexture(this.mSelectedRaidDef.getBGXLImageName());
            }
            if(!this.mLeftContainer.contains(this.mRaidImageXL))
            {
               this.mRaidImageXL.scale = 1.33;
               this.mLeftContainer.addChild(this.mRaidImageXL);
               this.mRaidImageXL.x = this.mLeftPanelImage.x + (this.mLeftPanelImage.width - this.mRaidImageXL.width) / 2;
               this.mRaidImageXL.y = 15;
            }
         }
      }
      
      private function createRaidOwnerInfoSection() : void
      {
         var _loc1_:int = 0;
         if(this.mSelectedRaidDef)
         {
            if(this.mRaidDescriptionPanel == null && Boolean(this.mRaidImageXL))
            {
               this.mRaidDescriptionPanel = new FSImage(Root.assets.getTexture("raids_description_panel"));
               this.mRaidDescriptionPanel.x = this.mRaidImageXL.x;
               this.mRaidDescriptionPanel.y = this.mRaidImageSeparator ? this.mRaidImageSeparator.y + this.mRaidImageSeparator.height / 1.5 : this.mRaidImageXL.y + this.mRaidImageXL.height;
            }
            if(!this.mLeftContainer.contains(this.mRaidDescriptionPanel))
            {
               if(this.mRaidImageSeparator)
               {
                  _loc1_ = this.mRaidImageSeparator ? this.mLeftContainer.getChildIndex(this.mRaidImageSeparator) : 0;
                  this.mLeftContainer.addChildAt(this.mRaidDescriptionPanel,_loc1_);
               }
               else
               {
                  this.mLeftContainer.addChild(this.mRaidDescriptionPanel);
               }
            }
         }
      }
      
      public function showMap() : void
      {
         dispatchEventWith(Screen.GO_TO_MAP,true);
      }
      
      public function onDifficultySelected(param1:int) : void
      {
         var _loc2_:Boolean = false;
         Utils.removeLog();
         if(Boolean(this.mChooseButton) && this.mCurrentDifficultySelected != param1)
         {
            if(this.mSelectedRaidDef)
            {
               this.mCurrentDifficultySelected = param1;
               this.mChooseButton.upState = Root.assets.getTexture(Constants.ACCEPT_GREEN_BUTTON_UP_NAME);
               Utils.setupButton9Scale(this.mChooseButton,7.5,15,10,5,106.6,39.4);
            }
            if(param1 == -1)
            {
               this.onDifficultyReset();
            }
            else
            {
               _loc2_ = InstanceMng.getRaidsMng().isBossDefeated(this.mSelectedRaidDef,this.mCurrentDifficultySelected);
               if(!_loc2_ || !this.mSelectedRaidDef.getIsMultiPlayer())
               {
                  this.removeLeftRaidCompleteInfo();
                  this.createLeftSection();
                  this.createRaidBoss();
                  this.createRaidBattleEventBg();
                  this.createRaidRewards();
                  if(this.mSelectedRaidDef.getIsMultiPlayer())
                  {
                     this.setVisibleLadderButton(true);
                  }
                  else
                  {
                     this.setVisibleLadderButton(false);
                  }
               }
               if(_loc2_ && this.mSelectedRaidDef.getIsMultiPlayer())
               {
                  this.removeLeftRaidCompleteInfo();
                  this.createLeftRaidCompleteInfo();
                  Utils.setLogText(TextManager.getText("TID_RAID_REWARDS_LOG") + " " + InstanceMng.getRaidsMng().getWeeklySeasonTimeLeft());
               }
            }
            InstanceMng.getRaidsMng().setCurrentRaidDef(this.mSelectedRaidDef);
            InstanceMng.getRaidsMng().setCurrentRaidDifficulty(this.mCurrentDifficultySelected);
         }
      }
      
      public function setVisibleLadderButton(param1:Boolean) : void
      {
         if(Boolean(this.mLadderButton) && Boolean(this.mLadderTextfield))
         {
            this.mLadderButton.visible = param1;
            this.mLadderTextfield.visible = param1;
         }
      }
      
      public function removeLeftRaidCompleteInfo() : void
      {
         if(this.mRaidCompleteInfo)
         {
            this.mRaidCompleteInfo.removeFromParent();
            this.mRaidCompleteInfo.destroy();
            this.mRaidCompleteInfo = null;
         }
      }
      
      private function createLeftRaidCompleteInfo() : void
      {
         if(this.mRaidCompleteInfo == null)
         {
            this.mRaidCompleteInfo = new FSRaidCompleteInfo(this.mSelectedRaidDef.getSku(),this.mCurrentDifficultySelected,true);
            this.mRaidCompleteInfo.x = this.mRaidImageXL.parent.x + this.mRaidImageXL.x + (this.mRaidImageXL.width - this.mRaidCompleteInfo.width) / 2;
            this.mRaidCompleteInfo.y = this.mRaidImageXL.parent.y + this.mRaidImageXL.y;
            addChild(this.mRaidCompleteInfo);
         }
      }
      
      private function createRaidBattleEventBg() : void
      {
         if(this.mBattleEventInfo)
         {
            this.mBattleEventInfo.removeFromParent();
            this.mBattleEventInfo.destroy();
            this.mBattleEventInfo = null;
         }
         if(this.mBattlesEventBG)
         {
            this.mBattlesEventBG.removeFromParent();
         }
         if(this.mBattlesEventBG == null && Boolean(this.mRaidImageXL))
         {
            this.mBattlesEventBG = new Quad(this.mRaidImageXL.width * 0.94,this.mRaidImageXL.height * 0.3,0);
            this.mBattlesEventBG.x = this.mRaidImageXL.x + (this.mRaidImageXL.width - this.mBattlesEventBG.width) / 2;
            this.mBattlesEventBG.y = this.mRaidImageXL.y + this.mRaidImageXL.height * 0.96 - this.mBattlesEventBG.height * 1.7;
         }
         this.mBattlesEventBG.alpha = 0.5;
         SpecialFX.tweenToAlpha(this.mBattlesEventBG,0.5,0.25,0);
         this.mLeftContainer.addChild(this.mBattlesEventBG);
         this.createRaidBattleEventInfo();
      }
      
      private function createRaidBattleEventInfo() : void
      {
         var _loc1_:RaidLevelDef = null;
         var _loc2_:BattleEventDef = null;
         if(this.mBattleEventInfo == null && Boolean(this.mSelectedRaidDef))
         {
            _loc1_ = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(this.mSelectedRaidDef.getLevelsByDifficultyIndex(this.mCurrentDifficultySelected)));
            if(_loc1_)
            {
               _loc2_ = BattleEventDef(InstanceMng.getBattleEventDefMng().getDefBySku(_loc1_.getBattleEventsSku(UserData.WORLD_DEFAULT)));
            }
            if(Boolean(_loc2_) && Boolean(this.mBattlesEventBG))
            {
               this.mBattleEventInfo = new FSBattleEventInfo(_loc2_,this.mLeftContainer.width,true);
               this.mBattleEventInfo.x = this.mBattlesEventBG.x - this.mBattleEventInfo.width / 7;
               this.mBattleEventInfo.y = this.mBattlesEventBG.y;
               this.mLeftContainer.addChild(this.mBattleEventInfo);
            }
         }
      }
      
      private function createRaidBoss() : void
      {
         if(this.mRaidBoss)
         {
            this.mRaidBoss.removeFromParent();
            this.mRaidBoss.destroy();
            this.mRaidBoss = null;
         }
         if(this.mRaidBoss == null && Boolean(this.mSelectedRaidDef))
         {
            this.mRaidBoss = new FSRaidBoss(this.mSelectedRaidDef,this.mCurrentDifficultySelected,false);
            this.mRaidBoss.init();
            this.mRaidBoss.x = this.mLeftContainer.x + (this.mRaidImageXL.width - this.mRaidBoss.width) / 2;
            this.mRaidBoss.y = this.mLeftContainer.y + this.mRaidBoss.height * 0.5;
            addChild(this.mRaidBoss);
         }
      }
      
      public function onDifficultyReset() : void
      {
         if(this.mChooseButton)
         {
            this.mChooseButton.text = TextManager.getText("TID_DUNGEON_CHOOSE_BUTTON");
            this.mChooseButton.upState = Root.assets.getTexture("choose_button_disabled");
            Utils.setupButton9Scale(this.mChooseButton,7.5,15,10,5,106.75,39.5);
         }
         this.resetRaidInfo();
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
         if(Boolean(this.mRaidsScrollContainer) && this.mRaidsScrollContainer.numChildren > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mRaidsScrollContainer.numChildren)
            {
               _loc2_ = Component(this.mRaidsScrollContainer.getChildAt(_loc3_));
               if(_loc2_ != null)
               {
                  if(_loc2_ is FSRaidSlotInfo || _loc2_ is FSRaidSlotDifficultyInfo)
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
         if(this.mRaidsScrollContainer)
         {
            this.mRaidsScrollContainer.removeFromParent(true);
            this.mRaidsScrollContainer = null;
         }
         if(this.mRaidImageXL)
         {
            this.mRaidImageXL.removeFromParent(true);
            this.mRaidImageXL = null;
         }
         if(this.mRaidsSlots)
         {
            _loc1_ = 0;
            _loc1_ = 0;
            while(_loc1_ < this.mRaidsSlots.length)
            {
               this.mRaidsSlots[_loc1_].removeFromParent();
               this.mRaidsSlots[_loc1_].destroy();
               _loc1_++;
            }
            this.mRaidsSlots.length = 0;
            this.mRaidsSlots = null;
         }
         if(this.mRaidImageSeparator)
         {
            this.mRaidImageSeparator.removeFromParent(true);
            this.mRaidImageSeparator = null;
         }
         if(this.mRaidDescriptionPanel)
         {
            this.mRaidDescriptionPanel.removeFromParent(true);
            this.mRaidDescriptionPanel = null;
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
         if(this.mSkinReward)
         {
            this.mSkinReward.removeFromParent(false);
            this.mSkinReward = null;
         }
         if(this.mRaidCoinReward)
         {
            this.mRaidCoinReward.removeFromParent(true);
            this.mRaidCoinReward = null;
         }
         if(this.mPacksReward)
         {
            this.mPacksReward.removeFromParent(true);
            this.mPacksReward = null;
         }
         if(this.mPackImage)
         {
            this.mPackImage.removeFromParent(true);
            this.mPackImage = null;
         }
         if(this.mPackImageTextfield)
         {
            this.mPackImageTextfield.removeFromParent(true);
            this.mPackImageTextfield = null;
         }
         if(this.mLadderButton)
         {
            this.mLadderButton.removeFromParent(true);
            this.mLadderButton = null;
         }
         if(this.mLadderTextfield)
         {
            this.mLadderTextfield.removeFromParent(true);
            this.mLadderTextfield = null;
         }
         if(this.mBattleEventInfo)
         {
            this.mBattleEventInfo.removeFromParent(true);
            this.mBattleEventInfo = null;
         }
         if(this.mRaidBoss)
         {
            this.mRaidBoss.removeFromParent(true);
            this.mRaidBoss = null;
         }
         if(this.mTicketsCounterMPTextfield)
         {
            this.mTicketsCounterMPTextfield.removeFromParent(true);
            this.mTicketsCounterMPTextfield = null;
         }
         if(this.mTicketsCounterSPTextfield)
         {
            this.mTicketsCounterSPTextfield.removeFromParent(true);
            this.mTicketsCounterSPTextfield = null;
         }
         if(this.mTicketsCounterMPImage)
         {
            this.mTicketsCounterMPImage.removeFromParent(true);
            this.mTicketsCounterMPImage = null;
         }
         if(this.mTicketsCounterSPImage)
         {
            this.mTicketsCounterSPImage.removeFromParent(true);
            this.mTicketsCounterSPImage = null;
         }
         if(this.mRaidCompleteInfo)
         {
            this.mRaidCompleteInfo.removeFromParent(true);
            this.mRaidCompleteInfo = null;
         }
         if(this.mTimerTicketsLayer)
         {
            this.mTimerTicketsLayer.removeFromParent(true);
            this.mTimerTicketsLayer = null;
         }
         if(this.mTimerTicketsImage)
         {
            this.mTimerTicketsImage.removeFromParent(true);
            this.mTimerTicketsImage = null;
         }
         if(this.mTimerTicketsTextfield)
         {
            this.mTimerTicketsTextfield.removeFromParent(true);
            this.mTimerTicketsTextfield = null;
         }
         if(this.mTimerRaidLayer)
         {
            this.mTimerRaidLayer.removeFromParent(true);
            this.mTimerRaidLayer = null;
         }
         if(this.mTimerRaidImage)
         {
            this.mTimerRaidImage.removeFromParent(true);
            this.mTimerRaidImage = null;
         }
         if(this.mTimerRaidTextfield)
         {
            this.mTimerRaidTextfield.removeFromParent(true);
            this.mTimerRaidTextfield = null;
         }
         if(this.mRecommendedTextfield)
         {
            this.mRecommendedTextfield.removeFromParent(true);
            this.mRecommendedTextfield = null;
         }
         if(this.mRecommendedNumbertextfield)
         {
            this.mRecommendedNumbertextfield.removeFromParent(true);
            this.mRecommendedNumbertextfield = null;
         }
         if(this.mGuildSizeTextfield)
         {
            this.mGuildSizeTextfield.removeFromParent(true);
            this.mGuildSizeTextfield = null;
         }
         if(this.mBattlesEventBG)
         {
            this.mBattlesEventBG.removeFromParent(true);
            this.mBattlesEventBG = null;
         }
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("frames",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesXL",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesFactionsRarities",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("cards_thumbs",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("portraits",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         if(Config.getConfig().cardsHaveCustomAuras())
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("anims/animAuras",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         }
         InstanceMng.getResourcesMng().removeSpecialScreenResources("customBGs");
         InstanceMng.getResourcesMng().removeResourcesFromFolder("customBGs");
         mSelectedCard = null;
         this.mCurrentDifficultySelected = -1;
         this.mSelectedRaidDef = null;
         Utils.destroyArray(this.mRaidDefArray);
         this.mRaidDefArray = null;
         super.unload();
      }
      
      public function onPaymentCompleted(param1:int) : void
      {
         var onGoldSubstractedSuccessfully:Function = null;
         var onGoldSubstractedFailed:Function = null;
         var userGold:int = 0;
         var goldCost:int = param1;
         onGoldSubstractedSuccessfully = function():void
         {
            FSTracker.trackMiscAction(FSTracker.CATEGORY_RAIDS,FSTracker.ACTION_RAID_STARTED,{
               "raid":mSelectedRaidDef.getIndex(),
               "difficulty":mCurrentDifficultySelected,
               "goldCost":goldCost
            });
            InstanceMng.getUserDataMng().getOwnerUserData().addRaidsUnlocked(mSelectedRaidDef.getSku());
            InstanceMng.getUserDataMng().updateRaidsUnlocked();
            cleanScrollContainer(createRightSection);
         };
         onGoldSubstractedFailed = function():void
         {
            Utils.showNotEnoughCurrencyMessage(ServerConnection.CURRENCY_GOLD,true);
            disableChooseButtonTemporarily();
            unlockRaidSlotsInfo();
         };
         if(Boolean(this.mSelectedRaidDef) && Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            userGold = InstanceMng.getUserDataMng().getOwnerUserData().getGold();
            if(userGold - goldCost < 0)
            {
               onGoldSubstractedFailed();
            }
            else if(!InstanceMng.getUserDataMng().getOwnerUserData().hasGuild())
            {
               Utils.setLogText(TextManager.getText("TID_RAID_ERROR_GYM"),true);
               this.disableChooseButtonTemporarily();
               this.unlockRaidSlotsInfo();
            }
            else if(this.mGoldVisor)
            {
               InstanceMng.getUserDataMng().getOwnerUserData().substractGold(-goldCost,onGoldSubstractedSuccessfully,null,onGoldSubstractedFailed);
            }
         }
      }
      
      private function onRaidsContainerEmpty() : void
      {
         var _loc1_:RaidLevelDef = null;
         if(this.mChooseButton)
         {
            this.mChooseButton.enabled = true;
            this.mChooseButton.text = TextManager.getText("TID_GEN_PLAY");
            this.mChooseButton.upState = Root.assets.getTexture(Constants.ACCEPT_GREEN_BUTTON_UP_NAME);
            Utils.setupButton9Scale(this.mChooseButton,7.5,15,10,5,106.6,39.4);
            this.mChooseButton.enableScaleOnMouseOver(false);
            SpecialFX.createYoYoZoomTransition(this.mChooseButton,1.2,2,-1,null,null,false);
            this.mChooseButton.removeEventListener(Event.TRIGGERED,this.onChooseTriggered);
            _loc1_ = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(this.mSelectedRaidDef.getLevelsByDifficultyIndex(this.mCurrentDifficultySelected)));
            InstanceMng.getPopupMng().openPlayRaidLevelPopup(_loc1_.getSku());
            if(Root.smBattleData == null)
            {
               Root.smBattleData = new Object();
            }
         }
         if(this.mChooseMissionTextfield)
         {
            this.mChooseMissionTextfield.text = TextManager.getText("TID_GEN_MENU_DECK");
         }
      }
      
      public function enableRightPanel(param1:Boolean) : void
      {
         if(this.mRaidsScrollContainer)
         {
            this.mRaidsScrollContainer.touchable = param1;
         }
      }
      
      override public function removeTranslucentBG(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:Popup = InstanceMng.getPopupMng().getPopupShown();
         if(_loc3_ == null)
         {
            super.removeTranslucentBG(param1,param2);
         }
         else
         {
            FSDebug.debugTrace("***********Popup: getPopupShown:*********** " + _loc3_.name);
         }
         if(Boolean(mSelectedCard) && !param2)
         {
            SpecialFX.zoomOut(mSelectedCard);
            mSelectedCard = null;
            if(_loc3_ != null)
            {
               _loc3_.visible = true;
            }
         }
      }
      
      public function setSelectedRaidDef(param1:RaidDef) : void
      {
         this.mSelectedRaidDef = param1;
      }
      
      public function getSelectedRaidDef() : RaidDef
      {
         return this.mSelectedRaidDef;
      }
      
      public function getSelectedCurrentDifficulty() : int
      {
         return this.mCurrentDifficultySelected;
      }
      
      public function removeRaidStatus() : void
      {
         if(this.mRaidIncompleteInfo)
         {
            this.mRaidIncompleteInfo.removeFromParent();
            this.mRaidIncompleteInfo.destroy();
            this.mRaidIncompleteInfo = null;
         }
      }
      
      public function resetRightSection() : void
      {
         this.createRightSection();
         if(this.mChooseButton)
         {
            this.mChooseButton.enabled = true;
            this.mChooseButton.addEventListener(Event.TRIGGERED,this.onChooseTriggered);
            this.mChooseMissionTextfield.text = TextManager.getText("TID_RAID_CHOOSE");
         }
         this.onDifficultyReset();
         this.setVisibleLadderButton(false);
      }
      
      private function onGetRaidBattlesByGuildId(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
         }
         if(param1)
         {
            _loc4_ = param1 as Array;
            if((Boolean(_loc4_)) && _loc4_.length > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  if(this.isPlayingRaid(_loc4_[_loc5_]) && _loc4_[_loc5_].playerId != _loc3_)
                  {
                     _loc2_++;
                  }
                  _loc5_++;
               }
            }
         }
         if(_loc2_ > 0)
         {
            this.refreshBossHP();
         }
      }
      
      private function isPlayingRaid(param1:Object) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(param1)
         {
            _loc2_ = false;
            _loc3_ = Number(param1.time.time);
            _loc4_ = ServerConnection.smServerTimeMS;
            _loc5_ = TimerUtil.minToMs(5);
            if(_loc4_ - _loc3_ < _loc5_)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      public function isRaidStatusActive() : Boolean
      {
         return this.mLadderRaidStatusActive;
      }
      
      public function refreshBossHP() : void
      {
         var _loc1_:Component = null;
         var _loc2_:int = 0;
         if(Boolean(this.mRaidsScrollContainer) && this.mRaidsScrollContainer.numChildren > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mRaidsScrollContainer.numChildren)
            {
               _loc1_ = Component(this.mRaidsScrollContainer.getChildAt(_loc2_));
               if(_loc1_ != null)
               {
                  if(_loc1_ is FSRaidSlotDifficultyInfo)
                  {
                     FSRaidSlotDifficultyInfo(_loc1_).manageRaidInfo();
                  }
               }
               _loc2_++;
            }
         }
         if(this.mRaidBoss)
         {
            this.mRaidBoss.updateProgressBar();
         }
      }
      
      public function lockRaidScrollContainer() : void
      {
         if(this.mRaidsScrollContainer)
         {
            this.mRaidsScrollContainer.touchable = false;
            TweenMax.delayedCall(2,this.unlockRaidScrollContainer);
         }
      }
      
      public function unlockRaidScrollContainer() : void
      {
         if(this.mRaidsScrollContainer)
         {
            this.mRaidsScrollContainer.touchable = true;
         }
      }
      
      public function getTicketsCounterSPTextfield() : FSTextfield
      {
         return this.mTicketsCounterSPTextfield;
      }
      
      public function getTicketsCounterMPTextfield() : FSTextfield
      {
         return this.mTicketsCounterMPTextfield;
      }
      
      public function getRaidIncompleteInfo() : FSRaidCompleteInfo
      {
         return this.mRaidIncompleteInfo;
      }
      
      public function createRecommendedPlayersSize() : void
      {
         if(Boolean(this.mLeftContainer) && this.mRecommendedTextfield == null)
         {
            this.mRecommendedTextfield = new FSTextfield(this.mRaidDescriptionPanel.width * 0.4,this.mRaidDescriptionPanel.height * 0.2,TextManager.getText("TID_RAID_RECOMMENDED"));
            this.mRecommendedTextfield.x = this.mLeftContainer.x + this.mLeftContainer.width / 2 - this.mRecommendedTextfield.width / 2;
            this.mRecommendedTextfield.y = this.mLeftContainer.y + this.mLeftContainer.height - this.mRecommendedTextfield.height * 4.5;
            addChild(this.mRecommendedTextfield);
         }
         if(Boolean(this.mRecommendedTextfield) && this.mRecommendedNumbertextfield == null)
         {
            this.mRecommendedNumbertextfield = new FSTextfield(this.mRaidDescriptionPanel.width * 0.4,this.mRaidDescriptionPanel.height * 0.3,Config.getConfig().getPlayersRecommendedByDifficulty(this.mCurrentDifficultySelected));
            this.mRecommendedNumbertextfield.x = this.mRecommendedTextfield.x;
            this.mRecommendedNumbertextfield.y = this.mRecommendedTextfield.y + this.mRecommendedTextfield.height;
            addChild(this.mRecommendedNumbertextfield);
         }
         else
         {
            this.mRecommendedNumbertextfield.text = Config.getConfig().getPlayersRecommendedByDifficulty(this.mCurrentDifficultySelected);
         }
         if(Boolean(this.mRecommendedNumbertextfield) && this.mGuildSizeTextfield == null)
         {
            this.mGuildSizeTextfield = new FSTextfield(this.mRaidDescriptionPanel.width * 0.4,this.mRaidDescriptionPanel.height * 0.2,TextManager.getText("TID_RAID_GYM_SIZE"));
            this.mGuildSizeTextfield.x = this.mRecommendedNumbertextfield.x;
            this.mGuildSizeTextfield.y = this.mRecommendedNumbertextfield.y + this.mRecommendedNumbertextfield.height;
            addChild(this.mGuildSizeTextfield);
         }
      }
      
      public function resetRaidVariables() : void
      {
         this.mCurrentDifficultySelected = -1;
      }
      
      public function getRewardsBGWidth() : int
      {
         return this.mLeftContainer ? int(this.mLeftContainer.width) : 0;
      }
   }
}

