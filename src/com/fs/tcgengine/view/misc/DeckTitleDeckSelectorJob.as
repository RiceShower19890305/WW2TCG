package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import feathers.controls.ScrollContainer;
   import feathers.controls.supportClasses.LayoutViewPort;
   import flash.utils.Dictionary;
   
   public class DeckTitleDeckSelectorJob extends DeckTitleDeckSelector
   {
      
      public static const BG_DECK_NAME_ON:String = "deck_layer_on";
      
      public static const BG_DECK_NAME_OFF:String = "deck_layer_off";
      
      private var mJobImage:FSImage;
      
      private var mJobDef:JobDef;
      
      private var mIsJobDeckBasic:Boolean;
      
      private var mIsDeckConfigured:Boolean;
      
      private var mDeckJobConfig:DeckJobConfigurator;
      
      public function DeckTitleDeckSelectorJob(param1:int, param2:Boolean, param3:DeckSelectorMini, param4:Boolean = false, param5:Boolean = false, param6:Boolean = true)
      {
         this.mIsJobDeckBasic = param6;
         if(this.mIsJobDeckBasic)
         {
            this.mIsDeckConfigured = true;
            this.mJobDef = JobDef(InstanceMng.getJobsDefMng().getBasicJobByDeck(String(param1)));
         }
         else
         {
            this.mDeckJobConfig = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(param1);
            if(this.mDeckJobConfig)
            {
               this.mIsDeckConfigured = true;
               this.mJobDef = JobDef(InstanceMng.getJobsDefMng().getDefBySku(this.mDeckJobConfig.getJobSku()));
            }
         }
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function createBG() : void
      {
         var _loc2_:String = null;
         if(this.mJobImage == null)
         {
            if(this.mIsDeckConfigured)
            {
               _loc2_ = this.mJobDef.getBgIcon();
            }
            else
            {
               _loc2_ = "icon_class_00";
            }
            this.mJobImage = new FSImage(Root.assets.getTexture(_loc2_));
            addChild(this.mJobImage);
         }
         var _loc1_:String = InstanceMng.getUserDataMng().getOwnerUserData().getSelectedDeckIndex() == mDeckIndex && this.mIsDeckConfigured && this.mIsJobDeckBasic ? BG_DECK_NAME_ON : BG_DECK_NAME_OFF;
         if(mBG == null && Boolean(this.mJobImage))
         {
            mBG = new FSImage(Root.assets.getTexture(_loc1_));
            mBG.x = this.mJobImage.width * 1.1;
            addChild(mBG);
         }
      }
      
      override protected function createBGDecoration() : void
      {
         if(!this.mIsDeckConfigured)
         {
            super.createBGDecoration();
            mBGDecoration.x = mBG.x + mBG.width * 0.9 - mBGDecoration.width;
         }
      }
      
      override protected function createStatusTextfield() : void
      {
         if(!this.mIsDeckConfigured)
         {
            super.createStatusTextfield();
            mStatusTextfield.x = mBG.x + mBG.width * 0.17;
         }
      }
      
      override protected function createStatusLight() : void
      {
         if(!this.mIsJobDeckBasic)
         {
            super.createStatusLight();
            mStatusLight.x = mBG.x;
         }
      }
      
      override public function setIsSelectedDeck(param1:Boolean) : void
      {
         mIsSelectedDeck = param1;
         createBGActiveDeck();
         this.updateStatusLight();
         updateIncompleteBG();
      }
      
      override protected function createTitleTextfield() : void
      {
         var _loc1_:String = null;
         if(mTitleTextfield == null)
         {
            if(this.mIsDeckConfigured && this.mIsJobDeckBasic)
            {
               _loc1_ = this.mJobDef.getName();
            }
            else
            {
               _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeckName(mDeckIndex) ? InstanceMng.getUserDataMng().getOwnerUserData().getDeckName(mDeckIndex).toUpperCase() : "";
            }
            mTitleTextfield = new FSTextfield(mBG.width,mBG.height,_loc1_,12632256);
            mTitleTextfield.fontName = FSResourceMng.getFontByType();
            mTitleTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            mTitleTextfield.x = mBG.x;
            mTitleTextfield.y = mBG.y;
            addChild(mTitleTextfield);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mJobImage)
         {
            this.mJobImage.removeFromParent(true);
            this.mJobImage = null;
         }
         super.dispose();
      }
      
      public function getJobDef() : JobDef
      {
         return this.mJobDef;
      }
      
      public function setAvailable(param1:Boolean) : void
      {
         mAvailable = param1;
      }
      
      override protected function updateStatusLight() : void
      {
         if(this.mIsJobDeckBasic)
         {
            if(this.mIsJobDeckBasic && mIsSelectedDeck)
            {
               mBG.texture = Root.assets.getTexture(BG_DECK_NAME_ON);
            }
            else
            {
               mBG.texture = Root.assets.getTexture(BG_DECK_NAME_OFF);
            }
         }
         else
         {
            super.updateStatusLight();
         }
      }
      
      override protected function performOnTouchOps() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:ScrollContainer = parent is LayoutViewPort ? ScrollContainer(parent.parent) : null;
         var _loc2_:Boolean = _loc1_ ? _loc1_.isScrolling : false;
         if(_loc2_)
         {
            return;
         }
         var _loc3_:UserData = Utils.getOwnerUserData();
         if(_loc3_)
         {
            if(mAvailable)
            {
               this.onDeckSelectedSwitchToJob();
            }
            else if(this.mIsJobDeckBasic)
            {
               if(InstanceMng.getLogPanel())
               {
                  _loc4_ = this.mJobDef.getUnlockLevel();
                  _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY);
                  if(_loc5_ < _loc4_)
                  {
                     Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_JOBS_UNLOCKED_DECK"),[this.mJobDef.getUnlockLevel()]),true);
                  }
                  else
                  {
                     _loc6_ = this.mJobDef.getUnlockCost();
                     if(_loc6_ > 0)
                     {
                        Utils.setLogText(TextManager.getText("TID_JOBS_UNLOCKABLE"),true);
                     }
                     else
                     {
                        this.onDeckSelectedSwitchToJob();
                     }
                  }
               }
            }
            else if(!this.mIsJobDeckBasic && isPurchasable())
            {
               if(Boolean(InstanceMng.getApplication()) && !InstanceMng.getApplication().hasPermanentBoosts())
               {
                  Utils.setLogText(TextManager.getText("TID_GEN_OS_FEATURE"),true);
               }
               else if(InstanceMng.getPopupMng().getPopupShown())
               {
                  InstanceMng.getPopupMng().getPopupShown().hideTemporarily(InstanceMng.getPopupMng().openDeckSlotPopup,[mDeckSlotDef]);
               }
               else
               {
                  InstanceMng.getPopupMng().openDeckSlotPopup(mDeckSlotDef);
               }
            }
            else
            {
               _loc7_ = _loc3_.getDecksPurchasedAmount();
               if(mDeckIndex > _loc7_ + Config.getConfig().getDefaultAvailableDecksAmount())
               {
                  Utils.setLogText(TextManager.getText("TID_DECKSLOT_FIRST_BUY"),true,false);
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_GEN_GO_DB"),true,false,false);
               }
            }
         }
      }
      
      public function onDeckSelectedSwitchToJob() : void
      {
         var _loc3_:int = 0;
         var _loc4_:DeckTitleDeckSelector = null;
         if(InstanceMng.getTutorialMapMng().isTutorialON())
         {
            InstanceMng.getTutorialMapMng().increaseCurrentStep();
         }
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(mParentDeckSelector != null)
         {
            _loc3_ = _loc1_.getSelectedDeckIndex();
            _loc4_ = mParentDeckSelector.getDeckTitleByIndex(_loc3_);
            if(_loc4_ != null)
            {
               _loc4_.setIsSelectedDeck(false);
            }
         }
         _loc1_.setSelectedDeckIndex(mDeckIndex,true);
         if(mDeckIndex >= Config.getConfig().getMaxDecksAmount())
         {
            _loc1_.setDeck(_loc1_.createBestBasicDeckConfiguration(this.mJobDef),mDeckIndex);
         }
         var _loc2_:String = this.mIsJobDeckBasic ? TextManager.getText("TID_GEN_DECK_SELECTED") + " " + this.mJobDef.getName() : TextManager.getText("TID_GEN_DECK_SELECTED") + " " + _loc1_.getDeckName(mDeckIndex);
         Utils.setLogText(_loc2_,false,false,false);
         this.setIsSelectedDeck(true);
      }
      
      override protected function isSizeCorrect() : Boolean
      {
         var _loc2_:Dictionary = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Boolean = false;
         var _loc5_:DeckJobConfigurator = null;
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_)
         {
            _loc2_ = _loc1_.getDeck(mDeckIndex);
            _loc3_ = _loc1_.getCardCollection();
            _loc4_ = true;
            if(Config.getConfig().gameHasClassSystem())
            {
               _loc5_ = _loc1_.getDeckJobConfiguratorByDeck(mDeckIndex);
               if(_loc5_ != null)
               {
                  _loc4_ = _loc5_.getJobSku() != "" && _loc5_.getJobSku() != null && _loc5_.getJobSku() != "null" && _loc5_.getSkinSku() != "" && _loc5_.getSkinSku() != null && _loc5_.getSkinSku() != "null" && _loc5_.getActiveAbilitySku() != "" && _loc5_.getActiveAbilitySku() != null && _loc5_.getActiveAbilitySku() != "null";
               }
               else
               {
                  _loc4_ = false;
               }
            }
         }
         return _loc4_ && DictionaryUtils.checkIfDeckSizeCorrect(_loc2_,_loc3_,mDeckIndex);
      }
   }
}

