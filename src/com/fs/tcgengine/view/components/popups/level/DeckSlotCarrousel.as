package com.fs.tcgengine.view.components.popups.level
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.DeckSlotDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.DeckJobConfigurator;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.levels.FSPopupPlayLevel;
   import feathers.controls.ScrollContainer;
   import feathers.controls.supportClasses.LayoutViewPort;
   import flash.utils.Dictionary;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class DeckSlotCarrousel extends Component
   {
      
      public static const STATE_UNSELECTED:int = 0;
      
      public static const STATE_SELECTED:int = 1;
      
      public static const STATE_DISABLED:int = 2;
      
      private var mBG:CustomComponent;
      
      private var mFG:FSImage;
      
      private var mNameTextfield:FSTextfield;
      
      private var mAmountTextfield:FSTextfield;
      
      private var mLockedImage:FSImage;
      
      private var mJobDef:JobDef;
      
      private var mDeckIndex:int;
      
      private var mState:int;
      
      protected var mIsSelectedDeck:Boolean;
      
      private var mAvailable:Boolean;
      
      private var mDeckSlotDef:DeckSlotDef;
      
      private var mType:int;
      
      private var mIsDeckConfigured:Boolean;
      
      public function DeckSlotCarrousel(param1:int, param2:int, param3:int)
      {
         var _loc4_:DeckJobConfigurator = null;
         super();
         this.mDeckIndex = param1;
         this.mType = param3;
         if(this.mType == DeckSelectorCarrousel.TYPE_BASIC)
         {
            this.mIsDeckConfigured = true;
            this.mJobDef = JobDef(InstanceMng.getJobsDefMng().getBasicJobByDeck(String(param1)));
         }
         else
         {
            _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(param1);
            if(_loc4_)
            {
               this.mIsDeckConfigured = true;
               this.mJobDef = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc4_.getJobSku()));
            }
         }
         this.mDeckSlotDef = InstanceMng.getDeckSlotsDefMng().getDeckSlotDefByIndex(param1);
         this.mAvailable = this.isAvailable();
         this.createUI();
         alignPivot();
         x -= width / 2;
         y -= height / 2;
      }
      
      private function createUI() : void
      {
         this.createBG(STATE_UNSELECTED);
         this.createFG();
         this.createLock();
         this.createName();
         this.createAmountTextfield();
         addEventListener(TouchEvent.TOUCH,this.onTouch);
         this.checkAvailability();
      }
      
      private function checkAvailability() : void
      {
         var _loc1_:Boolean = this.mAvailable && this.isCompleted();
         if(this.mFG)
         {
            this.mFG.alpha = _loc1_ ? 1 : 0.5;
         }
      }
      
      private function createLock() : void
      {
         if(!this.mAvailable)
         {
            if(this.mLockedImage == null)
            {
               this.mLockedImage = new FSImage(Root.assets.getTexture("icon_class_lock"));
               this.mLockedImage.alignPivot();
               this.mLockedImage.x = this.mFG.x + this.mFG.width / 2;
               this.mLockedImage.y = this.mFG.y + this.mFG.height / 2;
               addChild(this.mLockedImage);
            }
         }
         else if(this.mLockedImage)
         {
            this.mLockedImage.removeFromParent();
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(Utils.isDesktop() || Utils.isBrowser())
         {
            _loc2_ = param1.getTouch(this,TouchPhase.HOVER);
            scaleX = _loc2_ ? 1.04 : 1;
            scaleY = _loc2_ ? 1.04 : 1;
         }
         if(param1.getTouch(this,TouchPhase.ENDED))
         {
            this.performOnTouchOps();
         }
      }
      
      private function performOnTouchOps() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:FSPopupPlayLevel = null;
         var _loc8_:int = 0;
         var _loc1_:ScrollContainer = parent is LayoutViewPort && parent.parent != null ? ScrollContainer(parent.parent) : null;
         var _loc2_:Boolean = _loc1_ ? _loc1_.isScrolling : false;
         if(_loc2_ || Config.getConfig().gameHasClassSystem() && this.mJobDef == null)
         {
            return;
         }
         var _loc3_:UserData = Utils.getOwnerUserData();
         if(_loc3_)
         {
            if(Config.getConfig().gameHasClassSystem() && this.mType == DeckSelectorCarrousel.TYPE_BASIC && JobsMng.getJobState(this.mJobDef) == JobsMng.STATE_AVAILABLE)
            {
               JobsMng.buyJob(this.mJobDef,null,false);
            }
            if(this.mAvailable && this.isCompleted())
            {
               this.onDeckSelectedSwitch();
            }
            else if(Config.getConfig().gameHasClassSystem() && this.mType == DeckSelectorCarrousel.TYPE_BASIC)
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
                        this.onDeckSelectedSwitch();
                     }
                  }
               }
            }
            else if(this.isPurchasable() && (this.mType == DeckSelectorCarrousel.TYPE_CUSTOM || this.mJobDef == null))
            {
               if(Boolean(InstanceMng.getApplication()) && !InstanceMng.getApplication().hasPermanentBoosts())
               {
                  Utils.setLogText(TextManager.getText("TID_GEN_OS_FEATURE"),true);
               }
               else
               {
                  _loc7_ = InstanceMng.getPopupMng().getPopupInBackground() is FSPopupPlayLevel ? FSPopupPlayLevel(InstanceMng.getPopupMng().getPopupInBackground()) : null;
                  if(_loc7_)
                  {
                     _loc7_.hideCarrousels(false);
                  }
                  InstanceMng.getPopupMng().getPopupShown().hideTemporarily(InstanceMng.getPopupMng().openDeckSlotPopup,[this.mDeckSlotDef]);
               }
            }
            else
            {
               _loc8_ = _loc3_.getDecksPurchasedAmount();
               if(this.mDeckIndex > _loc8_ + Config.getConfig().getDefaultAvailableDecksAmount())
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
      
      public function isPurchasable() : Boolean
      {
         var _loc1_:int = InstanceMng.getUserDataMng().getOwnerUserData().getDecksPurchasedAmount();
         return this.mDeckIndex == _loc1_ + Config.getConfig().getDefaultAvailableDecksAmount();
      }
      
      public function onDeckSelectedSwitch() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = _loc1_.getSelectedDeckIndex();
         var _loc3_:String = Boolean(this.mJobDef) && this.mJobDef.isBasicDeck() ? TextManager.getText("TID_GEN_DECK_SELECTED") + " " + this.mJobDef.getName() : TextManager.getText("TID_GEN_DECK_SELECTED") + " " + _loc1_.getDeckName(this.mDeckIndex);
         Utils.setLogText(_loc3_,false,false,false);
         _loc1_.setSelectedDeckIndex(this.mDeckIndex);
         var _loc4_:FSPopupPlayLevel = InstanceMng.getPopupMng().getPopupInBackground() is FSPopupPlayLevel ? FSPopupPlayLevel(InstanceMng.getPopupMng().getPopupInBackground()) : null;
         if(_loc4_)
         {
            _loc4_.onDeckSelectionChanged(_loc2_,this.mDeckIndex);
            FSTracker.trackMiscAction(FSTracker.CATEGORY_USER,FSTracker.ACTION_DECK_SELECTED,{
               "oldDeckIndex":_loc2_,
               "newDeckIndex":this.mDeckIndex
            });
         }
         if(Config.getConfig().gameHasClassSystem())
         {
            if(this.mDeckIndex >= Config.getConfig().getMaxDecksAmount())
            {
               _loc1_.setDeck(_loc1_.createBestBasicDeckConfiguration(this.mJobDef),this.mDeckIndex);
            }
         }
         this.setIsSelectedDeck(true);
      }
      
      private function createBG(param1:int) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case STATE_UNSELECTED:
               _loc2_ = "button_deck_normal";
               break;
            case STATE_SELECTED:
               _loc2_ = "button_deck_active";
               break;
            case STATE_DISABLED:
               _loc2_ = "button_deck_disabled";
         }
         _loc2_ = this.mAvailable ? _loc2_ : "button_deck_disabled";
         if(this.mBG == null)
         {
            this.mBG = Utils.createCustomBox(_loc2_,278);
            addChild(this.mBG);
         }
         else
         {
            this.mBG.updateTextures(_loc2_,278);
         }
      }
      
      public function refreshState(param1:int) : void
      {
         this.createBG(param1);
      }
      
      private function createFG() : void
      {
         var _loc1_:String = this.mJobDef ? this.mJobDef.getBgIcon() : "icon_deck";
         if(Config.getConfig().gameHasClassSystem())
         {
            _loc1_ = this.mIsDeckConfigured && Boolean(this.mJobDef) ? this.mJobDef.getBgIcon() : "icon_class_00_XL";
         }
         else
         {
            _loc1_ = "icon_deck";
         }
         if(this.mFG == null)
         {
            this.mFG = new FSImage(Root.assets.getTexture(_loc1_));
            this.mFG.x = (this.mBG.width - this.mFG.width) / 2;
            this.mFG.y = (this.mBG.height - this.mFG.height) / 2.75;
            addChild(this.mFG);
         }
      }
      
      private function createName() : void
      {
         var _loc1_:String = "";
         if(Config.getConfig().gameHasClassSystem() && this.mType == DeckSelectorCarrousel.TYPE_BASIC)
         {
            _loc1_ = this.mJobDef ? this.mJobDef.getName() : "???";
         }
         else
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeckName(this.mDeckIndex);
         }
         if(this.mNameTextfield == null)
         {
            this.mNameTextfield = new FSTextfield(this.mBG.width * 0.8,this.mBG.height / 3.25,_loc1_,16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
            this.mNameTextfield.x = (this.mBG.width - this.mNameTextfield.width) / 2;
            this.mNameTextfield.y = this.mBG.height - this.mNameTextfield.height;
            addChild(this.mNameTextfield);
         }
      }
      
      private function createAmountTextfield() : void
      {
         var _loc5_:int = 0;
         var _loc1_:Boolean = false;
         var _loc2_:UserData = Utils.getOwnerUserData();
         var _loc3_:Dictionary = _loc2_.getDeck(this.mDeckIndex);
         var _loc4_:int = DictionaryUtils.getCardsAmountPerCatalog(_loc3_);
         if(!this.isCompleted() && this.mAvailable)
         {
            if(this.mAmountTextfield == null)
            {
               this.mAmountTextfield = new FSTextfield(this.mBG.width,this.mBG.height / 2,"",16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
               this.mAmountTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
               this.mAmountTextfield.alignPivot();
               this.mAmountTextfield.x = this.mBG.width / 2;
               this.mAmountTextfield.y = this.mBG.height / 2;
               addChild(this.mAmountTextfield);
            }
            _loc5_ = _loc4_ > 0 ? int(_loc4_ - 1) : _loc4_;
            this.mAmountTextfield.text = _loc5_ + "/" + Config.getConfig().getDeckCardsAmount();
         }
         else if(this.mAmountTextfield)
         {
            this.mAmountTextfield.removeFromParent(true);
         }
      }
      
      private function isCompleted() : Boolean
      {
         var _loc4_:Dictionary = null;
         var _loc5_:int = 0;
         if(!this.mAvailable)
         {
            return false;
         }
         var _loc1_:Boolean = this.mDeckIndex >= Config.getConfig().getMaxDecksAmount();
         if(_loc1_)
         {
            return true;
         }
         var _loc2_:Boolean = false;
         var _loc3_:UserData = Utils.getOwnerUserData();
         if(_loc3_)
         {
            _loc4_ = _loc3_.getDeck(this.mDeckIndex);
            _loc5_ = Boolean(InstanceMng.getPopupMng().getPopupInBackground()) && InstanceMng.getPopupMng().getPopupInBackground() is FSPopupPlayLevel ? FSPopupPlayLevel(InstanceMng.getPopupMng().getPopupInBackground()).getCollectionSizePreCalculated() : 0;
            _loc2_ = DictionaryUtils.checkIfDeckSizeCorrect(_loc4_,_loc3_.getCardCollection(),-1,_loc5_);
         }
         return _loc2_;
      }
      
      public function setIsSelectedDeck(param1:Boolean) : void
      {
         this.mIsSelectedDeck = param1;
         if(param1)
         {
            this.refreshState(STATE_SELECTED);
         }
         else
         {
            this.refreshState(STATE_UNSELECTED);
         }
      }
      
      private function isAvailable() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:Boolean = false;
         if(this.mType == DeckSelectorCarrousel.TYPE_BASIC)
         {
            if(this.mJobDef)
            {
               _loc2_ = this.mJobDef.getUnlockLevel();
               _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY);
               if(_loc2_ <= _loc3_)
               {
                  _loc1_ = true;
               }
            }
         }
         else
         {
            _loc1_ = InstanceMng.getUserDataMng().isDeckBought(this.mDeckIndex);
         }
         return _loc1_;
      }
      
      public function getIndex() : int
      {
         return this.mDeckIndex;
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mFG)
         {
            this.mFG.removeFromParent();
            this.mFG.destroy();
            this.mFG = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(this.mLockedImage)
         {
            this.mLockedImage.removeFromParent();
            this.mLockedImage.destroy();
            this.mLockedImage = null;
         }
         if(this.mAmountTextfield)
         {
            this.mAmountTextfield.removeFromParent(true);
            this.mAmountTextfield = null;
         }
         this.mJobDef = null;
         this.mDeckSlotDef = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
   }
}

