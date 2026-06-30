package com.fs.tcgengine.view.guilds
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.GuildsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.guilds.Guild;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSMemberOptions;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.FSPlayerConnectivityVisor;
   import com.fs.tcgengine.view.popups.guilds.PopupGuilds;
   import feathers.controls.Callout;
   import feathers.controls.ScrollContainer;
   import flash.geom.Point;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class GuildMemberSlot extends Component
   {
      
      private var mBG:CustomComponent;
      
      private var mRankInsigniaImage:FSImage;
      
      private var mNameTextfield:FSTextfield;
      
      private var mRankTextfield:FSTextfield;
      
      private var mGlobalScore:GuildScoreBatch;
      
      private var mWeeklyScore:GuildScoreBatch;
      
      private var mUserData:UserData;
      
      private var mGuildMemberRankOptions:FSMemberOptions;
      
      private var mParentScrollContainer:ScrollContainer;
      
      private var mPlayerConnectivityVisor:FSPlayerConnectivityVisor;
      
      public function GuildMemberSlot(param1:UserData)
      {
         super();
         this.mUserData = param1;
         this.createUI();
         touchable = true;
         useHandCursor = true;
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      public function addParentScrollContainer(param1:ScrollContainer) : void
      {
         this.mParentScrollContainer = param1;
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:UserData = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Guild = null;
         var _loc10_:Boolean = false;
         var _loc11_:Point = null;
         var _loc12_:Boolean = false;
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(Boolean(_loc2_ && this.mParentScrollContainer && !this.mParentScrollContainer.isScrolling) && Boolean(this.mUserData) && Boolean(InstanceMng.getServerConnection().getBackendUserProfile()))
         {
            _loc3_ = Utils.getOwnerUserData();
            if(_loc3_)
            {
               _loc4_ = _loc3_.getGuildId();
               _loc5_ = this.mUserData.getGuildId();
               _loc6_ = _loc5_ == _loc4_;
               _loc7_ = this.mUserData.getAccountId() == InstanceMng.getServerConnection().getUserId();
               _loc8_ = Config.smPvPHasFriendlyPvP ? true : _loc3_.getGuildRank() <= GuildsMng.RANK_OFFICER;
               _loc9_ = Boolean(InstanceMng.getPopupMng().getPopupShown()) && InstanceMng.getPopupMng().getPopupShown() is PopupGuilds ? PopupGuilds(InstanceMng.getPopupMng().getPopupShown()).getSelectedGuild() : null;
               _loc10_ = _loc5_ == "" && Boolean(_loc9_) && _loc9_.getId() == _loc4_;
               if((_loc6_ || _loc10_ || Config.smPvPHasFriendlyPvP) && !_loc7_ && _loc8_ && Boolean(parent))
               {
                  _loc11_ = parent.localToGlobal(new Point(x,y));
                  _loc12_ = _loc2_ && _loc11_ && (_loc2_.globalX >= _loc11_.x && _loc2_.globalX <= _loc11_.x + width) && (_loc2_.globalY >= _loc11_.y && _loc2_.globalY <= _loc11_.y + height);
                  if(_loc12_)
                  {
                     this.createMemberRankOptions();
                  }
               }
            }
         }
      }
      
      public function getMemberGuildId() : String
      {
         return this.mUserData ? this.mUserData.getGuildId() : "";
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createInsignia();
         this.createNameInfo();
         this.createScore();
         this.createOnlineStatus();
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = Utils.createCustomBox("guild_layer",1890);
            addChild(this.mBG);
         }
      }
      
      private function createInsignia() : void
      {
         var _loc1_:String = null;
         if(this.mRankInsigniaImage == null)
         {
            _loc1_ = Config.getConfig().hasPortraits() ? this.mUserData.getRankDef().getBGImageName() : "rank_insignia";
            this.mRankInsigniaImage = new FSImage(Root.assets.getTexture(_loc1_));
            this.mRankInsigniaImage.x = 10;
            this.mRankInsigniaImage.y = (this.mBG.height - this.mRankInsigniaImage.height) / 2;
            addChild(this.mRankInsigniaImage);
         }
      }
      
      private function createNameInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.mNameTextfield == null)
         {
            this.mNameTextfield = new FSTextfield(this.mBG.width / 3,this.mBG.height / 1.5,this.mUserData.getName(),16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
            this.mNameTextfield.format.verticalAlign = Align.BOTTOM;
            this.mNameTextfield.fontName = this.mUserData.getAccountId() == InstanceMng.getServerConnection().getUserId() ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD) : FSResourceMng.getFontByType();
            this.mNameTextfield.x = this.mRankInsigniaImage.x + this.mRankInsigniaImage.width * 1.05;
            this.mNameTextfield.y = 0;
            addChild(this.mNameTextfield);
         }
         if(this.mRankTextfield == null)
         {
            _loc1_ = this.mUserData.getGuildRank();
            _loc2_ = InstanceMng.getGuildsMng().getMemberTitleByRankId(_loc1_,false) + " (" + TextManager.replaceParameters(TextManager.getText("TID_GEN_LEVEL",true),[this.mUserData.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY)]) + " / PvP " + this.mUserData.getElo() + ")";
            this.mRankTextfield = new FSTextfield(this.mNameTextfield.width,this.mBG.height / 3,_loc2_,16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
            this.mRankTextfield.format.verticalAlign = Align.TOP;
            this.mRankTextfield.fontName = _loc1_ == GuildsMng.RANK_LEADER ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN) : FSResourceMng.getFontByType();
            this.mRankTextfield.x = this.mNameTextfield.x;
            this.mRankTextfield.y = this.mNameTextfield.y + this.mNameTextfield.height * 0.85;
            addChild(this.mRankTextfield);
         }
      }
      
      private function createScore() : void
      {
         if(this.mGlobalScore == null)
         {
            this.mGlobalScore = new GuildScoreBatch("guild_points_plate",this.mUserData.getGuildGlobalTotalScore());
            this.mGlobalScore.x = this.mBG.x + this.mBG.width * 0.985 - this.mGlobalScore.width * 1.05;
            this.mGlobalScore.y = this.mBG.y + (this.mBG.height - this.mGlobalScore.height) / 2;
            addChild(this.mGlobalScore);
         }
         if(this.mWeeklyScore == null)
         {
            this.mWeeklyScore = new GuildScoreBatch("guild_weekly_points_plate",this.mUserData.getGuildWeeklyTotalScore());
            this.mWeeklyScore.x = this.mGlobalScore.x - this.mWeeklyScore.width * 1.05;
            this.mWeeklyScore.y = this.mGlobalScore.y;
            addChild(this.mWeeklyScore);
         }
      }
      
      private function createOnlineStatus() : void
      {
         var _loc2_:UserData = null;
         var _loc3_:Boolean = false;
         var _loc1_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().hasGuild() && InstanceMng.getUserDataMng().getOwnerUserData().getGuildId() == this.mUserData.getGuildId();
         if(_loc1_ && this.mPlayerConnectivityVisor == null)
         {
            _loc2_ = Utils.getOwnerUserData();
            _loc3_ = _loc2_ ? _loc2_.getGuildRank() <= GuildsMng.RANK_OFFICER : false;
            this.mPlayerConnectivityVisor = new FSPlayerConnectivityVisor(this.mUserData.getCurrentDateMS(),5,_loc3_);
            this.mPlayerConnectivityVisor.x = 0;
            this.mPlayerConnectivityVisor.y = 0;
            addChild(this.mPlayerConnectivityVisor);
         }
      }
      
      private function createMemberRankOptions() : void
      {
         var _loc2_:Callout = null;
         var _loc1_:PopupGuilds = InstanceMng.getPopupMng().getPopupShown() is PopupGuilds ? PopupGuilds(InstanceMng.getPopupMng().getPopupShown()) : null;
         if(_loc1_)
         {
            if(_loc1_.getGuildMembersScrollContainer() != null && !_loc1_.getGuildMembersScrollContainer().isScrolling)
            {
               if(this.mGuildMemberRankOptions == null)
               {
                  this.mGuildMemberRankOptions = new FSMemberOptions(FSMemberOptions.TYPE_GUILD_MEMBER,this.mUserData.getAccountId(),this.mUserData.getGuildMemberId(),this.mUserData.getName(),"",this.mUserData.getRankIndex(),this);
               }
               _loc2_ = Callout.show(this.mGuildMemberRankOptions,this.mNameTextfield);
               this.mGuildMemberRankOptions.setParentCallout(_loc2_);
               this.mGuildMemberRankOptions.onShown();
               if(this.mNameTextfield)
               {
                  this.mNameTextfield.color = 16766720;
               }
            }
         }
      }
      
      public function hideMemberRankOptions() : void
      {
         if(this.mGuildMemberRankOptions)
         {
            this.mGuildMemberRankOptions.removeFromParent();
            this.mGuildMemberRankOptions.destroy();
            this.mGuildMemberRankOptions = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.color = 16777215;
         }
      }
      
      public function onMemberRankChanged(param1:int) : void
      {
         if(this.mRankTextfield)
         {
            this.mUserData.setGuildRank(param1);
            this.mRankTextfield.fontName = param1 == GuildsMng.RANK_LEADER ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN) : FSResourceMng.getFontByType();
            this.mRankTextfield.text = InstanceMng.getGuildsMng().getMemberTitleByRankId(param1,false);
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.color = 16777215;
         }
      }
      
      public function onMemberKicked() : void
      {
         removeFromParent();
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mRankInsigniaImage)
         {
            this.mRankInsigniaImage.removeFromParent(true);
            this.mRankInsigniaImage = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(this.mRankTextfield)
         {
            this.mRankTextfield.removeFromParent(true);
            this.mRankTextfield = null;
         }
         if(this.mGlobalScore)
         {
            this.mGlobalScore.removeFromParent(true);
            this.mGlobalScore = null;
         }
         if(this.mWeeklyScore)
         {
            this.mWeeklyScore.removeFromParent(true);
            this.mWeeklyScore = null;
         }
         if(this.mGuildMemberRankOptions)
         {
            this.mGuildMemberRankOptions.removeFromParent(true);
            this.mGuildMemberRankOptions = null;
         }
         this.mUserData = null;
         removeChildren(0,-1,true);
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
   }
}

