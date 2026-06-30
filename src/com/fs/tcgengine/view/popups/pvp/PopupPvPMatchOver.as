package com.fs.tcgengine.view.popups.pvp
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class PopupPvPMatchOver extends PopupStandard
   {
      
      private const RANKING_ASSET_NAME:String = "pvp_end_reward";
      
      private const GOLD_ICON_NAME:String = "gold_icon";
      
      protected var mTitle:FSTextfield;
      
      private var mWinnerBattleInfo:UserBattleInfo;
      
      private var mExtraMsg:String;
      
      private var mEloGained:Number;
      
      private var mRankingContainer:Component;
      
      private var mRatingContainer:Component;
      
      private var mRewardContainer:Component;
      
      private var mGoldIcon:FSImage;
      
      private var mGoldAmount:FSTextfield;
      
      private var mRatingGainedTitleTextfield:FSTextfield;
      
      private var mRatingGainedTextfield:FSTextfield;
      
      private var mCurrentRatingTitleTextfield:FSTextfield;
      
      private var mCurrentRatingTextfield:FSTextfield;
      
      private var mRankingTitleTextfield:FSTextfield;
      
      private var mRankingTextfield:FSTextfield;
      
      protected var mWasFBFriend:Boolean = false;
      
      public function PopupPvPMatchOver(param1:Boolean = true)
      {
         super(false);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = Constants.POPUP_SETTINGS_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,720);
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.setupTexts();
      }
      
      private function createRewardContainer() : void
      {
         var _loc2_:FSImage = null;
         if(this.mRewardContainer == null)
         {
            this.mRewardContainer = new Component();
            _loc2_ = new FSImage(Root.assets.getTexture(this.RANKING_ASSET_NAME));
            Utils.setupImage9Scale(_loc2_,10,8,1,1,131.5,41);
            this.mRewardContainer.addChild(_loc2_);
            this.mRewardContainer.x = (width - this.mRewardContainer.width) / 2;
            this.mRewardContainer.y = height * 0.3;
         }
         if(this.mGoldIcon == null)
         {
            this.mGoldIcon = new FSImage(Root.assets.getTexture(this.GOLD_ICON_NAME));
            this.mGoldIcon.scaleX = 0.8;
            this.mGoldIcon.scaleY = 0.8;
            this.mGoldIcon.x = this.mRewardContainer.width / 2 - this.mGoldIcon.width;
            this.mGoldIcon.y = (this.mRewardContainer.height - this.mGoldIcon.height) / 2;
            this.mRewardContainer.addChild(this.mGoldIcon);
         }
         var _loc1_:int = this.getGoldWon();
         if(this.mGoldAmount == null)
         {
            this.mGoldAmount = new FSTextfield(this.mRewardContainer.width / 2,this.mRewardContainer.height,_loc1_.toString(),12632256);
            this.mGoldAmount.fontName = FSResourceMng.getFontByType();
            this.mGoldAmount.format.horizontalAlign = Align.LEFT;
            this.mGoldAmount.x = this.mRewardContainer.width / 2 + 20;
            this.mRewardContainer.addChild(this.mGoldAmount);
         }
         if(this.mGoldAmount)
         {
            this.mGoldAmount.text = _loc1_.toString();
         }
         addChild(this.mRewardContainer);
      }
      
      protected function getGoldWon() : int
      {
         var _loc1_:int = 0;
         if(InstanceMng.getBattleEngine().isOnlineMatch() && !this.mWasFBFriend)
         {
            if(Boolean(InstanceMng.getBattleEngine().getOwnerBattleInfo().getHP() > 0) && Boolean(this.mWinnerBattleInfo) && this.mWinnerBattleInfo.isOwnerBattleInfo())
            {
               _loc1_ = Config.getConfig().getGoldGainedPerPvPMatchWon();
            }
            else
            {
               _loc1_ = Math.min(Math.round(InstanceMng.getBattleEngine().getCurrentTurnId() * 0.5),Config.getConfig().getGoldGainedPerPvPMatchDraw());
               InstanceMng.getUserDataMng().getOwnerUserData().addGold(_loc1_);
            }
         }
         else
         {
            _loc1_ = 0;
         }
         return _loc1_;
      }
      
      private function createRatingContainer() : void
      {
         var _loc1_:FSImage = null;
         if(this.mRatingContainer == null)
         {
            this.mRatingContainer = new Component();
            _loc1_ = new FSImage(Root.assets.getTexture(this.RANKING_ASSET_NAME));
            Utils.setupImage9Scale(_loc1_,10,8,1,1,131.5,41);
            this.mRatingContainer.addChild(_loc1_);
            this.mRatingContainer.x = (width - this.mRatingContainer.width) / 2;
            this.mRatingContainer.y = this.mRewardContainer.y + this.mRewardContainer.height + 5;
            addChild(this.mRatingContainer);
         }
         this.createRatingGainedSection();
         this.createCurrentRatingSection();
      }
      
      private function createRatingGainedSection() : void
      {
         if(this.mRatingGainedTitleTextfield == null)
         {
            this.mRatingGainedTitleTextfield = new FSTextfield(this.mRatingContainer.width / 2,this.mRatingContainer.height * 0.25,TextManager.getText("TID_PVP_RATING_GAINED"));
            this.mRatingContainer.addChild(this.mRatingGainedTitleTextfield);
         }
         if(this.mRatingGainedTextfield == null)
         {
            this.mRatingGainedTextfield = new FSTextfield(this.mRatingContainer.width / 2,this.mRatingContainer.height * 0.75,this.mEloGained.toString());
            this.mRatingGainedTextfield.y = this.mRatingGainedTitleTextfield.y + this.mRatingGainedTitleTextfield.height;
            this.mRatingContainer.addChild(this.mRatingGainedTextfield);
         }
         if(this.mRatingGainedTextfield)
         {
            this.mRatingGainedTextfield.fontName = this.mEloGained >= 0 ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN) : FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
            this.mRatingGainedTextfield.text = this.mEloGained.toString();
         }
      }
      
      private function createCurrentRatingSection() : void
      {
         var _loc1_:int = 0;
         if(this.mCurrentRatingTitleTextfield == null)
         {
            this.mCurrentRatingTitleTextfield = new FSTextfield(this.mRatingContainer.width / 2,this.mRatingContainer.height * 0.25,TextManager.getText("TID_PVP_RATING_CURRENT"));
            this.mCurrentRatingTitleTextfield.x = this.mRatingContainer.width / 2;
            this.mRatingContainer.addChild(this.mCurrentRatingTitleTextfield);
         }
         if(this.mCurrentRatingTextfield == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getElo();
            this.mCurrentRatingTextfield = new FSTextfield(this.mRatingContainer.width / 2,this.mRatingContainer.height * 0.75,_loc1_.toString());
            this.mCurrentRatingTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mCurrentRatingTextfield.x = this.mRatingContainer.width / 2;
            this.mCurrentRatingTextfield.y = this.mCurrentRatingTitleTextfield.y + this.mCurrentRatingTitleTextfield.height;
            this.mRatingContainer.addChild(this.mCurrentRatingTextfield);
         }
      }
      
      public function setupPopup(param1:UserBattleInfo, param2:Number = 0, param3:String = null, param4:Boolean = false) : void
      {
         this.mWinnerBattleInfo = param1;
         this.mExtraMsg = param3;
         this.mWasFBFriend = param4;
         this.mEloGained = !this.mWasFBFriend ? param2 : 0;
         this.setupTexts();
         var _loc5_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc5_ != null && _loc5_.isOnlineMatch())
         {
            this.createRewardContainer();
            this.createRatingContainer();
         }
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mTitle)
         {
            this.mTitle.removeFromParent(true);
            this.mTitle = null;
         }
         this.mWinnerBattleInfo = null;
         if(this.mGoldAmount)
         {
            this.mGoldAmount.removeFromParent(true);
            this.mGoldAmount = null;
         }
         if(this.mGoldIcon)
         {
            this.mGoldIcon.removeFromParent(true);
            this.mGoldIcon = null;
         }
         if(this.mRankingContainer)
         {
            this.mRankingContainer.removeFromParent(true);
            this.mRankingContainer = null;
         }
         if(this.mRatingContainer)
         {
            this.mRatingContainer.removeFromParent(true);
            this.mRatingContainer = null;
         }
         if(this.mRewardContainer)
         {
            this.mRewardContainer.removeFromParent(true);
            this.mRewardContainer = null;
         }
         if(this.mRankingTextfield)
         {
            this.mRankingTextfield.removeFromParent(true);
            this.mRankingTextfield = null;
         }
         if(this.mRankingTitleTextfield)
         {
            this.mRankingTitleTextfield.removeFromParent(true);
            this.mRankingTitleTextfield = null;
         }
         if(this.mRatingGainedTextfield)
         {
            this.mRatingGainedTextfield.removeFromParent(true);
            this.mRatingGainedTextfield = null;
         }
         if(this.mRatingGainedTitleTextfield)
         {
            this.mRatingGainedTitleTextfield.removeFromParent(true);
            this.mRatingGainedTitleTextfield = null;
         }
         if(this.mCurrentRatingTextfield)
         {
            this.mCurrentRatingTextfield.removeFromParent(true);
            this.mCurrentRatingTextfield = null;
         }
         if(this.mCurrentRatingTitleTextfield)
         {
            this.mCurrentRatingTitleTextfield.removeFromParent(true);
            this.mCurrentRatingTitleTextfield = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.PVP_MATCH_OVER_POPUP_NAME);
         super.removeFromStage();
      }
      
      protected function setupTexts() : void
      {
         var _loc3_:Boolean = false;
         this.createTitle();
         if(this.mExtraMsg != "" && this.mExtraMsg != null)
         {
            Utils.setLogText(this.mExtraMsg);
         }
         var _loc1_:String = "";
         var _loc2_:String = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
         if(Boolean(InstanceMng.getBattleEngine()) && !InstanceMng.getBattleEngine().isOnlineMatch())
         {
            if(this.mWinnerBattleInfo)
            {
               _loc3_ = this.mWinnerBattleInfo.isOwnerBattleInfo();
               _loc1_ = _loc3_ ? TextManager.getText("TID_PVP_PLAYER_WON_1") : TextManager.getText("TID_PVP_PLAYER_WON_2");
               _loc2_ = _loc3_ ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_BLUE) : FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
            }
            else
            {
               _loc1_ = TextManager.getText("TID_PVP_MATCH_CANCELLED");
            }
            setMainFieldText(_loc1_);
            if(mInfoTextfield)
            {
               mInfoTextfield.fontName = _loc2_;
            }
         }
      }
      
      protected function createTitle() : void
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         if(this.mTitle == null)
         {
            this.mTitle = new FSTextfield(width * 0.9,height * 0.2);
            this.mTitle.x = (mBox.width - this.mTitle.width) / 2;
            this.mTitle.y = mBox.height * 0.035;
            this.mTitle.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            addChild(this.mTitle);
         }
         var _loc1_:String = "";
         if(InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().isOnlineMatch())
         {
            if(this.mWinnerBattleInfo)
            {
               _loc3_ = this.mWinnerBattleInfo.isOwnerBattleInfo();
               _loc1_ = _loc3_ ? TextManager.getText("TID_PVP_VICTORY") : TextManager.getText("TID_PVP_DEFEAT");
            }
         }
         else
         {
            _loc1_ += TextManager.getText("TID_PVP_OVER");
         }
         this.mTitle.text = _loc1_;
      }
      
      override protected function onAccept(param1:Event) : void
      {
         super.onAccept(param1);
         mOnClosedFunction = this.onAcceptPerformOps;
      }
      
      protected function onAcceptPerformOps() : void
      {
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).performCardsLeavingFX(0,this.showPvPScreen);
         }
         Utils.stopSound(Constants.SOUND_DEFEAT);
         Utils.stopSound(Constants.SOUND_VICTORY);
      }
      
      protected function showPvPScreen() : void
      {
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).showPvPScreen();
         }
      }
   }
}

