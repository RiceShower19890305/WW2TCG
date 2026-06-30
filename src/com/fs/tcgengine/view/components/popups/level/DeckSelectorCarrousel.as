package com.fs.tcgengine.view.components.popups.level
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.HorizontalLayout;
   import starling.events.Event;
   
   public class DeckSelectorCarrousel extends Component
   {
      
      public static const TYPE_BASIC:int = 0;
      
      public static const TYPE_CUSTOM:int = 1;
      
      private var mContainer:ScrollContainer;
      
      private var mLabel:FSTextfield;
      
      private var mNextButton:FSButton;
      
      private var mPreviousButton:FSButton;
      
      private var mType:int;
      
      public function DeckSelectorCarrousel(param1:int)
      {
         super();
         this.mType = param1;
         this.createUI();
         alignPivot();
      }
      
      private function createUI() : void
      {
         this.createSlots();
         this.createLabel();
         this.createArrows();
      }
      
      private function createArrows() : void
      {
         var _loc1_:int = 0;
         if(this.mType == TYPE_CUSTOM)
         {
            _loc1_ = Config.getConfig().getMaxDecksAmount();
            if(_loc1_ > 5)
            {
               this.mContainer.validate();
               if(this.mPreviousButton == null)
               {
                  this.mPreviousButton = new FSButton(Root.assets.getTexture("arrow_button_left"));
                  this.mPreviousButton.x = this.mContainer.x - this.mPreviousButton.width;
                  this.mPreviousButton.y = this.mContainer.y + this.mPreviousButton.height / 2;
                  this.mPreviousButton.addEventListener(Event.TRIGGERED,this.onPrev);
                  addChild(this.mPreviousButton);
               }
               if(this.mNextButton == null)
               {
                  this.mNextButton = new FSButton(Root.assets.getTexture("arrow_button_right"));
                  this.mNextButton.x = this.mContainer.x + this.mContainer.width + this.mNextButton.width;
                  this.mNextButton.y = this.mContainer.y + this.mNextButton.height / 2;
                  this.mNextButton.addEventListener(Event.TRIGGERED,this.onNext);
                  addChild(this.mNextButton);
               }
            }
         }
         this.refreshArrowsState();
      }
      
      private function onPrev(param1:Event) : void
      {
         if(this.mContainer)
         {
            this.mContainer.scrollToPageIndex(0,0);
            this.refreshArrowsState();
         }
      }
      
      private function onNext(param1:Event) : void
      {
         if(this.mContainer)
         {
            this.mContainer.scrollToPageIndex(1,0);
            this.refreshArrowsState();
         }
      }
      
      private function refreshArrowsState() : void
      {
         if(this.mPreviousButton)
         {
            this.mPreviousButton.enabled = this.mContainer.horizontalPageIndex > 0;
            this.mPreviousButton.alpha = this.mPreviousButton.enabled ? 1 : 0.5;
         }
         if(this.mNextButton)
         {
            this.mNextButton.enabled = !this.mPreviousButton.enabled;
            this.mNextButton.alpha = this.mNextButton.enabled ? 1 : 0.5;
         }
      }
      
      private function createSlots() : void
      {
         var _loc1_:JobDef = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:DeckSlotCarrousel = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData().getSelectedDeckIndex();
         if(this.mType == TYPE_BASIC)
         {
            _loc3_ = InstanceMng.getJobsDefMng().getBasicsJobDef();
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc1_ = _loc3_[_loc4_];
               _loc5_ = int(_loc1_.getBasicDeckSku());
               _loc7_ = DeckSlotCarrousel.STATE_UNSELECTED;
               _loc6_ = new DeckSlotCarrousel(_loc5_,_loc7_,this.mType);
               _loc6_.name = "deckTitle_" + _loc5_;
               _loc6_.setIsSelectedDeck(_loc5_ == _loc2_);
               if(_loc5_ == _loc2_)
               {
                  InstanceMng.getUserDataMng().getOwnerUserData().setSelectedDeckIndex(_loc5_);
                  if(_loc5_ >= Config.getConfig().getMaxDecksAmount())
                  {
                     InstanceMng.getUserDataMng().getOwnerUserData().setDeck(InstanceMng.getUserDataMng().getOwnerUserData().createBestBasicDeckConfiguration(_loc1_),_loc5_);
                  }
               }
               this.addDeckInContainer(_loc6_);
               _loc4_++;
            }
         }
         else
         {
            _loc8_ = Config.getConfig().getMaxDecksAmount();
            _loc9_ = Config.getConfig().gameHasClassSystem();
            _loc4_ = 0;
            while(_loc4_ < _loc8_)
            {
               _loc7_ = DeckSlotCarrousel.STATE_UNSELECTED;
               _loc6_ = new DeckSlotCarrousel(_loc4_,_loc7_,this.mType);
               _loc6_.setIsSelectedDeck(_loc4_ == _loc2_);
               if(_loc4_ == _loc2_)
               {
                  InstanceMng.getUserDataMng().getOwnerUserData().setSelectedDeckIndex(_loc4_);
               }
               this.addDeckInContainer(_loc6_);
               _loc4_++;
            }
         }
      }
      
      private function addDeckInContainer(param1:DeckSlotCarrousel) : void
      {
         if(this.mContainer == null)
         {
            this.mContainer = new ScrollContainer();
            this.mContainer.name = "scrollContainer";
            this.mContainer.layout = this.getContainerLayout();
            this.mContainer.width = param1.width * 5;
            this.mContainer.height = param1.height;
            addChild(this.mContainer);
         }
         this.mContainer.addChild(param1);
      }
      
      private function getContainerLayout() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         this.mContainer.horizontalScrollPolicy = this.mType == TYPE_CUSTOM ? ScrollPolicy.ON : ScrollPolicy.OFF;
         this.mContainer.snapToPages = true;
         return _loc1_;
      }
      
      private function createLabel() : void
      {
         var _loc1_:String = null;
         if(this.mLabel == null)
         {
            _loc1_ = this.mType == TYPE_BASIC ? TextManager.getText("TID_GEN_BASIC_DECK") : TextManager.getText("TID_GEN_CUSTOM_DECK");
            this.mLabel = new FSTextfield(this.mContainer.width,50,_loc1_);
            this.mLabel.alignPivot();
            this.mLabel.x = this.mContainer.width / 2;
            this.mLabel.y = this.mContainer.y - this.mLabel.height / 2;
            addChild(this.mLabel);
         }
      }
      
      public function onDeckSelectionChanged(param1:int, param2:int) : void
      {
         var _loc3_:DeckSlotCarrousel = null;
         var _loc4_:int = 0;
         if(this.mContainer)
         {
            touchable = false;
            _loc4_ = 0;
            while(_loc4_ < this.mContainer.numChildren)
            {
               _loc3_ = this.mContainer.getChildAt(_loc4_) is DeckSlotCarrousel ? DeckSlotCarrousel(this.mContainer.getChildAt(_loc4_)) : null;
               if(Boolean(_loc3_) && _loc3_.getIndex() == param1)
               {
                  _loc3_.refreshState(DeckSlotCarrousel.STATE_UNSELECTED);
               }
               if(Boolean(_loc3_) && _loc3_.getIndex() == param2)
               {
                  _loc3_.refreshState(DeckSlotCarrousel.STATE_SELECTED);
               }
               _loc4_++;
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mContainer)
         {
            this.mContainer.removeChildren(0,-1,true);
            this.mContainer.removeFromParent(true);
            this.mContainer = null;
         }
         if(this.mLabel)
         {
            this.mLabel.removeFromParent(true);
            this.mLabel = null;
         }
         if(this.mNextButton)
         {
            this.mNextButton.removeEventListener(Event.TRIGGERED,this.onNext);
            this.mNextButton.removeFromParent();
            this.mNextButton.destroy();
            this.mNextButton = null;
         }
         if(this.mPreviousButton)
         {
            this.mPreviousButton.removeEventListener(Event.TRIGGERED,this.onPrev);
            this.mPreviousButton.removeFromParent();
            this.mPreviousButton.destroy();
            this.mPreviousButton = null;
         }
         super.dispose();
      }
   }
}

