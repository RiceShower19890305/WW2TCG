package com.fs.tcgengine.view.guilds
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.guilds.Guild;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.utils.Align;
   
   public class GuildRankingSlot extends GuildSlot
   {
      
      public static const TYPE_WEEKLY:int = 0;
      
      public static const TYPE_TOP:int = 1;
      
      private var mPositionIndicatorBG:FSImage;
      
      private var mPositionIndicatorTextfield:FSTextfield;
      
      private var mPos:int;
      
      private var mScoreBGName:String;
      
      private var mScoreType:int;
      
      public function GuildRankingSlot(param1:Guild, param2:int, param3:String, param4:int)
      {
         this.mPos = param2;
         this.mScoreBGName = param3;
         this.mScoreType = param4;
         super(param1);
      }
      
      override protected function createMembersInfo() : void
      {
      }
      
      override protected function createNameInfo() : void
      {
         super.createNameInfo();
         if(mNameTextfield)
         {
            mNameTextfield.format.horizontalAlign = Align.LEFT;
            mNameTextfield.width = mBG.width / 2.05;
         }
         if(mSeparator1)
         {
            mSeparator1.x = mNameTextfield.x + mNameTextfield.width + 5;
            mSeparator1.y = mNameTextfield.y;
         }
      }
      
      override protected function createLogo() : void
      {
         this.createPositionIndicator();
         super.createLogo();
         mLogo.x = this.mPositionIndicatorBG.x + this.mPositionIndicatorBG.width * 1.05;
         mLogo.y = this.mPositionIndicatorBG.y + (this.mPositionIndicatorBG.height - mLogo.height) / 2;
      }
      
      private function createPositionIndicator() : void
      {
         var _loc1_:String = null;
         if(this.mPositionIndicatorBG == null)
         {
            _loc1_ = this.mPos < 4 ? "guild_position_panel_" + this.mPos : "guild_position_panel_4";
            this.mPositionIndicatorBG = new FSImage(Root.assets.getTexture(_loc1_));
            this.mPositionIndicatorBG.x = 10;
            this.mPositionIndicatorBG.y = (mBG.height - this.mPositionIndicatorBG.height) / 2;
            addChild(this.mPositionIndicatorBG);
         }
         if(this.mPositionIndicatorTextfield == null)
         {
            this.mPositionIndicatorTextfield = new FSTextfield(this.mPositionIndicatorBG.width,this.mPositionIndicatorBG.height,this.mPos.toString());
            this.mPositionIndicatorTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            this.mPositionIndicatorTextfield.x = this.mPositionIndicatorBG.x;
            this.mPositionIndicatorTextfield.y = this.mPositionIndicatorBG.y;
            addChild(this.mPositionIndicatorTextfield);
         }
      }
      
      override protected function createScore() : void
      {
         var _loc1_:Number = NaN;
         if(mScore == null)
         {
            _loc1_ = this.mScoreType == TYPE_TOP ? mGuild.getGlobalTotalScore() : mGuild.getWeeklyTotalScore();
            mScore = new GuildScoreBatch(this.mScoreBGName,_loc1_);
            mScore.x = mSeparator2 ? mSeparator2.x + mSeparator2.width + 5 : mSeparator1.x + mSeparator1.width + 5;
            mScore.y = mSeparator2 ? mSeparator2.y + (mBG.height - mScore.height) / 2 : mSeparator1.y + (mBG.height - mScore.height) / 2;
            addChild(mScore);
         }
      }
      
      override protected function createMoreInfoLabel() : void
      {
      }
      
      override public function dispose() : void
      {
         if(this.mPositionIndicatorBG)
         {
            this.mPositionIndicatorBG.removeFromParent(true);
            this.mPositionIndicatorBG = null;
         }
         if(this.mPositionIndicatorTextfield)
         {
            this.mPositionIndicatorTextfield.removeFromParent(true);
            this.mPositionIndicatorTextfield = null;
         }
         removeChildren(0,-1,true);
         super.dispose();
      }
   }
}

