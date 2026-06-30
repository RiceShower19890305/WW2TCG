package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.QuestDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.jobs.FSJobSelectedInfo;
   import com.fs.tcgengine.view.jobs.FSJobSlot;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalLayout;
   import starling.events.Event;
   import starling.textures.Texture;
   
   public class JobPanel extends Component
   {
      
      private var mBG:FSImage;
      
      private var mJobsScrollContainer:ScrollContainer;
      
      private var mSelectedSlot:FSJobSlot;
      
      private var mJobSelectedInfo:FSJobSelectedInfo;
      
      private var mSelectJobButton:FSButton;
      
      private var mDeckJobConf:DeckJobConfigurator;
      
      private var mDeckTitleDeckBuilder:DeckTitleDeckBuilder;
      
      private var mPreventFromClosing:Boolean = false;
      
      public function JobPanel(param1:DeckTitleDeckBuilder)
      {
         this.mDeckTitleDeckBuilder = param1;
         super();
      }
      
      public function setupPanel(param1:DeckTitleDeckBuilder) : void
      {
         this.mDeckTitleDeckBuilder = param1;
         this.init();
         this.performOpeningFX();
      }
      
      private function init() : void
      {
         this.createUI();
      }
      
      private function refreshSelectedIndexSlot() : void
      {
         this.mDeckJobConf = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(InstanceMng.getUserDataMng().getOwnerUserData().getSelectedDeckIndex());
         var _loc1_:int = this.mDeckJobConf ? this.getIndexSlotToSelect(this.mDeckJobConf.getJobSku()) : 0;
         _loc1_ = _loc1_ != -1 ? _loc1_ : 0;
         this.selectSlot(_loc1_);
         if(InstanceMng.getTutorialDeckBuilderMng().isTutorialON())
         {
            InstanceMng.getTutorialDeckBuilderMng().checkTutorialFunctionsOnHold();
         }
      }
      
      private function getIndexSlotToSelect(param1:String) : int
      {
         var _loc3_:int = 0;
         var _loc4_:FSJobSlot = null;
         var _loc2_:int = -1;
         if(Boolean(this.mJobsScrollContainer) && this.mJobsScrollContainer.numChildren > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mJobsScrollContainer.numChildren)
            {
               _loc4_ = FSJobSlot(this.mJobsScrollContainer.getChildAt(_loc3_));
               if(_loc4_)
               {
                  if(_loc4_.getJobDef().getSku() == param1)
                  {
                     _loc2_ = _loc3_;
                     break;
                  }
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      private function createUI() : void
      {
         this.createBGImage();
         this.createJobsScrollContainer();
         this.createJobs();
         this.createSelectJobButton();
      }
      
      private function createSelectJobButton() : void
      {
         if(Boolean(this.mBG) && this.mSelectJobButton == null)
         {
            this.mSelectJobButton = new FSButton(Root.assets.getTexture("job_button_lit"),TextManager.getText("TID_GEN_SELECT"));
            this.mSelectJobButton.name = "select_job";
            this.mSelectJobButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mSelectJobButton.x = (this.mBG.x + this.mBG.width) / 2;
            this.mSelectJobButton.y = this.mBG.y + this.mBG.height - this.mSelectJobButton.height / 2;
            this.mSelectJobButton.addEventListener(Event.TRIGGERED,this.onJobSelectTriggered);
            addChild(this.mSelectJobButton);
         }
      }
      
      private function onJobSelectTriggered(param1:Event) : void
      {
         var _loc2_:UserData = null;
         var _loc3_:int = 0;
         var _loc4_:QuestDef = null;
         if(Boolean(this.mSelectedSlot && this.mSelectedSlot.getJobDef()) && Boolean(JobsMng.isJobAvailable(this.mSelectedSlot.getJobDef())) && JobsMng.haveEnoughCardsForJob(this.mSelectedSlot.getJobDef()))
         {
            this.resetSelectedDeck();
            this.saveDeckJobConfig();
            if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
            {
               FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).updateCurrentJobSelected(this.mSelectedSlot.getJobDef());
               InstanceMng.getCurrentScreen().removeTranslucentBG();
               FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).onStartEditingDeck();
               _loc2_ = Utils.getOwnerUserData();
               if(Boolean(FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getDeckSelector()) && Boolean(_loc2_))
               {
                  FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getDeckSelector().getDeckTitleByIndex(_loc2_.getSelectedDeckIndex()).updateBG();
               }
               this.unload();
               if(this.mDeckTitleDeckBuilder)
               {
                  this.mDeckTitleDeckBuilder.openDeckPanel();
               }
            }
         }
         else if(Boolean(this.mSelectedSlot) && Boolean(this.mSelectedSlot.getJobDef()))
         {
            _loc3_ = JobsMng.getJobState(this.mSelectedSlot.getJobDef());
            switch(_loc3_)
            {
               case JobsMng.STATE_UNLOCKED_NO_CARDS:
                  Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_JOBS_LOCKED"),[Config.getConfig().getDeckCardsAmount()]),true);
                  break;
               case JobsMng.STATE_LOCKED:
                  Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_JOBS_UNLOCKED_DECK"),[this.mSelectedSlot.getJobDef().getUnlockLevel()]),true);
                  break;
               case JobsMng.STATE_LOCKED_BY_QUEST:
                  _loc4_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(this.mSelectedSlot.getJobDef().getLockedByQuestSku()));
                  if(_loc4_)
                  {
                     Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_JOBS_UNLOCK_SOCIAL"),[_loc4_.getDesc()]),true);
                  }
            }
            if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
            {
               FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).updateCurrentJobSelected(null);
            }
         }
      }
      
      private function onJobBuyTriggered(param1:Event) : void
      {
         var buyJob:Function = null;
         var cancelJobPurchase:Function = null;
         var confirmationText:String = null;
         var e:Event = param1;
         buyJob = function():void
         {
            mPreventFromClosing = false;
            if(mSelectJobButton)
            {
               mSelectJobButton.disableTemporarily();
            }
            if(mJobSelectedInfo)
            {
               JobsMng.buyJob(mJobSelectedInfo.getJobDef(),mJobSelectedInfo);
               mJobSelectedInfo.touchable = true;
            }
            touchable = true;
         };
         cancelJobPurchase = function():void
         {
            mPreventFromClosing = false;
            if(mJobSelectedInfo)
            {
               mJobSelectedInfo.touchable = true;
            }
            touchable = true;
         };
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(JobsMng.isJobReadyToUnlock(this.mSelectedSlot.getJobDef()))
            {
               if(JobsMng.haveEnoughCardsForJob(this.mSelectedSlot.getJobDef()))
               {
                  buyJob();
               }
               else
               {
                  this.mPreventFromClosing = true;
                  this.mJobSelectedInfo.touchable = false;
                  touchable = false;
                  confirmationText = TextManager.replaceParameters(TextManager.getText("TID_JOBS_UNLOCKED_CONFIRMATION"),[JobsMng.getNumCardsForJob(this.mJobSelectedInfo.getJobDef()).toString(),Config.getConfig().getDeckCardsAmount().toString()]);
                  InstanceMng.getPopupMng().openConfirmationPopup(confirmationText,buyJob,cancelJobPurchase);
               }
            }
            else
            {
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_JOBS_UNLOCKED_REQUIREMENT"),[this.mSelectedSlot.getJobDef().getUnlockLevel().toString()]),true);
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
         }
      }
      
      public function preventFromClosing() : Boolean
      {
         return this.mPreventFromClosing;
      }
      
      public function setPreventFromClosing(param1:Boolean) : void
      {
         this.mPreventFromClosing = param1;
      }
      
      private function resetSelectedDeck() : void
      {
         var _loc1_:DeckJobConfigurator = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(InstanceMng.getUserDataMng().getOwnerUserData().getSelectedDeckIndex());
         if(_loc1_)
         {
            if(this.mDeckJobConf == null || Boolean(this.mDeckJobConf) && Boolean(_loc1_.getJobSku() != this.mDeckJobConf.getJobSku()))
            {
               InstanceMng.getUserDataMng().getOwnerUserData().setDeck(null,InstanceMng.getUserDataMng().getOwnerUserData().getSelectedDeckIndex());
            }
         }
      }
      
      private function saveDeckJobConfig() : void
      {
         var _loc1_:DeckJobConfigurator = null;
         if(Boolean(this.mSelectedSlot) && Boolean(this.mJobSelectedInfo))
         {
            if(this.mDeckJobConf)
            {
               this.mDeckJobConf.setJobSku(this.mSelectedSlot.getJobDef().getSku());
               this.mDeckJobConf.setActiveAbilitySku(this.mJobSelectedInfo.getActiveAbilitySelectedSku());
               this.mDeckJobConf.setSelectedSkinSku(this.mJobSelectedInfo.getSelectedSkin());
               InstanceMng.getUserDataMng().getOwnerUserData().setDeckJobConfigurator(this.mDeckJobConf);
            }
            else
            {
               _loc1_ = new DeckJobConfigurator(InstanceMng.getUserDataMng().getOwnerUserData().getSelectedDeckIndex().toString(),this.mSelectedSlot.getJobDef().getSku(),this.mJobSelectedInfo.getActiveAbilitySelectedSku(),this.mJobSelectedInfo.getSelectedSkin());
               InstanceMng.getUserDataMng().getOwnerUserData().setDeckJobConfigurator(_loc1_);
            }
         }
         InstanceMng.getUserDataMng().persistenceSaveData();
      }
      
      public function selectSlot(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSJobSlot = null;
         if(Boolean(this.mJobsScrollContainer) && this.mJobsScrollContainer.numChildren > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mJobsScrollContainer.numChildren)
            {
               _loc3_ = FSJobSlot(this.mJobsScrollContainer.getChildAt(_loc2_));
               if(_loc3_)
               {
                  if(_loc3_.getIndexSlot() == param1)
                  {
                     _loc3_.createSelectEffect();
                     this.mSelectedSlot = _loc3_;
                  }
                  else
                  {
                     _loc3_.removeSelectEffect();
                  }
               }
               _loc2_++;
            }
         }
         if(Boolean(this.mDeckJobConf) && (Boolean(this.mSelectedSlot) && Boolean(this.mDeckJobConf.getJobSku() != this.mSelectedSlot.getJobDef().getSku())))
         {
            this.mDeckJobConf = null;
         }
         this.removeJobSelectedInfo();
         this.createJobSelectedInfo();
      }
      
      private function removeJobSelectedInfo() : void
      {
         if(this.mJobSelectedInfo)
         {
            this.mJobSelectedInfo.unloadAllSkins();
            this.mJobSelectedInfo.removeFromParent();
            this.mJobSelectedInfo.destroy();
            this.mJobSelectedInfo = null;
         }
      }
      
      private function createJobSelectedInfo() : void
      {
         if(this.mJobSelectedInfo == null && Boolean(this.mSelectedSlot))
         {
            this.mJobSelectedInfo = new FSJobSelectedInfo(this.mSelectedSlot.getJobDef(),this);
            this.mJobSelectedInfo.alpha = 0.0001;
            SpecialFX.tweenToAlpha(this.mJobSelectedInfo,0.999,1,0);
            addChild(this.mJobSelectedInfo);
         }
      }
      
      private function createJobs() : void
      {
         var _loc1_:JobDef = null;
         var _loc3_:FSJobSlot = null;
         var _loc2_:int = 0;
         for each(_loc1_ in InstanceMng.getJobsDefMng().getAllJobsDef())
         {
            _loc3_ = new FSJobSlot(_loc1_,_loc2_,this);
            this.addToJobsScrollContainer(_loc3_);
            _loc2_++;
         }
      }
      
      private function addToJobsScrollContainer(param1:FSJobSlot) : void
      {
         if(this.mJobsScrollContainer)
         {
            this.mJobsScrollContainer.addChild(param1);
         }
      }
      
      private function createJobsScrollContainer() : void
      {
         if(this.mJobsScrollContainer == null)
         {
            this.mJobsScrollContainer = new ScrollContainer();
            this.mJobsScrollContainer.layout = this.getContainerLayout();
            this.mJobsScrollContainer.height = this.mBG.height * 0.82;
            this.mJobsScrollContainer.x = this.mBG.width * 0.05;
            this.mJobsScrollContainer.y = this.mBG.height * 0.05;
            addChild(this.mJobsScrollContainer);
         }
      }
      
      private function getContainerLayout() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.horizontalAlign = HorizontalAlign.CENTER;
         return _loc1_;
      }
      
      private function createBGImage() : void
      {
         this.mBG = new FSImage(Root.assets.getTexture("db_side_panel"));
         this.mBG.x = 0;
         this.mBG.y = 0;
         addChild(this.mBG);
      }
      
      private function performOpeningFX() : void
      {
         x -= this.mBG.width;
         SpecialFX.createTransition(this,new FSCoordinate(0,0),0.5,0,this.refreshSelectedIndexSlot);
      }
      
      public function unload(param1:Boolean = false) : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(param1);
            this.mBG = null;
         }
         if(this.mJobsScrollContainer)
         {
            this.cleanScrollContainer(this.mJobsScrollContainer);
            this.mJobsScrollContainer.removeFromParent(param1);
            this.mJobsScrollContainer = null;
         }
         if(this.mSelectedSlot)
         {
            this.mSelectedSlot.removeFromParent(param1);
            this.mSelectedSlot.destroy();
            this.mSelectedSlot = null;
         }
         if(this.mJobSelectedInfo)
         {
            this.mJobSelectedInfo.unloadAllSkins();
            this.mJobSelectedInfo.removeFromParent(param1);
            this.mJobSelectedInfo.destroy();
            this.mJobSelectedInfo = null;
         }
         if(this.mSelectJobButton)
         {
            this.mSelectJobButton.removeFromParent(param1);
            this.mSelectJobButton.destroy();
            this.mSelectJobButton = null;
         }
      }
      
      public function cleanScrollContainer(param1:ScrollContainer, param2:Function = null) : void
      {
         var _loc3_:Component = null;
         var _loc4_:int = 0;
         var _loc5_:Number = 0.25;
         if(Boolean(param1) && param1.numChildren > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.numChildren)
            {
               _loc3_ = Component(param1.getChildAt(_loc4_));
               if(_loc3_ != null)
               {
                  SpecialFX.tweenToAlpha(_loc3_,0.001,_loc5_,0,this.removeComponentFromParent,[_loc3_]);
               }
               _loc4_++;
            }
         }
         if(param2 != null)
         {
            TweenMax.delayedCall(_loc5_ + 0.25,param2);
         }
      }
      
      private function removeComponentFromParent(param1:Component) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      public function getDeckJobConf() : DeckJobConfigurator
      {
         return this.mDeckJobConf;
      }
      
      public function updateInfoText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSJobSlot = null;
         if(this.mJobsScrollContainer)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mJobsScrollContainer.numChildren)
            {
               _loc2_ = this.mJobsScrollContainer.getChildAt(_loc1_) as FSJobSlot;
               if(_loc2_)
               {
                  _loc2_.updateInfoText();
               }
               _loc1_++;
            }
         }
      }
      
      public function updateJobSkinAfterBuy() : void
      {
         if(this.mJobSelectedInfo)
         {
            this.mJobSelectedInfo.updateJobSkinAfterBuy();
         }
      }
      
      public function updateSelectedJobSkin() : void
      {
         if(this.mJobSelectedInfo)
         {
            this.mJobSelectedInfo.updateSelectedSkin();
         }
      }
      
      public function switchSelectButtonStateToBuy(param1:int) : void
      {
         var _loc2_:Texture = Root.assets.getTexture("buy_gold_button");
         this.mSelectJobButton.upState = _loc2_;
         this.mSelectJobButton.downState = _loc2_;
         this.mSelectJobButton.overState = _loc2_;
         this.mSelectJobButton.disabledState = _loc2_;
         this.mSelectJobButton.text = param1 > 0 ? param1.toString() : TextManager.getText("TID_GEN_FREE");
         this.mSelectJobButton.removeEventListener(Event.TRIGGERED,this.onJobSelectTriggered);
         this.mSelectJobButton.addEventListener(Event.TRIGGERED,this.onJobBuyTriggered);
      }
      
      public function switchSelectButtonStateToSelect() : void
      {
         var _loc1_:Texture = Root.assets.getTexture("job_button_lit");
         this.mSelectJobButton.upState = _loc1_;
         this.mSelectJobButton.downState = _loc1_;
         this.mSelectJobButton.overState = _loc1_;
         this.mSelectJobButton.disabledState = _loc1_;
         this.mSelectJobButton.text = TextManager.getText("TID_GEN_SELECT");
         this.mSelectJobButton.removeEventListener(Event.TRIGGERED,this.onJobBuyTriggered);
         this.mSelectJobButton.addEventListener(Event.TRIGGERED,this.onJobSelectTriggered);
      }
      
      public function setTouchable() : void
      {
         touchable = true;
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mJobsScrollContainer)
         {
            this.mJobsScrollContainer.removeChildren();
            this.mJobsScrollContainer.removeFromParent(true);
            this.mJobsScrollContainer = null;
         }
         if(this.mSelectedSlot)
         {
            this.mSelectedSlot.removeFromParent(true);
            this.mSelectedSlot = null;
         }
         if(this.mJobSelectedInfo)
         {
            this.mJobSelectedInfo.removeFromParent(true);
            this.mJobSelectedInfo = null;
         }
         if(this.mSelectJobButton)
         {
            this.mSelectJobButton.removeFromParent(true);
            this.mSelectJobButton = null;
         }
         if(this.mDeckTitleDeckBuilder)
         {
            this.mDeckTitleDeckBuilder.removeFromParent(true);
            this.mDeckTitleDeckBuilder = null;
         }
         this.mDeckJobConf = null;
         super.dispose();
      }
   }
}

