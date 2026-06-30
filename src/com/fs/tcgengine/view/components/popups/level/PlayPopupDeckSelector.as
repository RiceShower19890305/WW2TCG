package com.fs.tcgengine.view.components.popups.level
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.DeckJobConfigurator;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class PlayPopupDeckSelector extends Component
   {
      
      private static const BASIC_DECK:String = "basic";
      
      private static const CUSTOM_DECK:String = "custom";
      
      private var mIcon:FSImage;
      
      private var mDeckNameTextfield:FSTextfield;
      
      private var mDeckTypeTextfield:FSTextfield;
      
      private var mDeckSelectorButton:FSButton;
      
      private var mType:String;
      
      private var mDeckJobConfig:DeckJobConfigurator;
      
      private var mParentContainerWidth:int;
      
      private var mBasicDecksCarrousel:DeckSelectorCarrousel;
      
      private var mCustomDecksCarrousel:DeckSelectorCarrousel;
      
      public function PlayPopupDeckSelector(param1:int)
      {
         super();
         this.mParentContainerWidth = param1;
         this.mType = this.getTypeToShow();
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createIcon();
         this.createDeckName();
         this.createDeckType();
         this.createDeckSelectorLauncher();
      }
      
      protected function getSelectedDeckIndex() : int
      {
         return InstanceMng.getUserDataMng().getOwnerUserData().getSelectedDeckIndex();
      }
      
      private function createIcon() : void
      {
         var _loc2_:int = 0;
         var _loc3_:JobDef = null;
         var _loc1_:String = "";
         if(Config.getConfig().gameHasClassSystem())
         {
            _loc2_ = this.getSelectedDeckIndex();
            if(this.mType == BASIC_DECK)
            {
               _loc3_ = JobDef(InstanceMng.getJobsDefMng().getBasicJobByDeck(String(_loc2_)));
            }
            else
            {
               this.mDeckJobConfig = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(_loc2_);
               if(this.mDeckJobConfig)
               {
                  _loc3_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(this.mDeckJobConfig.getJobSku()));
               }
            }
            _loc1_ = _loc3_ ? _loc3_.getBgIcon() : "icon_class_00";
         }
         else
         {
            _loc1_ = "icon_deck";
         }
         if(this.mIcon == null)
         {
            this.mIcon = new FSImage(Root.assets.getTexture(_loc1_));
            this.mIcon.x = this.mParentContainerWidth / 6.25;
            addChild(this.mIcon);
         }
         else
         {
            this.mIcon.texture = Root.assets.getTexture(_loc1_);
         }
      }
      
      private function getCurrentJobDef() : JobDef
      {
         var _loc2_:JobDef = null;
         var _loc1_:int = this.getSelectedDeckIndex();
         if(this.mType == BASIC_DECK)
         {
            _loc2_ = JobDef(InstanceMng.getJobsDefMng().getBasicJobByDeck(String(_loc1_)));
         }
         else
         {
            this.mDeckJobConfig = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(_loc1_);
            if(this.mDeckJobConfig)
            {
               _loc2_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(this.mDeckJobConfig.getJobSku()));
            }
         }
         return _loc2_;
      }
      
      private function createDeckName() : void
      {
         var _loc3_:JobDef = null;
         var _loc1_:int = this.getSelectedDeckIndex();
         var _loc2_:String = "";
         if(Config.getConfig().gameHasClassSystem() && this.mType == BASIC_DECK)
         {
            _loc3_ = this.getCurrentJobDef();
            _loc2_ = _loc3_ ? _loc3_.getName() : "???";
         }
         else
         {
            _loc2_ = !isNaN(_loc1_) ? InstanceMng.getUserDataMng().getOwnerUserData().getDeckName(_loc1_) : "DECK";
         }
         if(this.mDeckNameTextfield == null)
         {
            this.mDeckNameTextfield = new FSTextfield(this.mParentContainerWidth / 2.75,this.mIcon.height * 0.6,_loc2_,16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
            this.mDeckNameTextfield.format.horizontalAlign = Align.LEFT;
            this.mDeckNameTextfield.x = this.mIcon.x + this.mIcon.width * 1.1;
            addChild(this.mDeckNameTextfield);
         }
         else
         {
            this.mDeckNameTextfield.text = _loc2_;
         }
      }
      
      private function createDeckType() : void
      {
         var _loc1_:String = this.mType == BASIC_DECK ? TextManager.getText("TID_GEN_BASIC_DECK") : TextManager.getText("TID_GEN_CUSTOM_DECK");
         if(this.mDeckTypeTextfield == null)
         {
            this.mDeckTypeTextfield = new FSTextfield(this.mDeckNameTextfield.width,this.mIcon.height * 0.4,_loc1_,16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
            this.mDeckTypeTextfield.format.font = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
            this.mDeckTypeTextfield.format.horizontalAlign = Align.LEFT;
            this.mDeckTypeTextfield.x = this.mDeckNameTextfield.x;
            this.mDeckTypeTextfield.y = this.mDeckNameTextfield.y + this.mDeckNameTextfield.height;
            addChild(this.mDeckTypeTextfield);
         }
         else
         {
            this.mDeckTypeTextfield.text = _loc1_;
         }
      }
      
      private function createDeckSelectorLauncher() : void
      {
         if(this.mDeckSelectorButton == null)
         {
            this.mDeckSelectorButton = new FSButton(Root.assets.getTexture("deck_select_icon"));
            this.mDeckSelectorButton.name = "deckSelectorButton";
            this.mDeckSelectorButton.x = this.mDeckNameTextfield.x + this.mDeckNameTextfield.width + this.mDeckSelectorButton.width / 2;
            this.mDeckSelectorButton.y = this.mDeckNameTextfield.y + this.mDeckSelectorButton.height / 2;
            this.mDeckSelectorButton.addEventListener(Event.TRIGGERED,this.onDeckSelectorTriggered);
            addChild(this.mDeckSelectorButton);
         }
      }
      
      private function onDeckSelectorTriggered(param1:Event) : void
      {
         var _loc2_:FSCoordinate = null;
         if(InstanceMng.getPopupMng().getPopupShown())
         {
            _loc2_ = new FSCoordinate();
            _loc2_.setX(InstanceMng.getPopupMng().getPopupShown().x);
            _loc2_.setY(InstanceMng.getPopupMng().getPopupShown().y);
            InstanceMng.getPopupMng().getPopupShown().hideTemporarily(this.showDeckCarrousels);
         }
      }
      
      private function showDeckCarrousels() : void
      {
         var onCarrouselShown:Function = null;
         onCarrouselShown = function():void
         {
            if(InstanceMng.getTutorialMapMng().isTutorialON())
            {
               InstanceMng.getTutorialMapMng().increaseCurrentStep();
            }
            if(mCustomDecksCarrousel)
            {
               mCustomDecksCarrousel.touchable = true;
            }
            Screen.smCarrousselTransitionON = false;
            FSDebug.debugTrace("==== CARROUSSEL TRANSITION -> FALSE");
         };
         if(Config.getConfig().gameHasClassSystem())
         {
            if(this.mBasicDecksCarrousel == null)
            {
               this.mBasicDecksCarrousel = new DeckSelectorCarrousel(DeckSelectorCarrousel.TYPE_BASIC);
               this.mBasicDecksCarrousel.name = "basicCarroussel";
               this.mBasicDecksCarrousel.x = Starling.current.stage.stageWidth / 2;
               this.mBasicDecksCarrousel.y = Starling.current.stage.stageHeight / 3;
            }
            this.mBasicDecksCarrousel.touchable = false;
            Screen.smCarrousselTransitionON = true;
            FSDebug.debugTrace("==== CARROUSSEL TRANSITION -> TRUE");
            InstanceMng.getCurrentScreen().addChild(this.mBasicDecksCarrousel);
            SpecialFX.createZoomAlphaTween(this.mBasicDecksCarrousel,0.25,0,1,6,1,null,this.onBasicCarrousselTransitionFinished);
            if(this.mCustomDecksCarrousel == null)
            {
               this.mCustomDecksCarrousel = new DeckSelectorCarrousel(DeckSelectorCarrousel.TYPE_CUSTOM);
               this.mCustomDecksCarrousel.x = Starling.current.stage.stageWidth / 2;
               this.mCustomDecksCarrousel.y = Starling.current.stage.stageHeight / 1.5;
               this.mCustomDecksCarrousel.alpha = 0;
            }
            this.mCustomDecksCarrousel.touchable = false;
            Screen.smCarrousselTransitionON = true;
            FSDebug.debugTrace("==== CARROUSSEL TRANSITION -> TRUE");
            InstanceMng.getCurrentScreen().addChild(this.mCustomDecksCarrousel);
            TweenMax.delayedCall(0.25,SpecialFX.createZoomAlphaTween,[this.mCustomDecksCarrousel,0.25,0,1,6,1,null,onCarrouselShown]);
         }
         else
         {
            if(this.mCustomDecksCarrousel == null)
            {
               this.mCustomDecksCarrousel = new DeckSelectorCarrousel(DeckSelectorCarrousel.TYPE_CUSTOM);
               this.mCustomDecksCarrousel.x = Starling.current.stage.stageWidth / 2;
               this.mCustomDecksCarrousel.y = Starling.current.stage.stageHeight / 2;
            }
            this.mCustomDecksCarrousel.touchable = false;
            Screen.smCarrousselTransitionON = true;
            FSDebug.debugTrace("==== CARROUSSEL TRANSITION -> TRUE");
            SpecialFX.createZoomAlphaTween(this.mCustomDecksCarrousel,0.25,0,1,6,1,null,onCarrouselShown);
            InstanceMng.getCurrentScreen().addChild(this.mCustomDecksCarrousel);
         }
      }
      
      private function onBasicCarrousselTransitionFinished() : void
      {
         if(this.mBasicDecksCarrousel)
         {
            this.mBasicDecksCarrousel.touchable = true;
         }
         Screen.smCarrousselTransitionON = false;
         FSDebug.debugTrace("==== CARROUSSEL TRANSITION -> FALSE");
      }
      
      public function hideCarrousels(param1:Boolean = true) : void
      {
         var onCarrouselsHidden:Function = null;
         var changeCarrousselState:Function = null;
         var resumePopupInBG:Boolean = param1;
         onCarrouselsHidden = function():void
         {
            if(mBasicDecksCarrousel)
            {
               mBasicDecksCarrousel.removeFromParent();
            }
            if(mCustomDecksCarrousel)
            {
               mCustomDecksCarrousel.removeFromParent();
            }
            if(resumePopupInBG)
            {
               InstanceMng.getPopupMng().resumePopupInBackground();
            }
            if(resumePopupInBG)
            {
               TweenMax.delayedCall(Popup.TRANSITION_TIME,changeCarrousselState);
            }
            else
            {
               changeCarrousselState();
            }
         };
         changeCarrousselState = function():void
         {
            Screen.smCarrousselTransitionON = false;
            FSDebug.debugTrace("==== CARROUSSEL TRANSITION -> FALSE");
         };
         if(this.mBasicDecksCarrousel)
         {
            SpecialFX.createZoomAlphaTween(this.mBasicDecksCarrousel,0.25,1,0,1,6);
         }
         if(this.mCustomDecksCarrousel)
         {
            SpecialFX.createZoomAlphaTween(this.mCustomDecksCarrousel,0.25,1,0,1,6,null,onCarrouselsHidden);
         }
      }
      
      private function getTypeToShow() : String
      {
         var _loc8_:int = 0;
         var _loc1_:Boolean = InstanceMng.getTutorialMapMng() ? InstanceMng.getTutorialMapMng().isTutorialON() : false;
         var _loc2_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().hasAnyCustomDeckAvailable();
         var _loc3_:String = _loc2_ && !_loc1_ ? CUSTOM_DECK : BASIC_DECK;
         var _loc4_:int = Config.getConfig().getDeckCardsAmount();
         var _loc5_:Dictionary = InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection();
         var _loc6_:int = DictionaryUtils.getCatalogCardsAmountCheckingRestrictions(_loc5_,true,_loc4_);
         _loc3_ = _loc3_ == CUSTOM_DECK && _loc6_ >= _loc4_ ? CUSTOM_DECK : BASIC_DECK;
         var _loc7_:int = this.getSelectedDeckIndex();
         if(_loc3_ == BASIC_DECK)
         {
            _loc7_ = _loc7_ < Config.getConfig().getMaxDecksAmount() ? Config.getConfig().getMaxDecksAmount() : _loc7_;
            return this.manageBasicDeckSelection(_loc7_);
         }
         if(_loc3_ == CUSTOM_DECK && _loc7_ >= Config.getConfig().getMaxDecksAmount())
         {
            if(!_loc2_)
            {
               return this.manageBasicDeckSelection(Config.getConfig().getMaxDecksAmount());
            }
            _loc8_ = InstanceMng.getUserDataMng().getOwnerUserData().getFirstCustomDeckIndexAvailable();
            InstanceMng.getUserDataMng().getOwnerUserData().setSelectedDeckIndex(_loc8_);
         }
         return _loc3_;
      }
      
      private function manageBasicDeckSelection(param1:int) : String
      {
         var _loc3_:JobDef = null;
         var _loc4_:Vector.<String> = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(Config.getConfig().gameHasClassSystem())
         {
            _loc3_ = JobDef(InstanceMng.getJobsDefMng().getBasicJobByDeck(String(param1)));
            _loc2_.setDeck(_loc2_.createBestBasicDeckConfiguration(_loc3_),param1);
         }
         else
         {
            _loc4_ = _loc2_.createBestDeckConfiguration();
            if(_loc4_)
            {
               _loc2_.cleanDeckByIndex(UserData.getTutorialDeckIndex());
               _loc7_ = "";
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  _loc7_ += _loc4_[_loc5_] + ":" + 1;
                  if(_loc5_ != _loc4_.length - 1)
                  {
                     _loc7_ += ",";
                  }
                  _loc5_++;
               }
               _loc6_ = _loc7_ ? _loc7_.split(",") : null;
               if(_loc6_)
               {
                  _loc2_.setDeck(_loc6_,param1);
               }
            }
         }
         InstanceMng.getUserDataMng().getOwnerUserData().setSelectedDeckIndex(param1);
         return BASIC_DECK;
      }
      
      public function onDeckSelectionChanged(param1:int, param2:int) : void
      {
         Screen.smCarrousselTransitionON = true;
         FSDebug.debugTrace("==== CARROUSSEL TRANSITION -> TRUE");
         if(this.mBasicDecksCarrousel)
         {
            this.mBasicDecksCarrousel.onDeckSelectionChanged(param1,param2);
         }
         if(this.mCustomDecksCarrousel)
         {
            this.mCustomDecksCarrousel.onDeckSelectionChanged(param1,param2);
         }
         TweenMax.delayedCall(0.25,this.hideCarrousels);
         this.mType = param2 < Config.getConfig().getMaxDecksAmount() ? CUSTOM_DECK : BASIC_DECK;
         this.createUI();
      }
      
      override public function dispose() : void
      {
         if(this.mIcon)
         {
            this.mIcon.removeFromParent();
            this.mIcon.destroy();
            this.mIcon = null;
         }
         if(this.mDeckNameTextfield)
         {
            this.mDeckNameTextfield.removeFromParent(true);
            this.mDeckNameTextfield = null;
         }
         if(this.mDeckTypeTextfield)
         {
            this.mDeckTypeTextfield.removeFromParent(true);
            this.mDeckTypeTextfield = null;
         }
         if(this.mDeckSelectorButton)
         {
            this.mDeckSelectorButton.removeEventListener(Event.TRIGGERED,this.onDeckSelectorTriggered);
            this.mDeckSelectorButton.removeFromParent();
            this.mDeckSelectorButton.destroy();
            this.mDeckSelectorButton = null;
         }
         if(this.mBasicDecksCarrousel)
         {
            this.mBasicDecksCarrousel.removeFromParent(true);
            this.mBasicDecksCarrousel = null;
         }
         if(this.mCustomDecksCarrousel)
         {
            this.mCustomDecksCarrousel.removeFromParent(true);
            this.mCustomDecksCarrousel = null;
         }
         this.mDeckJobConfig = null;
         super.dispose();
      }
   }
}

