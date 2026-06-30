package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.HeroCharacterDefMng;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.PortraitDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.buttons.FSToggleButton;
   import com.fs.tcgengine.view.components.buttons.SubcategoryToggleButton;
   import com.fs.tcgengine.view.components.misc.FSTextInput;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.misc.FSSkinSlot;
   import com.fs.tcgengine.view.components.popups.player.PortraitViewer;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.easing.Linear;
   import feathers.controls.ScrollBarDisplayMode;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.TiledRowsLayout;
   import feathers.layout.VerticalAlign;
   import flash.utils.Dictionary;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class PopupEditProfile extends PopupStandard
   {
      
      public static const SKINS_BY_PAGE:int = 2;
      
      public static const SHOP_SKINS_BY_PAGE:int = 2;
      
      private const SELECTED_PORTRAIT_BG_ASSET_NAME:String = "portrait_selected";
      
      private const NAME_CHANGE_BG_ASSET_NAME:String = "name_plate_edit";
      
      private var mMiniPortraitsScrollContainer:ScrollContainer;
      
      private var mSkinsScrollContainer:ScrollContainer;
      
      private var mNameChangeTitleTextfield:FSTextfield;
      
      private var mSelectedPortraitViewer:PortraitViewer;
      
      private var mUsernameTextInput:FSTextInput;
      
      private var mUserNameBG:Component;
      
      private var mUsernameLabel:FSTextfield;
      
      private var mFuturePlayerName:String;
      
      private var mFuturePortraitSku:String;
      
      private var mExitRequested:Boolean = false;
      
      private var mShowPortraits:Boolean = Config.getConfig().hasPortraits();
      
      private var mShowSkins:Boolean = Config.getConfig().hasSkins();
      
      private var mPrevPageButton:FSButton;
      
      private var mNextPageButton:FSButton;
      
      private var mCurrentPageSkin:int;
      
      private var mSkinFilterButtonsContainer:ScrollContainer;
      
      protected var mActiveFilter:int = -1;
      
      private var mSkinsArr:Array;
      
      private var mSkinPageActive:Boolean;
      
      public function PopupEditProfile(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function setResourcesToLoad() : void
      {
         var _loc2_:PortraitDef = null;
         var _loc3_:Dictionary = null;
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         if(_loc1_ != null)
         {
            if(this.mShowPortraits)
            {
               if(!Config.smPortraitFramesInAtlas)
               {
                  _loc3_ = InstanceMng.getPortraitsDefMng().getAllDefs();
                  for each(_loc2_ in _loc3_)
                  {
                     InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc2_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
                  }
               }
               InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + FSResourceMng.DEFAULT_PHOTO_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
            }
            else
            {
               InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + FSBattlefieldUserPortrait.FRAME_BG_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
               if(Config.getConfig().battleEnemyPortraitSpecial())
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + FSBattlefieldUserPortrait.ENEMY_FRAME_BG_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
               }
            }
         }
         super.setResourcesToLoad();
      }
      
      private function filterAppliesToSkin(param1:int, param2:HeroCharacterDef) : Boolean
      {
         var _loc3_:Boolean = false;
         switch(param1)
         {
            case HeroCharacterDefMng.UNLOCK_BY_DUNGEON:
               if(param2.getUnlockType() == HeroCharacterDefMng.UNLOCK_BY_DUNGEON)
               {
                  _loc3_ = true;
               }
               break;
            case HeroCharacterDefMng.UNLOCK_BY_LEVEL:
               if(param2.getUnlockType() == HeroCharacterDefMng.UNLOCK_BY_LEVEL)
               {
                  _loc3_ = true;
               }
               break;
            case HeroCharacterDefMng.UNLOCK_BY_PVP:
               if(param2.getUnlockType() == HeroCharacterDefMng.UNLOCK_BY_PVP)
               {
                  _loc3_ = true;
               }
               break;
            case HeroCharacterDefMng.UNLOCK_BY_QUEST:
               if(param2.getUnlockType() == HeroCharacterDefMng.UNLOCK_BY_QUEST)
               {
                  _loc3_ = true;
               }
               break;
            case HeroCharacterDefMng.UNLOCK_BY_RAID:
               if(param2.getUnlockType() == HeroCharacterDefMng.UNLOCK_BY_RAID)
               {
                  _loc3_ = true;
               }
               break;
            case HeroCharacterDefMng.UNLOCK_BY_SHOP:
               if(param2.getUnlockType() == HeroCharacterDefMng.UNLOCK_BY_SHOP)
               {
                  _loc3_ = true;
               }
               break;
            case HeroCharacterDefMng.UNLOCK_BY_GUILD:
               if(param2.getUnlockType() == HeroCharacterDefMng.UNLOCK_BY_GUILD)
               {
                  _loc3_ = true;
               }
               break;
            default:
               _loc3_ = true;
         }
         return _loc3_;
      }
      
      private function createNextPageButton() : void
      {
         if(this.mNextPageButton == null && Boolean(mBox))
         {
            this.mNextPageButton = new FSButton(Root.assets.getTexture("arrow_button_right"));
            this.mNextPageButton.x = mBox.width - this.mNextPageButton.width / 3;
            this.mNextPageButton.y = mBox.height / 2;
            this.mNextPageButton.addEventListener(TouchEvent.TOUCH,this.nextPageButtonTriggered);
         }
         if(this.mNextPageButton)
         {
            addChild(this.mNextPageButton);
         }
      }
      
      private function createPrevPageButton() : void
      {
         if(this.mPrevPageButton == null && Boolean(mBox))
         {
            this.mPrevPageButton = new FSButton(Root.assets.getTexture("arrow_button_left"));
            this.mPrevPageButton.x = this.mPrevPageButton.width / 3;
            this.mPrevPageButton.y = mBox.height / 2;
            this.mPrevPageButton.addEventListener(TouchEvent.TOUCH,this.prevPageButtonTriggered);
         }
         if(this.mPrevPageButton)
         {
            addChild(this.mPrevPageButton);
         }
      }
      
      private function prevPageButtonTriggered(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mPrevPageButton,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(this.mSkinPageActive)
            {
               if(this.mCurrentPageSkin > 0)
               {
                  this.lockPageButtons(true);
                  this.unloadCurrentSkinsItems();
                  --this.mCurrentPageSkin;
                  this.cleanScrollContainer(this.mSkinsScrollContainer,this.loadSkinsByPage);
               }
            }
         }
      }
      
      private function unloadCurrentSkinsItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:HeroCharacterDef = null;
         if(this.mSkinsScrollContainer)
         {
            this.mSkinsScrollContainer.removeChildren(0,-1,false);
         }
         if(this.mSkinsArr)
         {
            _loc1_ = this.getStartIndexCurrentPage();
            while(_loc1_ < this.getEndIndexCurrentPage())
            {
               _loc2_ = this.mSkinsArr[_loc1_];
               Root.assets.removeTexture(_loc2_.getBGImageName());
               _loc1_++;
            }
         }
      }
      
      private function nextPageButtonTriggered(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mNextPageButton,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(this.mSkinPageActive)
            {
               if(this.mSkinsArr)
               {
                  if(this.mCurrentPageSkin < this.mSkinsArr.length / SKINS_BY_PAGE - 1)
                  {
                     this.lockPageButtons(true);
                     this.unloadCurrentSkinsItems();
                     this.mCurrentPageSkin += 1;
                     this.cleanScrollContainer(this.mSkinsScrollContainer,this.loadSkinsByPage);
                  }
               }
            }
         }
      }
      
      public function cleanScrollContainer(param1:ScrollContainer, param2:Function = null) : void
      {
         var _loc3_:Component = null;
         var _loc4_:int = 0;
         var _loc5_:Number = 0.25;
         if(Boolean(param1) && param1.numChildren > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.numChildren)
            {
               _loc3_ = Component(param1.getChildAt(_loc4_));
               if(_loc3_ != null)
               {
                  SpecialFX.tweenToAlpha(_loc3_,0.001,_loc5_,0,this.removeComponentFromParent,[_loc3_]);
               }
               _loc4_++;
            }
         }
         if(param2 != null)
         {
            param2();
         }
      }
      
      private function removeComponentFromParent(param1:Component) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      private function cleanSkinPage() : void
      {
         this.cleanScrollContainer(this.mSkinFilterButtonsContainer);
         this.cleanScrollContainer(this.mSkinsScrollContainer);
         if(this.mSkinsScrollContainer)
         {
            this.mSkinsScrollContainer.removeFromParent();
            this.mSkinsScrollContainer = null;
         }
         if(this.mNameChangeTitleTextfield)
         {
            this.mNameChangeTitleTextfield.removeFromParent();
            this.mNameChangeTitleTextfield = null;
         }
         if(this.mSkinsArr)
         {
            this.mSkinsArr.length = 0;
            this.mSkinsArr = null;
         }
         if(this.mUserNameBG)
         {
            this.mUserNameBG.removeFromParent();
            this.mUserNameBG = null;
         }
         if(this.mUsernameTextInput)
         {
            this.mUsernameTextInput.removeFromParent();
            this.mUsernameTextInput = null;
         }
         if(this.mUsernameLabel)
         {
            this.mUsernameLabel.removeFromParent();
            this.mUsernameLabel = null;
         }
         if(this.mSkinFilterButtonsContainer)
         {
            this.mSkinFilterButtonsContainer.removeFromParent();
            this.mSkinFilterButtonsContainer = null;
         }
      }
      
      override protected function removeFromStage() : void
      {
         var _loc3_:PortraitDef = null;
         var _loc4_:int = 0;
         var _loc5_:HeroCharacterDef = null;
         if(this.mMiniPortraitsScrollContainer)
         {
            this.mMiniPortraitsScrollContainer.removeFromParent(true);
            this.mMiniPortraitsScrollContainer = null;
         }
         if(this.mPrevPageButton)
         {
            this.mPrevPageButton.removeFromParent(true);
            this.mPrevPageButton = null;
         }
         if(this.mNextPageButton)
         {
            this.mNextPageButton.removeFromParent(true);
            this.mNextPageButton = null;
         }
         if(this.mSkinsScrollContainer)
         {
            this.mSkinsScrollContainer.removeFromParent(true);
            this.mSkinsScrollContainer = null;
         }
         if(this.mNameChangeTitleTextfield)
         {
            this.mNameChangeTitleTextfield.removeFromParent(true);
            this.mNameChangeTitleTextfield = null;
         }
         if(this.mSelectedPortraitViewer)
         {
            this.mSelectedPortraitViewer.removeFromParent();
            this.mSelectedPortraitViewer = null;
         }
         var _loc1_:PortraitDef = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentPortraitDef();
         var _loc2_:Dictionary = InstanceMng.getPortraitsDefMng().getAllDefs();
         for each(_loc3_ in _loc2_)
         {
            if(this.mFuturePortraitSku != "" && this.mFuturePortraitSku != null)
            {
               if(_loc3_.getSku() != this.mFuturePortraitSku)
               {
                  Root.assets.removeTexture(_loc3_.getBGImageName());
               }
            }
            else if(_loc3_.getBGImageName() != _loc1_.getBGImageName())
            {
               Root.assets.removeTexture(_loc3_.getBGImageName());
            }
         }
         if(this.mSkinsArr)
         {
            _loc4_ = this.getStartIndexCurrentPage();
            while(_loc4_ < this.getEndIndexCurrentPage())
            {
               _loc5_ = this.mSkinsArr[_loc4_];
               Root.assets.removeTexture(_loc5_.getBGImageName());
               _loc4_++;
            }
            Utils.destroyArray(this.mSkinsArr);
            this.mSkinsArr = null;
         }
         Root.assets.removeTexture(FSResourceMng.DEFAULT_PHOTO_NAME);
         if(this.mSkinFilterButtonsContainer)
         {
            this.mSkinFilterButtonsContainer.removeFromParent(true);
            this.mSkinFilterButtonsContainer = null;
         }
         if(this.mUsernameTextInput)
         {
            this.mUsernameTextInput.removeFromParent(true);
            this.mUsernameTextInput = null;
         }
         if(this.mUserNameBG)
         {
            this.mUserNameBG.removeFromParent(true);
            this.mUserNameBG = null;
         }
         if(this.mUsernameLabel)
         {
            this.mUsernameLabel.removeFromParent(true);
            this.mUsernameLabel = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.EDIT_PROFILE_POPUP_NAME);
         super.removeFromStage();
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = this.mShowPortraits || this.mShowSkins ? Constants.POPUP_EXTENDED_NAME : Constants.POPUP_SETTINGS_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         var _loc3_:int = this.mShowPortraits || this.mShowSkins ? 1200 : 720;
         super.createBackground(param1,_loc3_);
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         if(this.mShowSkins)
         {
            this.hideAcceptButton();
            this.getSkins();
            this.loadSkinsByPage();
         }
         else
         {
            this.createPortraitsContainer();
            this.createNameChanger();
         }
         if(InstanceMng.getTutorialMapMng().isTutorialON())
         {
            touchable = false;
         }
      }
      
      private function createSkinPage() : void
      {
         this.mSkinPageActive = true;
         this.createSkinsContainer();
         this.createNextPageButton();
         this.createPrevPageButton();
         this.createFilterButtons();
         this.createNameChanger();
      }
      
      private function loadSkinsByPage() : void
      {
         var _loc1_:int = 0;
         var _loc2_:HeroCharacterDef = null;
         InstanceMng.getCurrentScreen().showLoadingIcon(true,true,Align.CENTER,Align.CENTER,1,null,this);
         if(this.mSkinsArr)
         {
            _loc1_ = this.getStartIndexCurrentPage();
            while(_loc1_ < this.getEndIndexCurrentPage())
            {
               _loc2_ = this.mSkinsArr[_loc1_];
               InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc2_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
               _loc1_++;
            }
         }
         InstanceMng.getResourcesMng().loadAssets(this.onCurrentSkinsLoaded);
      }
      
      private function onCurrentSkinsLoaded() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
         this.createSkinPage();
         this.lockPageButtons(false);
      }
      
      private function getSkins(param1:int = 0) : void
      {
         var _loc2_:HeroCharacterDef = null;
         if(this.mShowSkins)
         {
            this.mSkinsArr = InstanceMng.getHeroCharactersDefMng().getAllSkinsArr(param1);
         }
      }
      
      private function hasSkinsByFilter(param1:int) : Boolean
      {
         return Boolean(InstanceMng.getHeroCharactersDefMng().getAllSkinsArr(param1)) && InstanceMng.getHeroCharactersDefMng().getAllSkinsArr(param1).length > 0;
      }
      
      private function hideAcceptButton() : void
      {
         if(mAcceptButton)
         {
            mAcceptButton.visible = false;
         }
      }
      
      private function createNameChanger() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSImage = null;
         if(this.mNameChangeTitleTextfield == null)
         {
            _loc1_ = this.mShowPortraits ? int(height * 0.05) : int(height * 0.07);
            this.mNameChangeTitleTextfield = new FSTextfield(width * 0.3,_loc1_,TextManager.getText("TID_GEN_NAME_CHANGE"),16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mNameChangeTitleTextfield.name = "name_change_title";
            this.mNameChangeTitleTextfield.x = (width - this.mNameChangeTitleTextfield.width) / 2;
            if(this.mMiniPortraitsScrollContainer)
            {
               this.mNameChangeTitleTextfield.y = this.mMiniPortraitsScrollContainer.y + this.mMiniPortraitsScrollContainer.height + 5;
            }
            else if(this.mSkinsScrollContainer)
            {
               this.mNameChangeTitleTextfield.y = this.mSkinsScrollContainer.y + this.mSkinsScrollContainer.height;
            }
            else if(this.mSelectedPortraitViewer)
            {
               this.mNameChangeTitleTextfield.y = this.mSelectedPortraitViewer.y + this.mSelectedPortraitViewer.height + 5;
            }
            addChild(this.mNameChangeTitleTextfield);
            this.mNameChangeTitleTextfield.touchable = true;
            this.mNameChangeTitleTextfield.addEventListener(TouchEvent.TOUCH,this.onUsernameTouch);
         }
         if(this.mUserNameBG == null && Boolean(this.mNameChangeTitleTextfield))
         {
            this.mUserNameBG = new Component();
            _loc2_ = new FSImage(Root.assets.getTexture(this.NAME_CHANGE_BG_ASSET_NAME));
            this.mUserNameBG.addChild(_loc2_);
            this.mUserNameBG.x = (width - this.mUserNameBG.width) / 2;
            this.mUserNameBG.y = this.mNameChangeTitleTextfield.y + this.mNameChangeTitleTextfield.height;
            addChild(this.mUserNameBG);
         }
         this.createUsernameLabel();
      }
      
      private function createUsernameLabel() : void
      {
         if(this.mUsernameLabel == null)
         {
            this.mUsernameLabel = new FSTextfield(this.mUserNameBG.width * 0.9,this.mUserNameBG.height / 1.5,"",16777215);
            this.mUsernameLabel.fontName = FSResourceMng.getFontByType();
            this.mUsernameLabel.text = InstanceMng.getUserDataMng().getOwnerUserData().getName();
            this.mUsernameLabel.touchable = InstanceMng.getServerConnection().isUserLoggedIn();
            this.mUsernameLabel.x = this.mUserNameBG.x + (this.mUserNameBG.width - this.mUsernameLabel.width) / 2;
            this.mUsernameLabel.y = this.mUserNameBG.y + (this.mUserNameBG.height - this.mUsernameLabel.height) / 2;
            this.mUsernameLabel.addEventListener(TouchEvent.TOUCH,this.onUsernameTouch);
            addChild(this.mUsernameLabel);
         }
      }
      
      private function onUsernameTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         _loc2_ = _loc2_ == null ? param1.getTouch(this.mNameChangeTitleTextfield,TouchPhase.ENDED) : _loc2_;
         if(_loc2_)
         {
            if(InstanceMng.getTutorialMapMng().isTutorialON())
            {
               InstanceMng.getTutorialMapMng().increaseCurrentStep();
               if(Boolean(InstanceMng.getCurrentScreen()) && Boolean(InstanceMng.getCurrentScreen().getTouchableBG()))
               {
                  InstanceMng.getCurrentScreen().getTouchableBG().removeFromParent();
               }
            }
            if(!InstanceMng.getUserDataMng().getOwnerUserData().isInBlackList())
            {
               if(!InstanceMng.getUserDataMng().getOwnerUserData().isInDuplicatedList())
               {
                  this.editUsernameTitle();
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"),true,false,false);
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_GEN_FRAUD_PURCHASE"),true,false,false);
            }
         }
      }
      
      private function editUsernameTitle() : void
      {
         this.createUsernameTextinput();
         if(this.mUsernameLabel)
         {
            this.mUsernameLabel.visible = false;
         }
      }
      
      private function createUsernameTextinput() : void
      {
         if(Boolean(this.mUsernameTextInput == null) && Boolean(this.mUserNameBG) && Boolean(this.mUsernameLabel))
         {
            this.mUsernameTextInput = new FSTextInput();
            this.mUsernameTextInput.maxChars = Config.getConfig() ? Config.getConfig().getMaxPlayerNameChars() : 12;
            this.mUsernameTextInput.touchable = InstanceMng.getServerConnection() ? InstanceMng.getServerConnection().isUserLoggedIn() : false;
            this.mUsernameTextInput.width = this.mUserNameBG.width;
            this.mUsernameTextInput.height = this.mUserNameBG.height;
            this.mUsernameTextInput.text = this.mUsernameLabel.text;
            this.mUsernameTextInput.addEventListener(FeathersEventType.ENTER,this.inputEnterHandler);
            this.mUsernameTextInput.addEventListener(FeathersEventType.FOCUS_OUT,this.inputFocusOutHandler);
            this.mUsernameTextInput.addEventListener(FeathersEventType.FOCUS_IN,this.inputFocusInHandler);
         }
         if(Boolean(this.mUsernameTextInput) && Boolean(this.mUserNameBG))
         {
            this.mUsernameTextInput.validate();
            this.mUserNameBG.addChild(this.mUsernameTextInput);
            this.mUsernameTextInput.visible = true;
            this.mUsernameTextInput.textEditorProperties.restrict = "0-9a-zA-Z_";
         }
      }
      
      private function inputEnterHandler(param1:Event) : void
      {
         this.onSaveTextInputData();
      }
      
      private function inputFocusOutHandler(param1:Event) : void
      {
         this.onSaveTextInputData();
      }
      
      private function inputFocusInHandler(param1:Event) : void
      {
         this.mUsernameTextInput.selectRange(0,this.mUsernameTextInput.text.length);
         this.mUsernameLabel.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD);
      }
      
      private function onSaveTextInputData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         if(this.mUsernameTextInput != null)
         {
            if(this.mUsernameLabel != null)
            {
               if(this.mUsernameTextInput.text.length < 4)
               {
                  Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_GEN_USER_MIN"),[4]),true);
                  this.mUsernameLabel.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
                  _loc1_ = this.mUsernameLabel.x;
                  SpecialFX.createYoYoTransition(this.mUsernameLabel,new FSCoordinate(this.mUsernameLabel.x + 15,this.mUsernameLabel.y),0.1,9,null,Linear.easeNone);
                  InstanceMng.getCurrentScreen().addChild(this);
               }
               else
               {
                  _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getName();
                  _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getGold();
                  _loc4_ = !InstanceMng.getUserDataMng().getOwnerUserData().flagsIsFirstChangeName();
                  if(_loc3_ < Config.getConfig().getChangeNickGold() && !_loc4_)
                  {
                     Utils.setLogText(TextManager.getText("TID_GOLD_NOT_ENOUGH"),true);
                     this.resetOriginalName();
                  }
                  else if(this.mUsernameTextInput.text.toLowerCase() != _loc2_)
                  {
                     hideTemporarily(InstanceMng.getPopupMng().openChangeNickConfirmationPopup,[TextManager.getText("TID_NAME_CHANGE"),this,Config.getConfig().getChangeNickGold(),this.mUsernameTextInput.text.toLowerCase()]);
                  }
               }
               this.mUsernameLabel.text = this.mUsernameTextInput.text;
               this.mUsernameLabel.touchable = true;
               this.mUsernameTextInput.visible = false;
               this.mUsernameLabel.visible = true;
            }
         }
      }
      
      private function onNickQueryResponse(param1:Object, param2:String) : void
      {
         FSDebug.debugTrace("[checkIfNickAvailable] OK");
         var _loc3_:Array = param1 ? param1 as Array : null;
         var _loc4_:Boolean = false;
         if(_loc3_ != null && _loc3_.length > 0)
         {
            _loc4_ = Utils.getDataId(_loc3_[0]) == InstanceMng.getServerConnection().getUserId();
         }
         else
         {
            _loc4_ = true;
         }
         this.onNickReceivedFromServer(_loc4_,param2);
      }
      
      public function onNickReceivedFromServer(param1:Boolean, param2:String) : void
      {
         if(Boolean(this.mUsernameTextInput) && Boolean(this.mUsernameLabel))
         {
            if(param1)
            {
               this.onNickAvailableCommonOps();
               hideTemporarily(InstanceMng.getPopupMng().openChangeNickConfirmationPopup,[TextManager.getText("TID_NAME_CHANGE"),this,Config.getConfig().getChangeNickGold(),this.mFuturePlayerName.toLowerCase()]);
            }
            else
            {
               this.onNickNotAvailableCommonOps();
            }
         }
      }
      
      public function onNickAvailableCommonOps() : void
      {
         if(this.mUsernameTextInput)
         {
            this.mFuturePlayerName = this.mUsernameTextInput.text;
         }
         if(this.mUsernameLabel)
         {
            this.mUsernameLabel.color = 16777215;
         }
      }
      
      public function onNickNotAvailableCommonOps() : void
      {
         this.mExitRequested = false;
         Utils.setLogText(TextManager.getText("TID_NAME_NOT_AVAILABLE"),true);
         this.mUsernameLabel.color = 16711680;
      }
      
      private function createPortraitsContainer() : void
      {
         this.createSelectedPortraitContainer();
         this.createMiniPortraitsContainer();
      }
      
      private function createSelectedPortraitContainer() : void
      {
         var _loc1_:PortraitDef = null;
         var _loc2_:String = null;
         if(this.mSelectedPortraitViewer == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentPortraitDef();
            _loc2_ = Config.getConfig().hasPortraits() || Config.getConfig().hasSkins() ? this.SELECTED_PORTRAIT_BG_ASSET_NAME : FSBattlefieldUserPortrait.FRAME_BG_NAME;
            this.mSelectedPortraitViewer = new PortraitViewer(_loc1_,null,_loc2_,null,false,null,true,0.9);
            this.mSelectedPortraitViewer.x = mBox.width / 2 - this.mSelectedPortraitViewer.width / 2;
            this.mSelectedPortraitViewer.y = this.mShowPortraits ? -this.mSelectedPortraitViewer.height / 3 : mBox.height / 3;
            addChild(this.mSelectedPortraitViewer);
            this.mSelectedPortraitViewer.touchable = true;
            this.mSelectedPortraitViewer.addEventListener(TouchEvent.TOUCH,this.onUsernameTouch);
         }
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         super.onPopupOpenTransitionOver();
         if(InstanceMng.getTutorialMapMng().isTutorialON())
         {
            touchable = true;
            InstanceMng.getTutorialMapMng().increaseCurrentStep();
         }
         if(!mClosed)
         {
            if(this.mSelectedPortraitViewer)
            {
               this.mSelectedPortraitViewer.createUserPortrait();
            }
         }
      }
      
      private function createSkinsContainer() : void
      {
         var _loc1_:FSSkinSlot = null;
         var _loc2_:HeroCharacterDef = null;
         var _loc3_:UserData = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(this.mShowSkins)
         {
            if(Boolean(mBox) && this.mSkinsScrollContainer == null)
            {
               this.mSkinsScrollContainer = new ScrollContainer();
               this.mSkinsScrollContainer.width = mBox.width * 0.8;
               this.mSkinsScrollContainer.height = mBox.height * 0.6;
               this.mSkinsScrollContainer.layout = this.getContainerSkinLayout();
               this.mSkinsScrollContainer.scrollBarDisplayMode = ScrollBarDisplayMode.FIXED;
               this.mSkinsScrollContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
               this.mSkinsScrollContainer.verticalScrollPolicy = ScrollPolicy.OFF;
               this.mSkinsScrollContainer.x = (mBox.width - this.mSkinsScrollContainer.width) / 2;
               this.mSkinsScrollContainer.y = mBox.height * 0.2;
               addChild(this.mSkinsScrollContainer);
            }
            _loc3_ = Utils.getOwnerUserData();
            if(this.mSkinsArr)
            {
               _loc4_ = this.getStartIndexCurrentPage();
               while(_loc4_ < this.getEndIndexCurrentPage())
               {
                  _loc2_ = this.mSkinsArr[_loc4_];
                  if(_loc2_)
                  {
                     if(this.filterAppliesToSkin(this.mActiveFilter,_loc2_))
                     {
                        _loc5_ = _loc3_.getCurrentSkinSku();
                        _loc1_ = new FSSkinSlot(_loc2_,_loc5_ == _loc2_.getSku(),this);
                        _loc1_.alpha = 0.001;
                        this.mSkinsScrollContainer.addChild(_loc1_);
                        SpecialFX.tweenToAlpha(_loc1_,0.999,0.25,0);
                     }
                  }
                  _loc4_++;
               }
            }
         }
      }
      
      private function getStartIndexCurrentPage() : int
      {
         return this.mCurrentPageSkin * SKINS_BY_PAGE;
      }
      
      private function getEndIndexCurrentPage() : int
      {
         var _loc1_:int = 0;
         if(this.getStartIndexCurrentPage() + SKINS_BY_PAGE < this.mSkinsArr.length)
         {
            _loc1_ = this.getStartIndexCurrentPage() + SKINS_BY_PAGE;
         }
         else
         {
            _loc1_ = int(this.mSkinsArr.length);
         }
         return _loc1_;
      }
      
      private function createMiniPortraitsContainer() : void
      {
         var _loc1_:PortraitViewer = null;
         var _loc2_:Dictionary = null;
         var _loc3_:Array = null;
         var _loc4_:PortraitDef = null;
         var _loc5_:UserData = null;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         if(this.mShowPortraits)
         {
            if(this.mMiniPortraitsScrollContainer == null)
            {
               this.mMiniPortraitsScrollContainer = new ScrollContainer();
               this.mMiniPortraitsScrollContainer.width = mBox.width * 0.85;
               this.mMiniPortraitsScrollContainer.height = mBox.height / 2;
               this.mMiniPortraitsScrollContainer.layout = this.getContainerLayout();
               this.mMiniPortraitsScrollContainer.scrollBarDisplayMode = ScrollBarDisplayMode.FIXED;
               this.mMiniPortraitsScrollContainer.x = (mBox.width - this.mMiniPortraitsScrollContainer.width) / 2;
               this.mMiniPortraitsScrollContainer.y = this.mSelectedPortraitViewer.y + this.mSelectedPortraitViewer.height;
               addChild(this.mMiniPortraitsScrollContainer);
            }
            _loc2_ = InstanceMng.getPortraitsDefMng().getAllDefs();
            _loc3_ = DictionaryUtils.sortDictionaryByKey(_loc2_);
            _loc5_ = Utils.getOwnerUserData();
            _loc6_ = false;
            if(_loc3_)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc3_.length)
               {
                  _loc4_ = _loc3_[_loc7_].value;
                  if(_loc4_)
                  {
                     _loc1_ = new PortraitViewer(_loc4_,null,null,this.onMiniPortraitClicked);
                     _loc6_ = _loc5_.isPortraitAvailable(_loc4_.getSku());
                     _loc1_.setAvailable(_loc6_);
                     this.mMiniPortraitsScrollContainer.addChild(_loc1_);
                  }
                  _loc7_++;
               }
            }
         }
      }
      
      public function onMiniPortraitClicked(param1:TouchEvent) : void
      {
         var _loc3_:PortraitDef = null;
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(this.mMiniPortraitsScrollContainer)
            {
               if(PortraitViewer(param1.currentTarget).isAvailable())
               {
                  _loc3_ = PortraitViewer(param1.currentTarget).getPortraitDef();
                  if(_loc3_)
                  {
                     this.mFuturePortraitSku = _loc3_.getSku();
                     this.mSelectedPortraitViewer.updatePortraitDef(_loc3_);
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_PORTRAIT_UNLOCK_REQUIRED"),true);
               }
            }
         }
      }
      
      private function getContainerLayout() : TiledRowsLayout
      {
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.horizontalGap = 0;
         _loc1_.padding = 0;
         _loc1_.verticalAlign = VerticalAlign.MIDDLE;
         _loc1_.tileVerticalAlign = VerticalAlign.MIDDLE;
         _loc1_.horizontalAlign = HorizontalAlign.CENTER;
         _loc1_.tileHorizontalAlign = HorizontalAlign.CENTER;
         return _loc1_;
      }
      
      private function getContainerSkinLayout() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.verticalAlign = VerticalAlign.MIDDLE;
         _loc1_.gap = 10;
         _loc1_.horizontalAlign = HorizontalAlign.CENTER;
         return _loc1_;
      }
      
      override protected function onAccept(param1:Event) : void
      {
         if(mIsBeingHidden)
         {
            return;
         }
         if(this.mUsernameLabel.text != "")
         {
            if(this.mFuturePlayerName == null || this.mUsernameTextInput == null)
            {
               super.onAccept(param1);
               mOnClosedFunction = this.onAcceptPerformOps;
            }
            else
            {
               this.mExitRequested = true;
            }
         }
         else
         {
            Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_GEN_USER_MIN"),[4]),true);
         }
      }
      
      override public function onClose(param1:Event) : void
      {
         if(param1)
         {
            param1.stopImmediatePropagation();
         }
         if(this.mFuturePortraitSku != null && this.mFuturePortraitSku != "")
         {
            Utils.setLogText(TextManager.getText("TID_DATA_NOT_SAVED"),true);
            closePopup();
         }
         else
         {
            closePopup();
         }
      }
      
      private function onAcceptPerformOps() : void
      {
         if(this.mFuturePortraitSku != null && this.mFuturePortraitSku != "")
         {
            InstanceMng.getUserDataMng().getOwnerUserData().setCurrentPortraitSku(this.mFuturePortraitSku);
         }
         InstanceMng.getUserDataMng().updateCurrentPortraitSku();
         Utils.setLogText(TextManager.getText("TID_DATA_SAVED"));
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         super.setupAcceptButton(param1,param2,param3);
         if(mAcceptButton)
         {
            mAcceptButton.y += mAcceptButton.height / 2;
         }
      }
      
      override public function onConnectionChange() : void
      {
         super.onConnectionChange();
         if(this.mUsernameLabel)
         {
            this.mUsernameLabel.touchable = InstanceMng.getServerConnection().isUserLoggedIn();
         }
         if(mAcceptButton)
         {
            mAcceptButton.enabled = InstanceMng.getServerConnection().isUserLoggedIn();
         }
      }
      
      public function removeSelectedText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Component = null;
         if(Boolean(this.mSkinsScrollContainer) && this.mSkinsScrollContainer.numChildren > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mSkinsScrollContainer.numChildren)
            {
               _loc2_ = Component(this.mSkinsScrollContainer.getChildAt(_loc1_));
               if(_loc2_ != null)
               {
                  if(_loc2_ is FSSkinSlot)
                  {
                     FSSkinSlot(_loc2_).removeSelectedText();
                  }
               }
               _loc1_++;
            }
         }
      }
      
      private function createFilterButtons() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:HorizontalLayout = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(Boolean(mBox) && this.mSkinFilterButtonsContainer == null)
         {
            this.mSkinFilterButtonsContainer = new ScrollContainer();
            _loc2_ = new HorizontalLayout();
            _loc2_.gap = mBox.width / 35;
            this.mSkinFilterButtonsContainer.layout = _loc2_;
            this.mSkinFilterButtonsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mSkinFilterButtonsContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            this.mSkinFilterButtonsContainer.x = mBox.width * 0.05;
            this.mSkinFilterButtonsContainer.y = mBox.height * 0.1;
            addChild(this.mSkinFilterButtonsContainer);
            _loc1_ = new SubcategoryToggleButton("skin_filter_all_off","skin_filter_all_on");
            _loc1_.name = "all";
            _loc1_.setTooltipText(TextManager.getText("TID_GEN_SKINS_ALL"));
            this.mSkinFilterButtonsContainer.addChild(_loc1_);
            _loc1_.addEventListener(TouchEvent.TOUCH,this.onSkinFilterToggleTouch);
            this.mActiveFilter = -1;
            _loc3_ = 0;
            while(_loc3_ < 7)
            {
               if(this.hasSkinsByFilter(_loc3_ + 1))
               {
                  if(_loc3_ == 0)
                  {
                     _loc4_ = "skin_filter_raids_off";
                     _loc5_ = "skin_filter_raids_on";
                     _loc6_ = TextManager.getText("TID_RAID");
                  }
                  else if(_loc3_ == 1)
                  {
                     _loc4_ = "skin_filter_quest_off";
                     _loc5_ = "skin_filter_quest_on";
                     _loc6_ = TextManager.getText("TID_QUEST_JOURNAL");
                  }
                  else if(_loc3_ == 2)
                  {
                     _loc4_ = "skin_filter_pvp_off";
                     _loc5_ = "skin_filter_pvp_on";
                     _loc6_ = TextManager.getText("TID_GEN_MENU_PVP");
                  }
                  else if(_loc3_ == 3)
                  {
                     _loc4_ = "skin_filter_level_off";
                     _loc5_ = "skin_filter_level_on";
                     _loc6_ = TextManager.getText("TID_ACHIEVEMENT_LEVEL");
                  }
                  else if(_loc3_ == 4)
                  {
                     _loc4_ = "skin_filter_dungeon_off";
                     _loc5_ = "skin_filter_dungeon_on";
                     _loc6_ = TextManager.getText("TID_DUNGEON_NAME");
                  }
                  else if(_loc3_ == 5)
                  {
                     _loc4_ = "skin_filter_shop_off";
                     _loc5_ = "skin_filter_shop_on";
                     _loc6_ = TextManager.getText("TID_GEN_MENU_SHOP");
                  }
                  else if(_loc3_ == 6)
                  {
                     _loc4_ = "skin_filter_guild_off";
                     _loc5_ = "skin_filter_guild_on";
                     _loc6_ = TextManager.getText("TID_RAID");
                  }
                  _loc1_ = new SubcategoryToggleButton(_loc4_,_loc5_);
                  _loc1_.name = (_loc3_ + 1).toString();
                  _loc1_.setTooltipText(_loc6_);
                  this.mSkinFilterButtonsContainer.addChild(_loc1_);
                  _loc1_.addEventListener(TouchEvent.TOUCH,this.onSkinFilterToggleTouch);
               }
               _loc3_++;
            }
            this.mSkinFilterButtonsContainer.validate();
            this.mSkinFilterButtonsContainer.x = (mBox.width - this.mSkinFilterButtonsContainer.width) / 2;
            this.mSkinFilterButtonsContainer.y = mBox.height * 0.1;
         }
      }
      
      private function onSkinFilterToggleTouch(param1:TouchEvent) : void
      {
         var _loc3_:FSToggleButton = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(!Root.assets.isLoading)
            {
               if(this.mSkinFilterButtonsContainer)
               {
                  _loc5_ = 0;
                  while(_loc5_ < this.mSkinFilterButtonsContainer.numChildren)
                  {
                     _loc3_ = FSToggleButton(this.mSkinFilterButtonsContainer.getChildAt(_loc5_));
                     if(_loc3_)
                     {
                        _loc3_.touchable = false;
                     }
                     _loc5_++;
                  }
               }
               _loc3_ = FSToggleButton(param1.currentTarget);
               _loc4_ = _loc3_.name;
               if(_loc4_ != "" || _loc4_ != null)
               {
                  if(_loc4_ == "all")
                  {
                     if(this.mSkinFilterButtonsContainer)
                     {
                        _loc5_ = 0;
                        while(_loc5_ < this.mSkinFilterButtonsContainer.numChildren)
                        {
                           _loc3_ = FSToggleButton(this.mSkinFilterButtonsContainer.getChildAt(_loc5_));
                           if(Boolean(_loc3_) && _loc3_.name != "all")
                           {
                              _loc3_.touchable = true;
                           }
                           _loc5_++;
                        }
                     }
                     if(this.mSkinFilterButtonsContainer)
                     {
                        _loc5_ = 0;
                        while(_loc5_ < this.mSkinFilterButtonsContainer.numChildren)
                        {
                           _loc3_ = FSToggleButton(this.mSkinFilterButtonsContainer.getChildAt(_loc5_));
                           if(_loc3_)
                           {
                              if(!_loc3_.isToggled())
                              {
                                 _loc3_.setToggled();
                              }
                           }
                           _loc5_++;
                        }
                     }
                     this.mActiveFilter = -1;
                     if(!_loc3_.isToggled())
                     {
                        _loc3_.setToggled();
                        return;
                     }
                  }
                  else
                  {
                     this.mActiveFilter = int(_loc3_.name);
                     if(_loc3_.name == _loc4_ && !_loc3_.isToggled())
                     {
                        _loc3_.setToggled();
                     }
                     _loc5_ = 0;
                     while(_loc5_ < this.mSkinFilterButtonsContainer.numChildren)
                     {
                        _loc3_ = FSToggleButton(this.mSkinFilterButtonsContainer.getChildAt(_loc5_));
                        if(_loc3_)
                        {
                           if(_loc3_.name != _loc4_)
                           {
                              if(_loc3_.isToggled())
                              {
                                 _loc3_.setToggled();
                              }
                           }
                        }
                        _loc5_++;
                     }
                     if(this.mSkinFilterButtonsContainer)
                     {
                        _loc5_ = 0;
                        while(_loc5_ < this.mSkinFilterButtonsContainer.numChildren)
                        {
                           _loc3_ = FSToggleButton(this.mSkinFilterButtonsContainer.getChildAt(_loc5_));
                           if(Boolean(_loc3_ != null) && Boolean(FSToggleButton(param1.currentTarget)) && FSToggleButton(param1.currentTarget).name != _loc3_.name)
                           {
                              _loc3_.touchable = true;
                           }
                           _loc5_++;
                        }
                     }
                  }
               }
               this.mCurrentPageSkin = 0;
               this.getSkins(this.mActiveFilter);
               this.cleanScrollContainer(this.mSkinsScrollContainer,this.loadSkinsByPage);
            }
         }
      }
      
      public function lockShopUI(param1:Boolean) : void
      {
      }
      
      public function getFutureName() : String
      {
         return this.mFuturePlayerName;
      }
      
      public function setFutureName(param1:String) : void
      {
         this.mFuturePlayerName = param1;
      }
      
      public function resetOriginalName() : void
      {
         if(this.mUsernameLabel)
         {
            this.mUsernameLabel.text = InstanceMng.getUserDataMng().getOwnerUserData().getName();
         }
         if(this.mUsernameTextInput)
         {
            this.mUsernameTextInput.text = InstanceMng.getUserDataMng().getOwnerUserData().getName();
         }
      }
      
      private function lockPageButtons(param1:Boolean) : void
      {
         if(this.mPrevPageButton)
         {
            this.mPrevPageButton.touchable = !param1;
         }
         if(this.mNextPageButton)
         {
            this.mNextPageButton.touchable = !param1;
         }
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
   }
}

