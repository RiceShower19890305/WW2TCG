package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.DeckSlotDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import feathers.controls.ScrollContainer;
   import feathers.controls.supportClasses.LayoutViewPort;
   import flash.ui.Mouse;
   import flash.utils.Dictionary;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class DeckTitleDeckSelector extends Component
   {
      
      private const BG_NAME:String = "deck_title";
      
      private const BG_ACTIVE_DECK:String = "active_deck";
      
      private const BG_INCOMPLETE_DECK:String = "incomplete_deck";
      
      private const BG_DECO_NAME:String = "icon_deck";
      
      private const LIGHT_GREEN_NAME:String = "light_green";
      
      private const LIGHT_RED_NAME:String = "light_red";
      
      private const LIGHT_OFF_NAME:String = "light_off";
      
      private const TEXT_DISABLED_COLOR:uint = 8421504;
      
      private const TEXT_ENABLED_COLOR:uint = 16777215;
      
      protected var mBG:FSImage;
      
      protected var mBGDecoration:FSImage;
      
      protected var mBGActiveDeck:FSImage;
      
      protected var mBGIncompleteDeck:FSImage;
      
      protected var mTitleTextfield:FSTextfield;
      
      protected var mDeckIndex:int;
      
      protected var mIsSelectedDeck:Boolean;
      
      protected var mIsEmpty:Boolean = true;
      
      protected var mStatusLight:FSImage;
      
      protected var mStatusTextfield:FSTextfield;
      
      private var mShowDeckStatus:Boolean;
      
      protected var mAvailable:Boolean;
      
      protected var mParentDeckSelector:DeckSelectorMini;
      
      protected var mDeckSlotDef:DeckSlotDef;
      
      protected var mIsPvP:Boolean;
      
      protected var mIsOpponent:Boolean;
      
      public function DeckTitleDeckSelector(param1:int, param2:Boolean, param3:DeckSelectorMini, param4:Boolean = false, param5:Boolean = false)
      {
         super();
         this.mIsPvP = param4;
         this.mIsOpponent = param5;
         this.mDeckSlotDef = InstanceMng.getDeckSlotsDefMng().getDeckSlotDefByIndex(param1);
         this.mDeckIndex = param1;
         this.mShowDeckStatus = param2;
         this.mParentDeckSelector = param3;
         this.init();
      }
      
      protected function init() : void
      {
         this.mAvailable = false;
         this.createBG();
         this.createBGDecoration();
         this.createTitleTextfield();
         this.createStatusLight();
         this.createStatusTextfield();
         this.addEventListeners();
         if(InstanceMng.getUserDataMng().isDeckBought(this.mDeckIndex))
         {
            if(this.mStatusLight)
            {
               SpecialFX.createYoYoAlphaTransition(this.mStatusLight,0.6,1);
            }
            if(this.mTitleTextfield)
            {
               SpecialFX.createYoYoAlphaTransition(this.mTitleTextfield,0.5,1);
            }
         }
      }
      
      protected function createStatusTextfield() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.mStatusTextfield == null)
         {
            if(InstanceMng.getUserDataMng().isDeckBought(this.mDeckIndex))
            {
               if(this.mIsEmpty)
               {
                  _loc1_ = TextManager.getText("TID_GEN_EMPTY");
               }
               else
               {
                  _loc1_ = this.mAvailable ? TextManager.getText("TID_GEN_AVAILABLE") : TextManager.getText("TID_GEN_INCOMPLETE");
               }
            }
            else
            {
               _loc1_ = TextManager.getText("TID_GEN_BUTTON_BUY");
            }
            _loc2_ = this.mBG.width * Config.getConfig().deckBuilderStatusWidthPercent();
            _loc3_ = this.mBG.height * Config.getConfig().deckBuilderStatusHeightPercent();
            this.mStatusTextfield = new FSTextfield(_loc2_,_loc3_,_loc1_,16777215);
            this.mStatusTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_DESC);
            this.mStatusTextfield.bold = true;
            this.mStatusTextfield.x = this.mBG.width * 0.13;
            this.mStatusTextfield.y = this.mStatusLight.y + 2;
            addChild(this.mStatusTextfield);
         }
      }
      
      protected function updateStatusTextfield() : void
      {
         var _loc1_:String = null;
         if(this.mStatusTextfield != null && Boolean(InstanceMng.getUserDataMng()))
         {
            if(this.mIsEmpty && !InstanceMng.getUserDataMng().isDeckBought(this.mDeckIndex))
            {
               _loc1_ = TextManager.getText("TID_GEN_BUTTON_BUY");
            }
            else
            {
               _loc1_ = this.mAvailable ? TextManager.getText("TID_GEN_AVAILABLE") : TextManager.getText("TID_GEN_INCOMPLETE");
            }
            this.mStatusTextfield.text = _loc1_ ? _loc1_.toUpperCase() : "";
         }
      }
      
      protected function createBG() : void
      {
         var _loc1_:String = null;
         var _loc2_:DeckJobConfigurator = null;
         var _loc3_:JobDef = null;
         if(this.mBG == null)
         {
            if(Config.getConfig().gameHasClassSystem())
            {
               _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(this.mDeckIndex);
               if(_loc2_)
               {
                  _loc3_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc2_.getJobSku()));
                  if(_loc3_)
                  {
                     _loc1_ = this.BG_NAME + "_" + _loc3_.getSku();
                  }
                  else
                  {
                     _loc1_ = this.BG_NAME;
                  }
               }
               else
               {
                  _loc1_ = this.BG_NAME;
               }
            }
            else
            {
               _loc1_ = this.BG_NAME;
            }
            this.mBG = new FSImage(Root.assets.getTexture(_loc1_));
            addChild(this.mBG);
         }
      }
      
      protected function createBGDecoration() : void
      {
         if(this.mBGDecoration == null)
         {
            this.mBGDecoration = new FSImage(Root.assets.getTexture(this.BG_DECO_NAME));
            this.mBGDecoration.scale = 0.75;
            this.mBGDecoration.x = this.mBG.x + (this.mBG.width - this.mBGDecoration.width);
            this.mBGDecoration.y = this.mBG.y + (this.mBG.height - this.mBGDecoration.height) / 2;
            addChild(this.mBGDecoration);
         }
      }
      
      public function createBGActiveDeck() : void
      {
         var _loc1_:int = 0;
         if(this.mBGActiveDeck == null)
         {
            this.mBGActiveDeck = new FSImage(Root.assets.getTexture(this.BG_ACTIVE_DECK));
            this.mBGActiveDeck.x = this.mBG.width * 0.9 - this.mBGActiveDeck.width;
            this.mBGActiveDeck.y = this.mBG.height * 0.95 - this.mBGActiveDeck.height;
         }
         if(this.mIsSelectedDeck)
         {
            _loc1_ = getChildIndex(this.mBG);
            addChildAt(this.mBGActiveDeck,_loc1_ + 1);
         }
         else
         {
            this.mBGActiveDeck.removeFromParent();
         }
      }
      
      protected function createTitleTextfield() : void
      {
         var _loc1_:String = null;
         if(this.mTitleTextfield == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeckName(this.mDeckIndex) ? InstanceMng.getUserDataMng().getOwnerUserData().getDeckName(this.mDeckIndex).toUpperCase() : "";
            this.mTitleTextfield = new FSTextfield(this.mBG.width * 0.8,this.mBG.height * 0.8,_loc1_,12632256);
            this.mTitleTextfield.fontName = FSResourceMng.getFontByType();
            this.mTitleTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mTitleTextfield.x = this.mBG.width * 0.1;
            this.mTitleTextfield.y = this.mBG.y + this.mBG.height * 0.25;
            addChild(this.mTitleTextfield);
         }
      }
      
      public function updateTitleTextfield() : void
      {
         var _loc1_:String = InstanceMng.getUserDataMng().getOwnerUserData().getDeckName(this.mDeckIndex);
         if(this.mTitleTextfield != null)
         {
            this.mTitleTextfield.text = _loc1_.toUpperCase();
         }
      }
      
      public function addEventListeners() : void
      {
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      protected function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            this.performOnTouchOps();
         }
         if(this.mAvailable && !this.mIsSelectedDeck)
         {
            _loc2_ = param1.getTouch(this,TouchPhase.HOVER);
            this.mBG.alpha = _loc2_ ? 0.8 : 1;
         }
         _loc2_ = param1 ? param1.getTouch(this,TouchPhase.HOVER) : null;
         if(Utils.isBrowser() || Utils.isDesktop())
         {
            Mouse.cursor = _loc2_ ? "hand" : "auto";
         }
         scaleX = _loc2_ ? 1.02 : 1;
         scaleY = _loc2_ ? 1.02 : 1;
      }
      
      protected function performOnTouchOps() : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:DeckTitleDeckSelector = null;
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
            if(this.mAvailable)
            {
               _loc4_ = _loc3_.getSelectedDeckIndex();
               if(this.mParentDeckSelector != null)
               {
                  _loc6_ = this.mParentDeckSelector.getDeckTitleByIndex(_loc4_);
                  if(_loc6_ != null)
                  {
                     _loc6_.setIsSelectedDeck(false);
                  }
               }
               _loc3_.setSelectedDeckIndex(this.mDeckIndex,true);
               _loc5_ = TextManager.getText("TID_GEN_DECK_SELECTED") + " " + _loc3_.getDeckName(this.mDeckIndex);
               Utils.setLogText(_loc5_,false,false,false);
               this.setIsSelectedDeck(true);
            }
            else if(this.isPurchasable())
            {
               if(Boolean(InstanceMng.getApplication()) && !InstanceMng.getApplication().hasPermanentBoosts())
               {
                  Utils.setLogText(TextManager.getText("TID_GEN_OS_FEATURE"),true);
               }
               else if(InstanceMng.getPopupMng().getPopupShown())
               {
                  InstanceMng.getPopupMng().getPopupShown().hideTemporarily(InstanceMng.getPopupMng().openDeckSlotPopup,[this.mDeckSlotDef]);
               }
               else
               {
                  InstanceMng.getPopupMng().openDeckSlotPopup(this.mDeckSlotDef);
               }
            }
            else
            {
               _loc7_ = _loc3_.getDecksPurchasedAmount();
               if(this.mDeckIndex > _loc7_ + Config.getConfig().getDefaultAvailableDecksAmount())
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
      
      public function setIsEmpty(param1:Boolean) : void
      {
         this.mIsEmpty = param1;
         if(this.mTitleTextfield != null)
         {
            this.mTitleTextfield.color = param1 ? this.TEXT_DISABLED_COLOR : this.TEXT_ENABLED_COLOR;
         }
         if(!this.mIsEmpty && InstanceMng.getUserDataMng().isDeckBought(this.mDeckIndex))
         {
            this.mAvailable = this.isSizeCorrect();
         }
         this.updateStatusLight();
         this.updateStatusTextfield();
         this.updateIncompleteBG();
      }
      
      protected function createStatusLight() : void
      {
         if(this.mStatusLight == null)
         {
            this.mStatusLight = new FSImage(Root.assets.getTexture(this.LIGHT_OFF_NAME));
         }
         this.mStatusLight.y = this.mStatusLight.height * 0.1;
         addChild(this.mStatusLight);
      }
      
      protected function updateStatusLight() : void
      {
         var _loc1_:String = null;
         if(this.mStatusLight == null)
         {
            this.createStatusLight();
         }
         if(this.mIsEmpty && !InstanceMng.getUserDataMng().isDeckBought(this.mDeckIndex))
         {
            _loc1_ = this.LIGHT_OFF_NAME;
         }
         else if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc1_ = this.mAvailable ? this.LIGHT_GREEN_NAME : this.LIGHT_RED_NAME;
         }
         else
         {
            _loc1_ = this.mIsSelectedDeck ? this.LIGHT_GREEN_NAME : this.LIGHT_RED_NAME;
         }
         this.mStatusLight.texture = Root.assets.getTexture(_loc1_);
      }
      
      protected function isSizeCorrect() : Boolean
      {
         var _loc2_:Dictionary = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Boolean = false;
         var _loc5_:DeckJobConfigurator = null;
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_)
         {
            _loc2_ = _loc1_.getDeck(this.mDeckIndex);
            _loc3_ = _loc1_.getCardCollection();
            _loc4_ = true;
            if(Config.getConfig().gameHasClassSystem())
            {
               _loc5_ = _loc1_.getDeckJobConfiguratorByDeck(this.mDeckIndex);
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
         return _loc4_ && DictionaryUtils.checkIfDeckSizeCorrect(_loc2_,_loc3_);
      }
      
      public function getIsSelectedDeck() : Boolean
      {
         return this.mIsSelectedDeck;
      }
      
      public function setIsSelectedDeck(param1:Boolean) : void
      {
         this.mIsSelectedDeck = param1;
         if(this.mIsSelectedDeck)
         {
            this.mParentDeckSelector.setUISelectedDeckIndex(this.mDeckIndex);
         }
         this.createBGActiveDeck();
         this.updateStatusLight();
         this.updateIncompleteBG();
      }
      
      protected function updateIncompleteBG() : void
      {
         var _loc1_:int = 0;
         if(this.mBGIncompleteDeck == null)
         {
            this.mBGIncompleteDeck = new FSImage(Root.assets.getTexture(this.BG_INCOMPLETE_DECK));
            this.mBGIncompleteDeck.x = this.mBG.width * 0.9 - this.mBGActiveDeck.width;
            this.mBGIncompleteDeck.y = this.mBG.height * 0.95 - this.mBGActiveDeck.height;
         }
         if(!this.mIsEmpty && InstanceMng.getUserDataMng().isDeckBought(this.mDeckIndex))
         {
            if(!this.mAvailable)
            {
               _loc1_ = this.mIsSelectedDeck ? getChildIndex(this.mBGActiveDeck) : getChildIndex(this.mBG);
               addChildAt(this.mBGIncompleteDeck,_loc1_ + 1);
            }
            else
            {
               this.mBGIncompleteDeck.removeFromParent();
            }
         }
         else
         {
            this.mBGIncompleteDeck.removeFromParent();
         }
      }
      
      public function getDeckIndex() : int
      {
         return this.mDeckIndex;
      }
      
      public function setDeckIndex(param1:int) : void
      {
         this.mDeckIndex = param1;
      }
      
      public function getProdId() : String
      {
         return this.mDeckSlotDef.getProdId();
      }
      
      public function isPurchasable() : Boolean
      {
         var _loc1_:int = InstanceMng.getUserDataMng().getOwnerUserData().getDecksPurchasedAmount();
         return this.mDeckIndex == _loc1_ + Config.getConfig().getDefaultAvailableDecksAmount();
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
         if(this.mBGDecoration)
         {
            this.mBGDecoration.removeFromParent(true);
            this.mBGDecoration = null;
         }
         if(this.mBGActiveDeck)
         {
            this.mBGActiveDeck.removeFromParent(true);
            this.mBGActiveDeck = null;
         }
         if(this.mBGIncompleteDeck)
         {
            this.mBGIncompleteDeck.removeFromParent(true);
            this.mBGIncompleteDeck = null;
         }
         if(this.mStatusLight)
         {
            this.mStatusLight.removeFromParent(true);
            this.mStatusLight = null;
         }
         if(this.mStatusTextfield)
         {
            this.mStatusTextfield.removeFromParent(true);
            this.mStatusTextfield = null;
         }
         this.mParentDeckSelector = null;
         this.mDeckSlotDef = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
      
      public function updateBG() : void
      {
         var _loc1_:String = null;
         var _loc2_:DeckJobConfigurator = null;
         var _loc3_:JobDef = null;
         if(this.mBG)
         {
            if(Config.getConfig().gameHasClassSystem())
            {
               _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(this.mDeckIndex);
               if(_loc2_)
               {
                  _loc3_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc2_.getJobSku()));
                  if(_loc3_)
                  {
                     _loc1_ = this.BG_NAME + "_" + _loc3_.getSku();
                  }
                  else
                  {
                     _loc1_ = this.BG_NAME;
                  }
               }
               else
               {
                  _loc1_ = this.BG_NAME;
               }
            }
            else
            {
               _loc1_ = this.BG_NAME;
            }
            this.mBG.texture = Root.assets.getTexture(_loc1_);
         }
      }
   }
}

