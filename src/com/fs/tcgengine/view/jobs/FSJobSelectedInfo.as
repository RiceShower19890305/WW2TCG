package com.fs.tcgengine.view.jobs
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.PassiveAbilityDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSGaugeProgressBar;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.JobPanel;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.Direction;
   import feathers.layout.TiledRowsLayout;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.deg2rad;
   
   public class FSJobSelectedInfo extends Component implements FSModelUnloadableInterface
   {
      
      private static const SKILLS_SELECTED_BUTTON:int = 0;
      
      private static const SKINS_SELECTED_BUTTON:int = 1;
      
      private var mJobDef:JobDef;
      
      private var mWidth:int;
      
      private var mHeight:int;
      
      private var mParentPanel:JobPanel;
      
      private var mName:FSTextfield;
      
      private var mJobImage:FSImage;
      
      private var mLevelText:FSTextfield;
      
      private var mPassiveSlot:FSJobAbilitySlot;
      
      private var mActiveDefaultSlot:FSJobAbilitySlot;
      
      private var mActiveSecondary:FSJobAbilitySlot;
      
      private var mActiveAbilitySelectedSku:String;
      
      private var mExpProgressBar:FSGaugeProgressBar;
      
      private var mSkillsButton:FSImage;
      
      private var mSkinsButton:FSImage;
      
      private var mSelected:int = 0;
      
      private var mSkillsTextfieldButton:FSTextfield;
      
      private var mSkinsTextfieldButton:FSTextfield;
      
      private var mJobSkinsScrollContainer:ScrollContainer;
      
      private var mJobLockedMc:MovieClip;
      
      private var mSkinPrevPageButton:FSButton;
      
      private var mSkinNextPageButton:FSButton;
      
      private var mSelectedSkinSku:String;
      
      public function FSJobSelectedInfo(param1:JobDef, param2:JobPanel)
      {
         this.mJobDef = param1;
         this.mParentPanel = param2;
         super();
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createPassiveSlot();
         this.createName();
         this.loadJobImage();
      }
      
      private function loadJobImage() : void
      {
         var _loc1_:String = null;
         var _loc2_:HeroCharacterDef = null;
         if(this.mJobDef)
         {
            _loc1_ = Boolean(this.mParentPanel) && Boolean(this.mParentPanel.getDeckJobConf()) && Boolean(this.mParentPanel.getDeckJobConf().getSkinSku()) ? this.mParentPanel.getDeckJobConf().getSkinSku() : this.mJobDef.getDefaultSkinSku();
            _loc2_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc1_));
            if(_loc2_)
            {
               InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc2_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
            }
            InstanceMng.getResourcesMng().loadAssets(this.onCurrentJobImageLoaded);
         }
      }
      
      private function onCurrentJobImageLoaded() : void
      {
         this.createJobImage();
         if(JobsMng.getJobState(this.mJobDef) == JobsMng.STATE_UNLOCKED)
         {
            this.createExpProgressBar();
         }
         this.createLevelTextfield();
         this.createJobLockMc();
         this.createSkillsButton();
         this.createSkillsTextfieldButton();
         this.createSkinsButton();
         this.createSkinsTextfieldButton();
         this.createSkillsItems();
         this.createSkinsItems();
         this.createSkinsPageButtons();
         this.showSkillsItems();
      }
      
      private function createSkinsPageButtons() : void
      {
         this.createSkinPrevPageButton();
         this.createSkinNextPageButton();
      }
      
      private function createSkinNextPageButton() : void
      {
         if(this.mSkinNextPageButton == null)
         {
            this.mSkinNextPageButton = new FSButton(Root.assets.getTexture("scroll_side_icon"));
            this.mSkinNextPageButton.addEventListener(TouchEvent.TOUCH,this.onSkinNextPageTouch);
            this.mSkinNextPageButton.rotation = deg2rad(90);
         }
      }
      
      private function onSkinNextPageTouch(param1:TouchEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Touch = param1.getTouch(this.mSkinNextPageButton,TouchPhase.ENDED);
         if(_loc2_)
         {
            _loc3_ = this.mJobSkinsScrollContainer.verticalPageIndex;
            if(_loc3_ + 1 < this.mJobSkinsScrollContainer.verticalPageCount)
            {
               _loc3_ += 1;
            }
            this.mJobSkinsScrollContainer.scrollToPageIndex(0,_loc3_,0.5);
         }
      }
      
      private function createSkinPrevPageButton() : void
      {
         if(this.mSkinPrevPageButton == null)
         {
            this.mSkinPrevPageButton = new FSButton(Root.assets.getTexture("scroll_side_icon"));
            this.mSkinPrevPageButton.addEventListener(TouchEvent.TOUCH,this.onSkinPrevPageTouch);
            this.mSkinPrevPageButton.rotation = deg2rad(-90);
         }
      }
      
      private function onSkinPrevPageTouch(param1:TouchEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Touch = param1.getTouch(this.mSkinPrevPageButton,TouchPhase.ENDED);
         if(_loc2_)
         {
            _loc3_ = this.mJobSkinsScrollContainer.verticalPageIndex;
            if(_loc3_ - 1 >= 0)
            {
               _loc3_--;
            }
            this.mJobSkinsScrollContainer.scrollToPageIndex(0,_loc3_,0.5);
         }
      }
      
      private function createJobLockMc() : void
      {
         if(!JobsMng.isJobAvailable(this.mJobDef))
         {
            if(Boolean(this.mJobImage) && this.mJobLockedMc == null)
            {
               this.mJobLockedMc = new MovieClip(Root.assets.getTextures("lock_anim"),15);
               this.mJobLockedMc.scale = 2;
               this.mJobLockedMc.touchable = false;
               this.mJobLockedMc.alignPivot();
               this.mJobLockedMc.loop = false;
               this.mJobLockedMc.x = this.mJobImage.x + this.mJobImage.width / 2;
               this.mJobLockedMc.y = this.mJobImage.y + this.mJobImage.height / 2;
               addChild(this.mJobLockedMc);
               Starling.juggler.add(this.mJobLockedMc);
               this.mJobLockedMc.pause();
            }
         }
      }
      
      public function removeJobLockImage() : void
      {
         if(this.mJobLockedMc)
         {
            this.mJobLockedMc.play();
            this.mJobLockedMc.addEventListener(Event.COMPLETE,this.onJobLockMCEnd);
         }
      }
      
      private function onJobLockMCEnd(param1:Event) : void
      {
         if(this.mJobLockedMc)
         {
            this.mJobLockedMc.stop();
            Starling.juggler.remove(this.mJobLockedMc);
            this.mJobLockedMc.removeFromParent();
            this.mJobLockedMc = null;
         }
      }
      
      private function lockUI(param1:Boolean) : void
      {
         if(this.mJobSkinsScrollContainer)
         {
            this.mJobSkinsScrollContainer.touchable = !param1;
         }
         if(this.mSkillsButton)
         {
            this.mSkillsButton.touchable = !param1;
         }
         if(this.mSkinsButton)
         {
            this.mSkinsButton.touchable = !param1;
         }
         if(this.mParentPanel)
         {
            this.mParentPanel.touchable = !param1;
         }
         if(this.mActiveDefaultSlot)
         {
            this.mActiveDefaultSlot.touchable = !param1;
         }
         if(this.mActiveSecondary)
         {
            this.mActiveSecondary.touchable = !param1;
         }
      }
      
      private function createSkinsTextfieldButton() : void
      {
         if(Boolean(this.mSkinsButton) && this.mSkinsTextfieldButton == null)
         {
            this.mSkinsTextfieldButton = new FSTextfield(this.mSkinsButton.width,this.mSkinsButton.height,TextManager.getText("TID_GEN_SKINS"));
            this.mSkinsTextfieldButton.x = this.mSkinsButton.x;
            this.mSkinsTextfieldButton.y = this.mSkinsButton.y;
            addChild(this.mSkinsTextfieldButton);
         }
      }
      
      private function createSkillsTextfieldButton() : void
      {
         if(Boolean(this.mSkillsButton) && this.mSkillsTextfieldButton == null)
         {
            this.mSkillsTextfieldButton = new FSTextfield(this.mSkillsButton.width,this.mSkillsButton.height,TextManager.getText("TID_JOBS_SKILLS"));
            this.mSkillsTextfieldButton.x = this.mSkillsButton.x;
            this.mSkillsTextfieldButton.y = this.mSkillsButton.y;
            addChild(this.mSkillsTextfieldButton);
         }
      }
      
      private function createSkinsButton() : void
      {
         if(Boolean(this.mJobImage) && this.mSkinsButton == null)
         {
            this.mSkinsButton = new FSImage(Root.assets.getTexture("job_layer_small_off"));
            this.mSkinsButton.x = this.mJobImage.x + this.mJobImage.width / 2;
            this.mSkinsButton.y = this.mJobImage.y + this.mJobImage.height + this.mSkinsButton.height * 0.1;
            this.mSkinsButton.addEventListener(TouchEvent.TOUCH,this.onSkinsButtonTouch);
            addChild(this.mSkinsButton);
         }
      }
      
      private function createSkillsButton() : void
      {
         if(Boolean(this.mJobImage) && this.mSkillsButton == null)
         {
            this.mSkillsButton = new FSImage(Root.assets.getTexture("job_layer_small_on"));
            this.mSkillsButton.x = this.mJobImage.x + this.mJobImage.width / 2 - this.mSkillsButton.width;
            this.mSkillsButton.y = this.mJobImage.y + this.mJobImage.height + this.mSkillsButton.height * 0.1;
            this.mSkillsButton.addEventListener(TouchEvent.TOUCH,this.onSkillsButtonTouch);
            addChild(this.mSkillsButton);
         }
      }
      
      private function onSkillsButtonTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mSkillsButton,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(this.getSelectedButton() == SKINS_SELECTED_BUTTON)
            {
               this.selectedButton(SKILLS_SELECTED_BUTTON);
            }
         }
      }
      
      private function onSkinsButtonTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mSkinsButton,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(this.getSelectedButton() == SKILLS_SELECTED_BUTTON)
            {
               this.selectedButton(SKINS_SELECTED_BUTTON);
            }
         }
      }
      
      private function getSelectedButton() : int
      {
         return this.mSelected;
      }
      
      private function createExpProgressBar() : void
      {
         if(Boolean(this.mJobImage) && this.mExpProgressBar == null)
         {
            this.mExpProgressBar = new FSGaugeProgressBar();
            this.mExpProgressBar.setRatio(JobsMng.getPercentageExpCurrentLevel(this.mJobDef));
            this.mExpProgressBar.x = this.mJobImage.x + this.mJobImage.width / 2 - this.mExpProgressBar.width / 2;
            this.mExpProgressBar.y = this.mJobImage.y + this.mJobImage.height - this.mExpProgressBar.height;
            addChild(this.mExpProgressBar);
         }
      }
      
      private function createActiveSecondarySlot() : void
      {
         var _loc1_:PowerDef = null;
         var _loc2_:String = null;
         var _loc3_:UserData = null;
         if(Boolean(this.mJobDef) && Boolean(this.mActiveDefaultSlot) && this.mActiveSecondary == null)
         {
            _loc1_ = PowerDef(InstanceMng.getPowerDefMng().getDefBySku(this.mJobDef.getActiveSecondarySku()));
            if(_loc1_)
            {
               this.mActiveSecondary = new FSJobAbilitySlot(_loc1_.getAbilities()[0],_loc1_.getSku(),this,true);
               _loc2_ = Boolean(this.mParentPanel) && Boolean(this.mParentPanel.getDeckJobConf()) && this.mParentPanel.getDeckJobConf().getJobSku() == this.mJobDef.getSku() ? this.mParentPanel.getDeckJobConf().getActiveAbilitySku() : "";
               if(_loc2_ == _loc1_.getSku())
               {
                  this.mActiveSecondary.createSelectedEffect();
                  this.mActiveAbilitySelectedSku = _loc1_.getSku();
                  _loc3_ = Utils.getOwnerUserData();
                  _loc3_.updateDeckPower(this.mActiveAbilitySelectedSku,_loc3_.getSelectedDeckIndex());
               }
            }
         }
      }
      
      private function createActiveDefaultSlot() : void
      {
         var _loc1_:PowerDef = null;
         var _loc2_:String = null;
         if(Boolean(this.mJobDef) && Boolean(this.mPassiveSlot) && this.mActiveDefaultSlot == null)
         {
            _loc1_ = PowerDef(InstanceMng.getPowerDefMng().getDefBySku(this.mJobDef.getActiveDefaultSku()));
            if(_loc1_)
            {
               this.mActiveDefaultSlot = new FSJobAbilitySlot(_loc1_.getAbilities()[0],_loc1_.getSku(),this);
               _loc2_ = Boolean(this.mParentPanel != null) && Boolean(this.mParentPanel.getDeckJobConf()) && this.mParentPanel.getDeckJobConf().getJobSku() == this.mJobDef.getSku() ? this.mParentPanel.getDeckJobConf().getActiveAbilitySku() : "";
               if(_loc2_ == _loc1_.getSku() || _loc2_ == null || _loc2_ == "")
               {
                  this.mActiveDefaultSlot.createSelectedEffect();
                  this.mActiveAbilitySelectedSku = _loc1_.getSku();
               }
            }
         }
      }
      
      private function addPassiveSlot() : void
      {
         if(Boolean(this.mJobImage) && Boolean(this.mPassiveSlot))
         {
            this.mPassiveSlot.x = this.mName.x + this.mName.width / 2 - this.mPassiveSlot.width / 2;
            this.mPassiveSlot.y = this.mSkillsButton.y + this.mSkillsButton.height;
            addChild(this.mPassiveSlot);
         }
      }
      
      private function addActiveDefaultSlot() : void
      {
         if(Boolean(this.mPassiveSlot) && Boolean(this.mActiveDefaultSlot))
         {
            this.mActiveDefaultSlot.x = this.mPassiveSlot.x;
            this.mActiveDefaultSlot.y = this.mPassiveSlot.y + this.mPassiveSlot.height;
            addChild(this.mActiveDefaultSlot);
         }
      }
      
      private function addActiveSecondarySlot() : void
      {
         if(Boolean(this.mActiveDefaultSlot) && Boolean(this.mActiveSecondary))
         {
            this.mActiveSecondary.x = this.mActiveDefaultSlot.x;
            this.mActiveSecondary.y = this.mActiveDefaultSlot.y + this.mActiveDefaultSlot.height;
            addChild(this.mActiveSecondary);
         }
      }
      
      private function createLevelTextfield() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mJobDef) && Boolean(this.mJobImage) && this.mLevelText == null)
         {
            _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_GEN_CHAR_LEVEL"),[JobsMng.getJobLevel(this.mJobDef)]);
            this.mLevelText = new FSTextfield(this.mJobImage.width,this.mJobImage.height / 3,_loc1_);
            this.mLevelText.x = this.mJobImage.x;
            this.mLevelText.y = this.mJobImage.y + this.mJobImage.height - this.mLevelText.height;
            addChild(this.mLevelText);
         }
      }
      
      private function createJobImage() : void
      {
         var _loc1_:String = null;
         var _loc2_:HeroCharacterDef = null;
         if(Boolean(this.mJobDef) && Boolean(this.mName) && this.mJobImage == null)
         {
            _loc1_ = Boolean(this.mParentPanel) && Boolean(this.mParentPanel.getDeckJobConf()) && Boolean(this.mParentPanel.getDeckJobConf().getSkinSku()) ? this.mParentPanel.getDeckJobConf().getSkinSku() : this.mJobDef.getDefaultSkinSku();
            _loc2_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc1_));
            if(_loc2_)
            {
               this.mJobImage = new FSImage(Root.assets.getTexture(_loc2_.getBGImageName()));
               this.mJobImage.touchable = true;
               this.mJobImage.setTooltipText(TextManager.getText("TID_JOBS_XP_INFO"));
               this.mJobImage.addEventListener(TouchEvent.TOUCH,this.onJobImageTouch);
               this.mJobImage.x = this.mName.x + this.mName.width / 2 - this.mJobImage.width / 2;
               this.mJobImage.y = this.mName.y + this.mName.height;
               addChild(this.mJobImage);
               this.mSelectedSkinSku = _loc1_;
            }
         }
      }
      
      private function onJobImageTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mJobImage);
         if(_loc2_)
         {
            this.mJobImage.showTooltip();
         }
         else
         {
            this.mJobImage.closeTooltip();
         }
      }
      
      private function createName() : void
      {
         if(Boolean(this.mJobDef) && Boolean(this.mName == null) && Boolean(this.mPassiveSlot))
         {
            this.mName = new FSTextfield(this.mWidth / 2,this.mHeight,this.mJobDef.getName(),16777215,FSResourceMng.FONT_STD_BIG_TITLE_SIZE);
            this.mName.x = this.mParentPanel != null ? this.mParentPanel.x + this.mParentPanel.width + (Starling.current.stage.stageWidth - (this.mParentPanel.x + this.mParentPanel.width)) / 2 - this.mName.width / 2 : 0;
            addChild(this.mName);
         }
      }
      
      private function createPassiveSlot() : void
      {
         var _loc1_:PassiveAbilityDef = null;
         if(Boolean(this.mJobDef) && this.mPassiveSlot == null)
         {
            _loc1_ = PassiveAbilityDef(InstanceMng.getPassiveAbilityDefMng().getDefBySku(this.mJobDef.getPassiveSku()));
            this.mPassiveSlot = new FSJobAbilitySlot(_loc1_.getAbilitiesSkus()[0],"",this,false,true);
            this.mWidth = this.mPassiveSlot.width;
            this.mHeight = this.mPassiveSlot.height;
         }
      }
      
      public function getActiveAbilitySelectedSku() : String
      {
         return this.mActiveAbilitySelectedSku;
      }
      
      override public function dispose() : void
      {
         var _loc1_:String = null;
         var _loc2_:HeroCharacterDef = null;
         if(this.mName)
         {
            this.mName.removeFromParent(true);
            this.mName = null;
         }
         if(this.mJobDef)
         {
            _loc1_ = Boolean(this.mParentPanel) && Boolean(this.mParentPanel.getDeckJobConf()) && Boolean(this.mParentPanel.getDeckJobConf().getSkinSku()) ? this.mParentPanel.getDeckJobConf().getSkinSku() : this.mJobDef.getDefaultSkinSku();
            _loc2_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc1_));
            if(_loc2_)
            {
               Root.assets.removeTexture(_loc2_.getBGImageName());
            }
         }
         if(this.mJobImage)
         {
            this.mJobImage.removeEventListener(TouchEvent.TOUCH,this.onJobImageTouch);
            this.mJobImage.removeFromParent();
            this.mJobImage.destroy();
            this.mJobImage = null;
         }
         if(this.mLevelText)
         {
            this.mLevelText.removeFromParent(true);
            this.mLevelText = null;
         }
         if(this.mPassiveSlot)
         {
            this.mPassiveSlot.removeFromParent(true);
            this.mPassiveSlot = null;
         }
         if(this.mActiveDefaultSlot)
         {
            this.mActiveDefaultSlot.removeFromParent(true);
            this.mActiveDefaultSlot = null;
         }
         if(this.mActiveSecondary)
         {
            this.mActiveSecondary.removeFromParent(true);
            this.mActiveSecondary = null;
         }
         if(this.mExpProgressBar)
         {
            this.mExpProgressBar.removeFromParent(true);
            this.mExpProgressBar = null;
         }
         if(this.mSkillsButton)
         {
            this.mSkillsButton.removeEventListener(TouchEvent.TOUCH,this.onSkillsButtonTouch);
            this.mSkillsButton.removeFromParent();
            this.mSkillsButton.destroy();
            this.mSkillsButton = null;
         }
         if(this.mSkinsButton)
         {
            this.mSkinsButton.removeEventListener(TouchEvent.TOUCH,this.onSkinsButtonTouch);
            this.mSkinsButton.removeFromParent();
            this.mSkinsButton.destroy();
            this.mSkinsButton = null;
         }
         if(this.mSkillsTextfieldButton)
         {
            this.mSkillsTextfieldButton.removeFromParent();
            this.mSkillsTextfieldButton = null;
         }
         if(this.mSkinsTextfieldButton)
         {
            this.mSkinsTextfieldButton.removeFromParent();
            this.mSkinsTextfieldButton = null;
         }
         this.cleanScrollContainer(this.mJobSkinsScrollContainer);
         if(this.mJobSkinsScrollContainer)
         {
            this.mJobSkinsScrollContainer.removeFromParent();
            this.mJobSkinsScrollContainer = null;
         }
         if(this.mJobLockedMc)
         {
            this.mJobLockedMc.stop();
            Starling.juggler.remove(this.mJobLockedMc);
            this.mJobLockedMc.removeEventListener(Event.COMPLETE,this.onJobLockMCEnd);
            this.mJobLockedMc.removeFromParent();
            this.mJobLockedMc = null;
         }
         if(this.mSkinPrevPageButton)
         {
            this.mSkinPrevPageButton.removeEventListener(TouchEvent.TOUCH,this.onSkinPrevPageTouch);
            this.mSkinPrevPageButton.removeFromParent();
            this.mSkinPrevPageButton.destroy();
            this.mSkinPrevPageButton = null;
         }
         if(this.mSkinNextPageButton)
         {
            this.mSkinNextPageButton.removeEventListener(TouchEvent.TOUCH,this.onSkinNextPageTouch);
            this.mSkinNextPageButton.removeFromParent();
            this.mSkinNextPageButton.destroy();
            this.mSkinNextPageButton = null;
         }
         this.mJobDef = null;
         this.mParentPanel = null;
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mName)
         {
            this.mName.removeFromParent();
            this.mName = null;
         }
         if(this.mJobImage)
         {
            this.mJobImage.removeEventListener(TouchEvent.TOUCH,this.onJobImageTouch);
            this.mJobImage.removeFromParent();
            this.mJobImage.destroy();
            this.mJobImage = null;
         }
         if(this.mLevelText)
         {
            this.mLevelText.removeFromParent();
            this.mLevelText = null;
         }
         if(this.mPassiveSlot)
         {
            this.mPassiveSlot.removeFromParent();
            this.mPassiveSlot = null;
         }
         if(this.mActiveDefaultSlot)
         {
            this.mActiveDefaultSlot.removeFromParent();
            this.mActiveDefaultSlot = null;
         }
         if(this.mActiveSecondary)
         {
            this.mActiveSecondary.removeFromParent();
            this.mActiveSecondary = null;
         }
         if(this.mExpProgressBar)
         {
            this.mExpProgressBar.removeFromParent();
            this.mExpProgressBar = null;
         }
         if(this.mSkillsButton)
         {
            this.mSkillsButton.removeEventListener(TouchEvent.TOUCH,this.onSkillsButtonTouch);
            this.mSkillsButton.removeFromParent();
            this.mSkillsButton = null;
         }
         if(this.mSkinsButton)
         {
            this.mSkinsButton.removeEventListener(TouchEvent.TOUCH,this.onSkinsButtonTouch);
            this.mSkinsButton.removeFromParent();
            this.mSkinsButton = null;
         }
         if(this.mSkillsTextfieldButton)
         {
            this.mSkillsTextfieldButton.removeFromParent();
            this.mSkillsTextfieldButton = null;
         }
         if(this.mSkinsTextfieldButton)
         {
            this.mSkinsTextfieldButton.removeFromParent();
            this.mSkinsTextfieldButton = null;
         }
         if(this.mJobSkinsScrollContainer)
         {
            this.mJobSkinsScrollContainer.removeFromParent();
            this.mJobSkinsScrollContainer = null;
         }
         if(this.mJobLockedMc)
         {
            this.mJobLockedMc.stop();
            Starling.juggler.remove(this.mJobLockedMc);
            this.mJobLockedMc.removeEventListener(Event.COMPLETE,this.onJobLockMCEnd);
            this.mJobLockedMc.removeFromParent();
            this.mJobLockedMc = null;
         }
         if(this.mSkinPrevPageButton)
         {
            this.mSkinPrevPageButton.removeEventListener(TouchEvent.TOUCH,this.onSkinPrevPageTouch);
            this.mSkinPrevPageButton.removeFromParent();
            this.mSkinPrevPageButton = null;
         }
         if(this.mSkinNextPageButton)
         {
            this.mSkinNextPageButton.removeEventListener(TouchEvent.TOUCH,this.onSkinNextPageTouch);
            this.mSkinNextPageButton.removeFromParent();
            this.mSkinNextPageButton = null;
         }
         this.mParentPanel = null;
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
      
      public function setSelectedActiveAbility(param1:String) : void
      {
         this.mActiveAbilitySelectedSku = param1;
      }
      
      public function refreshSelectedActiveAbility() : void
      {
         if(Boolean(this.mActiveAbilitySelectedSku) && this.mActiveAbilitySelectedSku != "")
         {
            if(this.mActiveAbilitySelectedSku == this.mActiveDefaultSlot.getPowerSku())
            {
               this.mActiveDefaultSlot.createSelectedEffect();
               this.mActiveSecondary.removeSelectedEffect();
            }
            else if(this.mActiveAbilitySelectedSku == this.mActiveSecondary.getPowerSku())
            {
               this.mActiveDefaultSlot.removeSelectedEffect();
               this.mActiveSecondary.createSelectedEffect();
            }
         }
      }
      
      public function getSelectedSkin() : String
      {
         return this.mSelectedSkinSku;
      }
      
      private function selectedButton(param1:int) : void
      {
         switch(param1)
         {
            case SKILLS_SELECTED_BUTTON:
               this.mSelected = SKILLS_SELECTED_BUTTON;
               if(this.mSkillsButton)
               {
                  this.mSkillsButton.texture = Root.assets.getTexture("job_layer_small_on");
               }
               if(this.mSkinsButton)
               {
                  this.mSkinsButton.texture = Root.assets.getTexture("job_layer_small_off");
               }
               this.hideSkinsItems();
               this.showSkillsItems();
               break;
            case SKINS_SELECTED_BUTTON:
               this.mSelected = SKINS_SELECTED_BUTTON;
               if(this.mSkillsButton)
               {
                  this.mSkillsButton.texture = Root.assets.getTexture("job_layer_small_off");
               }
               if(this.mSkinsButton)
               {
                  this.mSkinsButton.texture = Root.assets.getTexture("job_layer_small_on");
               }
               this.hideSkillsItems();
               this.showSkinsItems();
         }
      }
      
      private function hideSkinsItems() : void
      {
         if(this.mSkinPrevPageButton)
         {
            this.mSkinPrevPageButton.removeFromParent();
         }
         if(this.mSkinNextPageButton)
         {
            this.mSkinNextPageButton.removeFromParent();
         }
         if(this.mJobSkinsScrollContainer)
         {
            this.mJobSkinsScrollContainer.removeFromParent();
         }
      }
      
      private function showSkinsItems() : void
      {
         if(this.mSkinPrevPageButton)
         {
            this.mSkinPrevPageButton.x = this.mSkillsButton.x + this.mSkillsButton.width;
            this.mSkinPrevPageButton.y = this.mSkillsButton.y + this.mSkillsButton.height * 1.1;
            addChild(this.mSkinPrevPageButton);
         }
         if(Boolean(this.mSkinPrevPageButton) && Boolean(this.mJobSkinsScrollContainer))
         {
            this.mJobSkinsScrollContainer.x = this.mSkillsButton.x - this.mJobSkinsScrollContainer.width * 0.1;
            this.mJobSkinsScrollContainer.y = this.mSkinPrevPageButton.y + this.mSkinPrevPageButton.height * 0.5;
            addChild(this.mJobSkinsScrollContainer);
         }
         if(this.mSkinNextPageButton)
         {
            this.mSkinNextPageButton.x = this.mSkillsButton.x + this.mSkillsButton.width;
            this.mSkinNextPageButton.y = this.mJobSkinsScrollContainer.y + this.mJobSkinsScrollContainer.height * 1.1;
            addChild(this.mSkinNextPageButton);
         }
      }
      
      private function createSkinsItems() : void
      {
         this.createJobSkinScrollContainer();
         this.addJobSkinsToScrollContainer();
      }
      
      private function addJobSkinsToScrollContainer() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:JobSkinSlot = null;
         var _loc4_:String = null;
         if(this.mJobSkinsScrollContainer)
         {
            _loc1_ = JobsMng.getJobSkinSkusArray(this.mJobDef);
            if(Boolean(_loc1_) && _loc1_.length > 0)
            {
               _loc4_ = Boolean(this.mParentPanel) && Boolean(this.mParentPanel.getDeckJobConf()) && Boolean(this.mParentPanel.getDeckJobConf().getSkinSku()) ? this.mParentPanel.getDeckJobConf().getSkinSku() : this.mJobDef.getDefaultSkinSku();
               _loc2_ = 0;
               while(_loc2_ < _loc1_.length)
               {
                  _loc3_ = new JobSkinSlot(this.mJobDef,_loc1_[_loc2_],this,_loc4_ == _loc1_[_loc2_]);
                  this.mJobSkinsScrollContainer.addChild(_loc3_);
                  _loc2_++;
               }
               InstanceMng.getResourcesMng().loadAssets(this.onJobSelectedInfoAssetsLoaded);
               this.mJobSkinsScrollContainer.sortChildren(DictionaryUtils.sortSlotJobSkinByIndex);
            }
         }
      }
      
      private function onJobSelectedInfoAssetsLoaded() : void
      {
         var _loc1_:int = 0;
         var _loc2_:JobSkinSlot = null;
         if(this.mJobSkinsScrollContainer)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mJobSkinsScrollContainer.numChildren)
            {
               _loc2_ = JobSkinSlot(this.mJobSkinsScrollContainer.getChildAt(_loc1_));
               if(_loc2_)
               {
                  _loc2_.onCurrentJobImageLoaded();
               }
               _loc1_++;
            }
            this.mJobSkinsScrollContainer.validate();
            this.mJobSkinsScrollContainer.pageWidth = _loc2_ ? _loc2_.width * 3 : this.mJobSkinsScrollContainer.width;
            this.mJobSkinsScrollContainer.pageHeight = this.mJobSkinsScrollContainer.height;
         }
         if(this.mParentPanel)
         {
            this.mParentPanel.setTouchable();
         }
      }
      
      private function createJobSkinScrollContainer() : void
      {
         if(this.mJobSkinsScrollContainer == null)
         {
            this.mJobSkinsScrollContainer = new ScrollContainer();
            this.mJobSkinsScrollContainer.layout = this.getContainerRowLayout();
            this.mJobSkinsScrollContainer.snapToPages = true;
            this.mJobSkinsScrollContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mJobSkinsScrollContainer.verticalScrollPolicy = ScrollPolicy.ON;
         }
      }
      
      private function getContainerRowLayout() : TiledRowsLayout
      {
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.requestedColumnCount = 3;
         _loc1_.requestedRowCount = 1;
         _loc1_.horizontalGap = Utils.isAndroidOrDesktop() || Utils.isBrowser() ? -40 : -75;
         _loc1_.paging = Direction.VERTICAL;
         return _loc1_;
      }
      
      private function showSkillsItems() : void
      {
         this.addPassiveSlot();
         this.addActiveDefaultSlot();
         this.addActiveSecondarySlot();
      }
      
      private function hideSkillsItems() : void
      {
         if(this.mPassiveSlot)
         {
            this.mPassiveSlot.removeFromParent();
         }
         if(this.mActiveDefaultSlot)
         {
            this.mActiveDefaultSlot.removeFromParent();
         }
         if(this.mActiveSecondary)
         {
            this.mActiveSecondary.removeFromParent();
         }
      }
      
      private function createSkillsItems() : void
      {
         this.createActiveDefaultSlot();
         this.createActiveSecondarySlot();
      }
      
      public function getJobDef() : JobDef
      {
         return this.mJobDef;
      }
      
      public function updateJobSkinAfterBuy() : void
      {
         var _loc1_:int = 0;
         var _loc2_:JobSkinSlot = null;
         if(this.mJobSkinsScrollContainer)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mJobSkinsScrollContainer.numChildren)
            {
               _loc2_ = this.mJobSkinsScrollContainer.getChildAt(_loc1_) as JobSkinSlot;
               if(_loc2_)
               {
                  _loc2_.updateJobSkinAfterBuy();
               }
               _loc1_++;
            }
         }
      }
      
      public function setSelectedSkin(param1:String) : void
      {
         this.mSelectedSkinSku = param1;
      }
      
      public function updateSelectedSkin() : void
      {
         var _loc1_:int = 0;
         var _loc2_:JobSkinSlot = null;
         if(this.mJobSkinsScrollContainer)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mJobSkinsScrollContainer.numChildren)
            {
               _loc2_ = this.mJobSkinsScrollContainer.getChildAt(_loc1_) as JobSkinSlot;
               if(_loc2_)
               {
                  _loc2_.updateSelectedSkin();
               }
               _loc1_++;
            }
         }
         this.loadNewJobImage();
      }
      
      private function loadNewJobImage() : void
      {
         var _loc1_:HeroCharacterDef = null;
         if(Boolean(this.mSelectedSkinSku) && this.mSelectedSkinSku != "")
         {
            _loc1_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mSelectedSkinSku));
            if(_loc1_)
            {
               InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc1_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
            }
         }
         InstanceMng.getResourcesMng().loadAssets(this.onNewJobImageLoaded);
      }
      
      private function onNewJobImageLoaded() : void
      {
         var _loc1_:HeroCharacterDef = null;
         if(this.mJobImage)
         {
            _loc1_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mSelectedSkinSku));
            this.mJobImage.texture = Root.assets.getTexture(_loc1_.getBGImageName());
            this.mJobImage.alpha = 0.0001;
            SpecialFX.tweenToAlpha(this.mJobImage,0.999,0.25,0);
         }
      }
      
      public function unloadCurrentSkin() : void
      {
         var _loc1_:String = null;
         var _loc2_:HeroCharacterDef = null;
         if(this.mJobDef)
         {
            _loc1_ = Boolean(this.mParentPanel) && Boolean(this.mParentPanel.getDeckJobConf()) && Boolean(this.mParentPanel.getDeckJobConf().getSkinSku()) ? this.mParentPanel.getDeckJobConf().getSkinSku() : this.mJobDef.getDefaultSkinSku();
            _loc2_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc1_));
            if(_loc2_)
            {
               Root.assets.removeTexture(_loc2_.getBGImageName());
            }
         }
      }
      
      public function unloadAllSkins() : void
      {
         var _loc1_:int = 0;
         var _loc2_:JobSkinSlot = null;
         var _loc3_:HeroCharacterDef = null;
         if(this.mJobSkinsScrollContainer)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mJobSkinsScrollContainer.numChildren)
            {
               _loc2_ = JobSkinSlot(this.mJobSkinsScrollContainer.getChildAt(_loc1_));
               _loc3_ = _loc2_ ? HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc2_.getSkinSku())) : null;
               if(_loc3_)
               {
                  Root.assets.removeTexture(_loc3_.getBGImageName());
               }
               _loc1_++;
            }
         }
      }
      
      public function getParentPanel() : JobPanel
      {
         return this.mParentPanel;
      }
   }
}

