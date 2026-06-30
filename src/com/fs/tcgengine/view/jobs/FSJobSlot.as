package com.fs.tcgengine.view.jobs
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.PassiveAbilityDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSGaugeProgressBar;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.JobPanel;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class FSJobSlot extends Component implements FSModelUnloadableInterface
   {
      
      private var mJobDef:JobDef;
      
      private var mBG:FSImage;
      
      private var mIcon:FSImage;
      
      private var mNameText:FSTextfield;
      
      private var mPassiveIcon:FSImage;
      
      private var mActiveIcon:FSImage;
      
      private var mIndexContainer:int;
      
      private var mParentJobPanel:JobPanel;
      
      private var mInfoText:FSTextfield;
      
      private var mExpProgressBar:FSGaugeProgressBar;
      
      public function FSJobSlot(param1:JobDef, param2:int, param3:JobPanel)
      {
         this.mJobDef = param1;
         this.mIndexContainer = param2;
         this.mParentJobPanel = param3;
         super();
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createBg();
         this.createIcon();
         this.createNameText();
         if(JobsMng.getJobState(this.mJobDef) == JobsMng.STATE_UNLOCKED)
         {
            this.createExpProgressBar();
         }
         else
         {
            this.createInfoNotReady();
         }
         this.createPassiveIcon();
         this.createActiveIcon();
      }
      
      private function createExpProgressBar() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mNameText) && this.mExpProgressBar == null)
         {
            _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_GEN_CHAR_LEVEL"),[JobsMng.getJobLevel(this.mJobDef)]);
            this.mExpProgressBar = new FSGaugeProgressBar(_loc1_);
            this.mExpProgressBar.setRatio(JobsMng.getPercentageExpCurrentLevel(this.mJobDef));
            this.mExpProgressBar.x = this.mNameText.x;
            this.mExpProgressBar.y = this.mNameText.y + this.mNameText.height;
            this.mExpProgressBar.touchable = false;
            addChild(this.mExpProgressBar);
         }
      }
      
      private function createInfoNotReady() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this.mNameText) && this.mInfoText == null)
         {
            this.mInfoText = new FSTextfield(this.mNameText.width,this.mBG.height * 0.4,"");
            this.mInfoText.format.horizontalAlign = Align.LEFT;
            this.mInfoText.alignPivot();
            this.mInfoText.x = this.mNameText.x + this.mNameText.width / 2;
            this.mInfoText.y = this.mNameText.y + this.mNameText.height + this.mInfoText.height / 2;
            _loc1_ = JobsMng.getJobState(this.mJobDef);
            switch(_loc1_)
            {
               case JobsMng.STATE_LOCKED_BY_QUEST:
                  this.mInfoText.text = TextManager.getText("TID_GEN_LOCKED") + " (" + TextManager.getText("TID_QUEST_SINGLE") + ")";
                  this.mInfoText.format.horizontalAlign = Align.LEFT;
                  this.mInfoText.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
                  break;
               case JobsMng.STATE_UNLOCKED_NO_CARDS:
                  this.mInfoText.text = TextManager.replaceParameters(TextManager.getText("TID_JOBS_UNLOCKED_AMOUNT_CARDS"),[JobsMng.getNumCardsForJob(this.mJobDef).toString(),Config.getConfig().getDeckCardsAmount().toString()]);
                  this.mInfoText.format.horizontalAlign = Align.LEFT;
                  this.mInfoText.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
                  break;
               case JobsMng.STATE_AVAILABLE:
                  this.mInfoText.text = TextManager.getText("TID_JOBS_UNLOCKED");
                  this.mInfoText.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
                  this.mInfoText.format.horizontalAlign = Align.CENTER;
                  SpecialFX.createYoYoZoomTransition(this.mInfoText,1.3,1,-1,null,null,false);
                  break;
               case JobsMng.STATE_LOCKED:
                  this.mInfoText.text = TextManager.getText("TID_GEN_LOCKED") + " (" + TextManager.replaceParameters(TextManager.getText("TID_GEN_LEVEL"),[this.mJobDef.getUnlockLevel()]) + ")";
                  this.mInfoText.format.horizontalAlign = Align.LEFT;
                  this.mInfoText.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
            }
            addChild(this.mInfoText);
         }
      }
      
      private function createActiveIcon() : void
      {
         var _loc1_:PowerDef = null;
         var _loc2_:AbilityDef = null;
         if(Boolean(this.mJobDef && this.mBG) && Boolean(this.mPassiveIcon) && this.mActiveIcon == null)
         {
            _loc1_ = PowerDef(InstanceMng.getPowerDefMng().getDefBySku(this.mJobDef.getActiveDefaultSku()));
            if(_loc1_)
            {
               _loc2_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc1_.getAbilities()[0]));
               if(_loc2_)
               {
                  this.mActiveIcon = new FSImage(Root.assets.getTexture(_loc2_.getBGImageName()));
                  this.mActiveIcon.scale = 1.25;
                  this.mActiveIcon.x = this.mPassiveIcon.x + this.mPassiveIcon.width;
                  this.mActiveIcon.y = this.mBG.height / 2 - this.mActiveIcon.height / 2;
                  this.mActiveIcon.touchable = false;
                  addChild(this.mActiveIcon);
               }
            }
         }
      }
      
      private function createPassiveIcon() : void
      {
         var _loc1_:PassiveAbilityDef = null;
         var _loc2_:AbilityDef = null;
         if(Boolean(this.mJobDef && this.mBG) && Boolean(this.mNameText) && this.mPassiveIcon == null)
         {
            _loc1_ = PassiveAbilityDef(InstanceMng.getPassiveAbilityDefMng().getDefBySku(this.mJobDef.getPassiveSku()));
            if(_loc1_)
            {
               _loc2_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc1_.getAbilitiesSkus()[0]));
               if(_loc2_)
               {
                  this.mPassiveIcon = new FSImage(Root.assets.getTexture(_loc2_.getBGImageName()));
                  this.mPassiveIcon.scale = 1.25;
                  this.mPassiveIcon.x = this.mNameText.x + this.mNameText.width;
                  this.mPassiveIcon.y = this.mBG.height / 2 - this.mPassiveIcon.height / 2;
                  this.mPassiveIcon.touchable = false;
                  addChild(this.mPassiveIcon);
               }
            }
         }
      }
      
      private function createNameText() : void
      {
         if(Boolean(this.mJobDef && this.mBG) && Boolean(this.mIcon) && this.mNameText == null)
         {
            this.mNameText = new FSTextfield(this.mBG.width * 0.4,this.mBG.height * 0.5,this.mJobDef.getName());
            this.mNameText.x = this.mIcon.x + this.mIcon.width;
            this.mNameText.format.horizontalAlign = Align.LEFT;
            addChild(this.mNameText);
         }
      }
      
      private function createIcon() : void
      {
         if(Boolean(this.mJobDef) && Boolean(this.mBG) && this.mIcon == null)
         {
            this.mIcon = new FSImage(Root.assets.getTexture(this.mJobDef.getBgIcon()));
            this.mIcon.x = this.mIcon.width * 0.1;
            this.mIcon.y = this.mBG.height / 2 - this.mIcon.height / 2;
            this.mIcon.touchable = false;
            addChild(this.mIcon);
         }
      }
      
      private function createBg() : void
      {
         if(Boolean(this.mJobDef) && this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture("side_job_layer"));
            this.mBG.addEventListener(TouchEvent.TOUCH,this.onJobSlotTouch);
            addChild(this.mBG);
         }
      }
      
      private function onJobSlotTouch(param1:TouchEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            this.mParentJobPanel.touchable = false;
            this.mParentJobPanel.selectSlot(this.mIndexContainer);
            this.mParentJobPanel.updateSelectedJobSkin();
            _loc3_ = JobsMng.getJobState(this.mJobDef);
            switch(_loc3_)
            {
               case JobsMng.STATE_UNLOCKED:
               case JobsMng.STATE_UNLOCKED_NO_CARDS:
               case JobsMng.STATE_LOCKED:
               case JobsMng.STATE_LOCKED_BY_QUEST:
                  this.mParentJobPanel.switchSelectButtonStateToSelect();
                  break;
               case JobsMng.STATE_AVAILABLE:
                  this.mParentJobPanel.switchSelectButtonStateToBuy(this.mJobDef.getUnlockCost());
            }
         }
      }
      
      public function getIndexSlot() : int
      {
         return this.mIndexContainer;
      }
      
      public function createSelectEffect() : void
      {
         if(this.mBG)
         {
            this.mBG.texture = Root.assets.getTexture("side_job_layer_selected");
         }
      }
      
      public function removeSelectEffect() : void
      {
         if(this.mBG)
         {
            this.mBG.texture = Root.assets.getTexture("side_job_layer");
         }
      }
      
      public function getJobDef() : JobDef
      {
         return this.mJobDef;
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeEventListener(TouchEvent.TOUCH,this.onJobSlotTouch);
            this.mBG.removeFromParent();
            this.mBG.destroy();
            this.mBG = null;
         }
         if(this.mIcon)
         {
            this.mIcon.removeFromParent();
            this.mIcon.destroy();
            this.mIcon = null;
         }
         if(this.mNameText)
         {
            this.mNameText.removeFromParent(true);
            this.mNameText = null;
         }
         if(this.mPassiveIcon)
         {
            this.mPassiveIcon.removeFromParent();
            this.mPassiveIcon.destroy();
            this.mPassiveIcon = null;
         }
         if(this.mActiveIcon)
         {
            this.mActiveIcon.removeFromParent();
            this.mActiveIcon.destroy();
            this.mActiveIcon = null;
         }
         if(this.mInfoText)
         {
            this.mInfoText.removeFromParent(true);
            this.mInfoText = null;
         }
         if(this.mExpProgressBar)
         {
            this.mExpProgressBar.removeFromParent(true);
            this.mExpProgressBar = null;
         }
         this.mJobDef = null;
         this.mParentJobPanel = null;
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mBG)
         {
            this.mBG.removeEventListener(TouchEvent.TOUCH,this.onJobSlotTouch);
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mIcon)
         {
            this.mIcon.removeFromParent();
            this.mIcon = null;
         }
         if(this.mNameText)
         {
            this.mNameText.removeFromParent();
            this.mNameText = null;
         }
         if(this.mPassiveIcon)
         {
            this.mPassiveIcon.removeFromParent();
            this.mPassiveIcon = null;
         }
         if(this.mActiveIcon)
         {
            this.mActiveIcon.removeFromParent();
            this.mActiveIcon = null;
         }
         if(this.mInfoText)
         {
            this.mInfoText.removeFromParent();
            this.mInfoText = null;
         }
         if(this.mExpProgressBar)
         {
            this.mExpProgressBar.removeFromParent();
            this.mExpProgressBar = null;
         }
         this.mParentJobPanel = null;
      }
      
      public function updateInfoText() : void
      {
         if(this.mInfoText)
         {
            this.mInfoText.removeFromParent();
            this.mInfoText = null;
         }
         if(this.mExpProgressBar)
         {
            this.mExpProgressBar.removeFromParent();
            this.mExpProgressBar.destroy();
            this.mExpProgressBar = null;
         }
         if(JobsMng.getJobState(this.mJobDef) == JobsMng.STATE_UNLOCKED)
         {
            this.createExpProgressBar();
         }
         else
         {
            this.createInfoNotReady();
         }
      }
   }
}

