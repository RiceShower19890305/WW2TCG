package com.fs.tcgengine.view.popups.levels
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.RaidsMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.GameModeDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.RaidDef;
   import com.fs.tcgengine.model.rules.RaidLevelDef;
   import com.fs.tcgengine.model.rules.RewardDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSGaugeProgressBar;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.level.PlayPopupSlot;
   import com.fs.tcgengine.view.components.popups.level.SocialScoresBar;
   import com.fs.tcgengine.view.components.popups.misc.FSPopupStar;
   import com.fs.tcgengine.view.meshes.LevelItemContainer;
   import com.fs.tcgengine.view.misc.RewardsEffect;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.utils.deg2rad;
   
   public class FSPopupPlayLevel extends PopupStandard
   {
      
      public static const STAR_ANIM_DURATION:Number = 0.25;
      
      public static const STAR_ANIM_DELAY_BETWEEN_STARS_DURATION:Number = 0.5;
      
      private var mTitleTextfield:FSTextfield;
      
      private var mIsRaid:Boolean;
      
      private var mMinScoreReachedStar:FSPopupStar;
      
      private var mMedScoreReachedStar:FSPopupStar;
      
      private var mMaxScoreReachedStar:FSPopupStar;
      
      private var mSocialBottomBar:SocialScoresBar;
      
      private var mLevelDef:LevelDef;
      
      private var mScoreImagesContainer:Component;
      
      private var mScoreSlot:PlayPopupSlot;
      
      private var mEventSlot:PlayPopupSlot;
      
      private var mHardLevelSlot:PlayPopupSlot;
      
      private var mDeckSelectorSlot:PlayPopupSlot;
      
      private var mBoostersSlot:PlayPopupSlot;
      
      private var mMatchSummarySlot:PlayPopupSlot;
      
      private var mBottomSlot:PlayPopupSlot;
      
      private var mObjectivesInfoButton:FSButton;
      
      private var mIsNewLevel:Boolean;
      
      private var mPopupSetupDone:Boolean;
      
      private var mSlotsContainer:Component;
      
      private var mCurrentCollectionSize:int = -1;
      
      private var mIsEndLevel:Boolean;
      
      private var mWin:Boolean;
      
      private var mProgressBar:FSGaugeProgressBar;
      
      private var mSocialScoresAlreadyReceived:Boolean;
      
      private var mLevelItemRef:LevelItemContainer;
      
      public function FSPopupPlayLevel(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = !this.mIsEndLevel ? "start_level_top" : "end_level_bar_top";
      }
      
      public function setupPopup(param1:String, param2:Boolean, param3:Boolean, param4:Boolean = false, param5:Boolean = false, param6:Boolean = true, param7:Boolean = false, param8:Boolean = false, param9:LevelItemContainer = null) : void
      {
         this.mPopupSetupDone = true;
         this.mIsRaid = param4;
         this.mIsEndLevel = param2;
         this.mWin = param3;
         this.mLevelItemRef = param9;
         this.mLevelDef = null;
         this.mLevelDef = this.mIsRaid ? RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getDefBySku(param1)) : LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(param1));
         this.mIsNewLevel = this.mIsEndLevel ? param8 : InstanceMng.getUserDataMng().getOwnerUserData().isLevelCompleted(this.mLevelDef);
         this.createUI();
      }
      
      override protected function createUI() : void
      {
         if(this.mPopupSetupDone)
         {
            this.getBackgroundName("");
            super.createUI();
            this.createProgressBar();
            this.addOnScoreReachedImages();
            this.createTitleTextfield();
            this.createObjectivesButton();
            this.createScoreSlot();
            this.createHardLevelSlot();
            this.createEventSlot();
            this.manageSelector();
            this.createBoostersSlot();
            this.createMatchSummarySlot();
            this.createBottomSlot();
            this.createSocialBar();
            if(mAcceptButton)
            {
               mAcceptButton.y = this.mSlotsContainer.y + this.mSlotsContainer.height * 1.05 - mAcceptButton.height / 4;
               addChild(mAcceptButton);
            }
            if(Boolean(mCloseButton) && Boolean(this.mIsEndLevel) && this.mWin)
            {
               mCloseButtonActive = false;
               mCloseButton.removeFromParent();
            }
         }
      }
      
      protected function createTitleTextfield() : void
      {
         var _loc1_:int = 0;
         if(this.mTitleTextfield == null)
         {
            _loc1_ = FSResourceMng.FONT_STD_BIG_TITLE_SIZE;
            this.mTitleTextfield = new FSTextfield(mBox.width * 0.75,mBox.height * 0.75,"",16777215,_loc1_);
            this.mTitleTextfield.x = (mBox.width - this.mTitleTextfield.width) / 2;
            this.mTitleTextfield.y = this.mTitleTextfield.height / 3;
         }
         this.setTitleText();
         addChild(this.mTitleTextfield);
      }
      
      private function createObjectivesButton() : void
      {
         var _loc1_:GameModeDef = null;
         var _loc2_:String = null;
         if(!this.mIsEndLevel && !this.mIsRaid)
         {
            if(this.mObjectivesInfoButton == null)
            {
               if(this.mLevelDef != null)
               {
                  _loc1_ = GameModeDef(InstanceMng.getGameModesDefMng().getDefBySku(this.mLevelDef.getGameModeSku()));
               }
               if(_loc1_)
               {
                  _loc2_ = "start_level_" + _loc1_.getSku();
                  this.mObjectivesInfoButton = new FSButton(Root.assets.getTexture(_loc2_));
                  this.mObjectivesInfoButton.scaleWhenDown = 1;
                  this.mObjectivesInfoButton.enableScaleOnMouseOver(false);
                  this.mObjectivesInfoButton.x = this.mTitleTextfield.x - this.mObjectivesInfoButton.width / 5;
                  this.mObjectivesInfoButton.y = this.mTitleTextfield.y + this.mTitleTextfield.height / 2;
                  this.mObjectivesInfoButton.setTooltipText(this.setObjectivesText());
                  addChild(this.mObjectivesInfoButton);
               }
            }
         }
      }
      
      private function setObjectivesText() : String
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Dictionary = null;
         var _loc8_:Array = null;
         var _loc1_:String = "";
         var _loc2_:Dictionary = InstanceMng.getTargetMng().getObjectivesCatalog(this.mLevelDef);
         if(_loc2_ != null)
         {
            _loc1_ += InstanceMng.getTargetMng().getMainObjectiveText(true).toUpperCase();
            _loc3_ = DictionaryUtils.getKeys(_loc2_);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc6_ = int(_loc3_[_loc4_]);
               _loc7_ = _loc2_[_loc6_];
               if(_loc7_ != null)
               {
                  _loc8_ = InstanceMng.getTargetMng().getObjectiveText(_loc7_,_loc6_);
                  _loc5_ = 0;
                  while(_loc5_ < _loc8_.length)
                  {
                     _loc1_ += "\n" + _loc8_[_loc5_].text;
                     _loc5_++;
                  }
               }
               _loc4_++;
            }
         }
         return _loc1_;
      }
      
      protected function setTitleText() : void
      {
         var _loc1_:String = null;
         var _loc2_:RaidDef = null;
         var _loc3_:int = 0;
         if(this.mIsEndLevel)
         {
            _loc1_ = this.mWin ? TextManager.getText("TID_GEN_LEVEL_VICTORY") : TextManager.getText("TID_GEN_LEVEL_DEFEAT");
         }
         else if(this.mIsRaid && Boolean(InstanceMng.getRaidsMng()))
         {
            _loc2_ = InstanceMng.getRaidsMng().getCurrentRaidDef();
            _loc3_ = InstanceMng.getRaidsMng().getCurrentRaidDifficulty();
            if(_loc2_)
            {
               switch(_loc3_)
               {
                  case RaidsMng.RAID_DIFFICULTY_EASY:
                     _loc1_ = TextManager.getText("TID_DUNGEON_DIFFICULTY_01");
                     break;
                  case RaidsMng.RAID_DIFFICULTY_MEDIUM:
                     _loc1_ = TextManager.getText("TID_DUNGEON_DIFFICULTY_02");
                     break;
                  case RaidsMng.RAID_DIFFICULTY_HARD:
                     _loc1_ = TextManager.getText("TID_DUNGEON_DIFFICULTY_03");
                     break;
                  case RaidsMng.RAID_DIFFICULTY_EXPERT:
                     _loc1_ = TextManager.getText("TID_DUNGEON_DIFFICULTY_04");
               }
               _loc1_ = _loc2_.getName() + " (" + _loc1_ + ")";
            }
         }
         else
         {
            _loc1_ = this.mLevelDef ? TextManager.replaceParameters(TextManager.getText("TID_GEN_LEVEL"),[this.mLevelDef.getLevelIndex()]) : "";
         }
         _loc1_ = _loc1_ ? _loc1_ : "";
         if(this.mTitleTextfield != null)
         {
            this.mTitleTextfield.text = _loc1_.toUpperCase();
         }
      }
      
      private function addSlotToPopup(param1:PlayPopupSlot) : void
      {
         if(param1)
         {
            if(this.mSlotsContainer == null)
            {
               this.mSlotsContainer = new Component();
               this.mSlotsContainer.name = "slotsContainer";
               this.mSlotsContainer.x = mBox.x;
               this.mSlotsContainer.y = mBox.y + mBox.height;
               addChild(this.mSlotsContainer);
            }
            param1.y = this.mSlotsContainer.height - 2;
            this.mSlotsContainer.addChild(param1);
         }
      }
      
      private function createScoreSlot() : void
      {
         if(!this.mIsRaid && (!this.mIsNewLevel || this.mIsNewLevel && this.mIsEndLevel))
         {
            if(this.mScoreSlot == null)
            {
               this.mScoreSlot = new PlayPopupSlot(PlayPopupSlot.TYPE_SCORE,PlayPopupSlot.POS_TOP);
               this.addSlotToPopup(this.mScoreSlot);
            }
         }
      }
      
      private function createEventSlot() : void
      {
         if(Boolean(!this.mIsEndLevel) && Boolean(this.mLevelDef) && this.mLevelDef.hasBattleEvent())
         {
            if(this.mEventSlot == null)
            {
               this.mEventSlot = new PlayPopupSlot(PlayPopupSlot.TYPE_EVENT,PlayPopupSlot.POS_MID,this.mLevelDef);
               this.addSlotToPopup(this.mEventSlot);
            }
         }
      }
      
      private function createDeckSelectorSlot() : void
      {
         if(!this.mIsEndLevel && this.mDeckSelectorSlot == null)
         {
            this.mDeckSelectorSlot = new PlayPopupSlot(PlayPopupSlot.TYPE_DECK,PlayPopupSlot.POS_MID,this.mLevelDef);
            this.mDeckSelectorSlot.name = "deckSelector";
            this.addSlotToPopup(this.mDeckSelectorSlot);
         }
      }
      
      private function createHardLevelSlot() : void
      {
         var _loc1_:int = 0;
         if(this.mLevelDef)
         {
            _loc1_ = this.mLevelDef.getHardness();
            if(_loc1_ > 0 && !this.mIsEndLevel && this.mHardLevelSlot == null)
            {
               this.mHardLevelSlot = new PlayPopupSlot(PlayPopupSlot.TYPE_HARD_LEVEL_NOTIFIER,PlayPopupSlot.POS_MID,this.mLevelDef);
               this.mHardLevelSlot.name = "hardLevel";
               this.addSlotToPopup(this.mHardLevelSlot);
            }
         }
      }
      
      private function createBoostersSlot() : void
      {
         var _loc1_:Array = null;
         if(!this.mIsEndLevel)
         {
            _loc1_ = this.mLevelDef.getPreBoostsArr();
            if(_loc1_ != null && _loc1_.length > 0)
            {
               if(this.mBoostersSlot == null)
               {
                  this.mBoostersSlot = new PlayPopupSlot(PlayPopupSlot.TYPE_BOOSTERS,PlayPopupSlot.POS_MID,this.mLevelDef);
                  this.addSlotToPopup(this.mBoostersSlot);
               }
            }
         }
      }
      
      private function createMatchSummarySlot() : void
      {
         if(this.mIsEndLevel)
         {
            if(this.mMatchSummarySlot == null)
            {
               this.mMatchSummarySlot = new PlayPopupSlot(PlayPopupSlot.TYPE_MATCH_SUMMARY,PlayPopupSlot.POS_MID,this.mLevelDef);
               this.addSlotToPopup(this.mMatchSummarySlot);
            }
         }
      }
      
      private function createBottomSlot() : void
      {
         if(this.mBottomSlot == null)
         {
            this.mBottomSlot = new PlayPopupSlot(PlayPopupSlot.TYPE_NONE,PlayPopupSlot.POS_BOT);
            this.addSlotToPopup(this.mBottomSlot);
         }
      }
      
      protected function turnStarOn(param1:FSPopupStar) : void
      {
         if(param1)
         {
            param1.turnOnStar();
         }
      }
      
      private function addOnScoreReachedImages() : void
      {
         if(!this.mIsRaid)
         {
            if(this.mScoreImagesContainer == null)
            {
               this.mScoreImagesContainer = new Component();
               this.mScoreImagesContainer.touchable = false;
            }
            if(this.mMinScoreReachedStar == null)
            {
               this.mMinScoreReachedStar = new FSPopupStar(1.3,this.mScoreImagesContainer,1);
               this.mMinScoreReachedStar.x = mBox.width / 3 - this.mMinScoreReachedStar.width / 5;
            }
            if(this.mMedScoreReachedStar == null)
            {
               this.mMedScoreReachedStar = new FSPopupStar(1.5,this.mScoreImagesContainer,2);
               this.mMedScoreReachedStar.x = mBox.width / 2;
            }
            if(this.mMaxScoreReachedStar == null)
            {
               this.mMaxScoreReachedStar = new FSPopupStar(1.3,this.mScoreImagesContainer,3);
               this.mMaxScoreReachedStar.x = mBox.width / 1.5 + this.mMaxScoreReachedStar.width / 5;
            }
            this.mMinScoreReachedStar.rotation = deg2rad(-20);
            this.mMaxScoreReachedStar.rotation = deg2rad(20);
            this.mScoreImagesContainer.addChild(this.mMinScoreReachedStar);
            this.mScoreImagesContainer.addChild(this.mMedScoreReachedStar);
            this.mScoreImagesContainer.addChild(this.mMaxScoreReachedStar);
            this.mScoreImagesContainer.y = -this.mMaxScoreReachedStar.height / 3;
            addChild(this.mScoreImagesContainer);
         }
      }
      
      private function updateProgressBar(param1:int) : void
      {
         var _loc2_:int = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : 0;
         var _loc3_:int = this.mLevelDef != null ? this.mLevelDef.getMaxScoreByDifficulty(_loc2_) : 2000;
         var _loc4_:Number = Math.min(param1 / _loc3_,1);
         var _loc5_:Number = (STAR_ANIM_DURATION + STAR_ANIM_DELAY_BETWEEN_STARS_DURATION) * this.getStarsAmount(param1);
         this.mProgressBar.setValueAnimated(_loc4_,_loc5_);
      }
      
      private function getStarsAmount(param1:int) : int
      {
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         var _loc3_:int = this.mLevelDef != null ? this.mLevelDef.getMinScoreByDifficulty(_loc2_) : 250;
         var _loc4_:int = this.mLevelDef != null ? this.mLevelDef.getMedScoreByDifficulty(_loc2_) : 1500;
         var _loc5_:int = this.mLevelDef != null ? this.mLevelDef.getMaxScoreByDifficulty(_loc2_) : 2000;
         var _loc6_:Number = 0;
         if(param1 >= _loc3_)
         {
            _loc6_++;
         }
         if(param1 >= _loc4_)
         {
            _loc6_++;
         }
         if(param1 >= _loc5_)
         {
            _loc6_++;
         }
         return _loc6_;
      }
      
      private function onScoreShown(param1:int) : void
      {
         var _loc7_:Object = null;
         if(this.mProgressBar)
         {
            this.updateProgressBar(param1);
         }
         if(param1 > 0 && (this.mIsEndLevel && this.mWin || !this.mIsEndLevel))
         {
            if(Root.smCurrentLevelScore == null)
            {
               Root.smCurrentLevelScore = new Object();
            }
            _loc7_ = new Object();
            _loc7_.level = this.mLevelDef.getSku();
            _loc7_.score = param1;
            Root.smCurrentLevelScore.levelScore = _loc7_;
         }
         if(this.mScoreSlot)
         {
            this.mScoreSlot.updateScore(param1);
         }
         InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         var _loc3_:int = this.mLevelDef != null ? this.mLevelDef.getMinScoreByDifficulty(_loc2_) : 250;
         var _loc4_:int = this.mLevelDef != null ? this.mLevelDef.getMedScoreByDifficulty(_loc2_) : 1500;
         var _loc5_:int = this.mLevelDef != null ? this.mLevelDef.getMaxScoreByDifficulty(_loc2_) : 2000;
         var _loc6_:Number = 0;
         if(param1 >= _loc3_)
         {
            TweenMax.delayedCall(_loc6_,this.turnStarOn,[this.mMinScoreReachedStar]);
            _loc6_ += STAR_ANIM_DELAY_BETWEEN_STARS_DURATION;
         }
         if(param1 >= _loc4_)
         {
            TweenMax.delayedCall(_loc6_,this.turnStarOn,[this.mMedScoreReachedStar]);
            _loc6_ += STAR_ANIM_DELAY_BETWEEN_STARS_DURATION;
         }
         if(param1 >= _loc5_)
         {
            TweenMax.delayedCall(_loc6_,this.turnStarOn,[this.mMaxScoreReachedStar]);
            _loc6_ += STAR_ANIM_DELAY_BETWEEN_STARS_DURATION;
         }
         if(this.mMatchSummarySlot)
         {
            this.mMatchSummarySlot.increasePunctuationItemsValue(this.mWin);
         }
         if(this.mLevelItemRef)
         {
            this.mLevelItemRef.addStarMeshes();
         }
      }
      
      private function manageSelector() : void
      {
         var _loc3_:JobDef = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Vector.<String> = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:Boolean = _loc1_ ? _loc1_.isPlayerEligibleToSeeDeckSelector() : true;
         if(_loc1_)
         {
            if(this.mIsRaid || Boolean(this.mLevelDef) && Boolean(!this.mLevelDef.areDefaultCardsDefined()))
            {
               _loc4_ = DictionaryUtils.getCatalogCardsAmountCheckingRestrictions(_loc1_.getCardCollection(),true,Config.getConfig().getDeckCardsAmount());
               _loc5_ = _loc4_ < Config.getConfig().getDeckCardsAmount();
               _loc6_ = _loc1_.hasAnyCustomDeckAvailable();
               if(_loc5_ || !_loc6_)
               {
                  if(_loc5_ && !Config.getConfig().gameHasClassSystem())
                  {
                     _loc1_.setDeck(_loc1_.getCardCollectionArr(),UserData.getTutorialDeckIndex());
                  }
                  else if(Config.getConfig().gameHasClassSystem())
                  {
                     if(_loc2_)
                     {
                        this.createDeckSelectorSlot();
                     }
                     else
                     {
                        _loc3_ = JobDef(InstanceMng.getJobsDefMng().getBasicsJobDef()[0]);
                        _loc1_.setDeck(_loc1_.createBestBasicDeckConfiguration(_loc3_),UserData.getTutorialDeckIndex());
                        _loc1_.setSelectedDeckIndex(UserData.getTutorialDeckIndex());
                     }
                  }
                  else
                  {
                     _loc7_ = _loc1_.createBestDeckConfiguration();
                     if(_loc7_)
                     {
                        _loc1_.cleanDeckByIndex(UserData.getTutorialDeckIndex());
                        _loc10_ = "";
                        _loc8_ = 0;
                        while(_loc8_ < _loc7_.length)
                        {
                           _loc10_ += _loc7_[_loc8_] + ":" + 1;
                           if(_loc8_ != _loc7_.length - 1)
                           {
                              _loc10_ += ",";
                           }
                           _loc8_++;
                        }
                        _loc9_ = _loc10_ ? _loc10_.split(",") : null;
                        if(_loc9_)
                        {
                           _loc1_.setDeck(_loc9_,UserData.getTutorialDeckIndex());
                        }
                     }
                  }
                  if(!Config.getConfig().gameHasClassSystem())
                  {
                     _loc1_.setSelectedDeckIndex(UserData.getTutorialDeckIndex());
                  }
               }
               else
               {
                  this.createDeckSelectorSlot();
               }
            }
            else if(Config.getConfig().gameHasClassSystem())
            {
               if(_loc2_)
               {
                  this.createDeckSelectorSlot();
               }
               else
               {
                  _loc3_ = JobDef(InstanceMng.getJobsDefMng().getBasicsJobDef()[0]);
                  _loc1_.setDeck(_loc1_.createBestBasicDeckConfiguration(_loc3_),UserData.getTutorialDeckIndex());
                  _loc1_.setSelectedDeckIndex(UserData.getTutorialDeckIndex());
               }
            }
            else
            {
               _loc1_.setSelectedDeckIndex(UserData.getTutorialDeckIndex());
            }
         }
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:UserData = null;
         var _loc6_:LevelDef = null;
         var _loc7_:int = 0;
         super.onPopupOpenTransitionOver();
         if(!mClosed)
         {
            this.getCollectionSizePreCalculated();
            this.performTransitionTweenSocialBar();
            _loc1_ = !this.mIsEndLevel || this.mIsEndLevel && this.mWin;
            if(Boolean(this.mLevelDef) && _loc1_)
            {
               _loc2_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
               _loc3_ = InstanceMng.getBattleEngine() ? InstanceMng.getScoreMng().calculateFinalScore(true) : -1;
               _loc4_ = this.mIsEndLevel;
               _loc5_ = Utils.getOwnerUserData();
               _loc6_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().getLevelDef() : null;
               if(Boolean(_loc4_ && _loc3_ != -1) && Boolean(_loc6_) && this.mLevelDef.getLevelIndex() == _loc6_.getLevelIndex())
               {
                  this.onScoreShown(_loc3_);
               }
               else if(Boolean(_loc5_) && Boolean(_loc5_.getTopScores() != null) && Boolean(_loc5_.getScoreByLevelSku(this.mLevelDef.getSku())))
               {
                  _loc7_ = _loc5_.getScoreByLevelSku(this.mLevelDef.getSku());
                  this.onScoreShown(_loc7_);
               }
               else
               {
                  InstanceMng.getUserDataMng().getTopScoreByLevelSku(this.mLevelDef.getSku(),this.onScoreShown,_loc2_);
               }
            }
            else
            {
               this.onScoreShown(0);
            }
         }
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         var _loc5_:RaidDef = null;
         var _loc6_:int = 0;
         var _loc4_:String = "";
         if(this.mIsEndLevel)
         {
            _loc4_ = this.mWin ? TextManager.getText("TID_GEN_BUTTON_OK") : TextManager.getText("TID_GEN_BUTTON_RETRY");
         }
         else if(!this.mIsRaid)
         {
            _loc4_ = TextManager.getText("TID_GEN_PLAY");
         }
         else
         {
            _loc5_ = InstanceMng.getRaidsMng() ? InstanceMng.getRaidsMng().getCurrentRaidDef() : null;
            _loc6_ = (Boolean(_loc5_)) && _loc5_.getIsMultiPlayer() ? int(InstanceMng.getUserDataMng().getOwnerUserData().getRaidTicketsMultiPlayer()) : int(InstanceMng.getUserDataMng().getOwnerUserData().getRaidTicketsSinglePlayer());
            _loc4_ = InstanceMng.getCurrentScreen() is FSBattleScreen ? TextManager.getText("TID_GEN_BUTTON_RETRY") + " (" + _loc6_ + ")" : TextManager.getText("TID_GEN_PLAY");
         }
         super.setupAcceptButton(_loc4_,Constants.ACCEPT_GREEN_BUTTON_UP_NAME,Constants.ACCEPT_GREEN_BUTTON_UP_NAME);
         if(mAcceptButton)
         {
            mAcceptButton.fontName = FSResourceMng.getFontByType();
         }
      }
      
      override protected function performOpeningTransition(param1:FSCoordinate = null) : void
      {
         y = this.mScoreImagesContainer ? y + this.mScoreImagesContainer.height / 2 : y;
         super.performOpeningTransition(param1);
      }
      
      override public function onClose(param1:Event) : void
      {
         var _loc2_:Popup = null;
         var _loc3_:FSRaidsScreen = null;
         if(this.mSocialBottomBar)
         {
            this.mSocialBottomBar.setParentPopupAsClosed();
         }
         this.hideCarrousels(false);
         if(this.mIsEndLevel)
         {
            _loc2_ = InstanceMng.getPopupMng().getPopupInBackground();
            if(_loc2_)
            {
               _loc2_ = null;
               InstanceMng.getPopupMng().setPopupInBackground(null);
            }
            Utils.stopSound(Constants.SOUND_DEFEAT);
            closePopup(this.onCancelLevelFailedPerformActions);
         }
         else if(this.mIsRaid)
         {
            _loc3_ = InstanceMng.getCurrentScreen() as FSRaidsScreen;
            if(_loc3_)
            {
               _loc3_.enableRightPanel(true);
               _loc3_.resetRightSection();
            }
            else
            {
               Utils.stopSound(Constants.SOUND_VICTORY);
               Utils.stopSound(Constants.SOUND_DEFEAT);
               if(InstanceMng.getCurrentScreen() is FSBattleScreen)
               {
                  FSBattleScreen(InstanceMng.getCurrentScreen()).performCardsLeavingFX(0,FSBattleScreen(InstanceMng.getCurrentScreen()).showRaidsScreen);
               }
            }
            super.onClose(param1);
         }
         else
         {
            if(InstanceMng.getCurrentScreen() is FSMapScreen)
            {
               Main.smPreviousLevelItem = null;
            }
            if(param1)
            {
               param1.stopImmediatePropagation();
            }
            closePopup(this.onCancelStartLevelPerformActions);
         }
         if(this.mSocialBottomBar)
         {
            this.mSocialBottomBar.cancelPortraitPicsRequest();
         }
      }
      
      public function getSocialScoresBar() : SocialScoresBar
      {
         return this.mSocialBottomBar;
      }
      
      override public function onConnectionChange() : void
      {
         super.onConnectionChange();
         if(this.mSocialBottomBar)
         {
            this.mSocialBottomBar.setFBButtonVisibility();
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         var _loc2_:Popup = null;
         param1.stopImmediatePropagation();
         if(this.mIsEndLevel)
         {
            if(this.mWin)
            {
               _loc2_ = InstanceMng.getPopupMng().getPopupInBackground();
               if(_loc2_)
               {
                  _loc2_ = null;
                  InstanceMng.getPopupMng().setPopupInBackground(null);
               }
               super.onAccept(param1);
               if(this.mSocialBottomBar)
               {
                  this.mSocialBottomBar.cancelPortraitPicsRequest();
                  this.mSocialBottomBar.setParentPopupAsClosed();
               }
               mOnClosedFunction = this.onLevelCompletedAccept;
            }
            else
            {
               _loc2_ = InstanceMng.getPopupMng().getPopupInBackground();
               if(_loc2_)
               {
                  _loc2_ = null;
                  InstanceMng.getPopupMng().setPopupInBackground(null);
               }
               super.onAccept(param1);
               mOnClosedFunction = this.onFailedLevelRetry;
            }
         }
         else if(!this.mIsRaid)
         {
            this.onStartLevelAccept();
         }
         else if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc2_ = InstanceMng.getPopupMng().getPopupInBackground();
            if(_loc2_)
            {
               _loc2_ = null;
               InstanceMng.getPopupMng().setPopupInBackground(null);
            }
            super.onAccept(param1);
            mOnClosedFunction = this.onFailedLevelRetry;
         }
         else
         {
            this.onStartLevelAccept();
         }
      }
      
      private function onStartLevelAccept() : void
      {
         var _loc1_:Boolean = false;
         if(this.mIsRaid)
         {
            if(InstanceMng.getRaidsMng().isWeeklySeasonActive())
            {
               _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().isSelectedDeckSizeCorrect(this.mLevelDef);
               if(_loc1_)
               {
                  if(this.mSocialBottomBar)
                  {
                     this.mSocialBottomBar.setParentPopupAsClosed();
                  }
                  closePopup(this.onStartRaidLevelPerformAccept);
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_GEN_DECK_AVAILABLE"));
                  if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
                  {
                     FSRaidsScreen(InstanceMng.getCurrentScreen()).enableRightPanel(true);
                  }
               }
            }
            else
            {
               this.onClose(new Event(Event.CLOSE));
               if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
               {
                  FSRaidsScreen(InstanceMng.getCurrentScreen()).enableRightPanel(true);
               }
            }
         }
         else
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().isSelectedDeckSizeCorrect(this.mLevelDef);
            if(_loc1_)
            {
               if(this.mSocialBottomBar)
               {
                  this.mSocialBottomBar.setParentPopupAsClosed();
               }
               closePopup(this.onStartLevelPerformAccept);
               if(this.mSocialBottomBar)
               {
                  this.mSocialBottomBar.cancelPortraitPicsRequest();
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_GEN_DECK_AVAILABLE"));
            }
            if(InstanceMng.getTutorialMapMng().isTutorialON())
            {
               InstanceMng.getTutorialMapMng().increaseCurrentStep();
            }
         }
      }
      
      private function onFailedLevelRetry() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         InstanceMng.getQuestsMng().onLevelFailed();
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(Boolean(this.mLevelDef) && Boolean(_loc1_))
         {
            _loc2_ = _loc1_.getCurrentDifficulty();
            _loc3_ = this.mLevelDef.areDefaultCardsDefined();
            Utils.stopSound(Constants.SOUND_DEFEAT);
            if(_loc3_)
            {
               _loc4_ = !Config.smLivesSystemEnabled ? true : _loc1_.getLives() > 0;
               if(_loc4_)
               {
                  _loc5_ = _loc1_ ? _loc1_.getSelectedDeckIndex() : -1;
                  _loc1_.setLastLevelPlayedSkuByDifficulty(this.mLevelDef.getSku());
                  _loc6_ = Boolean(Root) && Boolean(Root.smBattleData) && Boolean(Root.smBattleData.easyMode);
                  _loc7_ = _loc1_ ? _loc1_.getCurrentLevelIndex(_loc2_) > this.mLevelDef.getLevelIndex() : false;
                  InstanceMng.getServerConnection().sendPvELevelAttempt(this.mLevelDef.getLevelIndex(),_loc2_,_loc7_,_loc5_,_loc6_);
                  if(Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen() is FSBattleScreen)
                  {
                     FSBattleScreen(InstanceMng.getCurrentScreen()).onRetry();
                  }
                  else
                  {
                     InstanceMng.getPopupMng().openPlayLevelPopup(this.mLevelDef.getSku());
                  }
               }
            }
            else if(!this.mIsRaid)
            {
               InstanceMng.getPopupMng().openPlayLevelPopup(this.mLevelDef.getSku());
            }
            else if(Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               if(InstanceMng.getRaidsMng().isAllowedToRetry())
               {
                  this.onStartRaidLevelPerformAccept();
               }
               else
               {
                  this.onCancelStartRaid();
               }
            }
         }
      }
      
      private function onCancelStartRaid() : void
      {
         Utils.stopSound(Constants.SOUND_VICTORY);
         Utils.stopSound(Constants.SOUND_DEFEAT);
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).performCardsLeavingFX(0,FSBattleScreen(InstanceMng.getCurrentScreen()).showRaidsScreen);
         }
      }
      
      private function onLevelCompletedAccept() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:RewardDef = null;
         var _loc7_:Boolean = false;
         var _loc8_:Object = null;
         var _loc9_:Number = NaN;
         var _loc10_:RewardsEffect = null;
         var _loc1_:Popup = InstanceMng.getPopupMng().getPopupInBackground();
         if(_loc1_)
         {
            _loc1_ = null;
            InstanceMng.getPopupMng().setPopupInBackground(null);
         }
         if(this.mSocialBottomBar)
         {
            this.mSocialBottomBar.setParentPopupAsClosed();
         }
         if(this.mLevelDef != null)
         {
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc3_ = this.mLevelDef.getMapWorldParentIndex();
            _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc4_);
            _loc5_ = this.mIsNewLevel ? this.mLevelDef.getRewardSkuByDifficulty(_loc2_,_loc4_) : this.mLevelDef.getReplayRewardSkuByDifficulty(_loc2_);
            _loc6_ = RewardDef(InstanceMng.getRewardsDefMng().getDefBySku(_loc5_));
            _loc7_ = false;
            if(_loc6_)
            {
               _loc8_ = Utils.getRewardsToClaimSummary(_loc6_);
               _loc9_ = this.mLevelDef.getExperience(!this.mIsNewLevel);
               JobsMng.winJobExperience(_loc9_);
               _loc10_ = new RewardsEffect(PacksDefMng.PACK_REWARD,_loc8_,false,this.mLevelDef.getChestBG());
               _loc10_.alpha = 0;
               SpecialFX.tweenToAlpha(_loc10_,1,0.3,0);
               InstanceMng.getCurrentScreen().addChild(_loc10_);
            }
            else
            {
               _loc7_ = true;
            }
            if(_loc7_)
            {
               if(Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen() is FSBattleScreen)
               {
                  FSBattleScreen(InstanceMng.getCurrentScreen()).showMap();
               }
               Utils.stopSound(Constants.SOUND_VICTORY);
               if(Utils.isMusicOn() && Config.getConfig().battleHasOwnMusic())
               {
                  if(Config.smTracklistModeOn)
                  {
                     Utils.loadNextTrack();
                  }
                  else
                  {
                     Utils.resumeAllSounds();
                  }
               }
            }
         }
      }
      
      private function onStartLevelPerformAccept() : void
      {
         var _loc1_:String = null;
         var _loc3_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         InstanceMng.getUserDataMng().updateSelectedDeckIndex();
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         var _loc4_:UserData = Utils.getOwnerUserData();
         _loc3_ = !Config.smLivesSystemEnabled || this.mIsRaid ? true : _loc4_.getLives() > 0;
         if(_loc3_)
         {
            _loc4_.setLastLevelPlayedSkuByDifficulty(this.mLevelDef.getSku());
            _loc5_ = Boolean(Root) && Boolean(Root.smBattleData) && Boolean(Root.smBattleData.easyMode);
            _loc1_ = _loc5_ ? FSTracker.ACTION_PVE_STARTED_EASY_MODE : FSTracker.ACTION_PVE_STARTED;
            _loc6_ = _loc4_ ? _loc4_.getSelectedDeckIndex() : -1;
            _loc7_ = _loc4_ ? _loc4_.getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
            _loc8_ = _loc4_ ? _loc4_.getCurrentLevelIndex(_loc7_) > this.mLevelDef.getLevelIndex() : false;
            InstanceMng.getServerConnection().sendPvELevelAttempt(this.mLevelDef.getLevelIndex(),_loc7_,_loc8_,_loc6_,_loc5_);
            if(_loc2_ is FSMapScreen)
            {
               _loc2_.startBattle(this.mLevelDef.getSku(),false);
            }
            else if(_loc2_ is FSBattleScreen)
            {
               FSBattleScreen(_loc2_).onRetry();
               _loc1_ = Boolean(Root) && Boolean(Root.smBattleData) && Boolean(Root.smBattleData.easyMode) ? FSTracker.ACTION_PVE_RETRY_EASY_MODE : FSTracker.ACTION_PVE_RETRY;
               FSTracker.trackMiscAction(FSTracker.getLevelCategoryByDifficulty(),_loc1_,{"level":this.mLevelDef.getSku()});
            }
         }
      }
      
      private function onStartRaidLevelPerformAccept() : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         InstanceMng.getRaidsMng().setBossHealCurrentRaid(0);
         InstanceMng.getRaidsMng().setBossHitCurrentRaid(0);
         var _loc1_:RaidDef = InstanceMng.getRaidsMng() ? InstanceMng.getRaidsMng().getCurrentRaidDef() : null;
         var _loc2_:int = InstanceMng.getRaidsMng() ? InstanceMng.getRaidsMng().getCurrentRaidDifficulty() : -1;
         if(_loc1_)
         {
            _loc3_ = _loc1_.getIsMultiPlayer() ? ServerConnection.CURRENCY_RAID_TICKETS_MP : ServerConnection.CURRENCY_RAID_TICKETS_SP;
            _loc4_ = _loc1_.getKeyCostByDifficultyIndex(_loc2_);
            if(_loc1_.getIsMultiPlayer())
            {
               InstanceMng.getUserDataMng().getOwnerUserData().substractRaidTicketsMP(-_loc4_,this.onRaidPayedStart,[_loc1_,_loc2_],this.onNotEnoughBalanceToStartRaid);
            }
            else
            {
               InstanceMng.getUserDataMng().getOwnerUserData().substractRaidTicketsSP(-_loc4_,this.onRaidPayedStart,[_loc1_,_loc2_],this.onNotEnoughBalanceToStartRaid);
            }
         }
      }
      
      private function onNotEnoughBalanceToStartRaid() : void
      {
         Utils.setLogText(TextManager.getText("TID_RAID_ENOUGH_TICKETS"),true,false,false);
         this.onCancelStartRaid();
      }
      
      private function onRaidPayedStart(param1:RaidDef, param2:int) : void
      {
         var _loc4_:int = 0;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).onRetry();
         }
         this.trackRaidStart();
         var _loc3_:Screen = InstanceMng.getCurrentScreen();
         if(_loc3_ is FSRaidsScreen)
         {
            _loc4_ = InstanceMng.getRaidsMng().getRaidBossHP(param1,param2);
            InstanceMng.getRaidsMng().onRaidStart(param1,param2,_loc4_);
         }
         else if(_loc3_ is FSBattleScreen)
         {
            InstanceMng.getRaidsMng().onRaidStart(param1,param2,InstanceMng.getBattleEngine().getOpponentBattleInfo().getHP());
         }
      }
      
      private function trackRaidStart() : void
      {
         var _loc1_:String = Boolean(Root) && Boolean(Root.smBattleData) && Boolean(Root.smBattleData.easyMode) ? FSTracker.ACTION_PVE_STARTED_EASY_MODE : FSTracker.ACTION_PVE_STARTED;
         var _loc2_:int = -1;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getSelectedDeckIndex();
         }
         FSTracker.trackMiscAction(FSTracker.CATEGORY_LEVELS,_loc1_,{
            "level":this.mLevelDef.getSku(),
            "deck":_loc2_
         });
      }
      
      private function onCancelLevelFailedPerformActions() : void
      {
         InstanceMng.getQuestsMng().onLevelFailed();
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).performCardsLeavingFX(0,this.battleScreenShowMap);
         }
      }
      
      private function onCancelStartLevelPerformActions() : void
      {
         InstanceMng.getQuestsMng().onLevelFailed();
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            TweenMax.delayedCall(0.25,this.battleScreenShowMap);
         }
      }
      
      private function battleScreenShowMap() : void
      {
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).showMap();
         }
      }
      
      public function onDeckSelectionChanged(param1:int, param2:int) : void
      {
         if(this.mDeckSelectorSlot)
         {
            this.mDeckSelectorSlot.onDeckSelectionChanged(param1,param2);
         }
      }
      
      public function hideCarrousels(param1:Boolean = true) : void
      {
         if(this.mDeckSelectorSlot)
         {
            this.mDeckSelectorSlot.hideCarrousels(param1);
         }
      }
      
      public function getCollectionSizePreCalculated() : int
      {
         this.mCurrentCollectionSize = this.mCurrentCollectionSize == -1 ? DictionaryUtils.getCatalogCardsAmountCheckingRestrictions(InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection(),true,Config.getConfig().getDeckCardsAmount()) : this.mCurrentCollectionSize;
         return this.mCurrentCollectionSize;
      }
      
      private function createProgressBar() : void
      {
         var _loc1_:Number = NaN;
         if(this.mIsEndLevel)
         {
            if(this.mProgressBar == null)
            {
               this.mProgressBar = new FSGaugeProgressBar("","end_level_bar",1,false,mBox.width * 0.7);
               this.mProgressBar.alignPivot();
               _loc1_ = 0;
               this.mProgressBar.x = mBox.width / 2;
               this.mProgressBar.y = this.mProgressBar.height / 2;
               this.mProgressBar.setRatio(_loc1_);
               this.mProgressBar.touchable = false;
               addChildAt(this.mProgressBar,0);
            }
         }
      }
      
      private function createSocialBar() : void
      {
         if(!this.mIsRaid)
         {
            if(this.mSocialBottomBar == null)
            {
               this.mSocialBottomBar = new SocialScoresBar(this.mLevelDef);
            }
            this.mSocialBottomBar.x = (Starling.current.stage.stageWidth - this.mSocialBottomBar.width) / 2;
            this.mSocialBottomBar.y = Starling.current.stage.stageHeight - this.mSocialBottomBar.height;
            this.mSocialBottomBar.visible = false;
         }
      }
      
      override public function hideTemporarily(param1:Function = null, param2:Array = null) : void
      {
         super.hideTemporarily(param1,param2);
         if(this.mSocialBottomBar)
         {
            TweenMax.delayedCall(0.25,this.setSocialBarVisible,[false]);
         }
      }
      
      private function setSocialBarVisible(param1:Boolean) : void
      {
         if(this.mSocialBottomBar)
         {
            this.mSocialBottomBar.visible = param1;
         }
      }
      
      private function performTransitionTweenSocialBar() : void
      {
         var _loc1_:FSCoordinate = new FSCoordinate();
         if(this.mSocialBottomBar != null)
         {
            _loc1_.setX((Starling.current.stage.stageWidth - this.mSocialBottomBar.width) / 2);
            _loc1_.setY(Starling.current.stage.stageHeight - this.mSocialBottomBar.getUsefulHeight());
            this.mSocialBottomBar.x = (Starling.current.stage.stageWidth - this.mSocialBottomBar.width) / 2;
            this.mSocialBottomBar.y = Starling.current.stage.stageHeight;
            this.mSocialBottomBar.visible = true;
            InstanceMng.getCurrentScreen().addChild(this.mSocialBottomBar);
            SpecialFX.createTransition(this.mSocialBottomBar,_loc1_,TRANSITION_TIME,0,this.requestSocialBarInfo);
         }
         if(InstanceMng.getTutorialMapMng().isTutorialON())
         {
            InstanceMng.getTutorialMapMng().increaseCurrentStep("UI/" + FSPopupMng.PLAY_LEVEL_POPUP_NAME);
         }
      }
      
      public function requestSocialBarInfo() : void
      {
         if(this.mSocialScoresAlreadyReceived == false && Boolean(this.mSocialBottomBar))
         {
            this.mSocialBottomBar.requestFriendsScores();
            this.mSocialScoresAlreadyReceived = true;
         }
      }
      
      public function isLevelCompleted() : Boolean
      {
         return !this.mIsRaid && this.mIsEndLevel && this.mWin;
      }
      
      override protected function removeFromStage() : void
      {
         this.hideCarrousels(false);
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mMinScoreReachedStar)
         {
            this.mMinScoreReachedStar.removeFromParent(true);
            this.mMinScoreReachedStar = null;
         }
         if(this.mMedScoreReachedStar)
         {
            this.mMedScoreReachedStar.removeFromParent(true);
            this.mMedScoreReachedStar = null;
         }
         if(this.mMaxScoreReachedStar)
         {
            this.mMaxScoreReachedStar.removeFromParent(true);
            this.mMaxScoreReachedStar = null;
         }
         if(this.mScoreImagesContainer)
         {
            this.mScoreImagesContainer.removeFromParent(true);
            this.mScoreImagesContainer = null;
         }
         if(this.mScoreSlot)
         {
            this.mScoreSlot.removeFromParent(true);
            this.mScoreSlot = null;
         }
         if(this.mEventSlot)
         {
            this.mEventSlot.removeFromParent(true);
            this.mEventSlot = null;
         }
         if(this.mDeckSelectorSlot)
         {
            this.mDeckSelectorSlot.removeFromParent(true);
            this.mDeckSelectorSlot = null;
         }
         if(this.mHardLevelSlot)
         {
            this.mHardLevelSlot.removeFromParent(true);
            this.mHardLevelSlot = null;
         }
         if(this.mBoostersSlot)
         {
            this.mBoostersSlot.removeFromParent(true);
            this.mBoostersSlot = null;
         }
         if(this.mMatchSummarySlot)
         {
            this.mMatchSummarySlot.removeFromParent(true);
            this.mMatchSummarySlot = null;
         }
         if(this.mBottomSlot)
         {
            this.mBottomSlot.removeFromParent(true);
            this.mBottomSlot = null;
         }
         if(this.mSlotsContainer)
         {
            this.mSlotsContainer.removeChildren(0,-1,true);
            this.mSlotsContainer.removeFromParent(true);
            this.mSlotsContainer = null;
         }
         if(this.mProgressBar)
         {
            this.mProgressBar.removeFromParent(true);
            this.mProgressBar = null;
         }
         if(this.mSocialBottomBar)
         {
            this.mSocialBottomBar.removeFromParent();
            this.mSocialBottomBar = null;
         }
         if(this.mObjectivesInfoButton)
         {
            this.mObjectivesInfoButton.removeFromParent();
            this.mObjectivesInfoButton = null;
         }
         this.mLevelItemRef = null;
         InstanceMng.getPopupMng().removePopup(FSPopupMng.PLAY_LEVEL_POPUP_NAME);
         super.removeFromStage();
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return !this.mWin;
      }
   }
}

