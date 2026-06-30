package com.fs.tcgengine.view.pvp
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.screens.FSPvPScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSMemberOptions;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.player.PlayerScorePortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import feathers.controls.Callout;
   import feathers.controls.ScrollContainer;
   import feathers.controls.supportClasses.LayoutViewPort;
   import feathers.layout.RelativePosition;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class PlayerPvPScorePortrait extends PlayerScorePortrait
   {
      
      private var mBG:CustomComponent;
      
      private var mVictoriesAmount:int;
      
      private var mVictoriesAmountTextfield:FSTextfield;
      
      private var mIsFacebookRanking:Boolean = true;
      
      private var mGuildId:String = "";
      
      private var mBGName_1:String = "dungeon_layer_1";
      
      private var mBGName_2:String = "dungeon_layer_2";
      
      private var mNameRankingName:String = "dungeon_layer_ranking";
      
      private var mMedalRankingName:String = "medal_ranking";
      
      private var mLayerRankingMeName:String = "dungeon_layer_ranking_me";
      
      public function PlayerPvPScorePortrait(param1:String = "", param2:int = 1, param3:String = "", param4:Number = 0, param5:int = 0, param6:Boolean = false, param7:Boolean = true, param8:String = "")
      {
         this.mVictoriesAmount = param5;
         this.mIsFacebookRanking = param7;
         this.mGuildId = param8;
         super(param1,param2,param3,param4,param6);
      }
      
      public function getBGName1() : String
      {
         return this.mBGName_1;
      }
      
      public function getBGName2() : String
      {
         return this.mBGName_2;
      }
      
      public function getNameRankingName() : String
      {
         return this.mNameRankingName;
      }
      
      public function getMedalRankingName() : String
      {
         return this.mMedalRankingName;
      }
      
      public function getLayerRankingMeName() : String
      {
         return this.mLayerRankingMeName;
      }
      
      override protected function createUI(param1:String, param2:Number) : void
      {
         this.createBG();
         super.createUI(param1,param2);
         this.createVictoriesTextfield();
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            if(mExtId != InstanceMng.getServerConnection().getUserId() && mExtId != "" && mExtId != null && mExtId != "guild")
            {
               this.createPvPMemberOptions();
            }
         }
      }
      
      private function createPvPMemberOptions() : void
      {
         var _loc1_:FSMemberOptions = null;
         var _loc2_:Callout = null;
         if(InstanceMng.getCurrentScreen() is FSPvPScreen)
         {
            if(parent != null && parent is LayoutViewPort && parent.parent is ScrollContainer && ScrollContainer(parent.parent).isScrolling)
            {
               return;
            }
            if(stage != null)
            {
               _loc1_ = FSPvPScreen(InstanceMng.getCurrentScreen()).createPvPMemberOptions(mExtId,this.mGuildId);
               if(_loc1_)
               {
                  _loc2_ = Callout.show(_loc1_,mNameTextfield,new <String>[RelativePosition.RIGHT]);
                  _loc1_.setParentCallout(_loc2_);
                  _loc1_.onShown();
                  if(mNameTextfield)
                  {
                     mNameTextfield.color = 16747520;
                  }
               }
            }
         }
      }
      
      public function hidePvPMemberOptions() : void
      {
         if(InstanceMng.getCurrentScreen() is FSPvPScreen)
         {
            FSPvPScreen(InstanceMng.getCurrentScreen()).hidePvPMemberOptions();
            if(mNameTextfield)
            {
               mNameTextfield.color = 16777215;
            }
         }
      }
      
      private function createBG() : void
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         if(InstanceMng.getCurrentScreen() is FSPvPScreen || InstanceMng.getCurrentScreen() is FSDungeonsScreen)
         {
            if(this.mBG == null)
            {
               if(this.mIsFacebookRanking || mRankingPos > 3 && !mIsOwnerPortrait)
               {
                  _loc1_ = mRankingPos % 2 == 0 ? this.getBGName2() : this.getBGName1();
               }
               else if(mIsOwnerPortrait)
               {
                  _loc1_ = this.getLayerRankingMeName();
               }
               else
               {
                  _loc1_ = this.getNameRankingName() + "_" + mRankingPos;
               }
               _loc2_ = InstanceMng.getCurrentScreen() is FSPvPScreen;
               _loc3_ = _loc2_ ? int(FSPvPScreen(InstanceMng.getCurrentScreen()).getLeaderboardRankingWidth() * 0.98) : 1070;
               if(_loc2_)
               {
                  _loc3_ /= Main.smScaleFactor;
               }
               this.mBG = Utils.createCustomBox(_loc1_,_loc3_,_loc2_);
               if(this.mBG)
               {
                  addChild(this.mBG);
               }
            }
            if(Boolean(mProfileFramePic) && Boolean(this.mBG))
            {
               mProfileFramePic.y = this.mBG.y + (this.mBG.height - mProfileFramePic.height) / 2;
               addChild(mProfileFramePic);
            }
            if(Boolean(mProfilePic) && Boolean(mProfileFramePic))
            {
               mProfilePic.y = mProfileFramePic.y + (mProfileFramePic.height - mProfilePic.height) / 2;
               addChild(mProfilePic);
               addChild(mProfileFramePic);
            }
         }
      }
      
      override protected function createNameTextfield(param1:String) : void
      {
         super.createNameTextfield(param1);
         if(mNameTextfield != null)
         {
            mNameTextfield.height = this.mBG ? this.mBG.height * 0.85 : height * 0.85;
            mNameTextfield.width = this.mBG ? this.mBG.width / 2.5 : width / 2.5;
            mNameTextfield.y = this.mBG ? (this.mBG.height - mNameTextfield.height) / 2 : (height - mNameTextfield.height) / 2;
            mNameTextfield.fontSize = FSResourceMng.FONT_STD_SMALL_SIZE;
            mNameTextfield.x = mRankingPosTextfield.x + mRankingPosTextfield.width;
         }
      }
      
      override protected function createPunctuationTextfield(param1:Number) : void
      {
         super.createPunctuationTextfield(param1);
         if(mPunctuationTextfield != null)
         {
            mPunctuationTextfield.x = mNameTextfield.x + mNameTextfield.width;
            mPunctuationTextfield.y = mNameTextfield.y;
            mPunctuationTextfield.width = this.mBG.width / 4;
            mPunctuationTextfield.fontName = FSResourceMng.getFontByType();
            mPunctuationTextfield.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
         }
      }
      
      protected function createVictoriesTextfield() : void
      {
         var _loc1_:int = 0;
         if(this.mVictoriesAmountTextfield == null && Boolean(mNameTextfield))
         {
            _loc1_ = mPunctuationTextfield ? int(mPunctuationTextfield.width * 0.65) : int(mNameTextfield.width * 0.5);
            this.mVictoriesAmountTextfield = new FSTextfield(_loc1_,mNameTextfield.height,this.mVictoriesAmount.toString());
            this.mVictoriesAmountTextfield.touchable = false;
            this.mVictoriesAmountTextfield.x = mPunctuationTextfield ? mPunctuationTextfield.x + mPunctuationTextfield.width : mNameTextfield.x + mNameTextfield.width;
            this.mVictoriesAmountTextfield.y = mPunctuationTextfield ? mPunctuationTextfield.y : mNameTextfield.y;
            this.mVictoriesAmountTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            this.mVictoriesAmountTextfield.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            addChild(this.mVictoriesAmountTextfield);
         }
      }
      
      override protected function createDefaultProfilePic() : void
      {
         if(this.mIsFacebookRanking)
         {
            super.createDefaultProfilePic();
         }
      }
      
      override protected function createProfilePic(param1:Texture) : void
      {
         if(this.mIsFacebookRanking)
         {
            super.createProfilePic(param1);
         }
      }
      
      override public function loadProfilePicture() : void
      {
         if(this.mIsFacebookRanking)
         {
            super.loadProfilePicture();
         }
      }
      
      override protected function createFrame() : void
      {
         var _loc1_:String = null;
         if(mProfileFramePic == null)
         {
            if(this.mIsFacebookRanking)
            {
               _loc1_ = mIsOwner ? SOCIAL_FRAME_OWNER_IMAGE_NAME : SOCIAL_FRAME_IMAGE_NAME;
            }
            else
            {
               _loc1_ = mRankingPos > 3 || mRankingPos == -1 ? this.getMedalRankingName() + "_4" : this.getMedalRankingName() + "_" + mRankingPos;
            }
            if(Root.assets.getTexture(_loc1_))
            {
               mProfileFramePic = new FSImage(Root.assets.getTexture(_loc1_));
               addChild(mProfileFramePic);
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mVictoriesAmountTextfield)
         {
            this.mVictoriesAmountTextfield.removeFromParent(true);
            this.mVictoriesAmountTextfield = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         super.dispose();
      }
   }
}

