package com.fs.tcgengine.view.guilds
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.GuildsMng;
   import com.fs.tcgengine.model.rules.RankDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSChatBlock;
   import starling.text.TextFieldAutoSize;
   import starling.utils.Align;
   
   public class FSGuildChatBlock extends FSChatBlock
   {
      
      private var mGuildRankIndex:int;
      
      private var mFontName:String;
      
      private var mFontColor:uint;
      
      private var mShowMessageAgeAlways:Boolean;
      
      public function FSGuildChatBlock(param1:int, param2:String, param3:RankDef, param4:String, param5:String, param6:Number, param7:int, param8:String = "", param9:uint = 16777215, param10:Boolean = false)
      {
         this.mGuildRankIndex = param7;
         this.mFontName = param8 == "" ? FSResourceMng.getFontByType() : param8;
         this.mFontColor = param9;
         this.mShowMessageAgeAlways = param10;
         super(param1,param2,param3,param4,param5,param6);
      }
      
      public function setGuildRank(param1:int) : void
      {
         this.mGuildRankIndex = param1;
      }
      
      public function setFontName(param1:String) : void
      {
         this.mFontName = param1 == "" ? FSResourceMng.getFontByType() : param1;
      }
      
      public function setFontColor(param1:uint) : void
      {
         this.mFontColor = param1;
      }
      
      public function setShowMessageAgeAlways(param1:Boolean) : void
      {
         this.mShowMessageAgeAlways = param1;
      }
      
      override protected function createText() : void
      {
         super.createText();
         if(mText)
         {
            mText.fontName = this.mFontName;
            mText.color = this.mFontColor;
         }
      }
      
      override protected function createGuildName() : void
      {
         var _loc2_:int = 0;
         var _loc1_:String = InstanceMng.getGuildsMng().getMemberTitleByRankId(this.mGuildRankIndex,false);
         if(mGuildName == null)
         {
            _loc2_ = FSResourceMng.isOriental(mGuildNameStr) ? int(mNameTextfield.width) : 1;
            mGuildName = new FSTextfield(_loc2_,mRankInsigniaImage.height,_loc1_);
         }
         mGuildName.text = _loc1_;
         mGuildName.fontName = FSResourceMng.getFontByType();
         mGuildName.color = this.mGuildRankIndex == GuildsMng.RANK_LEADER ? 9498256 : 13290186;
         mGuildName.color = this.mGuildRankIndex == GuildsMng.RANK_GUILD_MOTD ? 15241014 : mGuildName.color;
         mGuildName.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
         mGuildName.format.horizontalAlign = Align.RIGHT;
         mGuildName.autoSize = FSResourceMng.isOriental(mGuildNameStr) ? TextFieldAutoSize.NONE : TextFieldAutoSize.HORIZONTAL;
         mGuildName.x = mMaxWidth - mGuildName.width * 1.05;
         mGuildName.y = mNameTextfield.y;
         addChild(mGuildName);
      }
      
      override protected function createMessageAge() : void
      {
         super.createMessageAge();
         if(this.mShowMessageAgeAlways)
         {
            updateMessageAge();
         }
      }
   }
}

