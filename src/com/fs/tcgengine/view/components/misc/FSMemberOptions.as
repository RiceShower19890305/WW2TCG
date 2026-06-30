package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.GuildsMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.guilds.Guild;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSPvPScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.guilds.FSGuildChatBlock;
   import com.fs.tcgengine.view.guilds.GuildMemberSlot;
   import com.fs.tcgengine.view.misc.FSChatBlock;
   import com.fs.tcgengine.view.popups.guilds.PopupGuilds;
   import com.greensock.TweenMax;
   import feathers.controls.Callout;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import starling.events.Event;
   
   public class FSMemberOptions extends Component
   {
      
      public static const TYPE_CHAT:int = 0;
      
      public static const TYPE_GUILD_MEMBER:int = 1;
      
      private var mPromoteButton:FSButton;
      
      private var mDemoteButton:FSButton;
      
      private var mKickButton:FSButton;
      
      private var mPvPButton:FSButton;
      
      private var mGuildMemberId:String;
      
      private var mAccountId:String;
      
      private var mNick:String;
      
      private var mPlayerRank:int;
      
      private var mGuildId:String;
      
      private var mParentGuildMemberSlot:GuildMemberSlot;
      
      private var mParentChatMemberSlot:FSChatBlock;
      
      private var mType:int;
      
      private var mViewGuildButton:FSButton;
      
      private var mMuteButton:FSButton;
      
      private var mCalloutParent:Callout;
      
      private var mCopyTextButton:FSButton;
      
      public function FSMemberOptions(param1:int, param2:String, param3:String = "", param4:String = "", param5:String = "", param6:int = -1, param7:GuildMemberSlot = null, param8:FSChatBlock = null)
      {
         super();
         this.mType = param1;
         this.mGuildMemberId = param3;
         this.mAccountId = param2;
         this.mNick = param4;
         this.mParentGuildMemberSlot = param7;
         this.mPlayerRank = param6;
         this.mGuildId = param5;
         this.mParentChatMemberSlot = param8;
         this.createUI();
      }
      
      public function updateData(param1:String, param2:String = "") : void
      {
         this.mAccountId = param1;
         this.mGuildId = param2;
         this.createUI();
      }
      
      public function setParentCallout(param1:Callout) : void
      {
         this.mCalloutParent = param1;
      }
      
      private function createUI() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:UserData = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:String = null;
         var _loc1_:int = Config.smPvPHasFriendlyPvP ? 4 : 3;
         if(this.mType == TYPE_GUILD_MEMBER)
         {
            if(this.mPromoteButton == null)
            {
               this.mPromoteButton = new FSButton(Root.assets.getTexture("button_join"),TextManager.getText("TID_GUILD_MANAGE_PROMOTE"));
               Utils.setupButton9Scale(this.mPromoteButton,7.5,15,5,5,90.25,33.75);
               this.mPromoteButton.x = this.mPromoteButton.width / 2;
               this.mPromoteButton.y = this.mPromoteButton.height / 2;
               this.mPromoteButton.addEventListener(Event.TRIGGERED,this.onPromote);
               addChild(this.mPromoteButton);
            }
            if(this.mDemoteButton == null)
            {
               this.mDemoteButton = new FSButton(Root.assets.getTexture("button_leave"),TextManager.getText("TID_GUILD_MANAGE_DEMOTE"));
               Utils.setupButton9Scale(this.mDemoteButton,7.5,15,5,5,90.25,33.75);
               this.mDemoteButton.x = this.mPromoteButton.x;
               this.mDemoteButton.y = this.mPromoteButton.y + this.mPromoteButton.height * 1.025;
               this.mDemoteButton.addEventListener(Event.TRIGGERED,this.onDemote);
               addChild(this.mDemoteButton);
            }
            if(this.mKickButton == null)
            {
               this.mKickButton = new FSButton(Root.assets.getTexture("button_leave"),TextManager.getText("TID_GUILD_MANAGE_KICK"));
               Utils.setupButton9Scale(this.mKickButton,7.5,15,5,5,90.25,33.75);
               this.mKickButton.x = this.mPromoteButton.x;
               this.mKickButton.y = this.mDemoteButton.y + this.mDemoteButton.height * 1.025;
               this.mKickButton.addEventListener(Event.TRIGGERED,this.doubleCheckBeforeKicking);
               addChild(this.mKickButton);
            }
            _loc2_ = this.mPromoteButton.x;
            _loc3_ = this.mKickButton.y + this.mKickButton.height * 1.025;
            _loc4_ = this.mPromoteButton.x;
            _loc5_ = this.mKickButton.y + this.mKickButton.height * 1.025;
         }
         else if(this.mType == TYPE_CHAT)
         {
            _loc6_ = Utils.getOwnerUserData();
            _loc7_ = _loc6_ ? _loc6_.getGuildId() == this.mGuildId : false;
            _loc8_ = this.mParentChatMemberSlot is FSGuildChatBlock;
            _loc9_ = !_loc8_ && !_loc7_;
            _loc10_ = InstanceMng.getCurrentScreen() is FSPvPScreen;
            if(this.mViewGuildButton == null)
            {
               this.mViewGuildButton = new FSButton(Root.assets.getTexture("button_join"),TextManager.getText("TID_CHAT_VIEW_GUILD"));
               Utils.setupButton9Scale(this.mViewGuildButton,7.5,15,5,5,90.25,33.75);
               this.mViewGuildButton.x = this.mViewGuildButton.width / 2;
               this.mViewGuildButton.y = this.mViewGuildButton.height / 2;
               this.mViewGuildButton.addEventListener(Event.TRIGGERED,this.onViewGuild);
            }
            addChild(this.mViewGuildButton);
            this.mViewGuildButton.enabled = _loc9_ || _loc10_;
            if(this.mMuteButton == null)
            {
               _loc11_ = InstanceMng.getUserDataMng().isPlayerInMutedList(this.mAccountId);
               _loc12_ = _loc11_ ? TextManager.getText("TID_CHAT_UNMUTE") : TextManager.getText("TID_CHAT_MUTE");
               this.mMuteButton = new FSButton(Root.assets.getTexture("button_leave"),_loc12_);
               Utils.setupButton9Scale(this.mMuteButton,7.5,15,5,5,90.25,33.75);
               this.mMuteButton.x = this.mViewGuildButton.x;
               this.mMuteButton.y = this.mViewGuildButton.y + this.mViewGuildButton.height * 1.025;
               this.mMuteButton.addEventListener(Event.TRIGGERED,this.onMute);
            }
            addChild(this.mMuteButton);
            this.mMuteButton.enabled = _loc9_ && !_loc10_;
            _loc2_ = this.mViewGuildButton.x;
            _loc3_ = this.mMuteButton.y + this.mMuteButton.height * 1.025;
            _loc4_ = this.mViewGuildButton.x;
            _loc5_ = this.mMuteButton.y + this.mMuteButton.height * 1.025;
         }
         if(Config.smPvPHasFriendlyPvP)
         {
            if(this.mPvPButton == null)
            {
               this.mPvPButton = new FSButton(Root.assets.getTexture("button_join"),TextManager.getText("TID_GEN_MENU_PVP"));
               Utils.setupButton9Scale(this.mPvPButton,7.5,15,5,5,90.25,33.75);
               this.mPvPButton.x = _loc2_;
               this.mPvPButton.y = _loc3_;
               this.mPvPButton.addEventListener(Event.TRIGGERED,this.onPvP);
            }
            _loc4_ = this.mPvPButton.x;
            _loc5_ = this.mPvPButton.y + this.mPvPButton.height * 1.025;
            addChild(this.mPvPButton);
         }
         if(this.mType == TYPE_CHAT)
         {
            if(this.mCopyTextButton == null)
            {
               this.mCopyTextButton = new FSButton(Root.assets.getTexture("button_join"),TextManager.getText("TID_COPY_TEXT"));
               Utils.setupButton9Scale(this.mCopyTextButton,7.5,15,5,5,90.25,33.75);
               this.mCopyTextButton.x = _loc4_;
               this.mCopyTextButton.y = _loc5_;
               this.mCopyTextButton.addEventListener(Event.TRIGGERED,this.onCopyText);
            }
            addChild(this.mCopyTextButton);
         }
      }
      
      private function onCopyText(param1:Event) : void
      {
         if(this.mCalloutParent)
         {
            this.mCalloutParent.close();
         }
         var _loc2_:String = this.mParentChatMemberSlot != null ? this.mParentChatMemberSlot.mText.text : "";
         var _loc3_:Boolean = Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,_loc2_);
         if(_loc3_)
         {
            Utils.setLogText(TextManager.getText("TID_COPIED_TEXT"));
         }
      }
      
      private function onViewGuild(param1:Event) : void
      {
         if(this.mGuildId == null || this.mGuildId == "")
         {
            Utils.setLogText(TextManager.getText("TID_GUILD_NOT_MEMBER"));
            return;
         }
         if(this.mCalloutParent)
         {
            this.mCalloutParent.close();
         }
         InstanceMng.getApplication().hideGuildsPanel();
         InstanceMng.getPopupMng().openGuildsPopup(this.mGuildId);
      }
      
      private function onMute(param1:Event) : void
      {
         var _loc3_:Boolean = false;
         var _loc2_:Boolean = InstanceMng.getUserDataMng().isPlayerInMutedList(this.mAccountId);
         if(!_loc2_)
         {
            _loc3_ = _loc3_ = ServerConnection.smChatMutedTimestamp == -1 || ServerConnection.smChatMutedTimestamp != -1 && ServerConnection.smChatMutedTimestamp < ServerConnection.smServerTimeMS;
            if(!_loc3_)
            {
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_CHAT_MUTE_BAN_USE"),[InstanceMng.getServerConnection().getChatMutedTimeLeft()]),false,false,false);
            }
            else
            {
               InstanceMng.getServerConnection().muteGeneralPlayerChat(this.mAccountId,this.onMemberMutedSuccess);
            }
         }
         else
         {
            InstanceMng.getServerConnection().unmuteGeneralPlayerChat(this.mAccountId,this.onMemberUnmutedSuccess);
         }
         if(this.mCalloutParent)
         {
            this.mCalloutParent.close();
         }
         removeFromParent();
      }
      
      private function onMemberMutedSuccess() : void
      {
         InstanceMng.getUserDataMng().addPlayerToMutedPlayersList(this.mAccountId);
         Utils.setLogText(TextManager.getText("TID_CHAT_MUTE_SUCCESS"));
      }
      
      private function onMemberUnmutedSuccess() : void
      {
         InstanceMng.getUserDataMng().removeMutedPlayerFromList(this.mAccountId);
         Utils.setLogText(TextManager.getText("TID_CHAT_UNMUTE_SUCCESS"));
      }
      
      private function onPvP(param1:Event) : void
      {
         if(this.mCalloutParent)
         {
            this.mCalloutParent.close();
         }
         if(this.mPvPButton)
         {
            this.mPvPButton.enabled = false;
         }
         if(this.mType == TYPE_GUILD_MEMBER)
         {
            if(InstanceMng.getPopupMng().getPopupShown())
            {
               InstanceMng.getPopupMng().getPopupShown().closePopup(this.startFriendlyPvP);
            }
         }
         else
         {
            PvPConnectionMng.onPlayPvPTriggered(true,this.mAccountId,this.mPvPButton,true);
         }
      }
      
      private function startFriendlyPvP() : void
      {
         PvPConnectionMng.onPlayPvPTriggered(true,this.mAccountId,this.mPvPButton,true);
      }
      
      public function onShown() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Guild = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:UserData = null;
         var _loc7_:Boolean = false;
         if(this.mType == TYPE_GUILD_MEMBER)
         {
            _loc1_ = this.belongsToOwnersGuild();
            if(_loc1_)
            {
               _loc2_ = InstanceMng.getGuildsMng().getMyGuild();
               if(_loc2_)
               {
                  _loc3_ = _loc2_.getMemberRankById(this.mAccountId);
                  _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getGuildRank();
                  _loc5_ = _loc4_ < _loc3_;
                  _loc6_ = Utils.getOwnerUserData();
                  _loc7_ = _loc6_ ? _loc6_.getGuildRank() <= GuildsMng.RANK_OFFICER : false;
                  if(_loc3_ != -1)
                  {
                     if(this.mPromoteButton)
                     {
                        this.mPromoteButton.enabled = _loc7_ && _loc5_ && _loc3_ > GuildsMng.RANK_LEADER && _loc3_ != GuildsMng.RANK_UNCONFIRMED && _loc4_ <= _loc3_ - 1;
                     }
                     if(this.mDemoteButton)
                     {
                        this.mDemoteButton.enabled = _loc7_ && _loc5_ && _loc3_ < GuildsMng.RANK_MEMBER;
                     }
                     if(this.mKickButton)
                     {
                        this.mKickButton.enabled = _loc7_ && _loc5_ && _loc4_ <= GuildsMng.RANK_OFFICER;
                     }
                     if(this.mPvPButton)
                     {
                        this.mPvPButton.enabled = true;
                     }
                  }
                  else
                  {
                     InstanceMng.getGuildsMng().refreshMyGuild();
                     Utils.setLogText(TextManager.getText("TID_GUILD_TRY_AGAIN"),true);
                     if(this.mPromoteButton)
                     {
                        this.mPromoteButton.enabled = false;
                     }
                     if(this.mDemoteButton)
                     {
                        this.mDemoteButton.enabled = false;
                     }
                     if(this.mKickButton)
                     {
                        this.mKickButton.enabled = false;
                     }
                     if(this.mPvPButton)
                     {
                        this.mPvPButton.enabled = false;
                     }
                  }
               }
            }
            else
            {
               if(this.mPromoteButton)
               {
                  this.mPromoteButton.enabled = false;
               }
               if(this.mDemoteButton)
               {
                  this.mDemoteButton.enabled = false;
               }
               if(this.mKickButton)
               {
                  this.mKickButton.enabled = false;
               }
               if(this.mPvPButton)
               {
                  this.mPvPButton.enabled = true;
               }
            }
         }
      }
      
      private function belongsToOwnersGuild() : Boolean
      {
         var _loc1_:String = InstanceMng.getGuildsMng().getMyGuild() ? InstanceMng.getGuildsMng().getMyGuild().getId() : "";
         return this.mParentGuildMemberSlot && _loc1_ != "" && _loc1_ != null && _loc1_ == this.mParentGuildMemberSlot.getMemberGuildId();
      }
      
      private function onPromote(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.mCalloutParent)
         {
            this.mCalloutParent.close();
         }
         var _loc2_:Guild = InstanceMng.getGuildsMng().getMyGuild();
         if(_loc2_)
         {
            _loc3_ = InstanceMng.getGuildsMng().getMyGuild().getMemberRankById(this.mAccountId);
            _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getGuildRank();
            if(_loc3_ > GuildsMng.RANK_OFFICER)
            {
               _loc3_ = _loc3_ - 1 > _loc4_ ? int(_loc3_ - 1) : _loc3_;
               InstanceMng.getServerConnection().editGuildMemberRank(_loc2_.getId(),_loc3_,this.mAccountId,this.onMemberPromotedSuccess,this.onMemberRankModifiedFailed);
            }
            else if(InstanceMng.getPopupMng().getPopupShown())
            {
               this.doubleCheckBeforePromotingToLeader();
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GUILD_TRY_AGAIN"),true);
         }
      }
      
      private function doubleCheckBeforePromotingToLeader() : void
      {
         var _loc1_:String = TextManager.replaceParameters(TextManager.getText("TID_GUILD_PROMOTE_GM"),[this.mNick,InstanceMng.getGuildsMng().getMemberTitleByRankId(GuildsMng.RANK_LEADER)]);
         InstanceMng.getPopupMng().getPopupShown().hideTemporarily(InstanceMng.getPopupMng().openConfirmationPopup,[_loc1_,this.onConfirmedReplaceGuildMaster]);
      }
      
      private function onConfirmedReplaceGuildMaster() : void
      {
         var onReplaceFailed:Function = null;
         onReplaceFailed = function():void
         {
            Utils.setLogText(TextManager.getText("TID_GUILD_TRY_AGAIN"),true);
         };
         var myGuild:Guild = InstanceMng.getGuildsMng().getMyGuild();
         InstanceMng.getServerConnection().replaceGuildMaster(myGuild.getId(),this.mAccountId,this.onGuildMasterReplaced,onReplaceFailed);
      }
      
      private function onGuildMasterReplaced() : void
      {
         this.onMemberPromotedSuccess();
      }
      
      private function onMemberPromotedSuccess() : void
      {
         var _loc1_:int = InstanceMng.getGuildsMng().getMyGuild().getMemberRankById(this.mAccountId);
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData().getGuildRank();
         _loc1_ = _loc1_ - 1 > _loc2_ ? int(_loc1_ - 1) : _loc1_;
         _loc1_ = _loc1_ >= GuildsMng.RANK_OFFICER ? _loc1_ : GuildsMng.RANK_OFFICER;
         InstanceMng.getGuildsMng().getMyGuild().updateMemberRank(this.mAccountId,_loc1_);
         if(this.mParentGuildMemberSlot)
         {
            this.mParentGuildMemberSlot.onMemberRankChanged(_loc1_);
         }
      }
      
      private function onMemberRankModifiedFailed() : void
      {
         if(InstanceMng.getGuildsMng().getMyGuild().hasPrivilegesForManaging())
         {
            Utils.setLogText(TextManager.getText("TID_GUILD_TRY_AGAIN"),true);
         }
         else
         {
            TweenMax.delayedCall(1,InstanceMng.getGuildsMng().notifyPlayerIsTemporaryOwner);
         }
      }
      
      private function onDemote(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.mCalloutParent)
         {
            this.mCalloutParent.close();
         }
         var _loc2_:Guild = InstanceMng.getGuildsMng().getMyGuild();
         if(_loc2_)
         {
            _loc3_ = _loc2_.getMemberRankById(this.mAccountId);
            _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getGuildRank();
            _loc3_ = _loc3_ + 1 < GuildsMng.RANK_UNCONFIRMED ? int(_loc3_ + 1) : _loc3_;
            _loc3_ = _loc3_ != -1 ? _loc3_ : GuildsMng.RANK_MEMBER;
            InstanceMng.getServerConnection().editGuildMemberRank(_loc2_.getId(),_loc3_,this.mAccountId,this.onMemberDemotedSuccess,this.onMemberRankModifiedFailed);
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GUILD_TRY_AGAIN"),true);
         }
      }
      
      private function onMemberDemotedSuccess() : void
      {
         var _loc1_:int = InstanceMng.getGuildsMng().getMyGuild().getMemberRankById(this.mAccountId);
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData().getGuildRank();
         _loc1_ = _loc1_ + 1 < GuildsMng.RANK_UNCONFIRMED ? int(_loc1_ + 1) : _loc1_;
         _loc1_ = _loc1_ != -1 ? _loc1_ : GuildsMng.RANK_MEMBER;
         InstanceMng.getGuildsMng().getMyGuild().updateMemberRank(this.mAccountId,_loc1_);
         if(this.mParentGuildMemberSlot)
         {
            this.mParentGuildMemberSlot.onMemberRankChanged(_loc1_);
         }
      }
      
      private function onKick() : void
      {
         if(this.mCalloutParent)
         {
            this.mCalloutParent.close();
         }
         var _loc1_:int = GuildsMng.RANK_MEMBER;
         var _loc2_:String = InstanceMng.getGuildsMng().getMyGuild() ? InstanceMng.getGuildsMng().getMyGuild().getId() : "";
         InstanceMng.getServerConnection().editGuildMemberRank(_loc2_,-1,this.mAccountId,this.onMemberKickedSuccess,this.onMemberRankModifiedFailed);
      }
      
      private function doubleCheckBeforeKicking(param1:Event) : void
      {
         var _loc2_:String = TextManager.replaceParameters(TextManager.getText("TID_GUILD_KICK_CONFIRMATION"),[this.mNick]);
         InstanceMng.getPopupMng().getPopupShown().hideTemporarily(InstanceMng.getPopupMng().openConfirmationPopup,[_loc2_,this.onKick,this.cancelKick]);
      }
      
      private function cancelKick() : void
      {
         InstanceMng.getPopupMng().closePopupShown();
         if(this.mParentGuildMemberSlot)
         {
            this.mParentGuildMemberSlot.hideMemberRankOptions();
         }
      }
      
      private function onMemberKickedSuccess() : void
      {
         var _loc1_:Guild = InstanceMng.getGuildsMng().getMyGuild();
         var _loc2_:int = _loc1_ ? _loc1_.getMemberRankById(this.mAccountId) : -1;
         InstanceMng.getGuildsMng().getMyGuild().removeMemberById(this.mAccountId);
         if(this.mParentGuildMemberSlot)
         {
            this.mParentGuildMemberSlot.onMemberKicked();
         }
         var _loc3_:PopupGuilds = InstanceMng.getPopupMng().getPopupShown() is PopupGuilds ? PopupGuilds(InstanceMng.getPopupMng().getPopupShown()) : null;
         if(_loc3_)
         {
            _loc3_.onMemberKicked(this.mAccountId);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mPromoteButton)
         {
            this.mPromoteButton.removeFromParent(true);
            this.mPromoteButton = null;
         }
         if(this.mDemoteButton)
         {
            this.mDemoteButton.removeFromParent(true);
            this.mDemoteButton = null;
         }
         if(this.mKickButton)
         {
            this.mKickButton.removeFromParent(true);
            this.mKickButton = null;
         }
         if(this.mPvPButton)
         {
            this.mPvPButton.removeFromParent(true);
            this.mPvPButton = null;
         }
         if(this.mViewGuildButton)
         {
            this.mViewGuildButton.removeFromParent(true);
            this.mViewGuildButton = null;
         }
         if(this.mMuteButton)
         {
            this.mMuteButton.removeFromParent(true);
            this.mMuteButton = null;
         }
         this.mParentGuildMemberSlot = null;
         this.mParentChatMemberSlot = null;
         this.mCalloutParent = null;
         removeChildren(0,-1,true);
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mPromoteButton)
         {
            this.mPromoteButton.removeFromParent();
            this.mPromoteButton.removeEventListener(Event.TRIGGERED,this.onPromote);
            this.mPromoteButton.destroy();
            this.mPromoteButton = null;
         }
         if(this.mDemoteButton)
         {
            this.mDemoteButton.removeFromParent();
            this.mDemoteButton.removeEventListener(Event.TRIGGERED,this.onDemote);
            this.mDemoteButton.destroy();
            this.mDemoteButton = null;
         }
         if(this.mKickButton)
         {
            this.mKickButton.removeFromParent();
            this.mKickButton.removeEventListener(Event.TRIGGERED,this.onKick);
            this.mKickButton.destroy();
            this.mKickButton = null;
         }
         if(this.mPvPButton)
         {
            this.mPvPButton.removeFromParent();
            this.mPvPButton.removeEventListener(Event.TRIGGERED,this.onMute);
            this.mPvPButton.destroy();
            this.mPvPButton = null;
         }
         if(this.mViewGuildButton)
         {
            this.mViewGuildButton.removeEventListener(Event.TRIGGERED,this.onViewGuild);
            this.mViewGuildButton.removeFromParent();
            this.mViewGuildButton.destroy();
            this.mViewGuildButton = null;
         }
         if(this.mMuteButton)
         {
            this.mMuteButton.removeEventListener(Event.TRIGGERED,this.onMute);
            this.mMuteButton.removeFromParent();
            this.mMuteButton.destroy();
            this.mMuteButton = null;
         }
         this.mParentChatMemberSlot = null;
         this.mParentGuildMemberSlot = null;
         removeChildren();
      }
   }
}

