package com.fs.tcgengine.view.components.popups.quests
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.QuestsDefMng;
   import com.fs.tcgengine.model.quests.Quest;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.map.MapSubmenu;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.quests.PopupQuest;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import flash.utils.setTimeout;
   import starling.display.Quad;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class QuestSlot extends Component
   {
      
      public static const QUESTSLOT_DAILY_BG:String = "daily_quest_layer";
      
      public static const QUESTSLOT_BG:String = "quest_layer";
      
      public static const QUESTSLOT_CURRENCY_ICON_BG:String = "quest_currency_icon";
      
      public static const QUESTSLOT_GOLD_ICON_BG:String = "rewards_gold_icon";
      
      public static const QUESTSLOT_RAID_COIN_ICON_BG:String = "rewards_raid_points_icon";
      
      public static const QUESTSLOT_DAILY_BANNER_BG:String = "daily_quest_banner";
      
      public static const QUESTSLOT_COMMUNITY_BG:String = "global_quest_layer";
      
      public static const QUESTSLOT_CRAFT_UNLOCKED_BG:String = "rewards_craft_unlocked_icon";
      
      protected var mBG:FSImage;
      
      protected var mBGProgress:Quad;
      
      protected var mCurrencyIconImage:FSImage;
      
      protected var mQuestInfoBG:FSImage;
      
      protected var mQuestImage:FSImage;
      
      protected var mQuestInfoTextfield:FSTextfield;
      
      protected var mQuestDescriptionTextfield:FSTextfield;
      
      protected var mCurrencyTextfield:FSTextfield;
      
      protected var mProgressQuestTextfield:FSTextfield;
      
      protected var mCompleteQuestTextfield:FSTextfield;
      
      protected var mQuest:Quest;
      
      private var mParentContainer:ScrollContainer;
      
      protected var mSkinImage:FSImage;
      
      protected var mPackAnim:PackAnimation;
      
      protected var mNotificationIcon:FSImage;
      
      public function QuestSlot(param1:Quest, param2:ScrollContainer)
      {
         this.mQuest = param1;
         this.mParentContainer = param2;
         super();
         this.createBG();
         this.createRewardIcon();
         Utils.alignComponentAndFixPosition(this);
      }
      
      protected function createRewardIcon() : void
      {
         if(this.mQuest.getDef().getRewardType() == QuestsDefMng.REWARD_TYPE_QUEST_COINS || this.mQuest.getDef().getRewardType() == QuestsDefMng.REWARD_TYPE_RAID_COINS || this.mQuest.getDef().getRewardType() == QuestsDefMng.REWARD_TYPE_CLASS_UNLOCK || this.mQuest.getDef().getRewardType() == QuestsDefMng.REWARD_TYPE_GOLD || this.mQuest.getDef().getRewardType() == QuestsDefMng.REWARD_TYPE_TOKENS || this.mQuest.getDef().getRewardType() == QuestsDefMng.REWARD_TYPE_JOB_XP || this.mQuest.getDef().getRewardType() == QuestsDefMng.REWARD_TYPE_CARD || this.mQuest.getDef().getRewardType() == QuestsDefMng.REWARD_TYPE_UNLOCK_CRAFT)
         {
            this.createCurrencyIcon();
            this.createQuestImage();
            this.createQuestDescription();
         }
         else if(this.mQuest.getDef().getRewardType() == QuestsDefMng.REWARD_TYPE_PORTRAIT_SKIN)
         {
            this.onSkinLoaded();
         }
         else if(this.mQuest.getDef().getRewardType() == QuestsDefMng.REWARD_TYPE_PACK)
         {
            this.onPackLoaded();
         }
         else
         {
            this.createQuestImage();
            this.createQuestDescription();
         }
      }
      
      private function createClaimeableIcon() : void
      {
         if(this.mQuest.isCompleted())
         {
            this.showNotificationIcon(true);
         }
      }
      
      private function onPackLoaded() : void
      {
         this.createPackImage();
         this.createQuestImage();
         this.createQuestDescription();
      }
      
      private function onSkinLoaded() : void
      {
         this.createSkinImage();
         this.createQuestImage();
         this.createQuestDescription();
      }
      
      protected function createSkinImage() : void
      {
         if(Boolean(this.mSkinImage == null && this.mQuest) && Boolean(this.mQuest.getDef()) && Boolean(this.mBG))
         {
            this.mSkinImage = InstanceMng.getQuestsMng().createSkinImage(this.mQuest.getDef());
            this.mSkinImage.x = this.mBG.width * 0.9 - this.mSkinImage.width / 2;
            this.mSkinImage.y = this.mBG.height / 2 - this.mSkinImage.height * 0.6;
            addChild(this.mSkinImage);
         }
      }
      
      protected function createPackImage() : void
      {
         if(Boolean(this.mPackAnim == null) && Boolean(this.mQuest) && Boolean(this.mBG))
         {
            this.mPackAnim = InstanceMng.getQuestsMng().createPackImage(this.mQuest.getDef());
            this.mPackAnim.x = this.mBG.width * 0.9;
            this.mPackAnim.y = this.mBG.height / 2 + this.mPackAnim.height / 5;
            addChild(this.mPackAnim);
         }
      }
      
      protected function createQuestDescription() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mQuestDescriptionTextfield == null && this.mQuest) && Boolean(this.mBG) && Boolean(this.mQuestImage))
         {
            _loc1_ = Boolean(this.mQuest.getDef()) && Boolean(this.mQuest.getDef().getIsSecretQuest()) && !this.mQuest.isCompleted() ? TextManager.getText("TID_QUEST_SECRET_01") : this.mQuest.getDef().getDesc();
            this.mQuestDescriptionTextfield = new FSTextfield(this.mBG.width * 0.6,this.mBG.height * 0.75,_loc1_,16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mQuestDescriptionTextfield.touchable = false;
            this.mQuestDescriptionTextfield.alignPivot();
            this.mQuestDescriptionTextfield.x = this.mQuestImage.x + this.mQuestImage.width * 2.1;
            this.mQuestDescriptionTextfield.y = this.mQuestImage.y;
            if(this.mQuest.isCompleted())
            {
               this.mQuestDescriptionTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
               SpecialFX.createYoYoAlphaTransition(this.mQuestDescriptionTextfield,0.7,0.5);
            }
         }
         if(this.mQuestDescriptionTextfield)
         {
            addChild(this.mQuestDescriptionTextfield);
         }
      }
      
      protected function createQuestImage() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         if(Boolean(this.mQuestImage == null) && Boolean(this.mQuest) && Boolean(this.mBG))
         {
            if(this.mQuest.getDef().getIsSecretQuest() && !this.mQuest.isCompleted())
            {
               if(Root.assets.getTexture("quest_image_secret") == null)
               {
                  return;
               }
               this.mQuestImage = new FSImage(Root.assets.getTexture("quest_image_secret"));
            }
            else
            {
               _loc1_ = this.mQuest.isCommunityQuest();
               _loc2_ = !_loc1_ || _loc1_ && InstanceMng.getServerConnection().isUserLoggedIn() ? this.mQuest.getDef().getBGImageName() : "internet_off";
               if(Root.assets.getTexture(_loc2_) == null)
               {
                  return;
               }
               this.mQuestImage = new FSImage(Root.assets.getTexture(_loc2_));
            }
            this.mQuestImage.scale = 1.25;
            this.mQuestImage.alignPivot();
            this.mQuestImage.x = this.mBG.x + this.mBG.width * 0.1;
            this.mQuestImage.y = this.mBG.y + this.mQuestImage.height / 2;
            if(this.mQuest.isCompleted())
            {
               this.mQuestImage.addEventListener(TouchEvent.TOUCH,this.onQuestImageTouch);
            }
            else if(this.mQuest.getDef().getTargetType() == QuestsMng.TARGET_TYPE_SHARE_GAME_QUEST || this.mQuest.getDef().getTargetType() == QuestsMng.TARGET_TYPE_COMMUNITY_QUEST)
            {
               this.mQuestImage.addEventListener(TouchEvent.TOUCH,this.onShareQuestImageTouch);
            }
         }
         if(this.mQuestImage)
         {
            addChild(this.mQuestImage);
         }
         if(this.mQuest.isProgressQuest() && !this.mQuest.isCompleted() && this.mQuest.getDef().getTargetType() != QuestsMng.TARGET_DAILY_QUEST)
         {
            _loc3_ = this.mQuest.getProgress() / this.mQuest.getProgressToComplete();
            _loc4_ = this.mQuest.isCommunityQuest() ? Number(Math.floor(Math.min(_loc3_,1) * 100)).toPrecision(2) + "%" : this.mQuest.getProgress() + "/" + this.mQuest.getProgressToComplete();
            _loc5_ = this.mQuest.isCommunityQuest() ? Number(Math.floor(Math.min(_loc3_,1))) : this.mQuest.getProgress() / this.mQuest.getProgressToComplete();
            if(Boolean(this.mProgressQuestTextfield == null) && Boolean(this.mQuestImage) && Boolean(this.mQuest))
            {
               this.mProgressQuestTextfield = new FSTextfield(this.mQuestImage.width,this.mQuestImage.height / 2,_loc4_);
               this.mProgressQuestTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD);
               this.mProgressQuestTextfield.x = this.mProgressQuestTextfield.width / 2;
               this.mProgressQuestTextfield.y = this.mProgressQuestTextfield.height / 2;
               this.mProgressQuestTextfield.x = this.mQuestImage.x - this.mProgressQuestTextfield.width * 0.32;
               this.mProgressQuestTextfield.y = this.mQuestImage.y;
               this.mProgressQuestTextfield.scaleX = 0.7;
               this.mProgressQuestTextfield.scaleY = 0.7;
            }
            this.updateBGBasedOnPercentageDone(_loc5_);
            if(this.mProgressQuestTextfield)
            {
               addChild(this.mProgressQuestTextfield);
            }
         }
         if(this.mQuest.isCompleted())
         {
            if(Boolean(this.mCompleteQuestTextfield == null) && Boolean(this.mQuestImage) && Boolean(this.mQuest))
            {
               this.mCompleteQuestTextfield = new FSTextfield(this.mQuestImage.width,this.mQuestImage.height / 2,TextManager.getText("TID_ACHIEVEMENT_CLAIM"));
               this.mCompleteQuestTextfield.alignPivot();
               this.mCompleteQuestTextfield.x = this.mQuestImage.x;
               this.mCompleteQuestTextfield.y = this.mQuestImage.y + this.mCompleteQuestTextfield.height / 2;
               this.mCompleteQuestTextfield.scaleX = 0.7;
               this.mCompleteQuestTextfield.scaleY = 0.7;
               this.mCompleteQuestTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
               this.mCompleteQuestTextfield.color = FSResourceMng.isOriental() ? 65280 : 16777215;
               SpecialFX.createYoYoAlphaTransition(this.mCompleteQuestTextfield,0.7,0.5);
            }
            if(this.mCompleteQuestTextfield)
            {
               addChild(this.mCompleteQuestTextfield);
            }
            this.createClaimeableIcon();
         }
      }
      
      public function onConnectionChanged() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:Texture = null;
         if(this.mQuestImage)
         {
            _loc1_ = this.mQuest.isCommunityQuest();
            _loc2_ = InstanceMng.getServerConnection().isUserLoggedIn();
            _loc3_ = !_loc1_ || _loc1_ && _loc2_ ? this.mQuest.getDef().getBGImageName() : "internet_off";
            _loc4_ = Root.assets.getTexture(_loc3_);
            if(_loc4_ == null)
            {
               return;
            }
            this.mQuestImage.texture = _loc4_;
            if(_loc2_)
            {
               TweenMax.killTweensOf(this.mQuestImage);
               this.mQuestImage.alpha = 0.999;
            }
            else
            {
               SpecialFX.tweenToAlpha(this.mQuestImage,0.5,1,-1);
            }
         }
      }
      
      private function onShareQuestImageTouch(param1:TouchEvent) : void
      {
         var _loc2_:FSImage = FSImage(param1.currentTarget);
         var _loc3_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc3_)
         {
            if(this.mParentContainer != null && !this.mParentContainer.isScrolling)
            {
               if(InstanceMng.getServerConnection().isUserLoggedIn())
               {
                  if(Utils.isMobile())
                  {
                     InstanceMng.getApplication().shareGame();
                  }
                  else if(Utils.isDesktop())
                  {
                     InstanceMng.getApplication().shareGame();
                     if(Config.getConfig().hasQuests())
                     {
                        setTimeout(InstanceMng.getQuestsMng().addActionPerformed,3000,QuestsMng.TARGET_TYPE_SHARE_GAME_QUEST,1);
                     }
                  }
                  else if(InstanceMng.getApplication().isFacebookBrowser())
                  {
                     InstanceMng.getFacebookPlugin().shareGame();
                  }
                  else
                  {
                     InstanceMng.getApplication().getKongregatePlugin().shareGame();
                  }
               }
            }
         }
         _loc3_ = param1.getTouch(this.mQuestImage,TouchPhase.HOVER);
         if(this.mQuestImage)
         {
            this.mQuestImage.scaleX = _loc3_ ? 1.04 : 1;
            this.mQuestImage.scaleY = _loc3_ ? 1.04 : 1;
         }
         if(this.mCompleteQuestTextfield)
         {
            this.mCompleteQuestTextfield.scaleX = _loc3_ ? 0.74 : 0.7;
            this.mCompleteQuestTextfield.scaleY = _loc3_ ? 0.74 : 0.7;
         }
      }
      
      private function onQuestImageTouch(param1:TouchEvent) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc2_:FSImage = FSImage(param1.currentTarget);
         var _loc3_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc3_)
         {
            if(this.mParentContainer != null && !this.mParentContainer.isScrolling)
            {
               _loc4_ = this.mQuest.getDef().isCommunityQuest();
               _loc5_ = this.mQuest.isCompleted();
               if(!_loc5_ || InstanceMng.getServerConnection().isUserLoggedIn())
               {
                  if(_loc5_)
                  {
                     if(this.mQuestImage)
                     {
                        this.mQuestImage.touchable = false;
                     }
                     if(this.mBG)
                     {
                        this.mBG.touchable = false;
                     }
                     _loc6_ = this.mQuest.getDef().getRewardType();
                     if(_loc6_ == QuestsDefMng.REWARD_TYPE_PACK)
                     {
                        if(InstanceMng.getPopupMng().getPopupShown() != null && InstanceMng.getPopupMng().getPopupShown() is PopupQuest)
                        {
                           PopupQuest(InstanceMng.getPopupMng().getPopupShown()).enableCloseButton(false);
                        }
                     }
                     if(this.mQuest.getDef().isBattlePassQuest())
                     {
                        InstanceMng.getServerConnection().checkBattlePassChallengeClaimeable(this.mQuest.getDef().getSku(),this.mQuest.getDef().getBattlePassSeason(),this.mQuest.getDef().getBattlePassSeasonYear(),this.onBPChallengeClaimedSuccessfully,this.onBPChallengeClaimFailed);
                     }
                     else
                     {
                        SpecialFX.tweenToAlpha(this,0.0001,0.25,0,this.onQuestRemovedPreClaim);
                     }
                  }
                  else
                  {
                     setTooltipText(TextManager.getText(this.mQuest.getDef().getTooltipText()));
                  }
                  return;
               }
               Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
            }
         }
         _loc3_ = param1.getTouch(this,TouchPhase.HOVER);
         scale = _loc3_ ? 1.02 : 1;
      }
      
      private function onBPChallengeClaimFailed(param1:Object) : void
      {
         if(param1 != null && param1.hasOwnProperty("error"))
         {
            Utils.setLogText("Error: " + param1["error"],true,false,false);
            if(param1.hasOwnProperty("errorId") && param1["errorId"] == 2)
            {
               removeFromParent();
               InstanceMng.getQuestsMng().setQuestAsClaimed(this.mQuest);
            }
         }
         else
         {
            Utils.setLogText("Error claiming this Challenge, if the problem persists, contact support.");
         }
         if(this.mQuestImage)
         {
            this.mQuestImage.touchable = true;
         }
         if(this.mBG)
         {
            this.mBG.touchable = true;
         }
      }
      
      private function onBPChallengeClaimedSuccessfully() : void
      {
         SpecialFX.tweenToAlpha(this,0.0001,0.25,0,this.onQuestRemovedPreClaim);
      }
      
      protected function onQuestRemovedPreClaim() : void
      {
         removeFromParent();
         TweenMax.delayedCall(0.1,this.onQuestRemovedClaim);
      }
      
      protected function onQuestRemovedClaim() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this.mQuest) && Boolean(this.mQuest.getDef()))
         {
            this.mQuest.claim();
            if(this.mQuest.getDef().isBattlePassQuest())
            {
               return;
            }
            _loc1_ = this.mQuest.getDef().getRewardType();
            switch(_loc1_)
            {
               case QuestsDefMng.REWARD_TYPE_QUEST_COINS:
                  if(InstanceMng.getPopupMng().getPopupShown() != null && InstanceMng.getPopupMng().getPopupShown() is PopupQuest)
                  {
                     PopupQuest(InstanceMng.getPopupMng().getPopupShown()).refreshAmountQuestsCoins(this.mQuest.getRewardPoints());
                  }
                  break;
               case QuestsDefMng.REWARD_TYPE_PORTRAIT_SKIN:
                  Utils.setLogText(TextManager.getText("TID_SKIN_RECEIVED"));
                  break;
               case QuestsDefMng.REWARD_TYPE_RAID_COINS:
                  Utils.setLogText(TextManager.getText("TID_RAID_POINTS_ADDED"));
                  break;
               case QuestsDefMng.REWARD_TYPE_CLASS_UNLOCK:
                  Utils.setLogText(TextManager.getText("TID_JOBS_UNLOCKABLE"));
            }
         }
      }
      
      private function createCurrencyIcon() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(this.mCurrencyIconImage == null)
         {
            this.mCurrencyIconImage = InstanceMng.getQuestsMng().createCurrencyIcon(this.mQuest.getDef());
            this.mCurrencyIconImage.x = this.mBG.width * 0.9 - this.mCurrencyIconImage.width / 2;
            this.mCurrencyIconImage.y = this.mBG.height / 2 - this.mCurrencyIconImage.height * 0.6;
            addChild(this.mCurrencyIconImage);
         }
         if(Boolean(this.mCurrencyTextfield == null) && Boolean(this.mCurrencyIconImage) && Boolean(this.mQuest))
         {
            _loc1_ = this.mQuest.getDef().getRewardType();
            _loc2_ = 0;
            _loc3_ = "";
            switch(_loc1_)
            {
               case QuestsDefMng.REWARD_TYPE_QUEST_COINS:
                  _loc2_ = this.mQuest.getRewardPoints();
                  _loc3_ = _loc2_.toString();
                  break;
               case QuestsDefMng.REWARD_TYPE_RAID_COINS:
                  _loc2_ = this.mQuest.getDef().getRewardRaidPoints();
                  _loc3_ = _loc2_.toString();
                  break;
               case QuestsDefMng.REWARD_TYPE_GOLD:
                  _loc2_ = this.mQuest.getRewardGold();
                  _loc3_ = _loc2_.toString();
                  break;
               case QuestsDefMng.REWARD_TYPE_TOKENS:
                  _loc2_ = this.mQuest.getDef().getRewardTokens();
                  _loc3_ = _loc2_.toString();
                  break;
               case QuestsDefMng.REWARD_TYPE_JOB_XP:
                  _loc2_ = int(this.mQuest.getDef().getRewardJobXP().split(":")[1]);
                  _loc3_ = _loc2_ + "xp";
            }
            if(_loc2_ > 0)
            {
               this.mCurrencyTextfield = new FSTextfield(this.mCurrencyIconImage.width,this.mCurrencyIconImage.height,_loc3_);
               this.mCurrencyTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD);
               this.mCurrencyTextfield.x = this.mCurrencyIconImage.x;
               this.mCurrencyTextfield.y = this.mCurrencyIconImage.y;
               this.mCurrencyTextfield.touchable = false;
               addChild(this.mCurrencyTextfield);
            }
         }
      }
      
      protected function createBG(param1:Boolean = false) : void
      {
         var _loc2_:String = null;
         if(this.mBG == null)
         {
            _loc2_ = this.mQuest.isDaily() ? QUESTSLOT_DAILY_BG : QUESTSLOT_BG;
            _loc2_ = this.mQuest.getDef().isCommunityQuest() ? QUESTSLOT_COMMUNITY_BG : _loc2_;
            _loc2_ = param1 ? QUESTSLOT_DAILY_BG : _loc2_;
            this.mBG = new FSImage(Root.assets.getTexture(_loc2_));
            Utils.setupImage9Scale(this.mBG,6,10,8,12.5,296.25,55.31);
            if(this.mQuest.isCompleted() || this.mQuest.getDef().isCommunityQuest())
            {
               this.mBG.addEventListener(TouchEvent.TOUCH,this.onTouchableQuestBGTouch);
            }
            if(!this.mQuest.isCompleted() && this.mQuest.getDef().getTargetType() == QuestsMng.TARGET_TYPE_SHARE_GAME_QUEST)
            {
               this.mBG.addEventListener(TouchEvent.TOUCH,this.onShareQuestImageTouch);
            }
         }
         addChild(this.mBG);
         this.createBGProgress();
         if(this.mQuest.isDaily() || this.mQuest.getDef().isCommunityQuest())
         {
            this.createQuestInfoBanner();
         }
      }
      
      protected function createBGProgress() : void
      {
         if(this.mBGProgress == null)
         {
            this.mBGProgress = new Quad(this.mBG.width * 0.98,this.mBG.height / 20,4259584);
            this.mBGProgress.x = (this.mBG.width - this.mBGProgress.width) / 2;
            this.mBGProgress.alpha = 0.75;
            addChild(this.mBGProgress);
         }
      }
      
      public function updateBGBasedOnPercentageDone(param1:Number) : void
      {
         if(this.mBGProgress)
         {
            this.mBGProgress.scaleX = param1 >= 1 ? 1 : param1;
         }
      }
      
      private function onTouchableQuestBGTouch(param1:TouchEvent) : void
      {
         this.onQuestImageTouch(param1);
      }
      
      private function createQuestInfoBanner() : void
      {
         var _loc1_:String = null;
         if(this.mQuestInfoBG == null)
         {
            this.mQuestInfoBG = new FSImage(Root.assets.getTexture(QUESTSLOT_DAILY_BANNER_BG));
            this.mQuestInfoBG.x = this.mBG.width - this.mQuestInfoBG.width;
            this.mQuestInfoBG.y = this.mBG.height - this.mQuestInfoBG.height;
            this.mQuestInfoBG.touchable = false;
         }
         addChild(this.mQuestInfoBG);
         if(this.mQuestInfoTextfield == null && Boolean(this.mQuestInfoBG))
         {
            _loc1_ = this.mQuest.getDef().isCommunityQuest() ? TextManager.getText("TID_QUEST_COMMUNITY") : TextManager.getText("TID_QUEST_DAILY");
            this.mQuestInfoTextfield = new FSTextfield(this.mQuestInfoBG.width,this.mQuestInfoBG.height,_loc1_,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mQuestInfoTextfield.x = this.mQuestInfoBG.x;
            this.mQuestInfoTextfield.y = this.mQuestInfoBG.y;
            this.mQuestInfoTextfield.touchable = false;
         }
         addChild(this.mQuestInfoTextfield);
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mBGProgress)
         {
            this.mBGProgress.removeFromParent(true);
            this.mBGProgress = null;
         }
         if(this.mCurrencyIconImage)
         {
            this.mCurrencyIconImage.removeFromParent(true);
            this.mCurrencyIconImage = null;
         }
         if(this.mQuestInfoBG)
         {
            this.mQuestInfoBG.removeFromParent(true);
            this.mQuestInfoBG = null;
         }
         if(this.mQuestImage)
         {
            this.mQuestImage.removeFromParent(true);
            this.mQuestImage = null;
         }
         if(this.mQuestInfoTextfield)
         {
            this.mQuestInfoTextfield.removeFromParent(true);
            this.mQuestInfoTextfield = null;
         }
         if(this.mQuestDescriptionTextfield)
         {
            this.mQuestDescriptionTextfield.removeFromParent(true);
            this.mQuestDescriptionTextfield = null;
         }
         if(this.mCurrencyTextfield)
         {
            this.mCurrencyTextfield.removeFromParent(true);
            this.mCurrencyTextfield = null;
         }
         if(this.mProgressQuestTextfield)
         {
            this.mProgressQuestTextfield.removeFromParent(true);
            this.mProgressQuestTextfield = null;
         }
         if(this.mCompleteQuestTextfield)
         {
            this.mCompleteQuestTextfield.removeFromParent(true);
            this.mCompleteQuestTextfield = null;
         }
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent();
            this.mNotificationIcon.destroy();
            this.mNotificationIcon = null;
         }
         if(this.mSkinImage)
         {
            this.mSkinImage.removeFromParent(true);
            this.mSkinImage = null;
         }
         if(Boolean(this.mQuest) && this.mQuest.getDef().getRewardType() == QuestsDefMng.REWARD_TYPE_PACK)
         {
            if(this.mPackAnim)
            {
               this.mPackAnim.removeFromParent(true);
               this.mPackAnim = null;
            }
         }
         this.mQuest = null;
         this.mParentContainer = null;
         super.dispose();
      }
      
      public function getQuest() : Quest
      {
         return this.mQuest;
      }
      
      public function showNotificationIcon(param1:Boolean) : void
      {
         if(this.mNotificationIcon == null)
         {
            this.mNotificationIcon = new FSImage(Root.assets.getTexture(MapSubmenu.NOTIFICATION_NAME));
            this.mNotificationIcon.touchable = false;
            this.mNotificationIcon.alignPivot();
            this.mNotificationIcon.x = this.mQuestImage ? this.mQuestImage.x - this.mNotificationIcon.width * 0.75 : 0;
            this.mNotificationIcon.y = this.mQuestImage ? this.mQuestImage.y - this.mNotificationIcon.height * 0.75 : 0;
            addChild(this.mNotificationIcon);
            SpecialFX.createYoYoZoomTransition(this.mNotificationIcon,1,1,-1,null,null,false);
         }
         this.mNotificationIcon.visible = param1;
      }
   }
}

