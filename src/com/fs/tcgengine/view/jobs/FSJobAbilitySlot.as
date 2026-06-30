package com.fs.tcgengine.view.jobs
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class FSJobAbilitySlot extends Component
   {
      
      private var mAbilityDef:AbilityDef;
      
      private var mBG:FSImage;
      
      private var mAbilityIcon:FSImage;
      
      private var mName:FSTextfield;
      
      private var mDescription:FSTextfield;
      
      private var mSelectedAbilityIcon:FSImage;
      
      private var mParentJobSelectedInfo:FSJobSelectedInfo;
      
      private var mPowerSku:String;
      
      private var mAbilityBlockedTexfield:FSTextfield;
      
      private var mIsActiveSecondary:Boolean;
      
      private var mIsPassiveAbility:Boolean;
      
      public function FSJobAbilitySlot(param1:String, param2:String, param3:FSJobSelectedInfo, param4:Boolean = false, param5:Boolean = false)
      {
         this.mAbilityDef = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(param1));
         this.mParentJobSelectedInfo = param3;
         this.mPowerSku = param2;
         this.mIsActiveSecondary = param4;
         this.mIsPassiveAbility = param5;
         super();
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createBg();
         this.createAbilityIcon();
         this.createName();
         if(this.mIsActiveSecondary && !JobsMng.isActiveSecondaryAbilityUnlocked(this.mParentJobSelectedInfo.getJobDef()))
         {
            this.createTextfieldAbilityBlocked();
         }
         this.createDescription();
      }
      
      private function createTextfieldAbilityBlocked() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mBG) && Boolean(this.mName) && this.mAbilityBlockedTexfield == null)
         {
            _loc1_ = TextManager.getText("TID_GEN_LOCKED") + " (" + TextManager.replaceParameters(TextManager.getText("TID_GEN_CHAR_LEVEL"),[this.mParentJobSelectedInfo.getJobDef().getUnlockSecondaryAbiliyLevel()]) + ")";
            this.mAbilityBlockedTexfield = new FSTextfield(this.mBG.width * 0.4,this.mName.height,_loc1_);
            this.mAbilityBlockedTexfield.x = this.mName.x + this.mName.width;
            this.mAbilityBlockedTexfield.y = this.mName.y;
            this.mAbilityBlockedTexfield.format.horizontalAlign = Align.RIGHT;
            this.mAbilityBlockedTexfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
            addChild(this.mAbilityBlockedTexfield);
         }
      }
      
      private function createDescription() : void
      {
         if(Boolean(this.mAbilityDef && this.mAbilityIcon && this.mBG) && Boolean(this.mName) && this.mDescription == null)
         {
            this.mDescription = new FSTextfield(this.mBG.width * 0.9 - this.mAbilityIcon.width,this.mBG.height * 0.6,this.mAbilityDef.getDesc());
            this.mDescription.x = this.mName.x;
            this.mDescription.y = this.mName.y + this.mName.height;
            this.mDescription.format.horizontalAlign = Align.LEFT;
            addChild(this.mDescription);
         }
      }
      
      private function createName() : void
      {
         if(Boolean(this.mAbilityDef && this.mAbilityIcon) && Boolean(this.mBG) && this.mName == null)
         {
            this.mName = new FSTextfield(this.mBG.width * 0.5 - this.mAbilityIcon.width,this.mBG.height * 0.3,this.mAbilityDef.getName());
            this.mName.x = this.mAbilityIcon.x + this.mAbilityIcon.width * 1.2;
            this.mName.y = this.mName.height * 0.2;
            this.mName.format.horizontalAlign = Align.LEFT;
            addChild(this.mName);
         }
      }
      
      private function createAbilityIcon() : void
      {
         if(Boolean(this.mAbilityDef) && Boolean(this.mBG) && this.mAbilityIcon == null)
         {
            this.mAbilityIcon = new FSImage(Root.assets.getTexture(this.mAbilityDef.getBGImageName()));
            this.mAbilityIcon.x = this.mAbilityIcon.width * 0.2;
            this.mAbilityIcon.y = this.mBG.height / 2 - this.mAbilityIcon.height / 2;
            addChild(this.mAbilityIcon);
         }
      }
      
      private function createBg() : void
      {
         var _loc1_:String = null;
         if(this.mBG == null)
         {
            _loc1_ = this.mIsPassiveAbility ? "side_job_layer_passive" : "side_job_layer";
            this.mBG = new FSImage(Root.assets.getTexture(_loc1_));
            this.mBG.addEventListener(TouchEvent.TOUCH,this.onAbilitySlotTouch);
            addChild(this.mBG);
         }
      }
      
      private function onAbilitySlotTouch(param1:TouchEvent) : void
      {
         var _loc3_:UserData = null;
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(this.mIsActiveSecondary && JobsMng.isActiveSecondaryAbilityUnlocked(this.mParentJobSelectedInfo.getJobDef()) || !this.mIsActiveSecondary)
            {
               if(this.mParentJobSelectedInfo)
               {
                  this.mParentJobSelectedInfo.setSelectedActiveAbility(this.mPowerSku);
                  this.mParentJobSelectedInfo.refreshSelectedActiveAbility();
                  _loc3_ = Utils.getOwnerUserData();
                  _loc3_.updateDeckPower(this.mPowerSku,_loc3_.getSelectedDeckIndex());
               }
            }
            else if(this.mIsActiveSecondary && !JobsMng.isActiveSecondaryAbilityUnlocked(this.mParentJobSelectedInfo.getJobDef()))
            {
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_JOBS_UNLOCKED_ABILITY"),[this.mParentJobSelectedInfo.getJobDef().getUnlockSecondaryAbiliyLevel().toString()]),true);
            }
         }
      }
      
      public function getPowerSku() : String
      {
         return this.mPowerSku;
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeEventListener(TouchEvent.TOUCH,this.onAbilitySlotTouch);
            this.mBG.removeFromParent();
            this.mBG.destroy();
            this.mBG = null;
         }
         if(this.mAbilityIcon)
         {
            this.mAbilityIcon.removeFromParent();
            this.mAbilityIcon.destroy();
            this.mAbilityIcon = null;
         }
         if(this.mName)
         {
            this.mName.removeFromParent(true);
            this.mName = null;
         }
         if(this.mDescription)
         {
            this.mDescription.removeFromParent(true);
            this.mDescription = null;
         }
         if(this.mSelectedAbilityIcon)
         {
            this.mSelectedAbilityIcon.removeFromParent();
            this.mSelectedAbilityIcon.destroy();
            this.mSelectedAbilityIcon = null;
         }
         if(this.mAbilityBlockedTexfield)
         {
            this.mAbilityBlockedTexfield.removeFromParent(true);
            this.mAbilityBlockedTexfield = null;
         }
         this.mAbilityDef = null;
         this.mParentJobSelectedInfo = null;
         super.dispose();
      }
      
      public function createSelectedEffect() : void
      {
         if(this.mSelectedAbilityIcon == null)
         {
            this.mSelectedAbilityIcon = new FSImage(Root.assets.getTexture("skin_owned"));
            this.mSelectedAbilityIcon.x = this.mBG.x + this.mBG.width - this.mSelectedAbilityIcon.width;
            this.mSelectedAbilityIcon.y = 0;
            addChild(this.mSelectedAbilityIcon);
         }
      }
      
      public function removeSelectedEffect() : void
      {
         if(this.mSelectedAbilityIcon)
         {
            this.mSelectedAbilityIcon.removeFromParent();
            this.mSelectedAbilityIcon = null;
         }
      }
   }
}

