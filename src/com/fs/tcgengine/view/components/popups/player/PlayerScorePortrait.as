package com.fs.tcgengine.view.components.popups.player
{
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.greensock.TweenMax;
   
   public class PlayerScorePortrait extends PlayerPortrait
   {
      
      protected var mRankingPosTextfield:FSTextfield;
      
      protected var mNameTextfield:FSTextfield;
      
      protected var mPunctuationTextfield:FSTextfield;
      
      private var mSendLifeButton:FSButton;
      
      protected var mIsOwnerPortrait:Boolean;
      
      private var mLifeAlreadySent:Boolean;
      
      protected var mRankingPos:int;
      
      public function PlayerScorePortrait(param1:String = "", param2:int = 1, param3:String = "Test", param4:Number = 12345, param5:Boolean = false, param6:Boolean = false)
      {
         this.mIsOwnerPortrait = param5;
         this.mLifeAlreadySent = param6;
         this.mRankingPos = param2;
         super(param1,param5);
         this.createUI(param3,param4);
         touchable = true;
      }
      
      protected function createUI(param1:String, param2:Number) : void
      {
         this.createRankingPosTextfield();
         this.createNameTextfield(param1);
         this.createPunctuationTextfield(param2);
      }
      
      private function createRankingPosTextfield() : void
      {
         if(this.mRankingPosTextfield == null && Boolean(mProfileFramePic))
         {
            this.mRankingPosTextfield = new FSTextfield(mProfileFramePic.width / 1.5,mProfileFramePic.height / 2,this.mRankingPos.toString());
            this.mRankingPosTextfield.touchable = false;
            this.mRankingPosTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_GOLD);
            this.mRankingPosTextfield.x = mProfileFramePic.x + mProfileFramePic.width + 1;
            this.mRankingPosTextfield.y = mProfileFramePic.y + (mProfileFramePic.height - this.mRankingPosTextfield.height) / 2;
            addChild(this.mRankingPosTextfield);
         }
      }
      
      protected function createNameTextfield(param1:String) : void
      {
         param1 = param1 ? param1 : "";
         if(this.mNameTextfield == null && Boolean(mProfileFramePic))
         {
            this.mNameTextfield = new FSTextfield(mProfileFramePic.width * 1.5,mProfileFramePic.height / 2,param1.toUpperCase());
            this.mNameTextfield.touchable = false;
            this.mNameTextfield.fontName = this.isOwnerPortrait() ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN) : FSResourceMng.getFontByType();
            this.mNameTextfield.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
            this.mNameTextfield.x = this.mRankingPosTextfield ? this.mRankingPosTextfield.x + this.mRankingPosTextfield.width : 0;
            this.mNameTextfield.y = 0;
            addChild(this.mNameTextfield);
         }
      }
      
      protected function createPunctuationTextfield(param1:Number) : void
      {
         var _loc2_:String = null;
         if(this.mPunctuationTextfield == null && Boolean(this.mNameTextfield))
         {
            _loc2_ = param1 == -1 ? "" : param1.toString();
            this.mPunctuationTextfield = new FSTextfield(this.mNameTextfield.width,this.mNameTextfield.height,_loc2_);
            this.mPunctuationTextfield.touchable = false;
            this.mPunctuationTextfield.x = this.mNameTextfield.x;
            this.mPunctuationTextfield.y = this.mNameTextfield.y + this.mNameTextfield.height;
            this.mPunctuationTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            addChild(this.mPunctuationTextfield);
         }
      }
      
      private function isOwnerPortrait() : Boolean
      {
         return this.mIsOwnerPortrait;
      }
      
      override public function dispose() : void
      {
         if(this.mRankingPosTextfield)
         {
            this.mRankingPosTextfield.removeFromParent(true);
            this.mRankingPosTextfield = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(this.mPunctuationTextfield)
         {
            this.mPunctuationTextfield.removeFromParent(true);
            this.mPunctuationTextfield = null;
         }
         if(this.mSendLifeButton)
         {
            TweenMax.killTweensOf(this.mSendLifeButton);
            this.mSendLifeButton.removeFromParent(true);
            this.mSendLifeButton = null;
         }
         super.dispose();
      }
   }
}

