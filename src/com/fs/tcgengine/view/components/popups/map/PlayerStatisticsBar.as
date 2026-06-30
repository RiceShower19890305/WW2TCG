package com.fs.tcgengine.view.components.popups.map
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PortraitDef;
   import com.fs.tcgengine.model.rules.RankDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextInput;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.misc.RarityProgress;
   import com.fs.tcgengine.view.components.popups.player.PortraitViewer;
   import com.fs.tcgengine.view.popups.Popup;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalLayout;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class PlayerStatisticsBar extends Component
   {
      
      public static const BG_NAME:String = "bg_trainer";
      
      private const SELECTED_PORTRAIT_BG_ASSET_NAME:String = "portrait_selected";
      
      private const CITY_VIEW_BUTTON_BG:String = "city_view_button";
      
      protected var mBG:CustomComponent;
      
      private var mStatsTitleTextfield:FSTextfield;
      
      protected var mPortraitViewer:PortraitViewer;
      
      protected var mNameTextfield:FSTextfield;
      
      protected var mSubtitleTextfield:FSTextfield;
      
      private var mCitynameTextInput:FSTextInput;
      
      private var mFutureCityName:String;
      
      private var mExitRequested:Boolean = false;
      
      protected var mEditButton:FSButton;
      
      private var mEditCityNameButton:FSButton;
      
      private var mRaritiesContainer:ScrollContainer;
      
      private var mCityViewButton:FSButton;
      
      private var mCityNameTextfield:FSTextfield;
      
      public function PlayerStatisticsBar()
      {
         super();
         this.createUI();
      }
      
      protected function createUI() : void
      {
         this.createBG();
         this.createSelectedPortraitContainer();
         this.createNameTextfield();
         this.createSubtitle();
         this.createEditButton();
         this.createCityButton();
         this.createCityNameTextfield();
         this.createEditForCityNameButton();
         this.createStatsTitle();
         this.createRaritiesContainer();
         this.createRaritiesStats();
      }
      
      private function createEditForCityNameButton() : void
      {
         if(Config.getConfig().gameHasBuildingBadges())
         {
            if(this.mEditCityNameButton == null)
            {
               this.mEditCityNameButton = new FSButton(Root.assets.getTexture("edit_button"));
               this.mEditCityNameButton.x = this.mCityNameTextfield.x;
               this.mEditCityNameButton.y = this.mCityNameTextfield.y - this.mCityNameTextfield.height * 0.1;
               addChild(this.mEditCityNameButton);
               this.mEditCityNameButton.addEventListener(Event.TRIGGERED,this.onEditCityNameTriggered);
            }
         }
      }
      
      private function onEditCityNameTriggered() : void
      {
         this.editCitynameTitle();
      }
      
      private function editCitynameTitle() : void
      {
         this.createCitynameTextinput();
         this.mCityNameTextfield.visible = false;
      }
      
      private function createCityNameTextfield() : void
      {
         if(Config.getConfig().gameHasBuildingBadges())
         {
            if(this.mCityNameTextfield == null)
            {
               this.mCityNameTextfield = new FSTextfield(this.mBG.width * 0.4,this.mBG.height * 0.2,InstanceMng.getUserDataMng().getOwnerUserData().getCityName().toUpperCase(),16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
               this.mCityNameTextfield.format.horizontalAlign = Align.LEFT;
               this.mCityNameTextfield.format.verticalAlign = Align.BOTTOM;
               this.mCityNameTextfield.x = this.mCityViewButton.x + this.mCityViewButton.width * 0.7;
               this.mCityNameTextfield.y = this.mCityViewButton.y - this.mCityNameTextfield.height * 0.5;
               addChild(this.mCityNameTextfield);
               this.mCityNameTextfield.touchable = true;
               this.mCityNameTextfield.addEventListener(TouchEvent.TOUCH,this.onCitynameTouch);
            }
         }
      }
      
      private function onCitynameTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            this.editCitynameTitle();
         }
      }
      
      private function createCityButton() : void
      {
         if(Config.getConfig().gameHasBuildingBadges())
         {
            if(this.mCityViewButton == null)
            {
               this.mCityViewButton = new FSButton(Root.assets.getTexture(this.CITY_VIEW_BUTTON_BG));
               this.mCityViewButton.x = this.mPortraitViewer.x + this.mCityViewButton.width * 0.8;
               this.mCityViewButton.y = this.mPortraitViewer.y + this.mPortraitViewer.height * 1.4;
               this.mCityViewButton.addEventListener(Event.TRIGGERED,this.onCityViewButton);
               addChild(this.mCityViewButton);
            }
         }
      }
      
      private function onCityViewButton() : void
      {
         var _loc2_:LevelDef = null;
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_)
         {
            _loc2_ = InstanceMng.getLevelsDefMng().getLevelDefByLevelIndex(_loc1_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY));
            if(_loc2_)
            {
               InstanceMng.getPopupMng().getPopupShown().hideTemporarily(InstanceMng.getPopupMng().openRankPromotePopup,[_loc2_,true]);
            }
         }
      }
      
      protected function createEditButton() : void
      {
         if(this.mEditButton == null)
         {
            this.mEditButton = new FSButton(Root.assets.getTexture("edit_button"));
            this.mEditButton.name = "edit_name";
            this.mEditButton.x = this.mPortraitViewer.x + this.mPortraitViewer.width;
            if(Config.getConfig().gameHasBuildingBadges())
            {
               this.mEditButton.y = this.mEditButton.height * 0.5;
            }
            else
            {
               this.mEditButton.y = this.mEditButton.height / 3;
            }
            addChild(this.mEditButton);
            this.mEditButton.addEventListener(Event.TRIGGERED,this.onEditTriggered);
         }
      }
      
      private function onEditTriggered(param1:Event) : void
      {
         var _loc2_:Popup = InstanceMng.getPopupMng().getPopupShown();
         if(_loc2_)
         {
            _loc2_.closePopup(InstanceMng.getPopupMng().openEditProfilePopup);
         }
         else
         {
            InstanceMng.getPopupMng().openEditProfilePopup();
         }
      }
      
      protected function createSelectedPortraitContainer() : void
      {
         var _loc1_:PortraitDef = null;
         var _loc2_:String = null;
         if(this.mPortraitViewer == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentPortraitDef();
            _loc2_ = FSBattlefieldUserPortrait.FRAME_BG_NAME;
            this.mPortraitViewer = new PortraitViewer(null,null,_loc2_,null,true);
            this.mPortraitViewer.x = this.mPortraitViewer.width * 0.05;
            if(Config.getConfig().gameHasBuildingBadges())
            {
               this.mPortraitViewer.y = this.mBG.height * 0.1;
            }
            else
            {
               this.mPortraitViewer.y = (this.mBG.height - this.mPortraitViewer.height) / 2;
            }
            addChild(this.mPortraitViewer);
            this.mPortraitViewer.touchable = true;
            this.mPortraitViewer.addEventListener(TouchEvent.TOUCH,this.onPortraitTouch);
         }
      }
      
      public function createUserPortrait() : void
      {
         if(this.mPortraitViewer)
         {
            this.mPortraitViewer.createUserPortrait();
         }
      }
      
      protected function createNameTextfield(param1:int = -1) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mNameTextfield == null)
         {
            _loc2_ = Config.getConfig().gameHasBuildingBadges() ? int(this.mBG.height * 0.3) : int(this.mBG.height / 2.45);
            _loc3_ = param1 != -1 ? param1 : int(this.mBG.width / 3);
            this.mNameTextfield = new FSTextfield(_loc3_,_loc2_,InstanceMng.getUserDataMng().getOwnerUserData().getName().toUpperCase(),16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
            this.mNameTextfield.name = "name_label";
            this.mNameTextfield.format.horizontalAlign = Align.LEFT;
            this.mNameTextfield.x = this.mPortraitViewer.x + this.mPortraitViewer.width * 1.1;
            this.mNameTextfield.y = Config.getConfig().gameHasBuildingBadges() ? this.mNameTextfield.height * 0.3 : this.mNameTextfield.height * 0.375;
            addChild(this.mNameTextfield);
            this.mNameTextfield.touchable = true;
            this.mNameTextfield.addEventListener(TouchEvent.TOUCH,this.onUsernameTouch);
         }
      }
      
      protected function createSubtitle(param1:int = -1) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:UserData = null;
         var _loc6_:RankDef = null;
         if(this.mSubtitleTextfield == null)
         {
            _loc2_ = this.mNameTextfield.height / 1.75;
            if(Config.getConfig().hasToShowRankNameInStatsBar())
            {
               _loc5_ = Utils.getOwnerUserData();
               _loc6_ = _loc5_ ? _loc5_.getRankDef() : null;
               _loc3_ = _loc6_.getName();
            }
            else
            {
               _loc3_ = TextManager.getText("TID_GEN_TRAINER");
            }
            _loc4_ = param1 == -1 ? int(this.mNameTextfield.width / 2) : param1;
            this.mSubtitleTextfield = new FSTextfield(_loc4_,_loc2_,_loc3_,16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mSubtitleTextfield.format.horizontalAlign = Align.LEFT;
            this.mSubtitleTextfield.x = this.mNameTextfield.x;
            this.mSubtitleTextfield.y = this.mNameTextfield.y + this.mNameTextfield.height * 1.035;
            addChild(this.mSubtitleTextfield);
         }
      }
      
      private function onPortraitTouch(param1:TouchEvent) : void
      {
         var _loc3_:Popup = null;
         var _loc2_:Touch = param1.getTouch(this.mPortraitViewer,TouchPhase.ENDED);
         if(_loc2_)
         {
            _loc3_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc3_)
            {
               _loc3_.closePopup(InstanceMng.getPopupMng().openEditProfilePopup);
            }
            else
            {
               InstanceMng.getPopupMng().openEditProfilePopup();
            }
         }
      }
      
      private function onUsernameTouch(param1:TouchEvent) : void
      {
         var _loc3_:Popup = null;
         var _loc2_:Touch = param1.getTouch(this.mNameTextfield,TouchPhase.ENDED);
         if(_loc2_)
         {
            _loc3_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc3_)
            {
               _loc3_.closePopup(InstanceMng.getPopupMng().openEditProfilePopup);
            }
            else
            {
               InstanceMng.getPopupMng().openEditProfilePopup();
            }
         }
      }
      
      private function createCitynameTextinput() : void
      {
         if(this.mCitynameTextInput == null)
         {
            this.mCitynameTextInput = new FSTextInput();
            this.mCitynameTextInput.name = "city";
            this.mCitynameTextInput.x = this.mCityNameTextfield.x;
            this.mCitynameTextInput.y = this.mCityNameTextfield.y;
            this.mCitynameTextInput.width = this.mCityNameTextfield.width;
            this.mCitynameTextInput.height = this.mCityNameTextfield.height;
            this.mCitynameTextInput.text = this.mCityNameTextfield.text;
            this.mCitynameTextInput.addEventListener(FeathersEventType.ENTER,this.inputEnterHandler);
            this.mCitynameTextInput.addEventListener(FeathersEventType.FOCUS_OUT,this.inputFocusOutHandler);
            this.mCitynameTextInput.addEventListener(FeathersEventType.FOCUS_IN,this.inputFocusInHandler);
         }
         addChild(this.mCitynameTextInput);
         this.mCitynameTextInput.visible = true;
         this.mCitynameTextInput.textEditorProperties.restrict = "0-9a-zA-Z_";
      }
      
      private function inputEnterHandler(param1:Event) : void
      {
         this.onSaveTextInputData(param1);
      }
      
      private function inputFocusOutHandler(param1:Event) : void
      {
         this.onSaveTextInputData(param1);
      }
      
      private function inputFocusInHandler(param1:Event) : void
      {
         var _loc2_:FSTextInput = FSTextInput(param1.target);
         if(_loc2_.name == "city")
         {
            this.mCitynameTextInput.selectRange(0,this.mCitynameTextInput.text.length);
         }
      }
      
      private function onSaveTextInputData(param1:Event) : void
      {
         var _loc2_:FSTextInput = FSTextInput(param1.target);
         if(_loc2_.name == "city")
         {
            if(this.mCitynameTextInput != null)
            {
               this.mFutureCityName = this.mCitynameTextInput.text;
               this.mCityNameTextfield.color = 16777215;
               InstanceMng.getUserDataMng().getOwnerUserData().setCityName(this.mFutureCityName.toLowerCase());
               InstanceMng.getUserDataMng().updateCityName();
               this.mCityNameTextfield.text = this.mCitynameTextInput.text;
               this.mCityNameTextfield.touchable = true;
               this.mCitynameTextInput.visible = false;
               this.mCityNameTextfield.visible = true;
            }
         }
      }
      
      protected function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = Utils.createCustomBox(BG_NAME,1653);
            addChild(this.mBG);
         }
      }
      
      private function createStatsTitle() : void
      {
         if(this.mStatsTitleTextfield == null)
         {
            if(Config.getConfig().gameHasBuildingBadges())
            {
               this.mStatsTitleTextfield = new FSTextfield(this.mBG.width / 4,this.mBG.height * 0.25,TextManager.getText("TID_CARD_STATS"));
            }
            else
            {
               this.mStatsTitleTextfield = new FSTextfield(this.mBG.width / 4,this.mBG.height * 0.4,TextManager.getText("TID_CARD_STATS"));
            }
            this.mStatsTitleTextfield.x = this.mBG.width / 1.75;
            this.mStatsTitleTextfield.y = this.mNameTextfield.y;
            addChild(this.mStatsTitleTextfield);
         }
      }
      
      private function createRaritiesContainer() : void
      {
         var _loc1_:HorizontalLayout = null;
         if(this.mRaritiesContainer == null)
         {
            this.mRaritiesContainer = new ScrollContainer();
            _loc1_ = new HorizontalLayout();
            _loc1_.gap = 1;
            this.mRaritiesContainer.layout = _loc1_;
            this.mRaritiesContainer.horizontalScrollPolicy = ScrollPolicy.ON;
            this.mRaritiesContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            this.mRaritiesContainer.width = this.mBG.width * 0.975 - (this.mSubtitleTextfield.x + this.mSubtitleTextfield.width);
            this.mRaritiesContainer.x = this.mSubtitleTextfield.x + this.mSubtitleTextfield.width;
            this.mRaritiesContainer.y = this.mSubtitleTextfield.y;
            addChild(this.mRaritiesContainer);
         }
      }
      
      private function createRaritiesStats() : void
      {
         var _loc2_:int = 0;
         var _loc3_:RarityProgress = null;
         var _loc4_:FSCoordinate = null;
         var _loc5_:int = 0;
         var _loc1_:Vector.<RarityDef> = this.getRaritiesVector();
         if(_loc1_)
         {
            _loc5_ = this.mBG.width - (this.mSubtitleTextfield.x + this.mSubtitleTextfield.width);
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               if(_loc1_[_loc2_].getIndex() > 0)
               {
                  _loc3_ = new RarityProgress(_loc1_[_loc2_]);
                  _loc3_.changeBGScale(0.5);
                  this.mRaritiesContainer.addChild(_loc3_);
                  this.mRaritiesContainer.height = _loc3_.height * 1.05;
               }
               _loc2_++;
            }
         }
      }
      
      private function getRaritiesVector() : Vector.<RarityDef>
      {
         var _loc2_:Vector.<RarityDef> = null;
         var _loc3_:RarityDef = null;
         var _loc1_:Dictionary = InstanceMng.getRaritiesDefMng().getAllDefs();
         for each(_loc3_ in _loc1_)
         {
            if(_loc2_ == null)
            {
               _loc2_ = new Vector.<RarityDef>();
            }
            _loc2_.push(_loc3_);
         }
         if(_loc2_)
         {
            _loc2_.sort(DictionaryUtils.sortByIndexAsc);
         }
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         if(this.mBG != null)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mStatsTitleTextfield)
         {
            this.mStatsTitleTextfield.removeFromParent(true);
            this.mStatsTitleTextfield = null;
         }
         if(this.mSubtitleTextfield)
         {
            this.mSubtitleTextfield.removeFromParent(true);
            this.mSubtitleTextfield = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(this.mCitynameTextInput)
         {
            this.mCitynameTextInput.removeFromParent(true);
            this.mCitynameTextInput = null;
         }
         if(this.mEditCityNameButton)
         {
            this.mEditCityNameButton.removeFromParent(true);
            this.mEditCityNameButton = null;
         }
         if(this.mCityViewButton)
         {
            this.mCityViewButton.removeFromParent(true);
            this.mCityViewButton = null;
         }
         if(this.mCityNameTextfield)
         {
            this.mCityNameTextfield.removeFromParent(true);
            this.mCityNameTextfield = null;
         }
         if(this.mEditButton)
         {
            this.mEditButton.removeFromParent(true);
            this.mEditButton = null;
         }
         if(this.mPortraitViewer)
         {
            this.mPortraitViewer.removeEventListener(TouchEvent.TOUCH,this.onPortraitTouch);
            this.mPortraitViewer.removeFromParent();
            this.mPortraitViewer.destroy();
            this.mPortraitViewer = null;
         }
         if(this.mRaritiesContainer)
         {
            this.mRaritiesContainer.removeChildren();
            this.mRaritiesContainer.removeFromParent();
            this.mRaritiesContainer = null;
         }
         super.dispose();
      }
      
      public function refreshUI() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         if(this.mRaritiesContainer)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mRaritiesContainer.numChildren)
            {
               _loc1_ = this.mRaritiesContainer.getChildAt(_loc2_);
               if(_loc1_ != null && _loc1_ is RarityProgress)
               {
                  RarityProgress(_loc1_).refreshProgress();
               }
               _loc2_++;
            }
         }
      }
      
      public function updateName() : void
      {
         if(this.mNameTextfield)
         {
            this.mNameTextfield.text = InstanceMng.getUserDataMng().getOwnerUserData().getName();
         }
      }
   }
}

