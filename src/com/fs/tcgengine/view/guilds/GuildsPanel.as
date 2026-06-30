package com.fs.tcgengine.view.guilds
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.GuildsMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.guilds.Guild;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.RaidDef;
   import com.fs.tcgengine.model.rules.RankDef;
   import com.fs.tcgengine.model.rules.TutorialMapDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextInput;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSChatBlock;
   import com.fs.tcgengine.view.misc.FSChatInfoBlock;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalLayout;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Dictionary;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class GuildsPanel extends Component
   {
      
      public static const SECTION_GENERAL_CHAT:int = 0;
      
      public static const SECTION_GUILD_CHAT:int = 1;
      
      private var mBG:CustomComponent;
      
      private var mCreateGuildButton:FSButton;
      
      private var mCreateGuildText:FSTextfield;
      
      private var mIsOpen:Boolean;
      
      protected var mTab1Button:FSButton;
      
      protected var mTab2Button:FSButton;
      
      protected var mJoinDiscordButton:FSButton;
      
      protected var mJoinDiscordTextfield:FSTextfield;
      
      private var mTabsSeparator:Quad;
      
      protected var mSelectedSection:int = 0;
      
      protected var mTextInput:FSTextInput;
      
      private var mSendTextButton:FSButton;
      
      private var mGeneralChatIdsReadCatalog:Dictionary;
      
      private var mGeneralChatsContainer:ScrollContainer;
      
      private var mGuildChatIdsReadCatalog:Dictionary;
      
      private var mGuildEventsIdsReadCatalog:Dictionary;
      
      private var mGuildChatsContainer:ScrollContainer;
      
      private var mGuildEmblem:GuildEmblem;
      
      private var mGuildNameTextfield:FSTextfield;
      
      private var mGuildManageButton:FSButton;
      
      private var mInfoBlock1:FSChatInfoBlock;
      
      private var mGuildMessagesUnread:int;
      
      private var mChatsRefreshTimeoutId:uint;
      
      public function GuildsPanel()
      {
         super();
         name = "guildsPanel";
         this.createUI();
         this.refreshChats();
      }
      
      protected function createUI() : void
      {
         this.createBG();
         this.createTabs(TextManager.getText("TID_GUILD_TOP_RANKING"),TextManager.getText("TID_GUILD_NAME_SINGLE"));
         this.createJoinDiscordSection();
         this.createTextInput();
         this.mSelectedSection = SECTION_GUILD_CHAT;
         this.createDefaultInfoBlocks(TextManager.getText("TID_CHAT_WELCOME",true));
      }
      
      private function createJoinDiscordSection() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:int = this.mBG.width / 3;
         if(this.mJoinDiscordButton == null)
         {
            this.mJoinDiscordButton = new FSButton(Root.assets.getTexture("discord_chat_icon"));
            _loc2_ = this.mJoinDiscordButton.width + _loc1_;
            _loc3_ = this.mBG.width;
            _loc4_ = _loc3_ - _loc2_;
            this.mJoinDiscordButton.x = _loc4_ / 2;
            this.mJoinDiscordButton.y = this.mBG.y + this.mBG.height - this.mJoinDiscordButton.height;
            this.mJoinDiscordButton.addEventListener(Event.TRIGGERED,this.onJoinDiscordTriggered);
            addChild(this.mJoinDiscordButton);
         }
         if(this.mJoinDiscordTextfield == null)
         {
            this.mJoinDiscordTextfield = new FSTextfield(_loc1_,this.mJoinDiscordButton.height,TextManager.getText("TID_DISCORD_OPEN",true));
            this.mJoinDiscordTextfield.fontName = FSResourceMng.getFontByType();
            this.mJoinDiscordTextfield.format.horizontalAlign = Align.LEFT;
            this.mJoinDiscordTextfield.touchable = true;
            this.mJoinDiscordTextfield.x = this.mJoinDiscordButton.x + this.mJoinDiscordButton.width / 1.25;
            this.mJoinDiscordTextfield.y = this.mJoinDiscordButton.y - this.mJoinDiscordButton.height / 2;
            this.mJoinDiscordTextfield.addEventListener(TouchEvent.TOUCH,this.onJoinDiscordTextTouched);
            addChild(this.mJoinDiscordTextfield);
         }
      }
      
      protected function onJoinDiscordTextTouched(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            this.onJoinDiscordClicked();
         }
      }
      
      protected function onJoinDiscordTriggered(param1:Event) : void
      {
         this.onJoinDiscordClicked();
      }
      
      private function onJoinDiscordClicked() : void
      {
         var _loc1_:URLRequest = null;
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            _loc1_ = new URLRequest(Config.getConfig().getDiscordURL());
            navigateToURL(_loc1_);
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true,false,false);
         }
      }
      
      protected function createDefaultInfoBlocks(param1:String) : void
      {
         if(this.mInfoBlock1 == null)
         {
            this.mInfoBlock1 = new FSChatInfoBlock(this.mBG.width * 0.875,param1,FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN));
            this.addGeneralChatToContainer(this.mInfoBlock1);
         }
      }
      
      private function createGuildSection() : void
      {
         var _loc1_:Guild = null;
         var _loc2_:String = null;
         if(Boolean(InstanceMng.getGuildsMng()) && Boolean(InstanceMng.getGuildsMng().getMyGuild()) && Boolean(this.mBG))
         {
            if(this.mGuildEmblem == null)
            {
               this.mGuildEmblem = new GuildEmblem(InstanceMng.getGuildsMng().getMyGuild().getEmblemBG(),InstanceMng.getGuildsMng().getMyGuild().getEmblemFG());
               this.mGuildEmblem.x = this.mTabsSeparator ? this.mTabsSeparator.x : this.mTab1Button.x - this.mTab1Button.width / 2;
               this.mGuildEmblem.y = this.mTabsSeparator ? this.mTabsSeparator.y + this.mTabsSeparator.height * 3 : this.mTab1Button.y + this.mTab1Button.height / 1.95;
               addChild(this.mGuildEmblem);
            }
            if(this.mGuildNameTextfield == null)
            {
               this.mGuildNameTextfield = new FSTextfield(this.mBG.width / 2,this.mGuildEmblem.height,InstanceMng.getGuildsMng().getMyGuild().getName());
               this.mGuildNameTextfield.fontName = FSResourceMng.getFontByType();
               this.mGuildNameTextfield.format.horizontalAlign = Align.LEFT;
               this.mGuildNameTextfield.x = this.mGuildEmblem.x + this.mGuildEmblem.width * 1.05;
               this.mGuildNameTextfield.y = this.mGuildEmblem.y;
               addChild(this.mGuildNameTextfield);
            }
            if(this.mGuildManageButton == null)
            {
               this.mGuildManageButton = new FSButton(Root.assets.getTexture("guild_chat_options_button"));
               this.mGuildManageButton.x = this.mBG.x + this.mBG.width - this.mGuildManageButton.width / 1.45;
               this.mGuildManageButton.y = this.mGuildNameTextfield.y + this.mGuildNameTextfield.height / 2;
               _loc1_ = InstanceMng.getGuildsMng().getMyGuild();
               _loc2_ = Boolean(_loc1_) && Boolean(_loc1_.getDescription() != null) && _loc1_.getDescription() != "" ? _loc1_.getDescription() : "";
               if(_loc2_ != null && _loc2_ != "" && (Utils.isBrowser() || Utils.isDesktop()))
               {
                  this.mGuildManageButton.setTooltipText(_loc2_);
               }
               this.mGuildManageButton.addEventListener(Event.TRIGGERED,this.onManageGuildsButton);
               addChild(this.mGuildManageButton);
            }
            this.refreshUIPositions();
            this.hideAllMemberChatOptions();
         }
         else
         {
            InstanceMng.getGuildsMng().refreshMyGuild();
            TweenMax.delayedCall(3,this.createGuildSection);
         }
      }
      
      public function updateGuildManageTooltipInfo(param1:String) : void
      {
         if(this.mGuildManageButton != null && param1 != null && (Utils.isBrowser() || Utils.isDesktop()))
         {
            this.mGuildManageButton.setTooltipText(param1);
         }
      }
      
      public function refreshUIPositions() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.mTabsSeparator != null && !isNaN(this.mTabsSeparator.height))
         {
            switch(this.mSelectedSection)
            {
               case SECTION_GENERAL_CHAT:
                  if(this.mTextInput)
                  {
                     this.mTextInput.y = this.mTabsSeparator.y + this.mTabsSeparator.height * 3;
                  }
                  break;
               case SECTION_GUILD_CHAT:
                  if(this.mTextInput)
                  {
                     this.mTextInput.y = this.mGuildEmblem ? this.mGuildEmblem.y + this.mGuildEmblem.height * 1.05 : this.mTabsSeparator.y + this.mTabsSeparator.height * 3;
                  }
            }
            if(this.mSendTextButton)
            {
               this.mSendTextButton.y = this.mTextInput.y + this.mTextInput.height / 2;
            }
            _loc1_ = this.getChatsContainerPosY();
            if(this.mGuildChatsContainer)
            {
               this.mGuildChatsContainer.y = _loc1_;
               _loc2_ = this.mJoinDiscordButton.height;
               this.mGuildChatsContainer.setSize(this.mGuildChatsContainer.width,this.mBG.height * 0.95 - _loc1_ - _loc2_);
            }
            if(this.mGeneralChatsContainer)
            {
               this.mGeneralChatsContainer.y = _loc1_;
            }
         }
      }
      
      private function getChatsContainerPosY() : int
      {
         return this.mTextInput ? int(this.mTextInput.y + this.mTextInput.height * 1.3) : 0;
      }
      
      private function createTextInput() : void
      {
         if(this.mTextInput == null)
         {
            this.mTextInput = new FSTextInput();
            this.mTextInput.setSize(this.mBG.width / 1.25,this.mTab1Button.height);
            this.mTextInput.maxChars = 90;
            this.mTextInput.addEventListener(FeathersEventType.ENTER,this.inputEnterHandler);
            this.mTextInput.addEventListener(FeathersEventType.FOCUS_IN,this.inputFocusInHandler);
            this.mTextInput.x = this.mTabsSeparator.x + 10;
            this.mTextInput.y = this.mTabsSeparator.y + this.mTabsSeparator.height * 3;
            addChild(this.mTextInput);
         }
         if(this.mSendTextButton == null)
         {
            this.mSendTextButton = new FSButton(Root.assets.getTexture("guild_chat_icon"));
            this.mSendTextButton.x = this.mTextInput.x + this.mTextInput.width + this.mSendTextButton.width / 1.95;
            this.mSendTextButton.y = this.mTextInput.y + this.mTextInput.height / 2;
            this.mSendTextButton.addEventListener(Event.TRIGGERED,this.onSendText);
            addChild(this.mSendTextButton);
         }
      }
      
      private function inputEnterHandler(param1:Event) : void
      {
         this.sendText();
      }
      
      private function inputFocusInHandler(param1:Event) : void
      {
         this.hideAllMemberChatOptions();
      }
      
      protected function onSendText(param1:Event) : void
      {
         this.sendText();
      }
      
      protected function sendText() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         if(!InstanceMng.getUserDataMng().getOwnerUserData().isInBlackList())
         {
            if(!InstanceMng.getUserDataMng().getOwnerUserData().isInDuplicatedList())
            {
               _loc1_ = true;
               if(this.mSelectedSection == SECTION_GENERAL_CHAT)
               {
                  _loc1_ = ServerConnection.smChatMutedTimestamp == -1 || ServerConnection.smChatMutedTimestamp != -1 && ServerConnection.smChatMutedTimestamp < ServerConnection.smServerTimeMS;
               }
               if(_loc1_)
               {
                  if(InstanceMng.getServerConnection().isUserLoggedIn() && Boolean(InstanceMng.getServerConnection().getBackendUserProfile()))
                  {
                     _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().hasGuild() && this.mSelectedSection == SECTION_GUILD_CHAT;
                     if(_loc2_ || this.mSelectedSection == SECTION_GENERAL_CHAT)
                     {
                        this.hideAllMemberChatOptions();
                        _loc3_ = this.mTextInput ? this.mTextInput.text : "";
                        if(_loc3_ != "" && _loc3_ != " ")
                        {
                           if(ServerConnection.smServerTimeMS != -1)
                           {
                              switch(this.mSelectedSection)
                              {
                                 case SECTION_GENERAL_CHAT:
                                    InstanceMng.getServerConnection().createGeneralChatInstance(_loc3_);
                                    break;
                                 case SECTION_GUILD_CHAT:
                                    InstanceMng.getServerConnection().createGuildChatInstance(_loc3_);
                              }
                              this.mTextInput.text = "";
                              if(Utils.isDesktop())
                              {
                                 this.mTextInput.setFocus();
                              }
                           }
                           else
                           {
                              InstanceMng.getServerConnection().refreshServerTime();
                           }
                        }
                     }
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_CHAT_MUTE_BAN"),[InstanceMng.getServerConnection().getChatMutedTimeLeft()]));
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
      
      private function isIfChatTutorialOn() : Boolean
      {
         var _loc2_:TutorialMapDef = null;
         var _loc1_:Boolean = false;
         if(InstanceMng.getTutorialMapMng().isTutorialON())
         {
            _loc2_ = InstanceMng.getTutorialMapMng().getCurrentTutorialMapDef();
            if(Boolean(_loc2_) && Boolean(_loc2_.getAttachedTo() != null) && (_loc2_.getAttachedTo().indexOf("guildsPanel") != -1 || _loc2_.getAttachedTo().indexOf("guilds_button") != -1))
            {
               _loc1_ = true;
            }
         }
         return _loc1_;
      }
      
      protected function createTabs(param1:String, param2:String) : void
      {
         var _loc3_:String = null;
         if(this.mTab1Button == null)
         {
            _loc3_ = this.mSelectedSection == SECTION_GENERAL_CHAT ? "chat_button_up" : "chat_button_down";
            this.mTab1Button = new FSButton(Root.assets.getTexture(_loc3_),param1);
            Utils.setupButton9Scale(this.mTab1Button,7,9.5,9.5,12.5,122.25,31.5);
            this.mTab1Button.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mTab1Button.x = this.mBG.x + (this.mBG.width - this.mTab1Button.width) / 2;
            this.mTab1Button.y = 3 + this.mBG.y + this.mTab1Button.height / 2;
            this.mTab1Button.addEventListener(Event.TRIGGERED,this.onTab1Triggered);
            this.mTab1Button.enabled = !this.isIfChatTutorialOn();
            addChild(this.mTab1Button);
         }
         if(this.mTab2Button == null)
         {
            _loc3_ = this.mSelectedSection == SECTION_GUILD_CHAT ? "chat_button_up" : "chat_button_down";
            this.mTab2Button = new FSButton(Root.assets.getTexture(_loc3_),param2);
            Utils.setupButton9Scale(this.mTab2Button,7,9.5,9.5,12.5,122.25,31.5);
            this.mTab2Button.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mTab2Button.x = this.mTab1Button.x + this.mTab1Button.width / 1.95 + this.mTab2Button.width / 2;
            this.mTab2Button.y = this.mTab1Button.y;
            this.mTab2Button.addEventListener(Event.TRIGGERED,this.onTab2Triggered);
            this.mTab2Button.enabled = !this.isIfChatTutorialOn();
            addChild(this.mTab2Button);
         }
         if(this.mTabsSeparator == null)
         {
            this.mTabsSeparator = new Quad(this.mBG.width * Config.getConfig().getGuildSeparatorWidthPercentage(),1,uint(Config.getConfig().getGuildSeparatorColor()));
            this.mTabsSeparator.x = this.mTab1Button.x - this.mTab1Button.width / 2;
            this.mTabsSeparator.y = this.mTab1Button.y + this.mTab1Button.height / 1.95;
            addChild(this.mTabsSeparator);
         }
      }
      
      protected function refreshActiveTab() : void
      {
         var _loc1_:String = this.mSelectedSection == SECTION_GENERAL_CHAT ? "chat_button_up" : "chat_button_down";
         var _loc2_:String = this.mSelectedSection == SECTION_GENERAL_CHAT ? "chat_button_down" : "chat_button_up";
         if(this.mTab1Button)
         {
            this.mTab1Button.upState = Root.assets.getTexture(_loc1_);
         }
         if(this.mTab2Button)
         {
            this.mTab2Button.upState = Root.assets.getTexture(_loc2_);
         }
      }
      
      protected function onTab1Triggered(param1:Event) : void
      {
         this.mSelectedSection = SECTION_GENERAL_CHAT;
         this.refreshActiveTab();
         if(this.mTextInput)
         {
            addChild(this.mTextInput);
         }
         if(this.mSendTextButton)
         {
            addChild(this.mSendTextButton);
         }
         if(this.mGeneralChatsContainer)
         {
            addChild(this.mGeneralChatsContainer);
         }
         if(this.mGuildChatsContainer)
         {
            this.mGuildChatsContainer.removeFromParent();
         }
         if(this.mCreateGuildButton)
         {
            this.mCreateGuildButton.removeFromParent();
         }
         if(this.mCreateGuildText)
         {
            this.mCreateGuildText.removeFromParent();
         }
         if(this.mGuildEmblem)
         {
            this.mGuildEmblem.removeFromParent();
         }
         if(this.mGuildNameTextfield)
         {
            this.mGuildNameTextfield.removeFromParent();
         }
         if(this.mGuildManageButton)
         {
            this.mGuildManageButton.removeFromParent();
         }
         this.refreshUIPositions();
         this.hideAllMemberChatOptions();
         if(Utils.isDesktop())
         {
            this.mTextInput.setFocus();
         }
      }
      
      public function increaseGuildMessagesUnread() : void
      {
         ++this.mGuildMessagesUnread;
      }
      
      protected function onTab2Triggered(param1:Event) : void
      {
         this.mSelectedSection = SECTION_GUILD_CHAT;
         this.mGuildMessagesUnread = 0;
         InstanceMng.getCurrentScreen().resetGuildsAnimEffectDone();
         InstanceMng.getCurrentScreen().removeGuildVisualCounter();
         this.refreshActiveTab();
         if(this.mGeneralChatsContainer)
         {
            this.mGeneralChatsContainer.removeFromParent();
         }
         if(InstanceMng.getUserDataMng().getOwnerUserData().hasGuild())
         {
            this.createGuildSection();
            if(this.mTextInput)
            {
               addChild(this.mTextInput);
            }
            if(this.mSendTextButton)
            {
               addChild(this.mSendTextButton);
            }
            if(this.mGuildChatsContainer)
            {
               addChild(this.mGuildChatsContainer);
            }
            if(this.mGuildEmblem)
            {
               addChild(this.mGuildEmblem);
            }
            if(this.mGuildNameTextfield)
            {
               addChild(this.mGuildNameTextfield);
            }
            if(this.mGuildManageButton)
            {
               addChild(this.mGuildManageButton);
            }
            if(this.mCreateGuildButton)
            {
               this.mCreateGuildButton.removeFromParent();
            }
            if(this.mCreateGuildText)
            {
               this.mCreateGuildText.removeFromParent();
            }
         }
         else
         {
            if(this.mTextInput)
            {
               this.mTextInput.removeFromParent();
            }
            if(this.mSendTextButton)
            {
               this.mSendTextButton.removeFromParent();
            }
            if(this.mGuildChatsContainer)
            {
               this.mGuildChatsContainer.removeChildren();
               this.mGuildChatsContainer = null;
            }
            if(this.mGuildChatIdsReadCatalog)
            {
               DictionaryUtils.clearDictionary(this.mGuildChatIdsReadCatalog);
               this.mGuildChatIdsReadCatalog = null;
            }
            if(this.mGuildEmblem)
            {
               this.mGuildEmblem.removeFromParent();
               this.mGuildEmblem.destroy();
               this.mGuildEmblem = null;
            }
            if(this.mGuildNameTextfield)
            {
               this.mGuildNameTextfield.removeFromParent(true);
               this.mGuildNameTextfield = null;
            }
            if(this.mGuildManageButton)
            {
               this.mGuildManageButton.removeFromParent();
               this.mGuildManageButton.destroy();
               this.mGuildManageButton = null;
            }
            if(this.mCreateGuildButton)
            {
               addChild(this.mCreateGuildButton);
               if(this.mCreateGuildText)
               {
                  addChild(this.mCreateGuildText);
               }
            }
            else
            {
               this.createManageGuildsButton();
            }
         }
         this.refreshUIPositions();
         this.hideAllMemberChatOptions();
         if(Utils.isDesktop())
         {
            this.mTextInput.setFocus();
         }
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = Utils.createCustomBox("guild_chat_panel",1024);
            addChild(this.mBG);
         }
      }
      
      private function createManageGuildsButton() : void
      {
         if(this.mCreateGuildButton == null)
         {
            this.mCreateGuildButton = new FSButton(Root.assets.getTexture("guild_chat_join_button"));
            this.mCreateGuildButton.name = "guildsManageButton";
            this.mCreateGuildButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mCreateGuildButton.x = this.mBG.width / 2;
            this.mCreateGuildButton.y = this.mBG.height / 2;
            this.mCreateGuildButton.addEventListener(Event.TRIGGERED,this.onManageGuildsButton);
            addChild(this.mCreateGuildButton);
         }
         if(this.mCreateGuildText == null)
         {
            this.mCreateGuildText = new FSTextfield(width * 0.85,this.mCreateGuildButton.height / 3,TextManager.getText("TID_GUILD_JOIN_BUTTON"),16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
            this.mCreateGuildText.touchable = false;
            this.mCreateGuildText.x = (width - this.mCreateGuildText.width) / 2;
            this.mCreateGuildText.y = this.mCreateGuildButton.y + this.mCreateGuildButton.height / 1.95;
            addChild(this.mCreateGuildText);
         }
      }
      
      private function onManageGuildsButton(param1:Event) : void
      {
         if(InstanceMng.getTutorialMapMng().isTutorialON())
         {
            InstanceMng.getTutorialMapMng().increaseCurrentStep();
            if(this.mTab2Button)
            {
               this.mTab2Button.enabled = !this.isIfChatTutorialOn();
            }
            if(this.mTab1Button)
            {
               this.mTab1Button.enabled = !this.isIfChatTutorialOn();
            }
         }
         if(InstanceMng.getServerConnection().isUserLoggedIn() && Boolean(InstanceMng.getServerConnection().getBackendUserProfile()))
         {
            InstanceMng.getApplication().hideGuildsPanel();
            InstanceMng.getPopupMng().openGuildsPopup();
         }
      }
      
      public function setItOpen(param1:Boolean) : void
      {
         this.mIsOpen = param1;
         if(!this.mIsOpen)
         {
            this.hideAllMemberChatOptions();
         }
         if(this.mIsOpen && this.mSelectedSection == SECTION_GUILD_CHAT)
         {
            InstanceMng.getCurrentScreen().resetGuildsAnimEffectDone();
            this.mGuildMessagesUnread = 0;
            InstanceMng.getCurrentScreen().removeGuildVisualCounter();
         }
      }
      
      public function isOpen() : Boolean
      {
         return this.mIsOpen;
      }
      
      private function refreshChats() : void
      {
         if(InstanceMng.getUserDataMng().getOwnerUserData())
         {
            InstanceMng.getServerConnection().retrieveLastChats("GENERAL_CHAT","GENERAL_CHAT",GuildsMng.smMaxBoardMessages);
            if(InstanceMng.getUserDataMng().getOwnerUserData().hasGuild())
            {
               InstanceMng.getServerConnection().retrieveLastChats(InstanceMng.getUserDataMng().getOwnerUserData().getGuildId(),"FS_GUILD",GuildsMng.smMaxBoardMessages);
               InstanceMng.getServerConnection().refreshGuildEvents(this.onGuildEventsReceived);
            }
         }
      }
      
      public function onGuildEventsReceived(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:RankDef = null;
         var _loc9_:String = null;
         var _loc10_:uint = 0;
         var _loc11_:Number = NaN;
         var _loc12_:FSGuildChatBlock = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         if(Boolean(param1) && param1.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if(this.mGuildEventsIdsReadCatalog == null)
               {
                  this.mGuildEventsIdsReadCatalog = new Dictionary(true);
               }
               _loc4_ = !param1[_loc2_].hasOwnProperty("_id");
               if((_loc4_) || this.mGuildEventsIdsReadCatalog[Utils.getDataId(param1[_loc2_])] == null)
               {
                  _loc3_ = InstanceMng.getGuildsMng().getGuildEventTextByEvent(param1[_loc2_]);
                  _loc5_ = param1[_loc2_].currentLevelSku;
                  _loc6_ = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(_loc5_);
                  _loc7_ = 1;
                  if(_loc6_ != -1)
                  {
                     _loc7_ = RankDef(InstanceMng.getRanksDefMng().getDefByCurrentLevel(_loc6_)).getIndex();
                  }
                  _loc8_ = RankDef(InstanceMng.getRanksDefMng().getDefByIndex(_loc7_));
                  _loc9_ = FSResourceMng.getFontByType();
                  switch(param1[_loc2_].eventType)
                  {
                     case GuildsMng.GUILD_EVENT_LEFT:
                     case GuildsMng.GUILD_EVENT_KICK:
                        _loc10_ = 16711680;
                        break;
                     case GuildsMng.GUILD_EVENT_GOT_LEGENDARY:
                        _loc10_ = 16747520;
                        break;
                     case GuildsMng.GUILD_WEEKLY_EVENT_STARTED:
                     case GuildsMng.GUILD_WEEKLY_EVENT_ENDED:
                        _loc10_ = 255;
                        break;
                     case GuildsMng.GUILD_EVENT_RAID_EASY_COMPLETED:
                        _loc10_ = 49151;
                        break;
                     case GuildsMng.GUILD_EVENT_RAID_MEDIUM_COMPLETED:
                        _loc10_ = 8190976;
                        break;
                     case GuildsMng.GUILD_EVENT_RAID_HARD_COMPLETED:
                        _loc10_ = 16766720;
                        break;
                     case GuildsMng.GUILD_EVENT_RAID_EXPERT_COMPLETED:
                        _loc10_ = 16729344;
                        break;
                     default:
                        _loc10_ = 65280;
                  }
                  _loc11_ = Number(param1[_loc2_].when);
                  _loc13_ = this.mGuildChatsContainer ? this.mGuildChatsContainer.numChildren : 0;
                  _loc14_ = GuildsMng.smMaxBoardMessages;
                  if(_loc13_ > _loc14_)
                  {
                     _loc12_ = this.getLastGuildChatFromContainer();
                     if(_loc12_ != null)
                     {
                        _loc12_.removeFromParent();
                        _loc12_.setPlayerId(param1[_loc2_].playerInvolvedId);
                        _loc12_.setPlayerRankDef(_loc8_);
                        _loc12_.setGuildRank(param1[_loc2_].playerInvolvedGuildRank);
                        _loc12_.setNick(param1[_loc2_].playerInvolvedNick);
                        _loc12_.setFontName(_loc9_);
                        _loc12_.setFontColor(_loc10_);
                        _loc12_.setBody(_loc3_);
                        _loc12_.setCurrTimeMS(_loc11_);
                        _loc12_.setShowMessageAgeAlways(true);
                        _loc12_.cleanMessageAge();
                        _loc12_.refreshObjectAfterUpdate();
                     }
                  }
                  else
                  {
                     _loc12_ = new FSGuildChatBlock(this.mBG.width * 0.875,param1[_loc2_].playerInvolvedId,_loc8_,param1[_loc2_].playerInvolvedNick,_loc3_,_loc11_,param1[_loc2_].playerInvolvedGuildRank,_loc9_,_loc10_,true);
                  }
                  if(_loc12_)
                  {
                     this.addGuildChatToContainer(_loc12_);
                     if(!_loc4_)
                     {
                        this.mGuildEventsIdsReadCatalog[Utils.getDataId(param1[_loc2_])] = 1;
                     }
                  }
               }
               _loc2_++;
            }
         }
         this.notifyMessage();
      }
      
      private function shouldGuildEventNotify(param1:Object) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc4_:RaidDef = null;
         _loc2_ = param1["data"];
         var _loc3_:int = int(param1["eventType"]);
         switch(_loc3_)
         {
            case GuildsMng.GUILD_EVENT_PVP_WON:
            case GuildsMng.GUILD_EVENT_DUNGEON_EASY:
            case GuildsMng.GUILD_EVENT_DUNGEON_MED:
            case GuildsMng.GUILD_EVENT_DUNGEON_HARD:
               return false;
            case GuildsMng.GUILD_EVENT_JOIN:
            case GuildsMng.GUILD_EVENT_PROMOTE:
            case GuildsMng.GUILD_EVENT_DEMOTE:
            case GuildsMng.GUILD_EVENT_KICK:
            case GuildsMng.GUILD_EVENT_LEFT:
            case GuildsMng.GUILD_EVENT_GOT_LEGENDARY:
            case GuildsMng.GUILD_WEEKLY_EVENT_STARTED:
            case GuildsMng.GUILD_WEEKLY_EVENT_ENDED:
            case GuildsMng.GUILD_WEEKLY_REWARDS_READY:
            case GuildsMng.GUILD_GRAL_CHAT_SYSTEM_MESSAGE:
            case GuildsMng.GUILD_EVENT_GOLD_BAG_PURCHASED:
            case GuildsMng.GUILD_EVENT_RECRUITED_FRIEND:
               return true;
            case GuildsMng.GUILD_EVENT_RAID_EASY_COMPLETED:
            case GuildsMng.GUILD_EVENT_RAID_MEDIUM_COMPLETED:
            case GuildsMng.GUILD_EVENT_RAID_HARD_COMPLETED:
            case GuildsMng.GUILD_EVENT_RAID_EXPERT_COMPLETED:
            case GuildsMng.GUILD_EVENT_RAID_REWARDS_READY:
               _loc4_ = _loc2_ ? RaidDef(InstanceMng.getRaidsDefMng().getDefBySku(_loc2_)) : null;
               return _loc4_ ? _loc4_.getIsMultiPlayer() : false;
            default:
               return false;
         }
      }
      
      public function onGuildChatsReceived(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:RankDef = null;
         var _loc4_:Number = NaN;
         var _loc5_:Guild = null;
         var _loc6_:UserData = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:FSGuildChatBlock = null;
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if(this.mGuildChatIdsReadCatalog == null)
               {
                  this.mGuildChatIdsReadCatalog = new Dictionary(true);
               }
               if(param1[_loc2_] != null && this.mGuildChatIdsReadCatalog[Utils.getDataId(param1[_loc2_])] == null)
               {
                  _loc3_ = RankDef(InstanceMng.getRanksDefMng().getDefByIndex(param1[_loc2_].rankIndex));
                  _loc4_ = Number(param1[_loc2_].when);
                  _loc5_ = InstanceMng.getGuildsMng().getMyGuild();
                  _loc6_ = _loc5_ != null ? _loc5_.getMemberUserDataById(param1[_loc2_].uid) : null;
                  _loc7_ = param1[_loc2_].nick == "" && _loc5_ != null && Boolean(_loc6_) ? _loc6_.getName() : param1[_loc2_].nick;
                  _loc8_ = param1[_loc2_].hasOwnProperty("guildRank") ? int(param1[_loc2_].guildRank) : 3;
                  _loc8_ = param1[_loc2_].uid == "guild" ? GuildsMng.RANK_GUILD_MOTD : _loc8_;
                  _loc9_ = this.mGuildChatsContainer ? this.mGuildChatsContainer.numChildren : 0;
                  _loc10_ = GuildsMng.smMaxBoardMessages;
                  if(_loc9_ > _loc10_)
                  {
                     _loc11_ = this.getLastGuildChatFromContainer();
                     if(_loc11_)
                     {
                        _loc11_.removeFromParent();
                        _loc11_.setPlayerId(param1[_loc2_].uid);
                        _loc11_.setPlayerRankDef(_loc3_);
                        _loc11_.setGuildRank(_loc8_);
                        _loc11_.setNick(_loc7_);
                        _loc11_.setFontName("");
                        _loc11_.setFontColor(16777215);
                        _loc11_.setBody(param1[_loc2_].body);
                        _loc11_.setCurrTimeMS(_loc4_);
                        _loc11_.setShowMessageAgeAlways(false);
                        _loc11_.cleanMessageAge();
                        _loc11_.refreshObjectAfterUpdate();
                     }
                  }
                  else
                  {
                     _loc11_ = new FSGuildChatBlock(this.mBG.width * 0.875,param1[_loc2_].uid,_loc3_,_loc7_,param1[_loc2_].body,_loc4_,_loc8_);
                  }
                  if(_loc11_)
                  {
                     this.addGuildChatToContainer(_loc11_);
                     this.mGuildChatIdsReadCatalog[Utils.getDataId(param1[_loc2_])] = 1;
                  }
               }
               _loc2_++;
            }
         }
         this.notifyMessage();
      }
      
      private function getLastGuildChatFromContainer() : FSGuildChatBlock
      {
         return this.mGuildChatsContainer ? FSGuildChatBlock(this.mGuildChatsContainer.getChildAt(this.mGuildChatsContainer.numChildren - 1)) : null;
      }
      
      private function getLastGeneralChatFromContainer() : FSChatBlock
      {
         var _loc1_:FSChatBlock = null;
         var _loc2_:int = this.mGeneralChatsContainer ? this.mGeneralChatsContainer.numChildren : 0;
         var _loc3_:* = 0;
         _loc3_ = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            if(this.mGeneralChatsContainer.getChildAt(_loc3_) is FSChatBlock)
            {
               return FSChatBlock(this.mGeneralChatsContainer.getChildAt(_loc3_));
            }
            _loc3_--;
         }
         return _loc1_;
      }
      
      public function addGuildChatToContainer(param1:Component) : void
      {
         var _loc2_:int = 0;
         var _loc3_:VerticalLayout = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(Boolean(this.mBG) && Boolean(param1))
         {
            if(this.mGuildChatsContainer == null)
            {
               this.mGuildChatsContainer = new ScrollContainer();
               this.mGuildChatsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
               _loc3_ = new VerticalLayout();
               _loc3_.horizontalAlign = HorizontalAlign.CENTER;
               this.mGuildChatsContainer.layout = _loc3_;
               _loc4_ = this.getChatsContainerPosY();
               _loc5_ = this.mBG.width * 0.95;
               this.mGuildChatsContainer.setSize(_loc5_,this.mBG.height * 0.95 - _loc4_);
               this.mGuildChatsContainer.x = this.mBG.x + (this.mBG.width - _loc5_) / 2;
               if(this.mSelectedSection == SECTION_GUILD_CHAT)
               {
                  addChild(this.mGuildChatsContainer);
               }
               this.mGuildChatsContainer.addEventListener(TouchEvent.TOUCH,this.onChatContainerTouched);
            }
            param1.alpha = 0.001;
            SpecialFX.tweenToAlpha(param1,0.999,0.5,0);
            _loc2_ = this.getIndexToAddChatBlock(param1 as FSGuildChatBlock);
            this.mGuildChatsContainer.addChildAt(param1,_loc2_);
         }
      }
      
      private function getIndexToAddChatBlock(param1:FSChatBlock, param2:int = 0) : int
      {
         var _loc5_:FSChatBlock = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc3_:int = param2;
         var _loc4_:int = this.mGuildChatsContainer ? this.mGuildChatsContainer.numChildren : 0;
         if(Boolean(param1) && Boolean(this.mGuildChatsContainer) && _loc4_ > 0)
         {
            _loc6_ = param1.getMessageTime();
            _loc7_ = param2;
            while(_loc7_ < _loc4_)
            {
               _loc5_ = this.mGuildChatsContainer.getChildAt(_loc7_) as FSChatBlock;
               if(_loc5_)
               {
                  _loc8_ = _loc5_.getMessageTime();
                  if(_loc6_ < _loc8_)
                  {
                     param2 = _loc7_ + 1;
                     return this.getIndexToAddChatBlock(param1,param2);
                  }
                  return _loc7_;
               }
               _loc7_++;
            }
         }
         return _loc3_;
      }
      
      public function onGeneralChatsReceived(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSChatBlock = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:RankDef = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:FSChatInfoBlock = null;
         var _loc10_:String = null;
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if(this.mGeneralChatIdsReadCatalog == null)
               {
                  this.mGeneralChatIdsReadCatalog = new Dictionary(true);
               }
               if(param1[_loc2_]._id == null || this.mGeneralChatIdsReadCatalog[Utils.getDataId(param1[_loc2_])] == null)
               {
                  _loc4_ = this.mGeneralChatsContainer ? this.mGeneralChatsContainer.numChildren : 0;
                  _loc3_ = null;
                  _loc5_ = param1[_loc2_].isCS ? "[FS] " + param1[_loc2_].nick : param1[_loc2_].nick;
                  _loc6_ = RankDef(InstanceMng.getRanksDefMng().getDefByIndex(param1[_loc2_].rankIndex));
                  if(_loc4_ > GuildsMng.smMaxBoardMessages)
                  {
                     _loc3_ = this.getLastGeneralChatFromContainer();
                     if(_loc3_)
                     {
                        _loc3_.removeFromParent();
                        _loc3_.setIsCS(param1[_loc2_].isCS);
                        _loc3_.setPlayerId(param1[_loc2_].uid);
                        _loc3_.setPlayerRankDef(_loc6_);
                        _loc3_.setGuildId(param1[_loc2_].guildId);
                        _loc3_.setGuildEmblemBG(param1[_loc2_].guildEmblemBG);
                        _loc3_.setGuildEmblemFG(param1[_loc2_].guildEmblemFG);
                        _loc3_.setGuildName(param1[_loc2_].guildName);
                        _loc3_.setNick(_loc5_);
                        _loc3_.setBody(param1[_loc2_].body);
                        _loc3_.setCurrTimeMS(param1[_loc2_].when);
                        _loc3_.cleanMessageAge();
                        _loc3_.refreshObjectAfterUpdate();
                     }
                  }
                  if(param1[_loc2_].system == null)
                  {
                     if(!InstanceMng.getUserDataMng().isPlayerInMutedList(param1[_loc2_].uid))
                     {
                        if(_loc3_ == null)
                        {
                           _loc3_ = new FSChatBlock(this.mBG.width * 0.875,param1[_loc2_].uid,_loc6_,_loc5_,param1[_loc2_].body,param1[_loc2_].when,param1[_loc2_].isCS,param1[_loc2_].guildId,param1[_loc2_].guildEmblemBG,param1[_loc2_].guildEmblemFG,param1[_loc2_].guildName);
                        }
                        this.addGeneralChatToContainer(_loc3_);
                     }
                  }
                  else
                  {
                     _loc7_ = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_BLUE);
                     _loc8_ = param1[_loc2_].body ? param1[_loc2_].body : "";
                     if(param1[_loc2_].type != null)
                     {
                        switch(param1[_loc2_].type)
                        {
                           case 0:
                              _loc7_ = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_BLUE);
                              _loc8_ = param1[_loc2_].body;
                              break;
                           case 1:
                              if(Config.getConfig().gameHasAuctions())
                              {
                                 _loc7_ = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
                                 _loc10_ = param1[_loc2_].cardSku ? CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1[_loc2_].cardSku)).getName() : "";
                                 if(_loc10_ == "" || _loc10_ == null)
                                 {
                                    return;
                                 }
                                 _loc8_ = TextManager.replaceParameters(TextManager.getText("TID_AUCTIONS_GC_CARD_AVAILABLE"),["[" + _loc10_ + "]"]);
                                 break;
                              }
                              return;
                        }
                     }
                     _loc9_ = new FSChatInfoBlock(this.mBG.width * 0.875,_loc8_,_loc7_);
                     this.addGeneralChatToContainer(_loc9_);
                  }
                  this.mGeneralChatIdsReadCatalog[Utils.getDataId(param1[_loc2_])] = 1;
               }
               _loc2_++;
            }
         }
      }
      
      public function removeChatsFromPlayerId(param1:String) : void
      {
         var _loc2_:FSChatBlock = null;
         var _loc3_:* = 0;
         var _loc4_:Vector.<int> = null;
         var _loc5_:uint = 0;
         if(param1 != null && param1 != "")
         {
            if(this.mGeneralChatsContainer)
            {
               _loc3_ = int(_loc5_ = this.mGeneralChatsContainer.numChildren - 1);
               while(_loc3_ >= 0)
               {
                  if(this.mGeneralChatsContainer.getChildAt(_loc3_) is FSChatBlock)
                  {
                     _loc2_ = FSChatBlock(this.mGeneralChatsContainer.getChildAt(_loc3_));
                     if(Boolean(_loc2_) && _loc2_.getAccountId() == param1)
                     {
                        _loc2_.removeFromParent();
                        _loc2_.destroy();
                     }
                  }
                  _loc3_--;
               }
            }
            if(this.mGuildChatsContainer)
            {
               _loc3_ = int(_loc5_ = this.mGuildChatsContainer.numChildren - 1);
               while(_loc3_ >= 0)
               {
                  if(this.mGuildChatsContainer.getChildAt(_loc3_) is FSChatBlock)
                  {
                     _loc2_ = FSChatBlock(this.mGuildChatsContainer.getChildAt(_loc3_));
                     if(Boolean(_loc2_) && _loc2_.getAccountId() == param1)
                     {
                        _loc2_.removeFromParent();
                        _loc2_.destroy();
                     }
                  }
                  _loc3_--;
               }
            }
         }
      }
      
      private function addGeneralChatToContainer(param1:Component) : void
      {
         var _loc2_:VerticalLayout = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(Boolean(this.mGeneralChatsContainer == null) && Boolean(this.mBG) && Boolean(param1))
         {
            this.mGeneralChatsContainer = new ScrollContainer();
            this.mGeneralChatsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            _loc2_ = new VerticalLayout();
            _loc2_.horizontalAlign = HorizontalAlign.CENTER;
            this.mGeneralChatsContainer.layout = _loc2_;
            _loc3_ = this.getChatsContainerPosY();
            _loc4_ = this.mBG.width * 0.95;
            _loc5_ = this.mJoinDiscordButton.height;
            this.mGeneralChatsContainer.setSize(_loc4_,this.mBG.height * 0.95 - _loc3_ - _loc5_);
            this.mGeneralChatsContainer.x = this.mBG.x + (this.mBG.width - _loc4_) / 2;
            this.mGeneralChatsContainer.y = _loc3_;
            this.mGeneralChatsContainer.addEventListener(TouchEvent.TOUCH,this.onChatContainerTouched);
            if(this.mSelectedSection == SECTION_GENERAL_CHAT)
            {
               addChild(this.mGeneralChatsContainer);
            }
         }
         param1.alpha = 0.001;
         SpecialFX.tweenToAlpha(param1,0.999,0.5,0);
         this.mGeneralChatsContainer.addChildAt(param1,0);
      }
      
      private function notifyMessage() : void
      {
         var _loc1_:String = null;
         if(this.mGuildMessagesUnread > 0)
         {
            _loc1_ = this.mGuildMessagesUnread > 99 ? "99+" : this.mGuildMessagesUnread.toString();
            InstanceMng.getCurrentScreen().notifyGuildMessageReceived(_loc1_);
         }
      }
      
      public function getGuildMessagesUnread() : int
      {
         return this.mGuildMessagesUnread;
      }
      
      public function onGuildLeft() : void
      {
         if(this.mGuildChatIdsReadCatalog)
         {
            DictionaryUtils.clearDictionary(this.mGuildChatIdsReadCatalog);
            this.mGuildChatIdsReadCatalog = null;
         }
         if(this.mGuildChatsContainer)
         {
            this.mGuildChatsContainer.removeFromParent();
            this.mGuildChatsContainer = null;
         }
         if(this.mTextInput)
         {
            this.mTextInput.removeFromParent();
         }
         if(this.mTabsSeparator)
         {
            this.mTabsSeparator.removeFromParent();
         }
         if(this.mSendTextButton)
         {
            this.mSendTextButton.removeFromParent();
         }
         if(this.mGuildEmblem)
         {
            this.mGuildEmblem.removeFromParent();
            this.mGuildEmblem = null;
         }
         if(this.mGuildNameTextfield)
         {
            this.mGuildNameTextfield.removeFromParent(true);
            this.mGuildNameTextfield = null;
         }
         if(this.mGuildManageButton)
         {
            this.mGuildManageButton.removeFromParent();
            this.mGuildManageButton.destroy();
            this.mGuildManageButton = null;
         }
         if(this.mSelectedSection == SECTION_GUILD_CHAT)
         {
            if(this.mCreateGuildButton)
            {
               addChild(this.mCreateGuildButton);
               if(this.mCreateGuildText)
               {
                  addChild(this.mCreateGuildText);
               }
            }
            else
            {
               this.createManageGuildsButton();
            }
         }
         this.refreshUIPositions();
      }
      
      public function onGuildJoin() : void
      {
         this.onTab2Triggered(null);
      }
      
      public function refreshCurrentSection() : void
      {
         if(this.mSelectedSection == SECTION_GENERAL_CHAT)
         {
            this.onTab1Triggered(null);
         }
         else
         {
            this.refreshUpdateEmblem();
            this.onTab2Triggered(null);
         }
      }
      
      public function getGeneralChatScrollContainer() : ScrollContainer
      {
         return this.mGeneralChatsContainer;
      }
      
      public function getGuildsChatScrollContainer() : ScrollContainer
      {
         return this.mGuildChatsContainer;
      }
      
      private function onChatContainerTouched(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.BEGAN) : null;
         if(_loc2_)
         {
            this.hideAllMemberChatOptions();
         }
      }
      
      public function hideAllMemberChatOptions() : void
      {
         var _loc1_:int = 0;
         if(this.mGeneralChatsContainer)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mGeneralChatsContainer.numChildren)
            {
               if(this.mGeneralChatsContainer.getChildAt(_loc1_) != null && this.mGeneralChatsContainer.getChildAt(_loc1_) is FSChatBlock)
               {
                  FSChatBlock(this.mGeneralChatsContainer.getChildAt(_loc1_)).hideChatMemberOptions();
               }
               _loc1_++;
            }
         }
         if(this.mGuildChatsContainer)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mGuildChatsContainer.numChildren)
            {
               if(this.mGuildChatsContainer.getChildAt(_loc1_) != null && this.mGuildChatsContainer.getChildAt(_loc1_) is FSChatBlock)
               {
                  FSChatBlock(this.mGuildChatsContainer.getChildAt(_loc1_)).hideChatMemberOptions();
               }
               _loc1_++;
            }
         }
      }
      
      public function refreshUpdateEmblem() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.mGuildEmblem)
         {
            if(Boolean(InstanceMng.getGuildsMng()) && InstanceMng.getGuildsMng().getMyGuild() != null)
            {
               _loc1_ = InstanceMng.getGuildsMng().getMyGuild().getEmblemBG();
               _loc2_ = InstanceMng.getGuildsMng().getMyGuild().getEmblemFG();
               if(this.mGuildEmblem.getBGName() != _loc1_)
               {
                  this.mGuildEmblem.changeBGTexture(Root.assets.getTexture(_loc1_));
               }
               if(this.mGuildEmblem.getFGName() != _loc2_)
               {
                  this.mGuildEmblem.changeFGTexture(Root.assets.getTexture(_loc2_));
               }
            }
         }
      }
      
      override public function dispose() : void
      {
      }
      
      public function getCurrentSection() : int
      {
         return this.mSelectedSection;
      }
   }
}

