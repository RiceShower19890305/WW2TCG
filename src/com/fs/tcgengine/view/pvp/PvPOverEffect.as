package com.fs.tcgengine.view.pvp
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.pvp.LeagueFrame;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TimelineLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.greensock.easing.Elastic;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class PvPOverEffect extends Component
   {
      
      public static const MATCH_WON:int = 0;
      
      public static const MATCH_LOST:int = 1;
      
      public static const MATCH_DRAW:int = 3;
      
      public static const MATCH_DESYNCHRONIZED:int = 4;
      
      protected var mWasFriendlyMatch:Boolean = false;
      
      private var mEloGained:Number;
      
      private var mWinnerBattleInfo:UserBattleInfo;
      
      private var mExtraMsg:String;
      
      private var mIsDraw:Boolean;
      
      private var mIsDesync:Boolean;
      
      private var mIsOnlineMatch:Boolean;
      
      private var mBGQuad:Quad;
      
      private var mMatchResultTextfield:FSTextfield;
      
      private var mContainer:Component;
      
      private var mExitButton:FSButton;
      
      private var mLeagueFrame:LeagueFrame;
      
      private var mGoldIcon:FSImage;
      
      private var mGoldAmount:FSTextfield;
      
      private var mRatingGainedTitleTextfield:FSTextfield;
      
      private var mRatingGainedTextfield:FSTextfield;
      
      public function PvPOverEffect(param1:int, param2:UserBattleInfo, param3:String = null, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false)
      {
         super();
         this.mWasFriendlyMatch = param4;
         this.mEloGained = !this.mWasFriendlyMatch ? param1 : 0;
         this.mWinnerBattleInfo = param2;
         this.mExtraMsg = param3;
         this.mIsDraw = param5;
         this.mIsDesync = param6;
         this.mIsOnlineMatch = InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().isOnlineMatch();
         this.createUI();
      }
      
      private function createUI() : void
      {
         if(this.mExtraMsg != "" && this.mExtraMsg != null)
         {
            Utils.setLogText(this.mExtraMsg);
         }
         this.setTouchable(false);
         if(InstanceMng.getCurrentScreen())
         {
            if(InstanceMng.getCurrentScreen().getOptionsPanel())
            {
               InstanceMng.getCurrentScreen().getOptionsPanel().touchable = false;
            }
            if(InstanceMng.getCurrentScreen().getGuildsButton())
            {
               InstanceMng.getCurrentScreen().getGuildsButton().touchable = false;
            }
         }
         this.createQuad();
         this.createTitle();
         if(this.mIsOnlineMatch)
         {
            this.createLeagueFrame();
         }
         else
         {
            this.prepareToExit();
         }
      }
      
      private function createTitle() : void
      {
         var _loc2_:Boolean = false;
         var _loc1_:String = TextManager.getText("TID_PVP_OVER");
         if(this.mIsOnlineMatch)
         {
            if(this.mWinnerBattleInfo)
            {
               _loc2_ = this.mWinnerBattleInfo.isOwnerBattleInfo();
               _loc1_ = _loc2_ ? TextManager.getText("TID_PVP_VICTORY") : TextManager.getText("TID_PVP_DEFEAT");
            }
            if(this.mIsDesync || this.mIsDraw)
            {
               _loc1_ = TextManager.getText("TID_GEN_DRAW");
            }
         }
         else if(this.mWinnerBattleInfo)
         {
            _loc2_ = this.mWinnerBattleInfo.isOwnerBattleInfo();
            _loc1_ = _loc2_ ? TextManager.getText("TID_PVP_PLAYER_WON_1") : TextManager.getText("TID_PVP_PLAYER_WON_2");
         }
         else
         {
            _loc1_ = TextManager.getText("TID_PVP_MATCH_CANCELLED");
         }
         if(this.mMatchResultTextfield == null)
         {
            this.mMatchResultTextfield = new FSTextfield(this.mBGQuad.width,this.mBGQuad.height / 4,_loc1_,16777215,FSResourceMng.FONT_STD_BIG_XL_TITLE_SIZE);
            if(!this.mIsOnlineMatch)
            {
               this.mMatchResultTextfield.y = this.mBGQuad.height / 2 - this.mMatchResultTextfield.height / 2;
            }
            addChild(this.mMatchResultTextfield);
         }
      }
      
      private function createLeagueFrame() : void
      {
         var performFrameLeagueUpdate:Function = null;
         var onFrameLeagueUIUpdated:Function = null;
         var playFallingAnim:Function = function():void
         {
            var _loc1_:int = Starling.current.stage.stageHeight;
            var _loc2_:TimelineLite = new TimelineLite();
            if(mLeagueFrame)
            {
               _loc2_.to(mLeagueFrame,1.15,{
                  "y":_loc1_ / 2,
                  "ease":Elastic.easeInOut,
                  "onComplete":performFrameLeagueUpdate
               });
            }
         };
         performFrameLeagueUpdate = function():void
         {
            if(mLeagueFrame)
            {
               TweenMax.delayedCall(0.5,mLeagueFrame.updateUI,[onFrameLeagueUIUpdated,true]);
            }
         };
         onFrameLeagueUIUpdated = function():void
         {
            var _loc1_:TimelineLite = new TimelineLite();
            if(mLeagueFrame)
            {
               _loc1_.to(mLeagueFrame,0.75,{
                  "x":mLeagueFrame.x - mLeagueFrame.width / 3,
                  "ease":Back.easeOut,
                  "onComplete":createRightInfoSection
               });
            }
         };
         if(this.mLeagueFrame == null)
         {
            this.mLeagueFrame = new LeagueFrame(true);
            this.mLeagueFrame.x = this.mBGQuad.width / 2;
            this.mLeagueFrame.y = -this.mLeagueFrame.height / 2;
            addChild(this.mLeagueFrame);
         }
         playFallingAnim();
      }
      
      private function createRightInfoSection() : void
      {
         this.createGoldSection();
         this.createRatingGainedSection();
         this.handleGoldAmountProgress();
      }
      
      private function handleGoldAmountProgress() : void
      {
         var _loc1_:int = this.getGoldWon();
         if(this.mGoldAmount)
         {
            SpecialFX.createTextfieldAmountTransition(this.mGoldAmount,_loc1_,0.75,true,this.handleRatingAmountProgress);
         }
      }
      
      private function handleRatingAmountProgress() : void
      {
         SpecialFX.createTextfieldAmountTransition(this.mRatingGainedTextfield,this.mEloGained,0.75,true,this.prepareToExit);
      }
      
      private function prepareToExit() : void
      {
         this.createExitButton();
         this.setTouchable(true);
      }
      
      private function createGoldSection() : void
      {
         if(this.mGoldIcon == null)
         {
            this.mGoldIcon = new FSImage(Root.assets.getTexture("large_gold_reward"));
            this.mGoldIcon.x = this.mLeagueFrame.x + this.mLeagueFrame.width / 2;
            this.mGoldIcon.y = this.mLeagueFrame.y - this.mLeagueFrame.height / 3;
            addChild(this.mGoldIcon);
         }
         if(this.mGoldAmount == null)
         {
            this.mGoldAmount = new FSTextfield(this.mGoldIcon.width,this.mGoldIcon.height,"0",12632256,FSResourceMng.FONT_STD_BIG_TITLE_SIZE);
            this.mGoldAmount.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mGoldAmount.x = this.mGoldIcon.x + this.mLeagueFrame.width / 2.25;
            this.mGoldAmount.y = this.mGoldIcon.y;
            addChild(this.mGoldAmount);
         }
      }
      
      private function createRatingGainedSection() : void
      {
         if(this.mRatingGainedTitleTextfield == null)
         {
            this.mRatingGainedTitleTextfield = new FSTextfield(this.mLeagueFrame.width / 2.25,this.mGoldAmount.height,TextManager.getText("TID_PVP_RATING_GAINED"),16777215);
            this.mRatingGainedTitleTextfield.x = this.mGoldIcon.x;
            this.mRatingGainedTitleTextfield.y = this.mGoldIcon.y + this.mGoldIcon.height * 1.25;
            addChild(this.mRatingGainedTitleTextfield);
         }
         if(this.mRatingGainedTextfield == null)
         {
            this.mRatingGainedTextfield = new FSTextfield(this.mGoldAmount.width,this.mGoldAmount.height,"0",16777215,FSResourceMng.FONT_STD_BIG_TITLE_SIZE);
            this.mRatingGainedTextfield.x = this.mRatingGainedTitleTextfield.x + this.mRatingGainedTitleTextfield.width;
            this.mRatingGainedTextfield.y = this.mRatingGainedTitleTextfield.y;
            addChild(this.mRatingGainedTextfield);
         }
         if(this.mGoldIcon)
         {
            this.mGoldIcon.x = this.mRatingGainedTitleTextfield.x + this.mRatingGainedTitleTextfield.width / 2 - this.mGoldIcon.width / 2;
         }
         if(this.mRatingGainedTextfield)
         {
            this.mRatingGainedTextfield.fontName = this.mEloGained >= 0 ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN) : FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
         }
      }
      
      private function createExitButton() : void
      {
         var _loc1_:Texture = null;
         if(this.mExitButton == null)
         {
            _loc1_ = Root.assets.getTexture(Constants.ACCEPT_BUTTON_UP_NAME);
            this.mExitButton = new FSButton(_loc1_,TextManager.getText("TID_GEN_BUTTON_OK"),_loc1_,false,_loc1_);
            this.mExitButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mExitButton.x = Starling.current.stage.stageWidth / 2;
            this.mExitButton.y = Starling.current.stage.stageHeight - this.mExitButton.height / 1.5;
            this.mExitButton.addEventListener(Event.TRIGGERED,this.onExitTriggered);
         }
         this.mExitButton.alpha = 0;
         addChild(this.mExitButton);
         SpecialFX.tweenToAlpha(this.mExitButton,0.999,0.5,0);
      }
      
      private function onExitTriggered() : void
      {
         removeFromParent(true);
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
      
      private function createQuad() : void
      {
         if(this.mBGQuad == null)
         {
            this.mBGQuad = new Quad(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight,0);
            this.mBGQuad.touchable = true;
            this.mBGQuad.addEventListener(TouchEvent.TOUCH,this.onBGTouch);
         }
         this.mBGQuad.alpha = 0.7;
         addChild(this.mBGQuad);
      }
      
      private function onBGTouch(param1:TouchEvent) : void
      {
         if(param1.getTouch(this.mBGQuad,TouchPhase.ENDED))
         {
            this.skipIntros();
         }
      }
      
      private function skipIntros() : void
      {
         TweenMax.killAll(true);
         TweenMax.killAll(true);
         InstanceMng.getCurrentScreen().resetGuildsButtonPosition();
      }
      
      private function setTouchable(param1:Boolean) : void
      {
         if(this.mExitButton)
         {
            this.mExitButton.enabled = param1;
         }
      }
      
      protected function getGoldWon() : int
      {
         var _loc1_:int = 0;
         if(!this.mIsDesync && InstanceMng.getBattleEngine().isOnlineMatch() && !this.mWasFriendlyMatch)
         {
            if(this.mIsDraw)
            {
               _loc1_ = Config.getConfig().getGoldGainedPerPvPMatchDraw();
            }
            else if(Boolean(InstanceMng.getBattleEngine().getOwnerBattleInfo().getHP() > 0) && Boolean(this.mWinnerBattleInfo) && this.mWinnerBattleInfo.isOwnerBattleInfo())
            {
               _loc1_ = Config.getConfig().getGoldGainedPerPvPMatchWon();
            }
            else
            {
               _loc1_ = Math.min(Math.round(InstanceMng.getBattleEngine().getCurrentTurnId() * 0.5),Config.getConfig().getGoldGainedPerPvPMatchDraw());
               InstanceMng.getUserDataMng().getOwnerUserData().addGold(_loc1_);
            }
         }
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         if(this.mBGQuad)
         {
            this.mBGQuad.removeFromParent(true);
            this.mBGQuad = null;
         }
         if(this.mMatchResultTextfield)
         {
            this.mMatchResultTextfield.removeFromParent(true);
            this.mMatchResultTextfield = null;
         }
         if(this.mExitButton)
         {
            this.mExitButton.removeFromParent(true);
            this.mExitButton = null;
         }
         if(this.mLeagueFrame)
         {
            this.mLeagueFrame.removeFromParent(true);
            this.mLeagueFrame = null;
         }
         if(this.mGoldIcon)
         {
            this.mGoldIcon.removeFromParent(true);
            this.mGoldIcon = null;
         }
         if(this.mGoldAmount)
         {
            this.mGoldAmount.removeFromParent(true);
            this.mGoldAmount = null;
         }
         if(this.mRatingGainedTitleTextfield)
         {
            this.mRatingGainedTitleTextfield.removeFromParent(true);
            this.mRatingGainedTitleTextfield = null;
         }
         if(this.mRatingGainedTextfield)
         {
            this.mRatingGainedTextfield.removeFromParent(true);
            this.mRatingGainedTextfield = null;
         }
         if(this.mContainer)
         {
            this.mContainer.removeFromParent(true);
            this.mContainer = null;
         }
         this.mWinnerBattleInfo = null;
         super.dispose();
      }
   }
}

