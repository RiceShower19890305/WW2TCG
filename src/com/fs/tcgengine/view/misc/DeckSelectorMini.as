package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.VerticalLayout;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   
   public class DeckSelectorMini extends Component implements FSModelUnloadableInterface
   {
      
      public static const BG_DECK_CLASS_SYSTEM_SELECTOR_ON:String = "choose_deck_layer_on";
      
      public static const BG_DECK_CLASS_SYSTEM_SELECTOR_OFF:String = "choose_deck_layer_off";
      
      private static const BASIC_DECK:String = "basic";
      
      private static const CUSTOM_DECK:String = "custom";
      
      protected var mBG:CustomComponent;
      
      protected var mTitleTextfield:FSTextfield;
      
      private var mDeckTitlesCatalog:Dictionary;
      
      protected var mIsPvP:Boolean;
      
      protected var mIsOpponent:Boolean;
      
      protected var mScrollableContainer:ScrollContainer;
      
      protected var mSelectedDeckIndex:int;
      
      public function DeckSelectorMini(param1:Boolean = false, param2:Boolean = false, param3:Number = 5)
      {
         super();
         this.mIsPvP = param1;
         this.mIsOpponent = param2;
         this.init(param3);
      }
      
      protected function init(param1:Number = 5) : void
      {
         this.createBG();
         this.createTitle(param1);
         this.showUserDecks(param1);
      }
      
      protected function getSelectedDeckIndex() : int
      {
         return InstanceMng.getUserDataMng().getOwnerUserData().getSelectedDeckIndex();
      }
      
      protected function showUserDecks(param1:int) : void
      {
         var _loc3_:FSCoordinate = null;
         var _loc4_:DeckTitleDeckSelector = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(_loc2_ != null)
         {
            _loc6_ = this.mTitleTextfield != null ? int(this.mTitleTextfield.height) : 0;
            _loc7_ = this.getSelectedDeckIndex();
            _loc5_ = 0;
            while(_loc5_ < Config.getConfig().getMaxDecksAmount())
            {
               _loc4_ = this.createDeckTitle(_loc5_,true);
               _loc4_.setIsSelectedDeck(_loc5_ == _loc7_);
               this.addDeckInContainer(_loc4_,param1);
               if(this.mDeckTitlesCatalog == null)
               {
                  this.mDeckTitlesCatalog = new Dictionary(true);
               }
               this.mDeckTitlesCatalog[_loc5_] = _loc4_;
               _loc5_++;
            }
         }
      }
      
      private function addDeckInContainer(param1:DeckTitleDeckSelector, param2:int = 0) : void
      {
         if(this.mScrollableContainer == null)
         {
            this.mScrollableContainer = new ScrollContainer();
            this.mScrollableContainer.name = "scrollContainer";
            this.mScrollableContainer.layout = this.getContainerLayout();
            this.mScrollableContainer.width = param1.width * 1.1;
            this.mScrollableContainer.height = this.mBG.height - param1.height * 1.3 - param2;
            this.mScrollableContainer.x = this.getDecksPositionX(param1);
            this.mScrollableContainer.y = param1.height / 1.8 + param2;
            addChild(this.mScrollableContainer);
         }
         this.mScrollableContainer.addChild(param1);
      }
      
      private function getContainerLayout() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 0;
         this.mScrollableContainer.layout = _loc1_;
         this.mScrollableContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
         return _loc1_;
      }
      
      protected function getDecksPositionX(param1:DeckTitleDeckSelector) : Number
      {
         return (this.mBG.width - param1.width) / 2;
      }
      
      protected function createDeckTitle(param1:int, param2:Boolean = false) : DeckTitleDeckSelector
      {
         return new DeckTitleDeckSelector(param1,param2,this);
      }
      
      public function refresh() : void
      {
         var _loc1_:FSCoordinate = null;
         var _loc2_:DeckTitleDeckSelector = null;
         var _loc3_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:JobDef = null;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc4_:UserData = Utils.getOwnerUserData();
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_.getTotalDeckArr();
            if(_loc5_ != null)
            {
               _loc3_ = 0;
               while(_loc3_ < Config.getConfig().getMaxDecksAmount())
               {
                  if(InstanceMng.getUserDataMng().isDeckBought(_loc3_))
                  {
                     _loc2_ = this.mDeckTitlesCatalog ? this.mDeckTitlesCatalog[_loc3_] : null;
                     if(_loc2_ != null)
                     {
                        _loc2_.setIsEmpty(false);
                     }
                  }
                  _loc3_++;
               }
            }
            if(Config.getConfig().gameHasClassSystem())
            {
               _loc8_ = InstanceMng.getJobsDefMng().getBasicsJobDef();
               _loc9_ = 0;
               _loc9_ = 0;
               while(_loc9_ < _loc8_.length)
               {
                  _loc6_ = JobDef(_loc8_[_loc9_]);
                  _loc7_ = int(_loc6_.getBasicDeckSku());
                  _loc2_ = this.mDeckTitlesCatalog ? this.mDeckTitlesCatalog[_loc7_] : null;
                  if(_loc2_ != null)
                  {
                     _loc10_ = DeckTitleDeckSelectorJob(_loc2_).getJobDef().getUnlockLevel();
                     _loc11_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
                     _loc12_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc11_);
                     if(_loc10_ <= _loc12_)
                     {
                        DeckTitleDeckSelectorJob(_loc2_).setAvailable(true);
                     }
                  }
                  _loc9_++;
               }
            }
         }
      }
      
      protected function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = Utils.createCustomBox(DeckCardsPanel.DECK_PANEL_NAME,DeckCardsPanel.DECK_PANEL_WIDTH);
            addChild(this.mBG);
         }
      }
      
      protected function createTitle(param1:Number = 5) : void
      {
         if(this.mTitleTextfield == null)
         {
            this.mTitleTextfield = new FSTextfield(this.mBG.width * 0.8,this.mBG.height / 9,TextManager.getText("TID_LEVEL_DECK_CHOOSE"),16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mTitleTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mTitleTextfield.x = (this.mBG.width - this.mTitleTextfield.width) / 2;
            this.mTitleTextfield.y = param1;
            addChild(this.mTitleTextfield);
         }
      }
      
      public function getDeckTitlesCatalog() : Dictionary
      {
         return this.mDeckTitlesCatalog;
      }
      
      public function setDeckTitlesCatalog(param1:Dictionary) : void
      {
         this.mDeckTitlesCatalog = param1;
      }
      
      public function getDeckTitleByIndex(param1:int) : DeckTitleDeckSelector
      {
         var _loc2_:DeckTitleDeckSelector = null;
         if(this.mDeckTitlesCatalog != null)
         {
            _loc2_ = this.mDeckTitlesCatalog[param1];
         }
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mScrollableContainer)
         {
            this.mScrollableContainer.removeFromParent(true);
            this.mScrollableContainer = null;
         }
         this.mDeckTitlesCatalog = null;
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent();
            this.mTitleTextfield = null;
         }
         if(this.mScrollableContainer)
         {
            this.mScrollableContainer.removeFromParent();
            this.mScrollableContainer = null;
         }
         this.mDeckTitlesCatalog = null;
      }
      
      public function setUISelectedDeckIndex(param1:int) : void
      {
         this.mSelectedDeckIndex = param1;
      }
      
      public function getUISelectedDeckIndex() : int
      {
         return this.mSelectedDeckIndex;
      }
      
      public function movePanelDown(param1:Function) : void
      {
         var _loc2_:FSDeckBuilderScreen = null;
         var _loc3_:FSCoordinate = null;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc2_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            _loc2_.lockUI(true);
            _loc2_.showRecycleButton(false);
            _loc2_.showDeckTitle(false);
            _loc3_ = new FSCoordinate(x,Starling.current.stage.stageHeight);
            SpecialFX.createTransition(this,_loc3_,0.5,0,param1);
            Utils.playSound(Constants.SOUND_PANEL_DOWN,SoundManager.TYPE_SFX);
         }
      }
   }
}

