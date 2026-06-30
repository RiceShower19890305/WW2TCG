package com.fs.tcgengine.view.popups.pvp
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.PortraitDef;
   import com.fs.tcgengine.model.rules.PvPRewardsDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSPvPScreen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.buttons.FSSideImageButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.fs.tcgengine.view.pvp.FSPvPMedalSlot;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.VerticalLayout;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class PopupPvPRewardsInfo extends PopupStandard
   {
      
      private var mPvPSeasonRewardButton:FSSideImageButton;
      
      private var mPvPSeasonRewardButtonIcon:FSImage;
      
      private var mPvPSeasonButton:FSSideImageButton;
      
      private var mPvPSeasonIcon:FSImage;
      
      private var mInfoButton:FSButton;
      
      private var mMonthlyTournamentTextfield:FSTextfield;
      
      protected var mCharacterSkinBG:Quad;
      
      private var mRewardChestImage:FSImage;
      
      protected var mRewardChestTextfield:FSTextfield;
      
      protected var mRewardChestSeasonNumberTextfield:FSTextfield;
      
      private var mRewardExclusiveTextfield:FSTextfield;
      
      protected var mRewardsDefsArr:Array;
      
      private var mMedalScrollContainer:ScrollContainer;
      
      private var mPvpSeasonRewardsArr:Array;
      
      private var mRewardScrollContainer:ScrollContainer;
      
      protected var mNoRewardsTextfield:FSTextfield;
      
      protected var mVictoriesLeftInThisSeason:Number;
      
      protected var mExclusiveRewardImg:FSImage;
      
      protected var mExclusiveRewardImgName:String;
      
      public function PopupPvPRewardsInfo(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = this.getBGName();
      }
      
      override protected function createUI() : void
      {
         if(this.isOkToOpen())
         {
            this.setLeftVictories();
            super.createUI();
            this.createPvPSeasonPage();
            this.hideOkbutton();
         }
         else
         {
            closePopup();
         }
      }
      
      protected function isOkToOpen() : Boolean
      {
         return InstanceMng.getCurrentScreen().isFullyLoaded() && InstanceMng.getCurrentScreen() is FSPvPScreen;
      }
      
      protected function getRewards() : void
      {
         this.mRewardsDefsArr = InstanceMng.getPvPRewardsDefMng().getPvPRewards();
         if(this.mRewardsDefsArr)
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(true,true,Align.CENTER,Align.CENTER,1,null,this);
            InstanceMng.getResourcesMng().loadAssets(this.onItemsLoaded);
         }
      }
      
      protected function onItemsLoaded() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
         this.createMedalScrollContainer();
         this.createMedalRanking();
      }
      
      protected function createMedalRanking() : void
      {
         var _loc1_:int = 0;
         var _loc2_:PvPRewardsDef = null;
         var _loc3_:FSPvPMedalSlot = null;
         for each(_loc2_ in this.mRewardsDefsArr)
         {
            _loc3_ = new FSPvPMedalSlot(_loc2_,this);
            if(_loc3_)
            {
               this.addToMedalRankingScrollContainer(_loc3_);
            }
         }
      }
      
      protected function addToMedalRankingScrollContainer(param1:DisplayObject) : void
      {
         if(param1)
         {
            if(this.mMedalScrollContainer)
            {
               this.mMedalScrollContainer.addChild(param1);
            }
         }
      }
      
      private function createMedalScrollContainer() : void
      {
         if(mBox)
         {
            this.mMedalScrollContainer = new ScrollContainer();
            this.mMedalScrollContainer.layout = this.getContainerLayout();
            this.mMedalScrollContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            this.mMedalScrollContainer.touchable = false;
            this.mMedalScrollContainer.height = mBox.height * 0.4;
            this.mMedalScrollContainer.x = mBox.x + mBox.width * 0.04;
            this.mMedalScrollContainer.y = mBox.y + mBox.height * 0.55;
            addChild(this.mMedalScrollContainer);
         }
      }
      
      private function getContainerLayout() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.gap = Utils.isAndroidOrDesktop() || Utils.isBrowser() ? 15 : 25;
         _loc1_.paddingLeft = 8;
         return _loc1_;
      }
      
      private function createPvPSeasonPage() : void
      {
         this.createInfoButton();
         this.createMonthlyTournametTextfield();
         this.createCharacterSkinPlaceHolder();
         this.createRewardChestPlaceHolder();
         this.createRewardExclusiveTextfield();
         this.getRewards();
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
      
      override public function onClose(param1:Event) : void
      {
         this.lockTabs(true);
         super.onClose(param1);
      }
      
      private function lockTabs(param1:Boolean) : void
      {
         if(this.mPvPSeasonButton)
         {
            this.mPvPSeasonButton.setEnabled(!param1);
         }
         if(this.mPvPSeasonRewardButton)
         {
            this.mPvPSeasonRewardButton.setEnabled(!param1);
         }
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mPvPSeasonButton)
         {
            this.mPvPSeasonButton.removeFromParent(true);
            this.mPvPSeasonButton = null;
         }
         if(this.mPvPSeasonIcon)
         {
            this.mPvPSeasonIcon.removeFromParent(true);
            this.mPvPSeasonIcon = null;
         }
         if(this.mPvPSeasonRewardButton)
         {
            this.mPvPSeasonRewardButton.removeFromParent(true);
            this.mPvPSeasonRewardButton = null;
         }
         if(this.mPvPSeasonRewardButtonIcon)
         {
            this.mPvPSeasonRewardButtonIcon.removeFromParent(true);
            this.mPvPSeasonRewardButtonIcon = null;
         }
         if(this.mInfoButton)
         {
            this.mInfoButton.removeFromParent(true);
            this.mInfoButton = null;
         }
         if(this.mMonthlyTournamentTextfield)
         {
            this.mMonthlyTournamentTextfield.removeFromParent(true);
            this.mMonthlyTournamentTextfield = null;
         }
         if(this.mCharacterSkinBG)
         {
            this.mCharacterSkinBG.removeFromParent(true);
            this.mCharacterSkinBG = null;
         }
         if(this.mRewardChestImage)
         {
            this.mRewardChestImage.removeFromParent(true);
            this.mRewardChestImage = null;
         }
         if(this.mRewardChestTextfield)
         {
            this.mRewardChestTextfield.removeFromParent(true);
            this.mRewardChestTextfield = null;
         }
         if(this.mRewardChestSeasonNumberTextfield)
         {
            this.mRewardChestSeasonNumberTextfield.removeFromParent(true);
            this.mRewardChestSeasonNumberTextfield = null;
         }
         if(this.mRewardExclusiveTextfield)
         {
            this.mRewardExclusiveTextfield.removeFromParent(true);
            this.mRewardExclusiveTextfield = null;
         }
         if(this.mNoRewardsTextfield)
         {
            this.mNoRewardsTextfield.removeFromParent(true);
            this.mNoRewardsTextfield = null;
         }
         Utils.destroyArray(this.mRewardsDefsArr);
         this.mRewardsDefsArr = null;
         Utils.destroyArray(this.mPvpSeasonRewardsArr);
         this.mPvpSeasonRewardsArr = null;
         if(this.mMedalScrollContainer)
         {
            this.cleanScrollContainer(this.mMedalScrollContainer);
            this.mMedalScrollContainer.removeFromParent(true);
            this.mMedalScrollContainer = null;
         }
         if(this.mRewardScrollContainer)
         {
            this.cleanScrollContainer(this.mRewardScrollContainer);
            this.mRewardScrollContainer.removeFromParent(true);
            this.mRewardScrollContainer = null;
         }
         if(this.mExclusiveRewardImg)
         {
            this.mExclusiveRewardImg.removeFromParent();
            this.mExclusiveRewardImg.destroy();
            this.mExclusiveRewardImg = null;
         }
         Root.assets.removeTexture(this.mExclusiveRewardImgName);
         InstanceMng.getPopupMng().removePopup(FSPopupMng.PVP_SEASON_REWARD_POPUP_NAME);
         super.removeFromStage();
      }
      
      private function createInfoButton() : void
      {
         if(Boolean(mBox) && this.mInfoButton == null)
         {
            this.mInfoButton = new FSButton(Root.assets.getTexture(this.getInfoButtonName()));
            this.mInfoButton.x = mBox.x + this.mInfoButton.width;
            this.mInfoButton.y = mBox.y + this.mInfoButton.height;
            this.mInfoButton.scaleWhenDown = 1;
            this.mInfoButton.enableScaleOnMouseOver(false);
            this.mInfoButton.setTooltipText(this.getTIDToolTipInfoButton());
            addChild(this.mInfoButton);
         }
      }
      
      private function createMonthlyTournametTextfield() : void
      {
         if(Boolean(this.mInfoButton) && this.mMonthlyTournamentTextfield == null)
         {
            this.mMonthlyTournamentTextfield = new FSTextfield(mBox.width * 0.4,this.mInfoButton.height,this.getTIDMonthlyTournament());
            this.mMonthlyTournamentTextfield.x = this.mInfoButton.x + this.mInfoButton.width * 0.8;
            this.mMonthlyTournamentTextfield.y = this.mInfoButton.y - this.mMonthlyTournamentTextfield.height / 2;
            addChild(this.mMonthlyTournamentTextfield);
         }
      }
      
      protected function createCharacterSkinPlaceHolder() : void
      {
         this.createCharacterSkinBG();
         this.loadImage();
      }
      
      protected function loadImage(param1:Boolean = true) : void
      {
         var onInfoReceived:Function;
         var imgToLoad:String = null;
         var isPvP:Boolean = param1;
         imgToLoad = "";
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            onInfoReceived = function(param1:Object):void
            {
               var _loc3_:Array = null;
               var _loc4_:int = 0;
               var _loc5_:int = 0;
               var _loc6_:String = null;
               var _loc7_:String = null;
               var _loc8_:HeroCharacterDef = null;
               var _loc9_:PortraitDef = null;
               var _loc2_:Array = param1 as Array;
               if(_loc2_ != null && _loc2_.length > 0)
               {
                  imgToLoad = _loc2_[0].hasOwnProperty("defaultSkin") ? _loc2_[0].defaultSkin : "";
                  _loc3_ = _loc2_[0].hasOwnProperty("seasons") ? _loc2_[0].seasons : null;
                  if(Boolean(_loc3_) && _loc3_.length > 0)
                  {
                     _loc4_ = 0;
                     while(_loc4_ < _loc3_.length)
                     {
                        _loc6_ = _loc2_[0].seasons[_loc4_].hasOwnProperty("sku") ? _loc2_[0].seasons[_loc4_].sku : "";
                        _loc5_ = _loc2_[0].seasons[_loc4_].hasOwnProperty("season") ? int(_loc2_[0].seasons[_loc4_].season) : 0;
                        if(_loc5_ == Config.smServerConfig["pvp_season"])
                        {
                           _loc7_ = _loc2_[0].seasons[_loc4_].hasOwnProperty("origin") ? _loc2_[0].seasons[_loc4_].origin : "";
                           if(isPvP)
                           {
                              if(_loc7_ == "pvp")
                              {
                                 imgToLoad = _loc6_;
                                 break;
                              }
                           }
                           else if(_loc7_ == "dungeon")
                           {
                              imgToLoad = _loc6_;
                              break;
                           }
                        }
                        _loc4_++;
                     }
                  }
                  if(imgToLoad != "")
                  {
                     if(Config.getConfig().hasSkins())
                     {
                        _loc8_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(imgToLoad.toLowerCase()));
                        imgToLoad = _loc8_.getBGImageName();
                     }
                     else if(!Config.smPortraitFramesInAtlas)
                     {
                        _loc9_ = PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(imgToLoad.toLowerCase()));
                        imgToLoad = _loc9_.getBGImageName();
                     }
                  }
               }
               imgToLoad = imgToLoad != "" && imgToLoad != null ? imgToLoad : getDefaultSpecialRewardImgName(isPvP);
               loadSpecialRewardImage(imgToLoad);
            };
            InstanceMng.getServerConnection().searchInCollection("pvpAndDungeonsExtrasAwards","{}",onInfoReceived);
         }
         else
         {
            imgToLoad = this.getDefaultSpecialRewardImgName(isPvP);
            this.loadSpecialRewardImage(imgToLoad);
         }
      }
      
      private function loadSpecialRewardImage(param1:String = "") : void
      {
         this.mExclusiveRewardImgName = param1;
         if(param1 != "" && Root.assets.getTexture(param1) == null)
         {
            InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + param1,FSResourceMng.TYPE_TEXTURE_PNG);
            InstanceMng.getResourcesMng().loadAssets(this.createImg);
         }
         else
         {
            this.createImg();
         }
      }
      
      private function getDefaultSpecialRewardImgName(param1:Boolean = true) : String
      {
         var _loc3_:PortraitDef = null;
         var _loc4_:HeroCharacterDef = null;
         var _loc2_:String = "";
         if(Config.getConfig().hasPortraits() && !Config.smPortraitFramesInAtlas)
         {
            if(param1)
            {
               _loc3_ = InstanceMng.getPortraitsDefMng().getPvPExclusiveRewardBySeason(Config.smServerConfig["pvp_season"]);
            }
            else
            {
               _loc3_ = InstanceMng.getPortraitsDefMng().getDungeonExclusiveRewardBySeason(Config.smServerConfig["dungeons_season"]);
            }
            _loc2_ = _loc3_.getBGImageName();
         }
         else if(Config.getConfig().hasSkins())
         {
            if(param1)
            {
               _loc4_ = InstanceMng.getHeroCharactersDefMng().getPvPExclusiveRewardBySeason(Config.smServerConfig["pvp_season"]);
            }
            else
            {
               _loc4_ = InstanceMng.getHeroCharactersDefMng().getDungeonExclusiveRewardBySeason(Config.smServerConfig["dungeons_season"]);
            }
            _loc2_ = _loc4_.getBGImageName();
         }
         return _loc2_;
      }
      
      protected function createImg() : void
      {
         if(Boolean(this.mCharacterSkinBG) && this.mExclusiveRewardImg == null)
         {
            this.mExclusiveRewardImg = new FSImage(Root.assets.getTexture(this.mExclusiveRewardImgName));
            if(Config.getConfig().hasSkins())
            {
               this.mExclusiveRewardImg.scaleX *= 0.5;
               this.mExclusiveRewardImg.scaleY *= 0.5;
            }
            this.mExclusiveRewardImg.alignPivot();
            this.mExclusiveRewardImg.x = this.mCharacterSkinBG.x + this.mCharacterSkinBG.width / 2;
            this.mExclusiveRewardImg.y = this.mCharacterSkinBG.y + this.mCharacterSkinBG.height / 2;
            addChild(this.mExclusiveRewardImg);
         }
      }
      
      private function createCharacterSkinBG() : void
      {
         if(Boolean(mBox) && Boolean(this.mMonthlyTournamentTextfield) && this.mCharacterSkinBG == null)
         {
            this.mCharacterSkinBG = new Quad(mBox.width * 0.3,mBox.height * 0.3,0);
            this.mCharacterSkinBG.x = this.mMonthlyTournamentTextfield.x + this.mMonthlyTournamentTextfield.width * 1.1;
            this.mCharacterSkinBG.y = this.mMonthlyTournamentTextfield.y - this.mMonthlyTournamentTextfield.height / 4;
            this.mCharacterSkinBG.alpha = 0.5;
            addChild(this.mCharacterSkinBG);
         }
      }
      
      private function createRewardChestPlaceHolder() : void
      {
         this.createRewardChestImage();
         this.createRewardChestTextfield();
         this.createRewardChestSeasonNumberTextfield();
      }
      
      private function createRewardExclusiveTextfield() : void
      {
         if(Boolean(mBox) && Boolean(this.mRewardChestSeasonNumberTextfield) && this.mRewardExclusiveTextfield == null)
         {
            this.mRewardExclusiveTextfield = new FSTextfield(mBox.width * 0.4,this.mRewardChestSeasonNumberTextfield.height * 2,this.getTIDRewardExclusive());
            this.mRewardExclusiveTextfield.x = this.mRewardChestSeasonNumberTextfield.x + this.mRewardChestSeasonNumberTextfield.width * 1.3;
            this.mRewardExclusiveTextfield.y = this.mRewardChestSeasonNumberTextfield.y;
            addChild(this.mRewardExclusiveTextfield);
         }
      }
      
      private function createRewardChestImage() : void
      {
         if(Boolean(this.mInfoButton) && this.mRewardChestImage == null)
         {
            this.mRewardChestImage = new FSImage(Root.assets.getTexture(this.getRewardChestName()));
            this.mRewardChestImage.x = this.mInfoButton.x - this.mRewardChestImage.width * 0.3;
            this.mRewardChestImage.y = this.mInfoButton.y + this.mInfoButton.height;
            addChild(this.mRewardChestImage);
         }
      }
      
      private function createRewardChestTextfield() : void
      {
         if(Boolean(mBox) && Boolean(this.mRewardChestImage) && this.mRewardChestTextfield == null)
         {
            this.mRewardChestTextfield = new FSTextfield(mBox.width * 0.3,this.mRewardChestImage.height,this.getTIDLevelReward());
            this.mRewardChestTextfield.x = this.mRewardChestImage.x + this.mRewardChestImage.width;
            this.mRewardChestTextfield.y = this.mRewardChestImage.y - this.mRewardChestImage.height * 0.3;
            this.mRewardChestTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mRewardChestTextfield.fontSize *= 1.2;
            addChild(this.mRewardChestTextfield);
         }
      }
      
      protected function createRewardChestSeasonNumberTextfield() : void
      {
         if(Boolean(mBox) && Boolean(this.mRewardChestTextfield) && this.mRewardChestSeasonNumberTextfield == null)
         {
            this.mRewardChestSeasonNumberTextfield = new FSTextfield(this.mRewardChestTextfield.width,this.mRewardChestTextfield.height * 0.5,this.getTIDSeason());
            this.mRewardChestSeasonNumberTextfield.x = this.mRewardChestTextfield.x;
            this.mRewardChestSeasonNumberTextfield.y = this.mRewardChestTextfield.y + this.mRewardChestTextfield.height;
            addChild(this.mRewardChestSeasonNumberTextfield);
         }
      }
      
      private function cleanPvPSeasonPage() : void
      {
         if(this.mInfoButton)
         {
            this.mInfoButton.removeFromParent();
            this.mInfoButton.destroy();
            this.mInfoButton = null;
         }
         if(this.mMonthlyTournamentTextfield)
         {
            this.mMonthlyTournamentTextfield.removeFromParent();
            this.mMonthlyTournamentTextfield = null;
         }
         if(this.mCharacterSkinBG)
         {
            this.mCharacterSkinBG.removeFromParent();
            this.mCharacterSkinBG = null;
         }
         if(this.mRewardChestImage)
         {
            this.mRewardChestImage.removeFromParent();
            this.mRewardChestImage.destroy();
            this.mRewardChestImage = null;
         }
         if(this.mRewardChestTextfield)
         {
            this.mRewardChestTextfield.removeFromParent();
            this.mRewardChestTextfield = null;
         }
         if(this.mRewardChestSeasonNumberTextfield)
         {
            this.mRewardChestSeasonNumberTextfield.removeFromParent();
            this.mRewardChestSeasonNumberTextfield = null;
         }
         if(this.mRewardExclusiveTextfield)
         {
            this.mRewardExclusiveTextfield.removeFromParent();
            this.mRewardExclusiveTextfield = null;
         }
         if(this.mMedalScrollContainer)
         {
            this.cleanScrollContainer(this.mMedalScrollContainer);
            this.mMedalScrollContainer.removeFromParent();
            this.mMedalScrollContainer = null;
         }
         if(this.mExclusiveRewardImg)
         {
            this.mExclusiveRewardImg.removeFromParent();
            this.mExclusiveRewardImg.destroy();
            this.mExclusiveRewardImg = null;
         }
      }
      
      private function cleanPvPSeasonRewardPage() : void
      {
         if(this.mRewardScrollContainer)
         {
            this.cleanScrollContainer(this.mRewardScrollContainer);
            this.mRewardScrollContainer.removeFromParent();
            this.mRewardScrollContainer = null;
         }
         if(this.mNoRewardsTextfield)
         {
            this.mNoRewardsTextfield.removeFromParent();
            this.mNoRewardsTextfield = null;
         }
      }
      
      public function unlockClaimRewardsContainer() : void
      {
         if(this.mRewardScrollContainer)
         {
            this.mRewardScrollContainer.touchable = true;
         }
      }
      
      public function lockClaimRewardsContainerTemporarily() : void
      {
         if(this.mRewardScrollContainer)
         {
            this.mRewardScrollContainer.touchable = false;
         }
      }
      
      protected function createExclusiveReward(param1:String, param2:int) : Object
      {
         var _loc3_:Object = new Object();
         _loc3_.type = param2;
         _loc3_.sku = param1;
         _loc3_.amount = 1;
         _loc3_.seasonId = Config.smServerConfig["pvp_season"];
         _loc3_.timestampMS = ServerConnection.smServerTimeMS;
         return _loc3_;
      }
      
      protected function createPvPSeasonRewardScrollContainer() : void
      {
         if(this.mRewardScrollContainer == null && Boolean(mBox))
         {
            this.mRewardScrollContainer = new ScrollContainer();
            this.mRewardScrollContainer.layout = this.getContainerVerticalLayout();
            this.mRewardScrollContainer.height = mBox.height * 0.8;
            this.mRewardScrollContainer.x = mBox.width * 0.05;
            this.mRewardScrollContainer.y = mBox.height * 0.1;
            addChild(this.mRewardScrollContainer);
         }
      }
      
      private function getContainerVerticalLayout() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 5;
         return _loc1_;
      }
      
      private function hideOkbutton() : void
      {
         if(mAcceptButton)
         {
            mAcceptButton.visible = false;
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
            TweenMax.delayedCall(_loc5_ + 0.25,param2);
         }
      }
      
      private function removeComponentFromParent(param1:Component) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      protected function getBGName() : String
      {
         return Constants.POPUP_EXTENDED_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,1200);
         if(Boolean(mBox) && Config.getConfig().gameHasCustomPopups())
         {
            mBox.scale = Constants.POPUP_EXTENDED_SCALE_FACTOR;
         }
      }
      
      protected function getButtonRewardName() : String
      {
         return "pvp_reward_button";
      }
      
      protected function getButtonName() : String
      {
         return "pvp_season_button";
      }
      
      protected function getInfoButtonName() : String
      {
         return "pvp_info_button";
      }
      
      protected function getRewardChestName() : String
      {
         return "pvp_reward_large_chest";
      }
      
      protected function getTIDNoRewards() : String
      {
         return InstanceMng.getCurrentScreen() is FSPvPScreen ? TextManager.getText("TID_RAID_REWARDS_EMPTY") + " " + FSPvPScreen(InstanceMng.getCurrentScreen()).getSeasonEndTime() : TextManager.getText("TID_RAID_REWARDS_EMPTY");
      }
      
      protected function getTIDSeasonButton() : String
      {
         return TextManager.getText("TID_GEN_SEASON");
      }
      
      protected function getTIDToolTipInfoButton() : String
      {
         return TextManager.getText("TID_PVP_MONTHLY_TOURNAMENT");
      }
      
      protected function getTIDMonthlyTournament() : String
      {
         return TextManager.getText("TID_PVP_MONTHLY_TOURNAMENT");
      }
      
      protected function getTIDRewardExclusive() : String
      {
         var _loc1_:String = null;
         if(this.mVictoriesLeftInThisSeason <= 0)
         {
            _loc1_ = TextManager.getText("TID_REWARD_EXCLUSIVE_COMPLETED");
         }
         else
         {
            _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_PVP_REWARD_EXCLUSIVE"),[this.mVictoriesLeftInThisSeason]);
         }
         return _loc1_;
      }
      
      protected function getTIDLevelReward() : String
      {
         return TextManager.getText("TID_GEN_LEVEL_REWARDS");
      }
      
      protected function getTIDSeason() : String
      {
         var _loc1_:String = Boolean(Config.smServerConfig) && Config.smServerConfig.hasOwnProperty("pvp_season") ? Config.smServerConfig["pvp_season"] : "";
         return TextManager.getText("TID_GEN_SEASON") + " " + _loc1_;
      }
      
      protected function setLeftVictories() : void
      {
         var _loc1_:Number = Config.getConfig().getSeasonPvPVictories();
         var _loc2_:Number = InstanceMng.getUserDataMng().getOwnerUserData().getMatchesWon();
         this.mVictoriesLeftInThisSeason = _loc1_ - _loc2_;
      }
   }
}

