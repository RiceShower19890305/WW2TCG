package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.rules.DungeonsDefMng;
   import com.fs.tcgengine.model.rules.DungeonDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import feathers.controls.ScrollContainer;
   import feathers.controls.supportClasses.LayoutViewPort;
   import flash.ui.Mouse;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class FSDungeonSlotInfo extends Component
   {
      
      protected var mBackBG:FSImage;
      
      protected var mBG:FSImage;
      
      private var mNameTextfield:FSTextfield;
      
      protected var mExpandIcon:FSImage;
      
      protected var mDungeonDef:DungeonDef;
      
      private var mIsExpanded:Boolean = false;
      
      private var mDifficultySlots:Vector.<FSDungeonSlotDifficultyInfo>;
      
      public function FSDungeonSlotInfo(param1:String)
      {
         super();
         this.mDungeonDef = DungeonDef(InstanceMng.getDungeonsDefMng().getDefBySku(param1));
         this.init();
      }
      
      private function init() : void
      {
         if(this.mDungeonDef)
         {
            this.createBackBG();
            this.createDungeonBG();
            this.createNameTextfield();
            this.createExpandIcon();
         }
         this.addEventListeners();
      }
      
      private function addEventListeners() : void
      {
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            _loc3_ = parent != null && parent is LayoutViewPort && parent.parent is ScrollContainer && ScrollContainer(parent.parent).isScrolling;
            if(_loc3_)
            {
               return;
            }
            if(!Root.assets.isLoading)
            {
               FSDebug.debugTrace("Slot Click");
               if(InstanceMng.getCurrentScreen() is FSDungeonsScreen)
               {
                  FSDungeonsScreen(InstanceMng.getCurrentScreen()).fillInfoByDungeon(this.mDungeonDef,this);
                  this.setExpanded(!this.mIsExpanded);
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
      
      private function getParentContainer() : ScrollContainer
      {
         return InstanceMng.getCurrentScreen() is FSDungeonsScreen ? FSDungeonsScreen(InstanceMng.getCurrentScreen()).getDungeonsScrollContainer() : null;
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
            _loc2_ = this.mDungeonDef.getName();
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
      
      private function createDungeonBG() : void
      {
         if(this.mBG == null)
         {
            if(this.mDungeonDef != null)
            {
               this.mBG = new FSImage(Root.assets.getTexture(this.mDungeonDef.getBGImageName()));
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
         var _loc2_:FSDungeonSlotDifficultyInfo = null;
         var _loc3_:int = 0;
         if(this.mDifficultySlots)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mDifficultySlots.length)
            {
               _loc2_ = this.mDifficultySlots[_loc3_];
               if(_loc2_)
               {
                  if(_loc2_.getDifficultyIndex() != param1)
                  {
                     _loc2_.setSelected(false);
                  }
                  else
                  {
                     _loc2_.setSelected(true);
                  }
               }
               _loc3_++;
            }
         }
      }
      
      private function manageDifficultySlots() : void
      {
         var _loc1_:* = 0;
         var _loc2_:FSDungeonSlotDifficultyInfo = null;
         var _loc3_:Array = null;
         if(this.mDungeonDef == null)
         {
            return;
         }
         if(this.mIsExpanded)
         {
            _loc1_ = int(DungeonsDefMng.DIFFICULTIES_AMOUNT - 1);
            while(_loc1_ > -1)
            {
               _loc3_ = this.mDungeonDef.getLevelsByDifficultyIndex(_loc1_);
               if(Boolean(_loc3_) && _loc3_.length > 0)
               {
                  _loc2_ = new FSDungeonSlotDifficultyInfo(this,_loc1_);
                  _loc2_.alpha = 0.001;
                  SpecialFX.tweenToAlpha(_loc2_,0.999,0.15 * _loc1_,0);
                  this.addDungeonDifficultySlotsToScrollContainer(_loc2_);
                  if(this.mDifficultySlots == null)
                  {
                     this.mDifficultySlots = new Vector.<FSDungeonSlotDifficultyInfo>();
                  }
                  this.mDifficultySlots.push(_loc2_);
               }
               _loc1_--;
            }
         }
         else if(this.mDifficultySlots)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mDifficultySlots.length)
            {
               _loc2_ = this.mDifficultySlots[_loc1_];
               if(_loc2_)
               {
                  _loc2_.removeFromParent();
                  _loc2_.destroy();
               }
               _loc1_++;
            }
            this.mDifficultySlots.length = 0;
            this.mDifficultySlots = null;
         }
         if(this.getParentContainer())
         {
            this.getParentContainer().validate();
         }
      }
      
      private function addDungeonDifficultySlotsToScrollContainer(param1:FSDungeonSlotDifficultyInfo) : void
      {
         var _loc2_:ScrollContainer = this.getParentContainer();
         var _loc3_:int = _loc2_.getChildIndex(this) + 1;
         _loc2_.addChildAt(param1,_loc3_);
      }
      
      public function getDungeonDef() : DungeonDef
      {
         return this.mDungeonDef;
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
         this.mDungeonDef = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
   }
}

