package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.RankDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.ProfanityFilter;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSMemberOptions;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.guilds.GuildEmblem;
   import com.fs.tcgengine.view.guilds.GuildsPanel;
   import feathers.controls.Callout;
   import feathers.controls.ScrollContainer;
   import feathers.layout.RelativePosition;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import starling.display.Quad;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.text.TextFieldAutoSize;
   import starling.utils.Align;
   
   public class FSChatBlock extends Component implements FSModelUnloadableInterface
   {
      
      protected var mRankInsigniaImage:FSImage;
      
      protected var mNameTextfield:FSTextfield;
      
      protected var mGuildEmblem:GuildEmblem;
      
      protected var mGuildName:FSTextfield;
      
      public var mText:FSTextfield;
      
      private var mMessageAge:FSTextfield;
      
      private var mSeparator:Quad;
      
      protected var mMaxWidth:int;
      
      private var mGuildId:String;
      
      private var mCurrentTimeMS:Number;
      
      private var mAccountId:String;
      
      private var mChatMemberOptions:FSMemberOptions;
      
      private var mIsCS:Boolean;
      
      private var mPlayerRankDef:RankDef;
      
      private var mNick:String;
      
      private var mBody:String;
      
      private var mGuildEmblemBG:String;
      
      private var mGuildEmblemFG:String;
      
      protected var mGuildNameStr:String;
      
      private var mTimerId:uint;
      
      public function FSChatBlock(param1:int, param2:String, param3:RankDef, param4:String, param5:String, param6:Number, param7:Boolean = false, param8:String = null, param9:String = null, param10:String = null, param11:String = null)
      {
         super();
         this.mMaxWidth = param1;
         this.mGuildId = param8;
         this.mCurrentTimeMS = param6;
         this.mAccountId = param2;
         this.mIsCS = param7;
         this.mPlayerRankDef = param3;
         this.mNick = param4;
         this.mBody = param5;
         this.mGuildEmblemBG = param9;
         this.mGuildEmblemFG = param10;
         this.mGuildNameStr = param11;
         this.createUI();
         touchable = true;
         useHandCursor = true;
         this.addEventListeners();
      }
      
      public function setGuildEmblemBG(param1:String) : void
      {
         this.mGuildEmblemBG = param1;
      }
      
      public function setGuildEmblemFG(param1:String) : void
      {
         this.mGuildEmblemFG = param1;
      }
      
      public function setGuildName(param1:String) : void
      {
         this.mGuildNameStr = param1;
      }
      
      public function setGuildId(param1:String) : void
      {
         this.mGuildId = param1;
      }
      
      public function setIsCS(param1:Boolean) : void
      {
         this.mIsCS = param1;
      }
      
      public function setPlayerId(param1:String) : void
      {
         this.mAccountId = param1;
      }
      
      public function setPlayerRankDef(param1:RankDef) : void
      {
         this.mPlayerRankDef = param1;
      }
      
      public function setNick(param1:String) : void
      {
         this.mNick = param1;
      }
      
      public function setBody(param1:String) : void
      {
         this.mBody = param1;
      }
      
      public function setCurrTimeMS(param1:Number) : void
      {
         this.mCurrentTimeMS = param1;
      }
      
      public function refreshObjectAfterUpdate() : void
      {
         this.createUI();
      }
      
      protected function addEventListeners() : void
      {
         if(!this.mIsCS)
         {
            addEventListener(TouchEvent.TOUCH,this.onTouch);
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this.mIsCS)
         {
            _loc2_ = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
            if(_loc2_)
            {
               if(this.mAccountId != InstanceMng.getServerConnection().getUserId() && this.mAccountId != "" && this.mAccountId != null && this.mAccountId != "guild")
               {
                  this.createMemberChatOptions();
               }
            }
         }
      }
      
      private function createMemberChatOptions() : void
      {
         var _loc2_:ScrollContainer = null;
         var _loc3_:Callout = null;
         var _loc1_:GuildsPanel = InstanceMng.getApplication() ? InstanceMng.getApplication().getGuildsPanel() : null;
         if(_loc1_)
         {
            _loc2_ = _loc1_.getCurrentSection() == GuildsPanel.SECTION_GENERAL_CHAT ? _loc1_.getGeneralChatScrollContainer() : _loc1_.getGuildsChatScrollContainer();
            if(Boolean(_loc2_) && !_loc2_.isScrolling)
            {
               if(stage != null)
               {
                  if(this.mChatMemberOptions == null)
                  {
                     this.mChatMemberOptions = new FSMemberOptions(FSMemberOptions.TYPE_CHAT,this.mAccountId,"","",this.mGuildId,-1,null,this);
                  }
                  _loc3_ = Callout.show(this.mChatMemberOptions,this.mNameTextfield,new <String>[RelativePosition.RIGHT]);
                  this.mChatMemberOptions.setParentCallout(_loc3_);
                  this.mChatMemberOptions.onShown();
                  if(this.mNameTextfield)
                  {
                     this.mNameTextfield.color = 16747520;
                  }
               }
            }
         }
      }
      
      public function hideChatMemberOptions() : void
      {
         var _loc1_:Boolean = false;
         if(this.mChatMemberOptions)
         {
            this.mChatMemberOptions.removeFromParent();
            this.mChatMemberOptions.destroy();
            this.mChatMemberOptions = null;
         }
         if(Boolean(this.mNameTextfield) && Boolean(InstanceMng.getServerConnection().getBackendUserProfile()) && !this.mIsCS)
         {
            _loc1_ = this.mAccountId == InstanceMng.getServerConnection().getUserId();
            this.mNameTextfield.color = _loc1_ ? 9498256 : 15657130;
         }
      }
      
      private function createUI() : void
      {
         this.createRankInsignia();
         this.createName();
         this.createGuildEmblem();
         this.createGuildName();
         this.createText();
         this.createMessageAge();
         this.createSeparator();
      }
      
      private function createRankInsignia() : void
      {
         var _loc1_:String = Config.getConfig().hasPortraits() && Boolean(this.mPlayerRankDef) ? this.mPlayerRankDef.getBGImageName() : "rank_insignia";
         _loc1_ = this.mIsCS ? "cs_chat_icon" : _loc1_;
         if(this.mRankInsigniaImage == null)
         {
            this.mRankInsigniaImage = new FSImage(Root.assets.getTexture(_loc1_));
            addChild(this.mRankInsigniaImage);
         }
         else
         {
            this.mRankInsigniaImage.texture = Root.assets.getTexture(_loc1_);
         }
         if(this.mRankInsigniaImage)
         {
            this.mRankInsigniaImage.x = 0;
            this.mRankInsigniaImage.y = 0;
         }
      }
      
      private function createName() : void
      {
         var _loc1_:Boolean = InstanceMng.getServerConnection().getBackendUserProfile() ? this.mAccountId == InstanceMng.getServerConnection().getUserId() : false;
         this.mNick = _loc1_ ? TextManager.getText("TID_SOCIAL_ME",true) + " (" + this.mNick + ")" : this.mNick;
         this.mNick = this.mIsCS ? "[FS] Support" : this.mNick;
         var _loc2_:int = this.mMaxWidth / 2 - (this.mRankInsigniaImage.x + this.mRankInsigniaImage.width);
         if(this.mNameTextfield == null && Boolean(this.mRankInsigniaImage))
         {
            this.mNameTextfield = new FSTextfield(_loc2_,this.mRankInsigniaImage.height,this.mNick);
            this.mNameTextfield.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
            this.mNameTextfield.touchable = true;
            this.mNameTextfield.format.horizontalAlign = Align.LEFT;
            addChild(this.mNameTextfield);
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.text = this.mNick;
            this.mNameTextfield.width = _loc2_;
            this.mNameTextfield.height = this.mRankInsigniaImage.height;
            this.mNameTextfield.fontName = FSResourceMng.getFontByType();
            this.mNameTextfield.color = _loc1_ ? 9498256 : 15657130;
            this.mNameTextfield.color = this.mIsCS ? 15761536 : this.mNameTextfield.color;
            this.mNameTextfield.x = this.mRankInsigniaImage.x + this.mRankInsigniaImage.width;
            this.mNameTextfield.y = this.mRankInsigniaImage.y;
         }
      }
      
      private function createGuildEmblem() : void
      {
         var _loc1_:int = 0;
         if(this.mGuildEmblemBG != null && this.mGuildEmblemFG != null)
         {
            if(this.mGuildEmblem == null)
            {
               this.mGuildEmblem = new GuildEmblem(this.mGuildEmblemBG,this.mGuildEmblemFG);
               addChild(this.mGuildEmblem);
            }
            else if(this.mGuildEmblemBG != null && this.mGuildEmblemBG != "" && this.mGuildEmblemFG != null && this.mGuildEmblemFG != "")
            {
               this.mGuildEmblem.changeBGTexture(Root.assets.getTexture(this.mGuildEmblemBG));
               this.mGuildEmblem.changeFGTexture(Root.assets.getTexture(this.mGuildEmblemFG));
            }
            this.mGuildEmblem.width = this.mRankInsigniaImage.width;
            this.mGuildEmblem.height = this.mRankInsigniaImage.height;
            _loc1_ = this.mMaxWidth / 2 - (this.mRankInsigniaImage.x + this.mRankInsigniaImage.width);
            this.mGuildEmblem.x = this.mNameTextfield ? this.mNameTextfield.x + _loc1_ : width;
            this.mGuildEmblem.y = this.mNameTextfield ? this.mNameTextfield.y : 0;
         }
         else if(this.mGuildEmblem)
         {
            this.mGuildEmblem.removeFromParent();
         }
      }
      
      protected function createGuildName() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.mGuildNameStr != null)
         {
            if(this.mGuildName == null)
            {
               _loc1_ = this.mMaxWidth / 2 - (this.mRankInsigniaImage.x + this.mRankInsigniaImage.width);
               _loc2_ = FSResourceMng.isOriental(this.mGuildNameStr) ? _loc1_ : 1;
               this.mGuildName = new FSTextfield(_loc2_,this.mRankInsigniaImage.height,this.mGuildNameStr);
               addChild(this.mGuildName);
            }
            this.mGuildName.text = this.mGuildNameStr;
            this.mGuildName.touchable = true;
            this.mGuildName.fontName = FSResourceMng.getFontByType();
            this.mGuildName.color = 13290186;
            this.mGuildName.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
            this.mGuildName.format.horizontalAlign = Align.RIGHT;
            this.mGuildName.autoSize = FSResourceMng.isOriental(this.mGuildNameStr) ? TextFieldAutoSize.NONE : TextFieldAutoSize.HORIZONTAL;
            _loc1_ = this.mMaxWidth / 2 - (this.mRankInsigniaImage.x + this.mRankInsigniaImage.width);
            _loc2_ = FSResourceMng.isOriental(this.mGuildNameStr) ? _loc1_ : 1;
            this.mGuildName.width = _loc2_;
            this.mGuildName.height = this.mRankInsigniaImage ? this.mRankInsigniaImage.height : this.mGuildName.height;
            this.mGuildName.x = this.mMaxWidth - this.mGuildName.width * 1.05;
            this.mGuildName.y = this.mGuildEmblem.y;
            if(this.mGuildEmblem)
            {
               this.mGuildEmblem.x = this.mGuildName.x - this.mGuildEmblem.width * 1.05;
            }
         }
         else if(this.mGuildName)
         {
            this.mGuildName.text = "";
         }
      }
      
      protected function createText() : void
      {
         this.mBody = this.processTextMessage(this.mBody);
         var _loc1_:Boolean = FSResourceMng.isOriental(this.mBody);
         var _loc2_:int = _loc1_ ? 60 : 1;
         _loc2_ /= Utils.isAndroidOrDesktop() ? Main.smScaleFactor : 1;
         _loc2_ = _loc2_ < 1 ? 1 : _loc2_;
         if(this.mText == null)
         {
            this.mText = new FSTextfield(this.mMaxWidth,_loc2_,this.mBody);
            this.mText.touchable = true;
            this.mText.fontName = FSResourceMng.getFontByType();
            this.mText.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
            this.mText.format.horizontalAlign = Align.LEFT;
            this.mText.format.verticalAlign = Align.TOP;
            addChild(this.mText);
         }
         else
         {
            this.mText.text = this.mBody;
         }
         if(this.mText)
         {
            this.mText.fontName = !_loc1_ ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD) : this.mText.fontName;
            this.mText.width = this.mMaxWidth;
            this.mText.height = _loc2_;
            this.mText.autoSize = _loc1_ ? TextFieldAutoSize.NONE : TextFieldAutoSize.VERTICAL;
            if(this.mRankInsigniaImage)
            {
               this.mText.x = this.mRankInsigniaImage.x;
               this.mText.y = this.mRankInsigniaImage.y + this.mRankInsigniaImage.height;
            }
         }
      }
      
      private function processTextMessage(param1:String) : String
      {
         var _loc2_:int = 0;
         if(param1)
         {
            _loc2_ = param1.indexOf(" ");
            if(param1.length > 35 && (_loc2_ > 35 || _loc2_ == -1))
            {
               param1 = param1.substring(0,35) + " " + this.processTextMessage(param1.substring(35));
            }
         }
         return ProfanityFilter.$.filterString(param1);
      }
      
      protected function createMessageAge() : void
      {
         if(this.mMessageAge == null)
         {
            this.mMessageAge = new FSTextfield(this.mMaxWidth,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE,"",16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
            this.mMessageAge.touchable = true;
            this.mMessageAge.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_DESC);
            this.mMessageAge.fontSize = Utils.isBrowser() || Utils.isDesktop() ? FSResourceMng.FONT_STD_XSMALL_SIZE : FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
            this.mMessageAge.format.horizontalAlign = Align.RIGHT;
            addChild(this.mMessageAge);
         }
         this.updateMessageAgeProperties();
         if(ServerConnection.smServerTimeMS != -1 && TimerUtil.msToMin(ServerConnection.smServerTimeMS - this.mCurrentTimeMS) >= 1)
         {
            this.updateMessageAge();
         }
         else
         {
            this.mTimerId = setTimeout(this.updateMessageAge,60000);
         }
      }
      
      private function updateMessageAgeProperties() : void
      {
         if(this.mMessageAge != null && this.mText != null)
         {
            this.mMessageAge.width = this.mMaxWidth > 0 ? this.mMaxWidth : 1;
            this.mMessageAge.height = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
            this.mMessageAge.x = this.mText.x;
            this.mMessageAge.y = this.mText.y + this.mText.height;
         }
      }
      
      public function cleanMessageAge() : void
      {
         if(this.mMessageAge)
         {
            this.mMessageAge.text = "";
         }
      }
      
      protected function updateMessageAge() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         if(this.mMessageAge)
         {
            _loc1_ = "";
            if(ServerConnection.smServerTimeMS != -1)
            {
               this.mTimerId = setTimeout(this.updateMessageAge,60000);
               if(ServerConnection.smServerTimeMS - this.mCurrentTimeMS > TimerUtil.secondToMs(60))
               {
                  _loc2_ = ServerConnection.smServerTimeMS - this.mCurrentTimeMS;
                  _loc3_ = _loc2_ > 0 && !isNaN(_loc2_) ? TimerUtil.getTimeTextFromMs(_loc2_," " + TextManager.getText("TID_GEN_TIME_DAYS_ABR",true) + " "," " + TextManager.getText("TID_GEN_TIME_HOURS_ABR",true) + " "," " + TextManager.getText("TID_GEN_TIME_MINUTES_ABR",true) + " ",null,false,false) : "[Unknown]";
                  _loc3_ = _loc3_ ? _loc3_ : "";
                  _loc1_ = _loc3_ != "" ? TextManager.replaceParameters(TextManager.getText("TID_GEN_AGO",true),[_loc3_]) : "Unknown";
                  this.mMessageAge.text = _loc1_ != null ? _loc1_ : "???";
                  this.updateMessageAgeProperties();
               }
            }
         }
      }
      
      public function getMessageTime() : Number
      {
         return this.mCurrentTimeMS;
      }
      
      private function createSeparator() : void
      {
         if(this.mSeparator == null)
         {
            this.mSeparator = new Quad(this.mText.width,1,Config.getConfig().getGuildSeparatorColor());
            addChild(this.mSeparator);
         }
         if(Boolean(this.mSeparator) && Boolean(this.mText) && Boolean(this.mMessageAge))
         {
            this.mSeparator.x = this.mText.x;
            this.mSeparator.y = this.mMessageAge.y + this.mMessageAge.height;
         }
      }
      
      public function getAccountId() : String
      {
         return this.mAccountId;
      }
      
      override public function dispose() : void
      {
         clearTimeout(this.mTimerId);
         if(this.mRankInsigniaImage)
         {
            this.mRankInsigniaImage.removeFromParent();
            this.mRankInsigniaImage.destroy();
            this.mRankInsigniaImage = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent();
            this.mNameTextfield = null;
         }
         if(this.mGuildEmblem)
         {
            this.mGuildEmblem.removeFromParent(true);
            this.mGuildEmblem = null;
         }
         if(this.mText)
         {
            this.mText.removeFromParent();
            this.mText = null;
         }
         if(this.mMessageAge)
         {
            this.mMessageAge.removeFromParent(true);
            this.mMessageAge = null;
         }
         if(this.mSeparator)
         {
            this.mSeparator.removeFromParent();
            this.mSeparator = null;
         }
         if(this.mChatMemberOptions)
         {
            this.mChatMemberOptions.removeFromParent(true);
            this.mChatMemberOptions = null;
         }
         if(this.mRankInsigniaImage)
         {
            this.mRankInsigniaImage.removeFromParent();
            this.mRankInsigniaImage.destroy();
            this.mRankInsigniaImage = null;
         }
         if(this.mGuildName)
         {
            this.mGuildName.removeFromParent(true);
            this.mGuildName = null;
         }
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mRankInsigniaImage)
         {
            this.mRankInsigniaImage.removeFromParent();
            this.mRankInsigniaImage = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent();
            this.mNameTextfield = null;
         }
         if(this.mGuildEmblem)
         {
            this.mGuildEmblem.removeFromParent(true);
            this.mGuildEmblem = null;
         }
         if(this.mText)
         {
            this.mText.removeFromParent();
            this.mText = null;
         }
         if(this.mMessageAge)
         {
            this.mMessageAge.removeFromParent(true);
            this.mMessageAge = null;
         }
         if(this.mSeparator)
         {
            this.mSeparator.removeFromParent();
            this.mSeparator = null;
         }
         if(this.mChatMemberOptions)
         {
            this.mChatMemberOptions.removeFromParent();
            this.mChatMemberOptions.destroy();
            this.mChatMemberOptions = null;
         }
         if(this.mRankInsigniaImage)
         {
            this.mRankInsigniaImage.removeFromParent();
            this.mRankInsigniaImage.destroy();
            this.mRankInsigniaImage = null;
         }
         if(this.mGuildName)
         {
            this.mGuildName.removeFromParent();
            this.mGuildName = null;
         }
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
      }
   }
}

