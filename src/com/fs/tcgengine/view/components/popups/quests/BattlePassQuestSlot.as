package com.fs.tcgengine.view.components.popups.quests
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.QuestsDefMng;
   import com.fs.tcgengine.model.quests.Quest;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.quests.PopupBattlePass;
   import feathers.controls.ScrollContainer;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class BattlePassQuestSlot extends QuestSlot
   {
      
      private var mChallengeIdImage:FSImage;
      
      private var mChallengeIdTextfield:FSTextfield;
      
      private var mTimedResetBG:FSImage;
      
      private var mTimedResetTextfield:FSTextfield;
      
      private var mChainImage:FSImage;
      
      private var mChainTextfield:FSTextfield;
      
      private var mChainLegendImage:FSImage;
      
      private var mChainLegendTextfield:FSTextfield;
      
      private var mLockIcon:FSImage;
      
      protected var mRewardImage:FSImage;
      
      public function BattlePassQuestSlot(param1:Quest, param2:ScrollContainer)
      {
         super(param1,param2);
         this.createChallengeSection();
         if(mQuest.getDef().hasTimedReset())
         {
            this.createTimedResetSection();
         }
         if(mQuest.getDef().getBattlePassChainFamilyId() != -1)
         {
            this.createChainSection();
         }
         Utils.alignComponentAndFixPosition(this);
      }
      
      private function createChallengeSection() : void
      {
         if(this.mChallengeIdImage == null)
         {
            this.mChallengeIdImage = new FSImage(Root.assets.getTexture("battlepass_challenge_id"));
            addChild(this.mChallengeIdImage);
         }
         if(this.mChallengeIdTextfield == null)
         {
            this.mChallengeIdTextfield = new FSTextfield(this.mChallengeIdImage.width,this.mChallengeIdImage.height,mQuest.getDef().getBattlePassIndex().toString());
            addChild(this.mChallengeIdTextfield);
         }
         this.applyOffsetToOriginalContent(this.mChallengeIdImage.width * 1.1);
      }
      
      private function createTimedResetSection() : void
      {
         var _loc1_:String = null;
         _loc1_ = mQuest.getDef().hasDailyReset() ? Utils.getDailyKeyTimeResetText() : InstanceMng.getRaidsMng().getWeeklySeasonTimeLeft();
         if(this.mTimedResetBG == null)
         {
            this.mTimedResetBG = new FSImage(Root.assets.getTexture("battlepass_challenge_timer"));
            this.mTimedResetBG.touchable = true;
            this.mTimedResetBG.setTooltipText(TextManager.replaceParameters(TextManager.getText("TID_BP_TOOLTIP_CHALLENGE_TIMED"),[_loc1_]));
            this.mTimedResetBG.addEventListener(TouchEvent.TOUCH,this.onTimedResetBGTouched);
            this.mTimedResetBG.x = mBG.x + mBG.width + (mBG.x - (this.mChallengeIdImage.x + this.mChallengeIdImage.width));
            this.mTimedResetBG.y = mBG.y;
            addChild(this.mTimedResetBG);
         }
         if(this.mTimedResetTextfield == null)
         {
            this.mTimedResetTextfield = new FSTextfield(this.mTimedResetBG.width,this.mTimedResetBG.height,_loc1_);
            this.mTimedResetTextfield.x = this.mTimedResetBG.x;
            this.mTimedResetTextfield.y = this.mTimedResetBG.y;
            addChild(this.mTimedResetTextfield);
         }
      }
      
      private function onTimedResetBGTouched(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mTimedResetBG,TouchPhase.HOVER);
         if(_loc2_)
         {
            if(this.mTimedResetBG)
            {
               this.mTimedResetBG.showTooltip();
            }
         }
         else if(this.mTimedResetBG)
         {
            this.mTimedResetBG.closeTooltip();
         }
      }
      
      private function createChainSection() : void
      {
         var _loc1_:String = null;
         if(this.mChainLegendImage == null)
         {
            this.mChainLegendImage = new FSImage(Root.assets.getTexture("daily_quest_banner"));
            this.mChainLegendImage.x = mBG.x + mBG.width - this.mChainLegendImage.width;
            this.mChainLegendImage.y = mBG.y + mBG.height - this.mChainLegendImage.height;
            addChild(this.mChainLegendImage);
         }
         if(this.mChainLegendTextfield == null)
         {
            _loc1_ = mQuest.getDef().getBattlePassChainIndex() + 1 + "/" + mQuest.getDef().getBattlePassChainFamilyQuestsAmount();
            this.mChainLegendTextfield = new FSTextfield(this.mChainLegendImage.width,this.mChainLegendImage.height,_loc1_);
            this.mChainLegendTextfield.x = this.mChainLegendImage.x;
            this.mChainLegendTextfield.y = this.mChainLegendImage.y;
            addChild(this.mChainLegendTextfield);
         }
         if(mQuest.getDef().getBattlePassChainIndex() != mQuest.getDef().getBattlePassChainFamilyQuestsAmount() - 1)
         {
            if(this.mChainImage == null)
            {
               this.mChainImage = new FSImage(Root.assets.getTexture("battlepass_chain_icon"));
               this.mChainImage.x = mBG.x + mBG.width - this.mChainImage.width * 1.5;
               this.mChainImage.y = mBG.y + this.mChainImage.height * 0.25;
               addChild(this.mChainImage);
            }
            if(this.mChainTextfield == null)
            {
               this.mChainTextfield = new FSTextfield(this.mChainLegendTextfield.width,this.mChainImage.height,TextManager.getText("TID_BP_CHAIN"),16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mChainTextfield.x = this.mChainLegendTextfield.x;
               this.mChainTextfield.y = this.mChainImage.y;
               addChild(this.mChainTextfield);
            }
         }
      }
      
      private function applyOffsetToOriginalContent(param1:int) : void
      {
         if(mBG)
         {
            mBG.x += param1;
         }
         if(mCurrencyIconImage)
         {
            mCurrencyIconImage.x += param1;
         }
         if(mQuestInfoBG)
         {
            mQuestInfoBG.x += param1;
         }
         if(mQuestImage)
         {
            mQuestImage.x += param1;
         }
         if(mQuestInfoTextfield)
         {
            mQuestInfoTextfield.x += param1;
         }
         if(mQuestDescriptionTextfield)
         {
            mQuestDescriptionTextfield.x += param1;
         }
         if(mCurrencyTextfield)
         {
            mCurrencyTextfield.x += param1;
         }
         if(mProgressQuestTextfield)
         {
            mProgressQuestTextfield.x += param1;
         }
         if(mCompleteQuestTextfield)
         {
            mCompleteQuestTextfield.x += param1;
         }
         if(mSkinImage)
         {
            mSkinImage.x += param1;
         }
         if(mPackAnim)
         {
            mPackAnim.x += param1;
         }
         if(mNotificationIcon)
         {
            mNotificationIcon.x += param1;
         }
         if(this.mRewardImage)
         {
            this.mRewardImage.x += param1;
         }
         if(this.mLockIcon)
         {
            this.mLockIcon.x += param1;
         }
         if(mBGProgress)
         {
            mBGProgress.x += param1;
         }
      }
      
      override protected function createBG(param1:Boolean = false) : void
      {
         super.createBG(true);
      }
      
      override protected function createRewardIcon() : void
      {
         if(mQuest == null || Boolean(mQuest) && Boolean(mQuest.getDef() == null))
         {
            return;
         }
         var _loc1_:Boolean = mQuest.getDef().getRewardType() != QuestsDefMng.REWARD_TYPE_NONE;
         var _loc2_:Boolean = mQuest.getDef().hasPremiumReward();
         var _loc3_:Boolean = _loc1_ || _loc2_;
         if(_loc3_ && this.mRewardImage == null && Boolean(mBG))
         {
            this.mRewardImage = new FSImage(Root.assets.getTexture("rewards_packs_icon"));
            this.mRewardImage.x = mBG.width * 0.9 - this.mRewardImage.width / 2;
            this.mRewardImage.y = mBG.y + this.mRewardImage.height * 0.25;
            this.mRewardImage.touchable = false;
            addChild(this.mRewardImage);
         }
         if(_loc3_ && mQuest.getDef().hasPremiumReward() && !InstanceMng.getUserDataMng().getOwnerUserData().hasValidBattlePass())
         {
            if(Boolean(this.mLockIcon == null && mQuest) && Boolean(mQuest.getDef()) && Boolean(mBG))
            {
               this.mLockIcon = new FSImage(Root.assets.getTexture("battlepass_reward_icon_locked"));
               this.mLockIcon.x = this.mRewardImage.x + this.mRewardImage.width - this.mLockIcon.width;
               this.mLockIcon.y = this.mRewardImage.y;
               this.mLockIcon.touchable = false;
               addChild(this.mLockIcon);
            }
         }
         createQuestImage();
         createQuestDescription();
      }
      
      override protected function onQuestRemovedClaim() : void
      {
         super.onQuestRemovedClaim();
         if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
         {
            PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).onBattlePassQuestClaimed();
         }
      }
      
      override public function dispose() : void
      {
         if(this.mChallengeIdImage)
         {
            this.mChallengeIdImage.removeFromParent(true);
            this.mChallengeIdImage = null;
         }
         if(this.mChallengeIdTextfield)
         {
            this.mChallengeIdTextfield.removeFromParent(true);
            this.mChallengeIdTextfield = null;
         }
         if(this.mTimedResetBG)
         {
            this.mTimedResetBG.removeFromParent(true);
            this.mTimedResetBG = null;
         }
         if(this.mChainImage)
         {
            this.mChainImage.removeFromParent(true);
            this.mChainImage = null;
         }
         if(this.mTimedResetTextfield)
         {
            this.mTimedResetTextfield.removeFromParent(true);
            this.mTimedResetTextfield = null;
         }
         if(this.mChainTextfield)
         {
            this.mChainTextfield.removeFromParent(true);
            this.mChainTextfield = null;
         }
         if(this.mChainLegendImage)
         {
            this.mChainLegendImage.removeFromParent(true);
            this.mChainLegendImage = null;
         }
         if(this.mChainLegendTextfield)
         {
            this.mChainLegendTextfield.removeFromParent(true);
            this.mChainLegendTextfield = null;
         }
         if(this.mLockIcon)
         {
            this.mLockIcon.removeFromParent(true);
            this.mLockIcon = null;
         }
         if(this.mRewardImage)
         {
            this.mRewardImage.removeFromParent(true);
            this.mRewardImage = null;
         }
         super.dispose();
      }
   }
}

