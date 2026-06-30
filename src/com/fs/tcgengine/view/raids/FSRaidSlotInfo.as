package com.fs.tcgengine.view.raids
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.RaidsDefMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.RaidDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.controls.supportClasses.LayoutViewPort;
   import flash.ui.Mouse;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class FSRaidSlotInfo extends Component implements FSModelUnloadableInterface
   {
      
      protected var mBackBG:FSImage;
      
      protected var mBG:FSImage;
      
      private var mNameTextfield:FSTextfield;
      
      protected var mExpandIcon:FSImage;
      
      protected var mCostToUnlockIcon:FSImage;
      
      protected var mCostToUnlockTextfield:FSTextfield;
      
      protected var mRaidDef:RaidDef;
      
      private var mIsExpanded:Boolean = false;
      
      private var mDifficultySlots:Vector.<FSRaidSlotDifficultyInfo>;
      
      private var mItemNumber:int;
      
      public function FSRaidSlotInfo(param1:String, param2:int)
      {
         super();
         this.mRaidDef = RaidDef(InstanceMng.getRaidsDefMng().getDefBySku(param1));
         this.mItemNumber = param2;
         this.init();
      }
      
      private function init() : void
      {
         if(this.mRaidDef)
         {
            this.createBackBG();
            this.createRaidBG();
            this.createNameTextfield();
            if(Boolean(InstanceMng.getUserDataMng() && InstanceMng.getUserDataMng().getOwnerUserData()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData().isUnlockedRaid(this.mRaidDef.getSku())) || !this.mRaidDef.getIsMultiPlayer())
            {
               this.createExpandIcon();
            }
            else
            {
               this.createCostToUnlockIcon();
               this.createCostToUnlockTextfield();
            }
         }
         this.addEventListeners();
      }
      
      private function createCostToUnlockTextfield() : void
      {
         if(Boolean(this.mCostToUnlockTextfield == null) && Boolean(this.mCostToUnlockIcon) && Boolean(this.mRaidDef))
         {
            this.mCostToUnlockTextfield = new FSTextfield(this.mCostToUnlockIcon.width,this.mCostToUnlockIcon.height,this.mRaidDef.getUnlockCost().toString());
            this.mCostToUnlockTextfield.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mCostToUnlockTextfield.alignPivot();
            this.mCostToUnlockTextfield.x = this.mCostToUnlockIcon.x;
            this.mCostToUnlockTextfield.y = this.mCostToUnlockIcon.y;
            addChild(this.mCostToUnlockTextfield);
         }
      }
      
      private function createCostToUnlockIcon() : void
      {
         if(this.mCostToUnlockIcon == null && Boolean(this.mBG))
         {
            this.mCostToUnlockIcon = new FSImage(Root.assets.getTexture("dungeon_small_gold"));
            this.mCostToUnlockIcon.alignPivot();
            this.mCostToUnlockIcon.x = this.mBG.width - this.mCostToUnlockIcon.width * 0.7;
            this.mCostToUnlockIcon.y = this.mBG.height / 2;
            addChild(this.mCostToUnlockIcon);
         }
      }
      
      private function addEventListeners() : void
      {
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         _loc2_ = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            _loc3_ = parent != null && parent is LayoutViewPort && parent.parent is ScrollContainer && ScrollContainer(parent.parent).isScrolling;
            if(_loc3_)
            {
               return;
            }
            if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
            {
               FSRaidsScreen(InstanceMng.getCurrentScreen()).lockRaidScrollContainer();
            }
            this.lockItem();
            if(!Root.assets.isLoading)
            {
               if(InstanceMng.getServerConnection().isUserLoggedIn())
               {
                  if(InstanceMng.getRaidsMng().isWeeklySeasonActive())
                  {
                     if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
                     {
                        FSRaidsScreen(InstanceMng.getCurrentScreen()).onDifficultyReset();
                     }
                     if(this.mDifficultySlots)
                     {
                        _loc4_ = 0;
                        while(_loc4_ < this.mDifficultySlots.length)
                        {
                           FSRaidSlotDifficultyInfo(this.mDifficultySlots[_loc4_]).dispose();
                           _loc4_++;
                        }
                        this.mDifficultySlots.length = 0;
                        this.mDifficultySlots = null;
                     }
                     if(InstanceMng.getCurrentScreen() is FSRaidsScreen && !this.mIsExpanded)
                     {
                        InstanceMng.getCurrentScreen().showLoadingIcon(true,true,Align.CENTER,Align.CENTER,1,null,this);
                     }
                     if(Boolean(InstanceMng.getUserDataMng() && InstanceMng.getUserDataMng().getOwnerUserData()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData().isUnlockedRaid(this.mRaidDef.getSku())) || !this.mRaidDef.getIsMultiPlayer())
                     {
                        if(!this.mIsExpanded)
                        {
                           if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
                           {
                              FSRaidsScreen(InstanceMng.getCurrentScreen()).fillInfoByRaid(this.mRaidDef,this);
                           }
                           InstanceMng.getRaidsMng().refreshRaidsScores(this.mRaidDef,this.onRaidsScoresACK);
                        }
                        else
                        {
                           this.setExpanded(!this.mIsExpanded);
                        }
                     }
                     else
                     {
                        if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
                        {
                           if(FSRaidsScreen(InstanceMng.getCurrentScreen()).getSelectedRaidDef())
                           {
                              if(FSRaidsScreen(InstanceMng.getCurrentScreen()).getSelectedRaidDef().getSku() != this.mRaidDef.getSku())
                              {
                                 FSRaidsScreen(InstanceMng.getCurrentScreen()).collapseUnselectedRaids(null);
                                 FSRaidsScreen(InstanceMng.getCurrentScreen()).onDifficultySelected(-1);
                              }
                           }
                           FSRaidsScreen(InstanceMng.getCurrentScreen()).setSelectedRaidDef(this.mRaidDef);
                        }
                        if(this.mRaidDef)
                        {
                           InstanceMng.getPopupMng().openRaidPaymentConfirmationPopup(TextManager.getText("TID_RAID_UNLOCK_MESSAGE"),this.mRaidDef.getUnlockCost());
                        }
                     }
                  }
                  else
                  {
                     Utils.setLogText(TextManager.getText("TID_RAID_NOT_AVAILABLE"),true);
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
               }
            }
         }
         _loc2_ = param1.getTouch(this,TouchPhase.HOVER);
         alpha = _loc2_ ? 0.8 : 1;
         if(Utils.isBrowser() || Utils.isDesktop())
         {
            Mouse.cursor = _loc2_ ? "hand" : "auto";
         }
      }
      
      private function onRaidsScoresACK() : void
      {
         if(InstanceMng.getCurrentScreen() is FSRaidsScreen && InstanceMng.getCurrentScreen().isFullyLoaded())
         {
            this.setExpanded(!this.mIsExpanded);
         }
      }
      
      public function lockItem() : void
      {
         touchable = false;
      }
      
      private function getParentContainer() : ScrollContainer
      {
         var _loc1_:ScrollContainer = null;
         if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
         {
            _loc1_ = FSRaidsScreen(InstanceMng.getCurrentScreen()).getRaidsScrollContainer();
         }
         return _loc1_;
      }
      
      private function createExpandIcon() : void
      {
         if(this.mExpandIcon == null)
         {
            this.mExpandIcon = new FSImage(Root.assets.getTexture("dungeon_pointer"));
            this.mExpandIcon.alignPivot();
            this.mExpandIcon.x = this.mBG.width - this.mExpandIcon.width;
            this.mExpandIcon.y = this.mBG.height / 2;
            addChild(this.mExpandIcon);
         }
      }
      
      private function createNameTextfield() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.mNameTextfield == null && Boolean(this.mBG))
         {
            if(this.mRaidDef)
            {
               _loc2_ = this.mRaidDef.getName();
            }
            _loc2_ = _loc2_ ? _loc2_ : "";
            if(_loc2_.length > 16)
            {
               _loc1_ = _loc2_.slice(0,15);
               _loc1_ += "...";
            }
            else
            {
               _loc1_ = _loc2_;
            }
            this.mNameTextfield = new FSTextfield(this.mBG.width * 0.8,this.mBG.height * 0.4,_loc1_);
            this.mNameTextfield.format.horizontalAlign = Align.LEFT;
            this.mNameTextfield.x = this.mBG.width * 0.05;
            this.mNameTextfield.y = this.mBG.height / 2;
            this.mNameTextfield.fontSize = FSResourceMng.FONT_STD_SMALL_SIZE;
            addChild(this.mNameTextfield);
         }
      }
      
      private function createBackBG() : void
      {
         if(this.mBackBG == null)
         {
            this.mBackBG = new FSImage(Root.assets.getTexture("dungeon_base_button"));
            addChild(this.mBackBG);
         }
      }
      
      private function createRaidBG() : void
      {
         var _loc1_:String = null;
         if(this.mBG == null && Boolean(this.mBackBG))
         {
            if(this.mRaidDef != null)
            {
               if(Boolean(this.mRaidDef) && Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
               {
                  if(this.mRaidDef.getIsMultiPlayer() && InstanceMng.getUserDataMng().getOwnerUserData().isUnlockedRaid(this.mRaidDef.getSku()) || !this.mRaidDef.getIsMultiPlayer())
                  {
                     _loc1_ = this.mRaidDef.getBGImageName();
                  }
                  else
                  {
                     _loc1_ = this.mRaidDef.getBgLock();
                  }
               }
               this.mBG = new FSImage(Root.assets.getTexture(_loc1_));
               this.mBG.x = this.mBackBG.x + (this.mBackBG.width - this.mBG.width) / 2;
               this.mBG.y = this.mBackBG.y + (this.mBackBG.height - this.mBG.height) / 2;
               addChild(this.mBG);
            }
         }
      }
      
      public function isExpanded() : Boolean
      {
         return this.mIsExpanded;
      }
      
      public function setExpanded(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(this.mIsExpanded != param1)
         {
            this.mIsExpanded = param1;
            _loc2_ = this.mIsExpanded ? 90 : 0;
            SpecialFX.tweenRotate(this.mExpandIcon,0.15,0,null,_loc2_);
            this.manageDifficultySlots();
         }
      }
      
      public function onDifficultySelected(param1:int) : void
      {
         var _loc2_:FSRaidSlotDifficultyInfo = null;
         var _loc3_:int = 0;
         if(this.mDifficultySlots)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mDifficultySlots.length)
            {
               _loc2_ = this.mDifficultySlots[_loc3_];
               if(_loc2_.getDifficultyIndex() != param1)
               {
                  _loc2_.setSelected(false);
               }
               else
               {
                  _loc2_.setSelected(true);
               }
               _loc3_++;
            }
         }
      }
      
      private function manageDifficultySlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSRaidSlotDifficultyInfo = null;
         var _loc3_:FSRaidsScreen = null;
         if(this.mIsExpanded)
         {
            _loc2_ = new FSRaidSlotDifficultyInfo(this,RaidsDefMng.DIFFICULTIES_AMOUNT - 1);
         }
         else
         {
            if(this.mDifficultySlots)
            {
               _loc1_ = 0;
               while(_loc1_ < this.mDifficultySlots.length)
               {
                  _loc2_ = this.mDifficultySlots[_loc1_];
                  _loc2_.removeFromParent();
                  _loc2_.destroy();
                  _loc1_++;
               }
               this.mDifficultySlots.length = 0;
               this.mDifficultySlots = null;
            }
            if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
            {
               _loc3_ = FSRaidsScreen(InstanceMng.getCurrentScreen());
               if(_loc3_)
               {
                  _loc3_.setVisibleLadderButton(false);
                  _loc3_.removeLeftRaidCompleteInfo();
                  _loc3_.removeRaidStatus();
                  _loc3_.unlockRaidScrollContainer();
               }
            }
            this.unlockItem();
         }
         if(this.getParentContainer())
         {
            this.getParentContainer().validate();
         }
      }
      
      public function createUISlotDifficulty(param1:FSRaidSlotDifficultyInfo, param2:int) : void
      {
         var raidDifficultySlot:FSRaidSlotDifficultyInfo = null;
         var unlockRaidScrollContainer:Function = null;
         var slotDifficulty:FSRaidSlotDifficultyInfo = param1;
         var i:int = param2;
         unlockRaidScrollContainer = function():void
         {
            if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
            {
               FSRaidsScreen(InstanceMng.getCurrentScreen()).unlockRaidScrollContainer();
            }
         };
         if(slotDifficulty)
         {
            slotDifficulty.createUI();
            slotDifficulty.alpha = 0.001;
            SpecialFX.tweenToAlpha(slotDifficulty,0.999,0.15 * i,0);
            this.addRaidDifficultySlotsToScrollContainer(slotDifficulty);
            if(this.mDifficultySlots == null)
            {
               this.mDifficultySlots = new Vector.<FSRaidSlotDifficultyInfo>();
            }
            this.mDifficultySlots.push(slotDifficulty);
         }
         if(i > 0)
         {
            raidDifficultySlot = new FSRaidSlotDifficultyInfo(this,i - 1);
         }
         else if(i == 0)
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
            TweenMax.delayedCall(0.3,this.unlockChilds);
            if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
            {
               TweenMax.delayedCall(0.3,unlockRaidScrollContainer);
            }
         }
      }
      
      public function unlockItem() : void
      {
         touchable = true;
      }
      
      private function onGetRaidsFailed() : void
      {
         Utils.setLogText(TextManager.getText("TID_GUILD_TRY_AGAIN"),true);
      }
      
      private function addRaidDifficultySlotsToScrollContainer(param1:FSRaidSlotDifficultyInfo) : void
      {
         var _loc2_:ScrollContainer = null;
         var _loc3_:int = 0;
         _loc2_ = this.getParentContainer();
         if(Boolean(_loc2_) && Boolean(param1))
         {
            _loc3_ = _loc2_.getChildIndex(this) + 1;
            _loc2_.addChildAt(param1,_loc3_);
         }
      }
      
      public function getRaidDef() : RaidDef
      {
         return this.mRaidDef;
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         if(this.mBackBG)
         {
            this.mBackBG.removeFromParent(true);
            this.mBackBG = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(this.mExpandIcon)
         {
            this.mExpandIcon.removeFromParent(true);
            this.mExpandIcon = null;
         }
         if(this.mCostToUnlockIcon)
         {
            this.mCostToUnlockIcon.removeFromParent(true);
            this.mCostToUnlockIcon = null;
         }
         if(this.mCostToUnlockTextfield)
         {
            this.mCostToUnlockTextfield.removeFromParent(true);
            this.mCostToUnlockTextfield = null;
         }
         if(this.mDifficultySlots)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mDifficultySlots.length)
            {
               this.mDifficultySlots[_loc1_].removeFromParent(true);
               _loc1_++;
            }
            Utils.destroyArray(this.mDifficultySlots);
            this.mDifficultySlots = null;
         }
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
      
      public function destroy() : void
      {
         var _loc1_:int = 0;
         if(this.mBackBG)
         {
            this.mBackBG.removeFromParent();
            this.mBackBG.destroy();
            this.mBackBG = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG.destroy();
            this.mBG = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent();
            this.mNameTextfield = null;
         }
         if(this.mExpandIcon)
         {
            this.mExpandIcon.removeFromParent();
            this.mExpandIcon.destroy();
            this.mExpandIcon = null;
         }
         if(this.mCostToUnlockIcon)
         {
            this.mCostToUnlockIcon.removeFromParent();
            this.mCostToUnlockIcon.destroy();
            this.mCostToUnlockIcon = null;
         }
         if(this.mCostToUnlockTextfield)
         {
            this.mCostToUnlockTextfield.removeFromParent();
            this.mCostToUnlockTextfield = null;
         }
         if(this.mDifficultySlots)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mDifficultySlots.length)
            {
               this.mDifficultySlots[_loc1_].removeFromParent();
               this.mDifficultySlots[_loc1_].destroy();
               _loc1_++;
            }
            Utils.destroyArray(this.mDifficultySlots);
            this.mDifficultySlots = null;
         }
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      public function getRaidDifficultySlotByDifficulty(param1:int) : FSRaidSlotDifficultyInfo
      {
         var _loc2_:FSRaidSlotDifficultyInfo = null;
         var _loc3_:int = 0;
         if(this.mDifficultySlots)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mDifficultySlots.length)
            {
               if(this.mDifficultySlots[_loc3_].getDifficultyIndex() == param1)
               {
                  return this.mDifficultySlots[_loc3_];
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function unlockChilds() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this.mDifficultySlots) && this.mDifficultySlots.length == 4)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mDifficultySlots.length)
            {
               this.mDifficultySlots[_loc1_].touchable = true;
               _loc1_++;
            }
         }
      }
   }
}

