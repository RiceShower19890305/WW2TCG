package com.fs.tcgengine.view.jobs
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.fs.tcgengine.view.misc.FSImage;
   import flash.geom.Point;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class JobSkinSlot extends Component
   {
      
      private var mJobDef:JobDef;
      
      private var mSkinSku:String;
      
      private var mBG:FSImage;
      
      private var mJobImage:FSImage;
      
      private var mLockImage:FSImage;
      
      private var mParentJobSelectedInfo:FSJobSelectedInfo;
      
      private var mIsSelectedSkin:Boolean;
      
      private var mSelectedSkinText:FSTextfield;
      
      private var mHoverHelperPoint:Point;
      
      private var mIsHovered:Boolean;
      
      private var mIsMouseHeldDown:Boolean;
      
      public function JobSkinSlot(param1:JobDef, param2:String, param3:FSJobSelectedInfo, param4:Boolean)
      {
         this.mJobDef = param1;
         this.mSkinSku = param2;
         this.mParentJobSelectedInfo = param3;
         this.mIsSelectedSkin = param4;
         super();
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.loadJobImage();
      }
      
      private function loadJobImage() : void
      {
         var _loc1_:HeroCharacterDef = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mSkinSku));
         if(_loc1_)
         {
            if(Root.assets.getTexture(_loc1_.getBGImageName()) == null)
            {
               InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc1_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
            }
         }
      }
      
      public function onCurrentJobImageLoaded() : void
      {
         this.createJobImage();
         this.createLockImage();
         this.createSelectedText();
      }
      
      private function createSelectedText() : void
      {
         if(this.mIsSelectedSkin && this.mSelectedSkinText == null)
         {
            this.mSelectedSkinText = new FSTextfield(this.mBG.width,this.mBG.height * 0.2,TextManager.getText("TID_GEN_SELECTED"));
            this.mSelectedSkinText.y = this.mBG.y + this.mBG.height / 2 - this.mSelectedSkinText.height / 2;
            addChild(this.mSelectedSkinText);
         }
      }
      
      private function createLockImage() : void
      {
         if(!InstanceMng.getUserDataMng().getOwnerUserData().isSkinAvailable(this.mSkinSku))
         {
            if(Boolean(this.mBG) && this.mLockImage == null)
            {
               this.mLockImage = new FSImage(Root.assets.getTexture("job_lock_large"));
               this.mLockImage.x = this.mBG.x + this.mBG.width / 2 - this.mLockImage.width / 2;
               this.mLockImage.y = this.mBG.y + this.mBG.height - this.mLockImage.height * 1.1;
               this.mLockImage.touchable = false;
               addChild(this.mLockImage);
            }
         }
      }
      
      private function createJobImage() : void
      {
         var _loc1_:HeroCharacterDef = null;
         if(Boolean(this.mBG) && this.mJobImage == null)
         {
            _loc1_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mSkinSku));
            if(_loc1_)
            {
               this.mJobImage = new FSImage(Root.assets.getTexture(_loc1_.getBGImageName()));
               this.mJobImage.scale *= 0.6;
               this.mJobImage.touchable = false;
               this.mJobImage.x = this.mBG.x + this.mBG.width / 2 - this.mJobImage.width / 2;
               this.mJobImage.y = this.mBG.y + this.mBG.height / 2 - this.mJobImage.height / 2;
               addChild(this.mJobImage);
            }
         }
      }
      
      private function createBG() : void
      {
         var _loc1_:String = null;
         if(this.mBG == null)
         {
            if(InstanceMng.getUserDataMng().getOwnerUserData().isSkinAvailable(this.mSkinSku))
            {
               _loc1_ = "job_layer_skin_on";
            }
            else
            {
               _loc1_ = "job_layer_skin_off";
            }
            this.mBG = new FSImage(Root.assets.getTexture(_loc1_));
            this.mBG.addEventListener(TouchEvent.TOUCH,this.onSkinTouch);
            addChild(this.mBG);
         }
      }
      
      private function onSkinTouch(param1:TouchEvent) : void
      {
         var _loc2_:Boolean = false;
         if(param1.getTouch(this.mBG,TouchPhase.BEGAN))
         {
            this.mIsMouseHeldDown = true;
         }
         else if(param1.getTouch(this.mBG,TouchPhase.ENDED))
         {
            this.mHoverHelperPoint = parent ? param1.getTouch(this,TouchPhase.ENDED).getLocation(parent,this.mHoverHelperPoint) : null;
            this.onMouseUp();
            this.mIsMouseHeldDown = false;
         }
         else
         {
            this.mHoverHelperPoint = Boolean(parent) && Boolean(param1.getTouch(this.mBG,TouchPhase.MOVED)) ? param1.getTouch(this.mBG,TouchPhase.MOVED).getLocation(parent,this.mHoverHelperPoint) : null;
            _loc2_ = this.mHoverHelperPoint ? hitTest(this.mHoverHelperPoint) != null : false;
            if(!_loc2_)
            {
               this.mIsMouseHeldDown = false;
            }
         }
      }
      
      private function onMouseUp() : void
      {
         var _loc1_:HeroCharacterDef = null;
         var _loc2_:FSShopItem = null;
         if(!this.mIsMouseHeldDown)
         {
            return;
         }
         if(JobsMng.isJobAvailable(this.mJobDef) && JobsMng.haveEnoughCardsForJob(this.mJobDef))
         {
            if(InstanceMng.getUserDataMng().getOwnerUserData().isSkinAvailable(this.mSkinSku))
            {
               this.mParentJobSelectedInfo.setSelectedSkin(this.mSkinSku);
               this.mParentJobSelectedInfo.updateSelectedSkin();
            }
            else
            {
               _loc1_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mSkinSku));
               _loc2_ = new FSShopItem(_loc1_,false,null,true);
               InstanceMng.getPopupMng().openShopItemPopup(_loc2_);
            }
         }
         else
         {
            Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_JOBS_UNLOCKED_REQUIREMENT"),[this.mJobDef.getUnlockLevel().toString()]),true);
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:HeroCharacterDef = null;
         if(this.mBG)
         {
            this.mBG.removeEventListener(TouchEvent.TOUCH,this.onSkinTouch);
            this.mBG.removeFromParent();
            this.mBG.destroy();
            this.mBG = null;
         }
         if(this.mJobDef)
         {
            _loc1_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mSkinSku));
            if(_loc1_)
            {
               Root.assets.removeTexture(_loc1_.getBGImageName());
            }
         }
         if(this.mJobImage)
         {
            this.mJobImage.removeFromParent();
            this.mJobImage.destroy();
            this.mJobImage = null;
         }
         if(this.mLockImage)
         {
            this.mLockImage.removeFromParent();
            this.mLockImage.destroy();
            this.mLockImage = null;
         }
         this.mJobDef = null;
         this.mParentJobSelectedInfo = null;
         this.mHoverHelperPoint = null;
         super.dispose();
      }
      
      public function getSkinIndex() : int
      {
         var _loc1_:HeroCharacterDef = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mSkinSku));
         return _loc1_.getIndex();
      }
      
      public function getSkinSku() : String
      {
         return this.mSkinSku;
      }
      
      public function updateJobSkinAfterBuy() : void
      {
         var _loc1_:String = null;
         if(InstanceMng.getUserDataMng().getOwnerUserData().isSkinAvailable(this.mSkinSku))
         {
            _loc1_ = "job_layer_skin_on";
            if(this.mLockImage)
            {
               this.mLockImage.removeFromParent();
               this.mLockImage.destroy();
               this.mLockImage = null;
            }
            if(InstanceMng.getUserDataMng().getOwnerUserData().isSkinAvailable(this.mSkinSku) && JobsMng.isJobAvailable(this.mJobDef) && JobsMng.haveEnoughCardsForJob(this.mJobDef))
            {
               this.mBG.addEventListener(TouchEvent.TOUCH,this.onSkinTouch);
            }
         }
         else
         {
            _loc1_ = "job_layer_skin_off";
         }
         if(this.mBG)
         {
            this.mBG.texture = Root.assets.getTexture(_loc1_);
         }
      }
      
      public function updateSelectedSkin() : void
      {
         if(this.mParentJobSelectedInfo.getSelectedSkin() == this.mSkinSku)
         {
            this.mIsSelectedSkin = true;
            this.createSelectedText();
         }
         else
         {
            this.mIsSelectedSkin = false;
            this.removeSelectedText();
         }
      }
      
      private function removeSelectedText() : void
      {
         if(this.mSelectedSkinText)
         {
            this.mSelectedSkinText.removeFromParent();
            this.mSelectedSkinText = null;
         }
      }
   }
}

