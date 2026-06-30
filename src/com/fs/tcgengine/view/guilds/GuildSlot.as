package com.fs.tcgengine.view.guilds
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.GuildsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.guilds.Guild;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.guilds.PopupGuilds;
   import feathers.controls.ScrollContainer;
   import flash.geom.Point;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class GuildSlot extends Component
   {
      
      protected var mBG:CustomComponent;
      
      protected var mLogo:GuildEmblem;
      
      protected var mNameTextfield:FSTextfield;
      
      private var mMembersTextfield:FSTextfield;
      
      protected var mScore:GuildRankingBatch;
      
      protected var mGuild:Guild;
      
      protected var mSeparator1:FSImage;
      
      protected var mSeparator2:FSImage;
      
      protected var mSeparator3:FSImage;
      
      private var mMoreInfoTextfield:FSTextfield;
      
      private var mParentScrollContainer:ScrollContainer;
      
      public function GuildSlot(param1:Guild)
      {
         super();
         this.mGuild = param1;
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
         var _loc3_:Point = null;
         var _loc4_:Boolean = false;
         var _loc5_:PopupGuilds = null;
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(Boolean(_loc2_) && Boolean(this.mParentScrollContainer) && !this.mParentScrollContainer.isScrolling)
         {
            _loc3_ = parent.localToGlobal(new Point(x,y));
            _loc4_ = Boolean(_loc2_) && (_loc2_.globalX >= _loc3_.x && _loc2_.globalX <= _loc3_.x + width) && (_loc2_.globalY >= _loc3_.y && _loc2_.globalY <= _loc3_.y + height);
            if(_loc4_)
            {
               _loc5_ = InstanceMng.getPopupMng().getPopupShown() is PopupGuilds ? PopupGuilds(InstanceMng.getPopupMng().getPopupShown()) : null;
               if(_loc5_)
               {
                  _loc5_.refreshGuildInfo(this.mGuild.getId());
               }
            }
         }
      }
      
      protected function createUI() : void
      {
         this.createBG();
         this.createLogo();
         this.createNameInfo();
         this.createMembersInfo();
         this.createScore();
         this.createMoreInfoLabel();
      }
      
      protected function createLogo() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.mLogo == null)
         {
            _loc1_ = this.mGuild.getEmblemBG() ? this.mGuild.getEmblemBG() : "guild_logo_01";
            _loc2_ = this.mGuild.getEmblemFG() ? this.mGuild.getEmblemFG() : "guild_frame_01";
            this.mLogo = new GuildEmblem(_loc1_,_loc2_);
            this.mLogo.x = 10;
            this.mLogo.y = (this.mBG.height - this.mLogo.height) / 2;
            addChild(this.mLogo);
         }
      }
      
      protected function createNameInfo() : void
      {
         if(this.mNameTextfield == null)
         {
            this.mNameTextfield = new FSTextfield(this.mBG.width / 3.3,this.mBG.height,this.mGuild.getName(),16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mNameTextfield.fontName = FSResourceMng.getFontByType();
            this.mNameTextfield.x = this.mLogo.x + this.mLogo.width * 1.05;
            this.mNameTextfield.y = 0;
            addChild(this.mNameTextfield);
         }
         if(this.mSeparator1 == null)
         {
            this.mSeparator1 = new FSImage(Root.assets.getTexture("guild_separator"));
            this.mSeparator1.x = this.mNameTextfield.x + this.mNameTextfield.width + 5;
            this.mSeparator1.y = this.mNameTextfield.y;
            addChild(this.mSeparator1);
         }
      }
      
      protected function createMembersInfo() : void
      {
         var _loc1_:String = null;
         if(this.mMembersTextfield == null)
         {
            _loc1_ = TextManager.getText("TID_GUILD_MEMBERS") + " " + this.mGuild.getMembersAmount() + "/" + GuildsMng.smMaxMembers;
            this.mMembersTextfield = new FSTextfield(this.mBG.width / 4.5,this.mBG.height,_loc1_,16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
            this.mMembersTextfield.x = this.mSeparator1.x + this.mSeparator1.width + 5;
            this.mMembersTextfield.y = this.mSeparator1.y;
            addChild(this.mMembersTextfield);
         }
         if(this.mSeparator2 == null)
         {
            this.mSeparator2 = new FSImage(Root.assets.getTexture("guild_separator"));
            this.mSeparator2.x = this.mMembersTextfield.x + this.mMembersTextfield.width + 5;
            this.mSeparator2.y = this.mSeparator1.y;
            addChild(this.mSeparator2);
         }
      }
      
      protected function createScore() : void
      {
         if(this.mScore == null)
         {
            this.mScore = new GuildRankingBatch("guild_rank_plate",this.mGuild.getGlobalTotalScore());
            this.mScore.x = this.mSeparator2 ? this.mSeparator2.x + this.mSeparator2.width + 5 : this.mSeparator1.x + this.mSeparator1.width + 5;
            this.mScore.y = this.mSeparator2 ? this.mSeparator2.y + (this.mBG.height - this.mScore.height) / 2 : this.mSeparator1.y + (this.mBG.height - this.mScore.height) / 2;
            addChild(this.mScore);
         }
         if(this.mSeparator3 == null)
         {
            this.mSeparator3 = new FSImage(Root.assets.getTexture("guild_separator"));
            this.mSeparator3.x = this.mScore.x + this.mScore.width + 5;
            this.mSeparator3.y = this.mSeparator1.y;
            addChild(this.mSeparator3);
         }
      }
      
      protected function createMoreInfoLabel() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         if(this.mMoreInfoTextfield == null)
         {
            _loc1_ = Utils.isBrowser() || Utils.isDesktop() ? TextManager.getText("TID_GUILD_MORE_INFO") : TextManager.getText("TID_GUILD_TAP_INFO");
            if(Utils.isAndroid())
            {
               _loc2_ = this.mBG.width / 16;
            }
            else if(Utils.isBrowser() || Utils.isDesktop())
            {
               _loc2_ = this.mBG.width / 10.5;
            }
            else
            {
               _loc2_ = this.mBG.width / 9;
            }
            this.mMoreInfoTextfield = new FSTextfield(_loc2_,this.mBG.height * 0.9,_loc1_,16777215,FSResourceMng.FONT_STD_SMALL_SIZE);
            this.mMoreInfoTextfield.x = this.mSeparator3.x + this.mSeparator3.width + 5;
            this.mMoreInfoTextfield.y = this.mNameTextfield.y + (this.mBG.height - this.mMoreInfoTextfield.height) / 2;
            addChild(this.mMoreInfoTextfield);
         }
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = Utils.createCustomBox("guild_layer",1890);
            addChild(this.mBG);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mLogo)
         {
            this.mLogo.removeFromParent(true);
            this.mLogo = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(this.mMembersTextfield)
         {
            this.mMembersTextfield.removeFromParent(true);
            this.mMembersTextfield = null;
         }
         if(this.mScore)
         {
            this.mScore.removeFromParent(true);
            this.mScore = null;
         }
         this.mGuild = null;
         if(this.mSeparator1)
         {
            this.mSeparator1.removeFromParent(true);
            this.mSeparator1 = null;
         }
         if(this.mSeparator2)
         {
            this.mSeparator2.removeFromParent(true);
            this.mSeparator2 = null;
         }
         if(this.mSeparator3)
         {
            this.mSeparator3.removeFromParent(true);
            this.mSeparator3 = null;
         }
         if(this.mMoreInfoTextfield)
         {
            this.mMoreInfoTextfield.removeFromParent(true);
            this.mMoreInfoTextfield = null;
         }
         removeChildren(0,-1,true);
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
   }
}

