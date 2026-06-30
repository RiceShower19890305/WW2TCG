package com.fs.tcgengine.view.guilds
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.GuildsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.guilds.PopupGuilds;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class GuildRequestSlot extends Component
   {
      
      private var mBG:FSImage;
      
      private var mNameTextfield:FSTextfield;
      
      private var mLevelTextfield:FSTextfield;
      
      private var mRejectButton:FSButton;
      
      private var mAcceptButton:FSButton;
      
      private var mUserData:UserData;
      
      private var mRequestData:Object;
      
      public function GuildRequestSlot(param1:UserData, param2:Object)
      {
         super();
         this.mUserData = param1;
         this.mRequestData = param2;
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createNameInfo();
         this.createButtons();
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture("guild_layer_small"));
            Utils.setupImage9Scale(this.mBG,7.5,12.5,10,17.5,187.5,43.75);
            addChild(this.mBG);
         }
      }
      
      private function createNameInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.mNameTextfield == null)
         {
            this.mNameTextfield = new FSTextfield(this.mBG.width / 2,this.mBG.height / 1.5,this.mUserData.getName(),16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mNameTextfield.format.verticalAlign = Align.BOTTOM;
            this.mNameTextfield.x = 10;
            this.mNameTextfield.y = 0;
            addChild(this.mNameTextfield);
         }
         if(this.mLevelTextfield == null)
         {
            _loc1_ = this.mUserData ? this.mUserData.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
            _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_GEN_LEVEL",true),[_loc1_]) + " / PvP " + this.mUserData.getElo();
            this.mLevelTextfield = new FSTextfield(this.mNameTextfield.width,this.mBG.height / 3,_loc2_,16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
            this.mLevelTextfield.format.verticalAlign = Align.TOP;
            this.mLevelTextfield.x = this.mNameTextfield.x;
            this.mLevelTextfield.y = this.mNameTextfield.y + this.mNameTextfield.height * 0.85;
            addChild(this.mLevelTextfield);
         }
      }
      
      private function createButtons() : void
      {
         if(this.mAcceptButton == null)
         {
            this.mAcceptButton = new FSButton(Root.assets.getTexture("save_button"));
            this.mAcceptButton.x = this.mBG.x + this.mBG.width - this.mAcceptButton.width / 1.85;
            this.mAcceptButton.y = this.mBG.y + this.mBG.height / 2;
            this.mAcceptButton.addEventListener(Event.TRIGGERED,this.onAccept);
            addChild(this.mAcceptButton);
         }
         if(this.mRejectButton == null)
         {
            this.mRejectButton = new FSButton(Root.assets.getTexture("deny_button"));
            this.mRejectButton.x = this.mAcceptButton.x - this.mAcceptButton.width * 1.05;
            this.mRejectButton.y = this.mAcceptButton.y;
            this.mRejectButton.addEventListener(Event.TRIGGERED,this.onReject);
            addChild(this.mRejectButton);
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.width = this.mRejectButton.x - this.mNameTextfield.x - this.mRejectButton.width / 2;
         }
         if(this.mLevelTextfield)
         {
            this.mLevelTextfield.width = this.mNameTextfield.width;
         }
      }
      
      private function onAccept() : void
      {
         this.mAcceptButton.enabled = false;
         var _loc1_:String = InstanceMng.getUserDataMng().getOwnerUserData().getGuildId();
         InstanceMng.getServerConnection().acceptJoinGuildRequest(_loc1_,this.mUserData.getAccountId(),this.onJoinGuildRequestAccepted,this.onGetRequestFailed);
      }
      
      private function onJoinGuildRequestAccepted(param1:String, param2:String) : void
      {
         if(Boolean(this.mRequestData) && Boolean(this.mUserData))
         {
            InstanceMng.getServerConnection().deleteGuildRequest(Utils.getDataId(this.mRequestData));
            this.fadeAndRemove();
            this.onGuildMemberAddedSuccesfully(param1,this.mUserData.getAccountId());
         }
      }
      
      private function onGetRequestFailed(param1:String = "") : void
      {
         param1 = param1 ? ": " + param1.toUpperCase() : "";
         if(InstanceMng.getGuildsMng().getMyGuild().hasPrivilegesForManaging())
         {
            Utils.setLogText(TextManager.getText("TID_GUILD_MEMBER_ADD_ERROR") + param1,true);
         }
         else
         {
            InstanceMng.getGuildsMng().notifyPlayerIsTemporaryOwner();
         }
      }
      
      private function onGuildMemberAddedSuccesfully(param1:String, param2:String) : void
      {
         Utils.setLogText(TextManager.getText("TID_GUILD_MEMBER_ADDED"));
         if(InstanceMng.getGuildsMng().getMyGuild())
         {
            InstanceMng.getGuildsMng().getMyGuild().addMember(param2,GuildsMng.RANK_MEMBER);
         }
      }
      
      private function onGuildMemberAddedFailed() : void
      {
         Utils.setLogText(TextManager.getText("TID_GUILD_MEMBER_ADD_ERROR"),true);
      }
      
      private function onGuildInfoFailed() : void
      {
         if(this.mAcceptButton)
         {
            this.mAcceptButton.enabled = true;
         }
         Utils.setLogText(TextManager.getText("TID_GUILD_TRY_AGAIN"),true);
      }
      
      private function onReject() : void
      {
         if(InstanceMng.getGuildsMng().getMyGuild().hasPrivilegesForManaging())
         {
            if(this.mRejectButton)
            {
               this.mRejectButton.enabled = false;
            }
            if(this.mRequestData)
            {
               InstanceMng.getServerConnection().deleteGuildRequest(Utils.getDataId(this.mRequestData));
            }
            this.fadeAndRemove();
         }
         else
         {
            InstanceMng.getGuildsMng().notifyPlayerIsTemporaryOwner();
         }
      }
      
      private function fadeAndRemove() : void
      {
         var _loc1_:PopupGuilds = InstanceMng.getPopupMng().getPopupShown() is PopupGuilds ? PopupGuilds(InstanceMng.getPopupMng().getPopupShown()) : null;
         if(_loc1_)
         {
            _loc1_.deleteRequestReceived(this);
         }
         SpecialFX.tweenToAlpha(this,0.0001,0.15,0,this.onFaded);
      }
      
      private function onFaded() : void
      {
         removeFromParent();
         var _loc1_:PopupGuilds = InstanceMng.getPopupMng().getPopupShown() is PopupGuilds ? PopupGuilds(InstanceMng.getPopupMng().getPopupShown()) : null;
         if(_loc1_)
         {
            _loc1_.onGuildRequestSlotDeleted();
         }
      }
      
      public function getRequestData() : Object
      {
         return this.mRequestData;
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(this.mLevelTextfield)
         {
            this.mLevelTextfield.removeFromParent(true);
            this.mLevelTextfield = null;
         }
         if(this.mRejectButton)
         {
            this.mRejectButton.removeFromParent(true);
            this.mRejectButton = null;
         }
         if(this.mAcceptButton)
         {
            this.mAcceptButton.removeFromParent(true);
            this.mAcceptButton = null;
         }
         this.mUserData = null;
         this.mRequestData = null;
         removeChildren(0,-1,true);
         super.dispose();
      }
   }
}

