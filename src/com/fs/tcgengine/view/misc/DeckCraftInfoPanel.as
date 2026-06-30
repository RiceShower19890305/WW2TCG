package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.buttons.SubcategoryToggleButton;
   import com.fs.tcgengine.view.components.misc.FSCurrencyVisor;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.FlowLayout;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalAlign;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class DeckCraftInfoPanel extends DeckSelector
   {
      
      private var mCraftFilterTextfield:FSTextfield;
      
      private var mCraftFilterButton:SubcategoryToggleButton;
      
      private var mAllCardsMaterialsDefs:Vector.<CardDef>;
      
      private var mCardMaterialsVector:Vector.<FSCurrencyVisor>;
      
      private var mCurrenciesTextfield:FSTextfield;
      
      private var mCraftInfoTextfield:FSTextfield;
      
      private var mCurrenciesContainer:ScrollContainer;
      
      public function DeckCraftInfoPanel()
      {
         super();
      }
      
      override protected function createDeckTitle(param1:int, param2:Boolean = false) : DeckTitleDeckSelector
      {
         return null;
      }
      
      override protected function showUserDecks(param1:int) : void
      {
      }
      
      override protected function init(param1:Number = 5) : void
      {
         super.init(param1);
         this.createCraftFilterButton();
         this.createCraftInfo();
         this.createMaterialsTitle();
         this.fillCraftMaterials();
      }
      
      private function createCraftInfo() : void
      {
         if(this.mCraftInfoTextfield == null)
         {
            this.mCraftInfoTextfield = new FSTextfield(width * 0.75,this.mCraftFilterButton.height * 2,TextManager.getText("TID_DB_CRAFT_INFO"),16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mCraftInfoTextfield.x = (width - this.mCraftInfoTextfield.width) / 2;
            this.mCraftInfoTextfield.y = this.mCraftFilterButton.y + this.mCraftFilterButton.height;
            addChild(this.mCraftInfoTextfield);
         }
      }
      
      private function createMaterialsTitle() : void
      {
         if(this.mCurrenciesTextfield == null)
         {
            this.mCurrenciesTextfield = new FSTextfield(this.mCraftInfoTextfield.width,this.mCraftFilterButton.height * 0.5,TextManager.getText("TID_DB_CRAFT_MATERIAL"),16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
            this.mCurrenciesTextfield.format.verticalAlign = Align.BOTTOM;
            this.mCurrenciesTextfield.x = (width - this.mCurrenciesTextfield.width) / 2;
            this.mCurrenciesTextfield.y = this.mCraftInfoTextfield.y + this.mCraftInfoTextfield.height * 1.05;
            addChild(this.mCurrenciesTextfield);
         }
      }
      
      private function createCraftFilterButton() : void
      {
         if(FSDeckBuilderScreen.CRAFT_MODE_ON)
         {
            if(this.mCraftFilterButton == null)
            {
               this.mCraftFilterButton = new SubcategoryToggleButton("db_button_craft_available_on","db_button_craft_available_off");
               this.mCraftFilterButton.setTooltipText(TextManager.getText("TID_FILTER_CRAFT_AVAILABLE"));
               this.mCraftFilterButton.addEventListener(TouchEvent.TOUCH,this.onCraftToggleTouch);
               this.mCraftFilterButton.x = (width - this.mCraftFilterButton.width) / 2;
               this.mCraftFilterButton.y = this.mCraftFilterButton.height / 2;
               addChild(this.mCraftFilterButton);
            }
            if(this.mCraftFilterTextfield == null)
            {
               this.mCraftFilterTextfield = new FSTextfield(this.mCraftFilterButton.width * 0.8,this.mCraftFilterButton.height * 0.7,TextManager.getText("TID_CRAFT_ONLY"),16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
               this.mCraftFilterTextfield.x = this.mCraftFilterButton.x + this.mCraftFilterTextfield.width * 0.1;
               this.mCraftFilterTextfield.y = this.mCraftFilterButton.y + this.mCraftFilterTextfield.height * 0.2;
               addChild(this.mCraftFilterTextfield);
            }
         }
      }
      
      private function onCraftToggleTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(!Root.assets.isLoading)
         {
            _loc2_ = param1.getTouch(this,TouchPhase.ENDED);
            if(_loc2_)
            {
               if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
               {
                  _loc3_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).isCraftFilterON();
                  if(_loc3_)
                  {
                     FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).setCraftFilterON(false);
                  }
                  else
                  {
                     _loc4_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getEdidionStatus() == FSDeckBuilderScreen.STATUS_CREATION_MODE;
                     _loc5_ = !FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).isViewAllCardsModeON();
                     FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).setCraftFilterON(_loc4_ && _loc5_);
                  }
                  FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).resetContainerAndFill();
               }
            }
         }
      }
      
      public function setCraftFilterButtonVisible(param1:Boolean) : void
      {
         if(Boolean(this.mCraftFilterButton) && Boolean(this.mCraftFilterTextfield))
         {
            this.mCraftFilterButton.visible = param1;
            this.mCraftFilterTextfield.visible = param1;
            if(param1 && FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getIsAnyCardCrafteable())
            {
               this.mCraftFilterButton.showDeckNotificationIcon();
            }
         }
      }
      
      public function isCraftButtonToggled() : Boolean
      {
         return this.mCraftFilterButton.isToggled();
      }
      
      public function setCraftButtonToggled() : void
      {
         this.mCraftFilterButton.setToggled();
      }
      
      public function getCraftFilterButton() : SubcategoryToggleButton
      {
         return this.mCraftFilterButton;
      }
      
      private function fillCraftMaterials() : void
      {
         var _loc1_:CardDef = null;
         var _loc2_:FSCurrencyVisor = null;
         var _loc3_:int = 0;
         if(this.mAllCardsMaterialsDefs == null)
         {
            this.mAllCardsMaterialsDefs = InstanceMng.getCardsDefMng().getAllCardsMaterials();
         }
         if(this.mCardMaterialsVector == null)
         {
            this.mCardMaterialsVector = new Vector.<FSCurrencyVisor>();
            if(this.mAllCardsMaterialsDefs)
            {
               _loc3_ = 0;
               while(_loc3_ < this.mAllCardsMaterialsDefs.length)
               {
                  _loc1_ = this.mAllCardsMaterialsDefs[_loc3_];
                  if(_loc1_)
                  {
                     _loc2_ = new FSCurrencyVisor(ServerConnection.CURRENCY_CRAFT_MATERIAL,_loc1_.getSku());
                     this.mCardMaterialsVector.push(_loc2_);
                     this.addItemIntoContainer(_loc2_);
                  }
                  _loc3_++;
               }
            }
         }
         else
         {
            this.refreshCurrencyVisors();
         }
      }
      
      private function addItemIntoContainer(param1:FSCurrencyVisor) : void
      {
         var _loc2_:int = 0;
         if(this.mCurrenciesContainer == null)
         {
            _loc2_ = param1.width * 2;
            this.mCurrenciesContainer = new ScrollContainer();
            this.mCurrenciesContainer.x = (width - _loc2_) / 2;
            this.mCurrenciesContainer.y = this.mCurrenciesTextfield.y + this.mCurrenciesTextfield.height * 1.1;
            this.mCurrenciesContainer.layout = this.getContainerLayout();
            this.mCurrenciesContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mCurrenciesContainer.verticalScrollPolicy = ScrollPolicy.ON;
            this.mCurrenciesContainer.width = _loc2_ * 1.05;
            this.mCurrenciesContainer.height = height * 0.9 - (this.mCurrenciesTextfield.y + this.mCurrenciesTextfield.height);
            addChild(this.mCurrenciesContainer);
         }
         this.mCurrenciesContainer.addChild(param1);
      }
      
      private function getContainerLayout() : FlowLayout
      {
         var _loc1_:FlowLayout = new FlowLayout();
         _loc1_.verticalAlign = VerticalAlign.TOP;
         _loc1_.horizontalAlign = HorizontalAlign.LEFT;
         return _loc1_;
      }
      
      public function refreshCurrencyVisors() : void
      {
         var _loc1_:FSCurrencyVisor = null;
         var _loc2_:int = 0;
         if(this.mCardMaterialsVector)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mCardMaterialsVector.length)
            {
               _loc1_ = this.mCardMaterialsVector[_loc2_];
               if(_loc1_)
               {
                  _loc1_.refreshCurrencyAmount(true);
               }
               _loc2_++;
            }
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSCurrencyVisor = null;
         if(this.mCraftFilterTextfield)
         {
            this.mCraftFilterTextfield.removeFromParent(true);
            this.mCraftFilterTextfield = null;
         }
         if(this.mCraftFilterButton)
         {
            this.mCraftFilterButton.removeFromParent(true);
            this.mCraftFilterButton = null;
         }
         Utils.destroyArray(this.mAllCardsMaterialsDefs);
         this.mAllCardsMaterialsDefs = null;
         if(this.mCardMaterialsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mCardMaterialsVector.length)
            {
               _loc2_ = this.mCardMaterialsVector[_loc1_];
               if(_loc2_)
               {
                  _loc2_.removeFromParent(true);
                  _loc2_ = null;
               }
               _loc1_++;
            }
            Utils.destroyArray(this.mCardMaterialsVector);
            this.mCardMaterialsVector = null;
         }
         if(this.mCurrenciesTextfield)
         {
            this.mCurrenciesTextfield.removeFromParent(true);
            this.mCurrenciesTextfield = null;
         }
         if(this.mCraftInfoTextfield)
         {
            this.mCraftInfoTextfield.removeFromParent(true);
            this.mCraftInfoTextfield = null;
         }
         if(this.mCurrenciesContainer)
         {
            this.mCurrenciesContainer.removeChildren(0,-1,true);
            this.mCurrenciesContainer.removeFromParent(true);
            this.mCurrenciesContainer = null;
         }
         super.dispose();
      }
   }
}

