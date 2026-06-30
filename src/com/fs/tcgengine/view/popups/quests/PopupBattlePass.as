package com.fs.tcgengine.view.popups.quests
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.BoostsMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.QuestsDefMng;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.quests.Quest;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.QuestDef;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.buttons.FSMenuButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.quests.BattlePassChallengeRewardSlot;
   import com.fs.tcgengine.view.components.popups.quests.BattlePassInfoSlot;
   import com.fs.tcgengine.view.components.popups.quests.BattlePassQuestSlot;
   import com.fs.tcgengine.view.components.popups.quests.QuestSlot;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.fs.tcgengine.view.misc.FSBattlePassPurchasedAnimation;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.greensock.TweenMax;
   import com.greensock.easing.Bounce;
   import com.greensock.easing.Sine;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.VerticalLayout;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.text.TextFieldAutoSize;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.deg2rad;
   
   public class PopupBattlePass extends PopupStandard
   {
      
      public static const BG_NAME:String = Constants.POPUP_LARGE_NAME;
      
      public static const SECTION_CHALLENGE:int = 0;
      
      public static const SECTION_REWARDS:int = 1;
      
      public static const SECTION_INFO:int = 2;
      
      public static const MAX_REWARDS_COLS:int = 5;
      
      private static const REWARDS_NUMBER_BG_COLOR:uint = 3300449;
      
      private static const REWARDS_REWARD_BG_COLOR:uint = 5472388;
      
      private static const REWARDS_PREMIUM_REWARD_BG_COLOR:uint = 11112500;
      
      public static const REWARDS_NUMBER_HEIGHT_FACTOR:Number = 0.15;
      
      public static const REWARDS_REWARD_HEIGHT_FACTOR:Number = 0.35;
      
      public static const REWARDS_PREMIUM_REWARD_HEIGHT_FACTOR:Number = 0.5;
      
      private var mCurrentSectionIndex:int = SECTION_CHALLENGE;
      
      private var mTopContainer:Component;
      
      private var mChallengesTab:FSMenuButton;
      
      private var mRewardsTab:FSMenuButton;
      
      private var mInfoTab:FSMenuButton;
      
      private var mChallengesContainer:Component;
      
      private var mChallengesScrollContainer:ScrollContainer;
      
      private var mRewardsContainer:Component;
      
      private var mInfoContainer:Component;
      
      private var mBattlePassStatusTitle:FSTextfield;
      
      private var mBattlePassStatusSubtitle:FSTextfield;
      
      private var mChallengesQuestsComingSoon:FSTextfield;
      
      private var mInfoTitle:FSTextfield;
      
      private var mInfoSlotDescription:FSTextfield;
      
      private var mInfoSlots:Vector.<BattlePassInfoSlot>;
      
      private var mInfoBuyBattlePassButton:FSButton;
      
      private var mRewardsNumberBG:Quad;
      
      private var mRewardsRewardBG:Quad;
      
      private var mRewardsPremiumRewardBG:Quad;
      
      private var mRewardsChallengeTitle:FSTextfield;
      
      private var mRewardsRewardImage:FSImage;
      
      private var mRewardsPremiumRewardImage:FSImage;
      
      private var mRewardsScrollContainer:ScrollContainer;
      
      private var mRewardsSeasonTitleTextfield:FSTextfield;
      
      private var mRewardsSeasonEndsTextfield:FSTextfield;
      
      private var mRewardsChallengeDetailTitle:FSTextfield;
      
      private var mRewardsChallengeDetailImage:FSImage;
      
      private var mRewardsChallengeDetailPackAnim:PackAnimation;
      
      private var mRewardsChallengeDetailDesc:FSTextfield;
      
      private var mRewardsBuyBattlePassButton:FSButton;
      
      private var mRewardsBuyInfoTextfield:FSTextfield;
      
      private var mRewardsRewardSlotHighlighted:BattlePassChallengeRewardSlot;
      
      private var mRewardsCurrencyTextfield:FSTextfield;
      
      private var mRewardsPremiumRewardImageLock:FSImage;
      
      private var mRewardsPremiumShine:FSImage;
      
      private var mBattlePassPurchasedAnimation:FSBattlePassPurchasedAnimation;
      
      private var mExtraResourcesLoaded:Array;
      
      public function PopupBattlePass(param1:Boolean = true)
      {
         this.updateEndSeasonInfo();
         super(param1);
      }
      
      override public function setMainFieldText(param1:String = "") : void
      {
      }
      
      override protected function createFields() : void
      {
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      override protected function performOpeningTransition(param1:FSCoordinate = null) : void
      {
         if(this.mTopContainer)
         {
            y += this.mTopContainer.height / 1.5;
         }
         super.performOpeningTransition(param1);
         this.updateSelectedSection(this.mCurrentSectionIndex);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = BG_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,1969);
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.createFields();
         this.init();
      }
      
      private function init() : void
      {
         this.createTopSection();
         this.createTabsSection();
      }
      
      private function createTopSection() : void
      {
         if(this.mTopContainer == null)
         {
            this.mTopContainer = new Component();
         }
         this.mTopContainer.x = mBox.x;
         this.mTopContainer.y = mBox.y - this.mTopContainer.height;
         addChild(this.mTopContainer);
      }
      
      private function createTabsSection() : void
      {
         var _loc1_:FSCoordinate = null;
         if(this.mChallengesTab == null)
         {
            this.mChallengesTab = new FSMenuButton("battlepass_button_options_up",TextManager.getText("TID_BP_CHALLENGES"),this.onChallengesTabTriggered,"battlepass_button_options_challenges");
            _loc1_ = Utils.getXYPositionInContainer(0,this.mChallengesTab.width,this.mChallengesTab.height,mBox.width,this.mChallengesTab.height,3,1,true);
            this.mChallengesTab.x = this.mChallengesTab.width / 2 + _loc1_.getX();
            this.mChallengesTab.y = this.mChallengesTab.height / 2 + _loc1_.getY();
            this.mTopContainer.addChild(this.mChallengesTab);
         }
         if(this.mRewardsTab == null)
         {
            this.mRewardsTab = new FSMenuButton("battlepass_button_options_down",TextManager.getText("TID_GEN_LEVEL_REWARDS"),this.onRewardsTabTriggered,"battlepass_button_options_rewards");
            _loc1_ = Utils.getXYPositionInContainer(1,this.mRewardsTab.width,this.mRewardsTab.height,mBox.width,this.mRewardsTab.height,3,1,true);
            this.mRewardsTab.x = this.mRewardsTab.width / 2 + _loc1_.getX();
            this.mRewardsTab.y = this.mRewardsTab.height / 2 + _loc1_.getY();
            this.mTopContainer.addChild(this.mRewardsTab);
         }
         if(this.mInfoTab == null)
         {
            this.mInfoTab = new FSMenuButton("battlepass_button_options_down",TextManager.getText("TID_RAID_INFO"),this.onInfoTabTriggered,"battlepass_button_options_info");
            _loc1_ = Utils.getXYPositionInContainer(2,this.mInfoTab.width,this.mInfoTab.height,mBox.width,this.mInfoTab.height,3,1,true);
            this.mInfoTab.x = this.mInfoTab.width / 2 + _loc1_.getX();
            this.mInfoTab.y = this.mInfoTab.height / 2 + _loc1_.getY();
            this.mTopContainer.addChild(this.mInfoTab);
         }
         this.mTopContainer.y = -this.mTopContainer.height;
      }
      
      private function onChallengesTabTriggered() : void
      {
         this.updateSelectedSection(SECTION_CHALLENGE);
      }
      
      private function onRewardsTabTriggered() : void
      {
         this.updateSelectedSection(SECTION_REWARDS);
      }
      
      private function onInfoTabTriggered() : void
      {
         this.updateSelectedSection(SECTION_INFO);
      }
      
      private function createBattlePassQuestsComingSoonSection() : void
      {
         if(mBox)
         {
            if(this.mChallengesQuestsComingSoon == null)
            {
               this.mChallengesQuestsComingSoon = new FSTextfield(mBox.width * 0.5,mBox.height / 2,TextManager.getText("TID_BP_COMING_SOON"),16777215,FSResourceMng.FONT_STD_BIG_TITLE_SIZE);
               this.mChallengesQuestsComingSoon.alpha = 0.75;
               this.mChallengesQuestsComingSoon.x = (mBox.width - this.mChallengesQuestsComingSoon.width) / 2;
               this.mChallengesQuestsComingSoon.y = (mBox.height - this.mChallengesQuestsComingSoon.height) / 2;
            }
            this.mChallengesContainer.addChild(this.mChallengesQuestsComingSoon);
            this.mChallengesQuestsComingSoon.visible = !this.hasBattlePassQuests();
         }
      }
      
      private function createBattlePassStatusSection() : void
      {
         if(mBox)
         {
            if(this.mBattlePassStatusTitle == null)
            {
               this.mBattlePassStatusTitle = new FSTextfield(0,mBox.height / 17,TextManager.getText("TID_BP_BATTLEPASS") + ":",16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mBattlePassStatusTitle.autoSize = TextFieldAutoSize.HORIZONTAL;
               this.mBattlePassStatusTitle.y = mBox.height * 0.97 - this.mBattlePassStatusTitle.height;
               addChild(this.mBattlePassStatusTitle);
            }
            if(this.mBattlePassStatusSubtitle == null)
            {
               this.mBattlePassStatusSubtitle = new FSTextfield(0,this.mBattlePassStatusTitle.height,"",16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mBattlePassStatusSubtitle.autoSize = TextFieldAutoSize.HORIZONTAL;
               this.mBattlePassStatusSubtitle.format.horizontalAlign = Align.LEFT;
               this.mBattlePassStatusSubtitle.y = this.mBattlePassStatusTitle.y;
               addChild(this.mBattlePassStatusSubtitle);
            }
            this.mBattlePassStatusSubtitle.x = mBox.width * 0.93 - this.mBattlePassStatusSubtitle.width;
            this.mBattlePassStatusTitle.x = this.mBattlePassStatusSubtitle.x - this.mBattlePassStatusTitle.width;
         }
         this.updateBattlePassStatusInfo();
      }
      
      private function updateBattlePassStatusInfo() : void
      {
         var _loc1_:Boolean = this.ownerHasValidPass();
         var _loc2_:String = _loc1_ ? " " + TextManager.getText("TID_GEN_ACTIVATED") : " " + TextManager.getText("TID_GEN_DEACTIVATED");
         var _loc3_:uint = _loc1_ ? 15851554 : 16711680;
         if(this.mBattlePassStatusSubtitle)
         {
            this.mBattlePassStatusSubtitle.color = _loc3_;
            this.mBattlePassStatusSubtitle.text = _loc2_;
         }
         if(Boolean(this.mBattlePassStatusSubtitle) && Boolean(this.mBattlePassStatusTitle) && Boolean(mBox))
         {
            this.mBattlePassStatusSubtitle.x = mBox.width * 0.975 - this.mBattlePassStatusSubtitle.width;
            this.mBattlePassStatusTitle.x = this.mBattlePassStatusSubtitle.x - this.mBattlePassStatusTitle.width;
         }
      }
      
      private function showBattlePassStatusInfo(param1:Boolean) : void
      {
         if(this.mBattlePassStatusTitle == null || this.mBattlePassStatusSubtitle == null)
         {
            this.createBattlePassStatusSection();
         }
         if(this.mBattlePassStatusTitle)
         {
            this.mBattlePassStatusTitle.visible = param1;
         }
         if(this.mBattlePassStatusSubtitle)
         {
            this.mBattlePassStatusSubtitle.visible = param1;
         }
      }
      
      private function createChallengesSection() : void
      {
         var _loc1_:int = 0;
         if(mBox)
         {
            this.showBattlePassStatusInfo(true);
            _loc1_ = mBox.height * 0.875;
            if(this.mChallengesContainer == null)
            {
               this.mChallengesContainer = new Component();
               this.mChallengesContainer.height = _loc1_;
               this.mChallengesContainer.y = 0;
            }
            if(this.mChallengesScrollContainer == null)
            {
               this.mChallengesScrollContainer = new ScrollContainer();
               this.mChallengesScrollContainer.height = _loc1_;
               this.mChallengesScrollContainer.y = this.mBattlePassStatusTitle.height / 1.75;
               this.mChallengesScrollContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
               this.mChallengesScrollContainer.layout = this.getContainerLayoutVertical();
               this.mChallengesScrollContainer.touchable = true;
               this.refreshQuestsSection(false);
            }
            if(this.mChallengesContainer)
            {
               addChild(this.mChallengesContainer);
            }
            if(this.mChallengesScrollContainer)
            {
               this.mChallengesContainer.addChild(this.mChallengesScrollContainer);
            }
         }
      }
      
      public function refreshQuestsSection(param1:Boolean) : void
      {
         var _loc2_:Quest = null;
         var _loc5_:Boolean = false;
         var _loc7_:BattlePassQuestSlot = null;
         FSDebug.debugTrace("Refreshing the quests section");
         if(param1 && Boolean(this.mChallengesScrollContainer))
         {
            this.mChallengesScrollContainer.removeChildren();
         }
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         _loc3_ = this.mChallengesScrollContainer.width;
         var _loc6_:Vector.<Quest> = InstanceMng.getQuestsMng().getQuestsUnlocked(true);
         for each(_loc2_ in _loc6_)
         {
            _loc5_ = _loc2_.getDef().isBattlePassQuestEligibleBySeason();
            if((_loc5_) && !this.containerAlreadyContainsQuest(_loc2_.getDef()))
            {
               _loc7_ = new BattlePassQuestSlot(_loc2_,this.mChallengesScrollContainer);
               this.mChallengesScrollContainer.addChild(_loc7_);
               _loc3_ = _loc7_.width > _loc3_ ? int(_loc7_.width * 1.05) : _loc3_;
               this.mChallengesScrollContainer.width = _loc3_;
               _loc4_ = true;
            }
         }
         if(_loc4_)
         {
            this.mChallengesScrollContainer.sortChildren(DictionaryUtils.sortBattlePassQuestSlotsByIndex);
            this.mChallengesScrollContainer.x = (mBox.width - _loc3_) / 2;
         }
         this.createBattlePassQuestsComingSoonSection();
      }
      
      private function getContainerLayoutVertical() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 5;
         _loc1_.horizontalAlign = HorizontalAlign.LEFT;
         _loc1_.paddingLeft = 5;
         return _loc1_;
      }
      
      private function containerAlreadyContainsQuest(param1:QuestDef) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc2_:Boolean = false;
         if(this.mChallengesScrollContainer)
         {
            _loc3_ = this.mChallengesScrollContainer.numChildren;
            _loc4_ = param1.getSku();
            while(_loc5_ < _loc3_)
            {
               if(QuestSlot(this.mChallengesScrollContainer.getChildAt(_loc5_)) != null && QuestSlot(this.mChallengesScrollContainer.getChildAt(_loc5_)).getQuest().getDef().getSku() == _loc4_)
               {
                  return true;
               }
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      private function createRewardsSection() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         this.showBattlePassStatusInfo(true);
         if(this.mRewardsContainer == null)
         {
            this.mRewardsContainer = new Component();
            this.mRewardsContainer.touchable = true;
            _loc1_ = mBox.width * 0.635;
            _loc2_ = mBox.height * 0.75 + this.getSeparatorY() * 2;
            if(this.mRewardsNumberBG == null)
            {
               this.mRewardsNumberBG = new Quad(_loc1_,_loc2_ * REWARDS_NUMBER_HEIGHT_FACTOR,REWARDS_NUMBER_BG_COLOR);
               this.mRewardsNumberBG.x = mBox.width * 0.035;
               this.mRewardsNumberBG.y = this.mBattlePassStatusTitle.height / 1.75;
               this.mRewardsContainer.addChild(this.mRewardsNumberBG);
            }
            if(this.mRewardsChallengeTitle == null)
            {
               this.mRewardsChallengeTitle = new FSTextfield(_loc1_ * 0.15,this.mRewardsNumberBG.height,TextManager.getText("TID_BP_CHALLENGE"));
               this.mRewardsChallengeTitle.x = this.mRewardsNumberBG.x + this.getSeparatorY();
               this.mRewardsChallengeTitle.y = this.mRewardsNumberBG.y;
               this.mRewardsContainer.addChild(this.mRewardsChallengeTitle);
            }
            if(this.mRewardsRewardBG == null)
            {
               this.mRewardsRewardBG = new Quad(_loc1_,_loc2_ * REWARDS_REWARD_HEIGHT_FACTOR,REWARDS_REWARD_BG_COLOR);
               this.mRewardsRewardBG.x = this.mRewardsNumberBG.x;
               this.mRewardsRewardBG.y = this.mRewardsNumberBG.y + this.mRewardsNumberBG.height + this.getSeparatorY();
               this.mRewardsContainer.addChild(this.mRewardsRewardBG);
            }
            if(this.mRewardsRewardImage == null)
            {
               this.mRewardsRewardImage = new FSImage(Root.assets.getTexture("battlepass_icon_basic"));
               this.mRewardsRewardImage.x = this.mRewardsRewardBG.x + this.mRewardsRewardImage.width / 6;
               this.mRewardsRewardImage.y = this.mRewardsRewardBG.y + (this.mRewardsRewardBG.height - this.mRewardsRewardImage.height) / 2;
               this.mRewardsContainer.addChild(this.mRewardsRewardImage);
            }
            if(this.mRewardsPremiumRewardBG == null)
            {
               this.mRewardsPremiumRewardBG = new Quad(_loc1_,_loc2_ * REWARDS_PREMIUM_REWARD_HEIGHT_FACTOR,REWARDS_PREMIUM_REWARD_BG_COLOR);
               this.mRewardsPremiumRewardBG.x = this.mRewardsNumberBG.x;
               this.mRewardsPremiumRewardBG.y = this.mRewardsRewardBG.y + this.mRewardsRewardBG.height + this.getSeparatorY();
               this.mRewardsContainer.addChild(this.mRewardsPremiumRewardBG);
            }
            if(this.mRewardsPremiumRewardImage == null)
            {
               this.mRewardsPremiumRewardImage = new FSImage(Root.assets.getTexture("battlepass_icon_upgraded"));
               this.mRewardsPremiumRewardImage.x = this.mRewardsRewardImage.x;
               this.mRewardsPremiumRewardImage.y = this.mRewardsPremiumRewardBG.y + (this.mRewardsPremiumRewardBG.height - this.mRewardsPremiumRewardImage.height) / 2;
               this.mRewardsContainer.addChild(this.mRewardsPremiumRewardImage);
            }
            if(this.mRewardsPremiumShine == null)
            {
               this.mRewardsPremiumShine = new FSImage(Root.assets.getTexture("shine_effect"));
               this.mRewardsPremiumShine.alignPivot();
               this.mRewardsPremiumShine.scale = 0.75;
               this.mRewardsPremiumShine.x = this.mRewardsPremiumRewardImage.x + this.mRewardsPremiumRewardImage.width / 5;
               this.mRewardsPremiumShine.y = this.mRewardsPremiumRewardImage.y + this.mRewardsPremiumRewardImage.height / 4;
               this.mRewardsPremiumShine.alpha = 0;
               this.mRewardsContainer.addChild(this.mRewardsPremiumShine);
               TweenMax.delayedCall(1.5,this.doPremiumShineFX);
            }
            if(this.mRewardsPremiumRewardImageLock == null)
            {
               this.mRewardsPremiumRewardImageLock = new FSImage(Root.assets.getTexture("battlepass_reward_icon_locked"));
               this.mRewardsPremiumRewardImageLock.x = this.mRewardsPremiumRewardImage.x + this.mRewardsPremiumRewardImage.width - this.mRewardsPremiumRewardImageLock.width;
               this.mRewardsPremiumRewardImageLock.y = this.mRewardsPremiumRewardImage.y;
            }
            if(this.mRewardsPremiumRewardImageLock)
            {
               _loc7_ = this.ownerHasValidPass();
               if(!_loc7_)
               {
                  this.mRewardsContainer.addChild(this.mRewardsPremiumRewardImageLock);
               }
               else
               {
                  this.mRewardsPremiumRewardImageLock.removeFromParent();
               }
            }
            _loc3_ = this.mRewardsRewardImage.x + this.mRewardsRewardImage.width + this.mRewardsRewardImage.width / 6;
            _loc4_ = this.mRewardsNumberBG.width - _loc3_ + this.mRewardsNumberBG.x;
            _loc5_ = _loc2_;
            _loc6_ = false;
            if(this.mRewardsScrollContainer == null)
            {
               _loc6_ = true;
               this.mRewardsScrollContainer = new ScrollContainer();
               this.mRewardsScrollContainer.touchable = true;
               this.mRewardsScrollContainer.width = _loc4_;
               this.mRewardsScrollContainer.height = _loc5_;
               this.mRewardsScrollContainer.verticalScrollPolicy = ScrollPolicy.OFF;
               this.mRewardsScrollContainer.layout = this.getRewardsScrollContainerLayout();
               this.mRewardsScrollContainer.x = _loc3_;
               this.mRewardsScrollContainer.y = this.mRewardsNumberBG.y;
               this.mRewardsContainer.addChild(this.mRewardsScrollContainer);
            }
            if(_loc6_)
            {
               this.rewardsFillRewards(_loc4_,_loc5_);
            }
         }
         this.rewardsCreateDetailsSection();
         addChild(this.mRewardsContainer);
      }
      
      public function getRewardsNumberBG() : Quad
      {
         return this.mRewardsNumberBG;
      }
      
      public function getRewardsRewardBG() : Quad
      {
         return this.mRewardsRewardBG;
      }
      
      public function getRewardsPremiumRewardsBG() : Quad
      {
         return this.mRewardsPremiumRewardBG;
      }
      
      public function getSeparatorY() : Number
      {
         return Utils.isAndroidOrDesktop() ? 3.75 : 5;
      }
      
      private function doPremiumShineFX() : void
      {
         var tweenToAlphaNone:Function = null;
         var rotationTransTime:Number = NaN;
         var alphaTransTime:Number = NaN;
         tweenToAlphaNone = function():void
         {
            var _loc1_:Number = 3.5;
            SpecialFX.tweenToAlpha(mRewardsPremiumShine,0,alphaTransTime,0);
            TweenMax.delayedCall(alphaTransTime + _loc1_,doPremiumShineFX);
         };
         if(this.mRewardsPremiumShine)
         {
            rotationTransTime = 2.75;
            alphaTransTime = rotationTransTime / 2;
            this.mRewardsPremiumShine.rotation = deg2rad(0);
            this.mRewardsPremiumShine.alpha = 0;
            SpecialFX.tweenToAlpha(this.mRewardsPremiumShine,1,alphaTransTime,0);
            SpecialFX.tweenRotate(this.mRewardsPremiumShine,rotationTransTime,0,Sine.easeInOut,120);
            TweenMax.delayedCall(rotationTransTime - alphaTransTime,tweenToAlphaNone);
         }
      }
      
      private function rewardsCreateDetailsSection() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:ShopBoostDef = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         if(Boolean(mBox) && Boolean(this.mRewardsScrollContainer) && Boolean(this.mRewardsScrollContainer))
         {
            _loc1_ = mBox.width * 0.93 - (this.mRewardsScrollContainer.x + this.mRewardsScrollContainer.width);
            _loc2_ = this.hasBattlePassQuests();
            _loc3_ = Config.smMonthNumber.value;
            _loc3_ += !_loc2_ ? 1 : 0;
            if(this.mRewardsSeasonTitleTextfield == null)
            {
               this.mRewardsSeasonTitleTextfield = new FSTextfield(_loc1_,this.mRewardsNumberBG.height * 0.66,TextManager.getText("TID_GEN_SEASON") + " " + _loc3_,16777215,FSResourceMng.FONT_STD_BIG_TITLE_SIZE);
               this.mRewardsSeasonTitleTextfield.x = this.mRewardsScrollContainer.x + this.mRewardsScrollContainer.width + this.getSeparatorY();
               this.mRewardsSeasonTitleTextfield.y = this.mRewardsScrollContainer.y;
               this.mRewardsContainer.addChild(this.mRewardsSeasonTitleTextfield);
            }
            else
            {
               this.mRewardsSeasonTitleTextfield.text = TextManager.getText("TID_GEN_SEASON") + " " + _loc3_;
            }
            if(this.mRewardsSeasonEndsTextfield == null)
            {
               _loc5_ = this.hasBattlePassQuests() ? TextManager.getText("TID_SEASON_END") : TextManager.getText("TID_SEASON_STARTS");
               this.mRewardsSeasonEndsTextfield = new FSTextfield(_loc1_,this.mRewardsNumberBG.height * 0.33,_loc5_ + " ???",16711680,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mRewardsSeasonEndsTextfield.x = this.mRewardsSeasonTitleTextfield.x;
               this.mRewardsSeasonEndsTextfield.y = this.mRewardsSeasonTitleTextfield.y + this.mRewardsSeasonTitleTextfield.height;
               this.mRewardsContainer.addChild(this.mRewardsSeasonEndsTextfield);
            }
            _loc4_ = this.ownerHasValidPass();
            if(this.mRewardsBuyBattlePassButton == null)
            {
               _loc6_ = ShopBoostDef(InstanceMng.getShopBoostsDefMng().getShopBoostDefByKeyname(BoostsMng.BOOST_ID_PURCHASE_BATTLE_PASS));
               if(_loc6_ != null)
               {
                  _loc7_ = InstanceMng.getApplication().getInAppsManager().getPriceByDef(_loc6_);
                  _loc8_ = _loc7_ != null && _loc7_ != "" && _loc7_ != "N.A.";
                  this.mRewardsBuyBattlePassButton = new FSButton(Root.assets.getTexture("buy_button"),_loc7_);
                  Utils.setupButton9Scale(this.mRewardsBuyBattlePassButton,12.5,12.5,2.5,2.5,83.25,29.5);
                  this.mRewardsBuyBattlePassButton.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
                  this.mRewardsBuyBattlePassButton.x = this.mRewardsPremiumRewardBG.x + this.mRewardsBuyBattlePassButton.width / 2;
                  this.mRewardsBuyBattlePassButton.y = this.mRewardsPremiumRewardBG.y + this.mRewardsPremiumRewardBG.height + this.getSeparatorY() + this.mRewardsBuyBattlePassButton.height / 2;
                  this.mRewardsBuyBattlePassButton.enabled = !_loc4_;
                  this.mRewardsContainer.addChild(this.mRewardsBuyBattlePassButton);
                  this.mRewardsBuyBattlePassButton.addEventListener(Event.TRIGGERED,this.onBuyBattlePassTriggered);
               }
            }
            if(this.mRewardsBuyInfoTextfield == null && this.mRewardsBuyBattlePassButton != null)
            {
               _loc9_ = mBox.width * 0.93 - (_loc1_ + (this.mRewardsBuyBattlePassButton.x + this.mRewardsBuyBattlePassButton.width / 2)) - 10;
               this.mRewardsBuyInfoTextfield = new FSTextfield(_loc9_,this.mRewardsBuyBattlePassButton.height,TextManager.getText("TID_BP_PURCHASE_INFO"),16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mRewardsBuyInfoTextfield.format.horizontalAlign = Align.LEFT;
               this.mRewardsBuyInfoTextfield.x = this.mRewardsBuyBattlePassButton.x + this.mRewardsBuyBattlePassButton.width / 2 + this.getSeparatorY();
               this.mRewardsBuyInfoTextfield.y = this.mRewardsBuyBattlePassButton.y - this.mRewardsBuyBattlePassButton.height / 2;
               this.mRewardsContainer.addChild(this.mRewardsBuyInfoTextfield);
            }
            this.updateBuySection();
         }
      }
      
      private function hasBattlePassQuests() : Boolean
      {
         var _loc1_:Vector.<QuestDef> = InstanceMng.getQuestsMng().getSeasonBPQuests();
         return Boolean(_loc1_) && _loc1_.length > 0;
      }
      
      private function onBuyBattlePassTriggered(param1:Event) : void
      {
         var _loc3_:FSShopItem = null;
         var _loc2_:ShopBoostDef = ShopBoostDef(InstanceMng.getShopBoostsDefMng().getShopBoostDefByKeyname(BoostsMng.BOOST_ID_PURCHASE_BATTLE_PASS));
         if(_loc2_ != null)
         {
            _loc3_ = new FSShopItem(_loc2_,false,null,true);
            _loc3_.beginRealMoneyPurchase();
         }
      }
      
      public function onChallengeClicked(param1:Boolean, param2:BattlePassChallengeRewardSlot) : void
      {
         var onRewardPackTouched:Function = null;
         var questDef:QuestDef = null;
         var title:String = null;
         var craftCardDefUnlocked:CardDef = null;
         var rewardTexture:Texture = null;
         var premium:Boolean = param1;
         var bpChallengeRewardSlot:BattlePassChallengeRewardSlot = param2;
         onRewardPackTouched = function(param1:TouchEvent):void
         {
            var _loc2_:Popup = null;
            var _loc3_:PackDef = null;
            if(param1.getTouch(mRewardsChallengeDetailPackAnim,TouchPhase.ENDED))
            {
               _loc2_ = InstanceMng.getPopupMng().getPopupShown();
               if(_loc2_ is PopupBattlePass)
               {
                  _loc3_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(questDef.getRewardPackSku(premium)));
                  _loc2_.hideTemporarily(InstanceMng.getPopupMng().openProductDetailPopup,[1,_loc3_.getSku(),1,""]);
               }
            }
         };
         if(bpChallengeRewardSlot)
         {
            if(this.mRewardsRewardSlotHighlighted)
            {
               this.mRewardsRewardSlotHighlighted.setHighlighted(true,false);
               this.mRewardsRewardSlotHighlighted.setHighlighted(false,false);
            }
            this.mRewardsRewardSlotHighlighted = bpChallengeRewardSlot;
            bpChallengeRewardSlot.setHighlighted(premium,true);
            questDef = bpChallengeRewardSlot.getQuestDef();
            if(this.mRewardsChallengeDetailTitle == null)
            {
               this.mRewardsChallengeDetailTitle = new FSTextfield(this.mRewardsSeasonTitleTextfield.width,this.mRewardsSeasonTitleTextfield.height,"",16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mRewardsChallengeDetailTitle.x = this.mRewardsSeasonEndsTextfield.x;
               this.mRewardsChallengeDetailTitle.y = this.mRewardsSeasonEndsTextfield.y + this.mRewardsSeasonEndsTextfield.height * 2.5;
               this.mRewardsContainer.addChild(this.mRewardsChallengeDetailTitle);
            }
            this.mRewardsChallengeDetailTitle.text = TextManager.getText("TID_BP_CHALLENGE") + " " + questDef.getBattlePassIndex();
            if(this.mRewardsChallengeDetailImage)
            {
               this.mRewardsChallengeDetailImage.removeFromParent();
            }
            if(this.mRewardsChallengeDetailPackAnim)
            {
               this.mRewardsChallengeDetailPackAnim.removeFromParent();
            }
            if(questDef.getRewardType(premium) != QuestsDefMng.REWARD_TYPE_PACK)
            {
               rewardTexture = bpChallengeRewardSlot.getRewardImage(premium) ? FSImage(bpChallengeRewardSlot.getRewardImage(premium)).texture : null;
               if(this.mRewardsChallengeDetailImage == null)
               {
                  this.mRewardsChallengeDetailImage = new FSImage(rewardTexture);
               }
               this.mRewardsChallengeDetailImage.touchable = false;
               this.mRewardsChallengeDetailImage.texture = rewardTexture;
               this.mRewardsChallengeDetailImage.scale = questDef.getRewardType(premium) == QuestsDefMng.REWARD_TYPE_PORTRAIT_SKIN ? 1 : 1.75;
               this.mRewardsChallengeDetailImage.readjustSize();
               this.mRewardsChallengeDetailImage.x = this.mRewardsChallengeDetailTitle.x + (this.mRewardsChallengeDetailTitle.width - this.mRewardsChallengeDetailImage.width) / 2;
               this.mRewardsChallengeDetailImage.y = this.mRewardsChallengeDetailTitle.y + this.mRewardsChallengeDetailTitle.height * 2;
               this.mRewardsContainer.addChild(this.mRewardsChallengeDetailImage);
            }
            else
            {
               this.mRewardsChallengeDetailPackAnim = InstanceMng.getQuestsMng().createPackImage(questDef,premium);
               this.mRewardsChallengeDetailPackAnim.scale = 0.75;
               this.mRewardsChallengeDetailPackAnim.touchable = true;
               this.mRewardsChallengeDetailPackAnim.addEventListener(TouchEvent.TOUCH,onRewardPackTouched);
               this.mRewardsContainer.addChild(this.mRewardsChallengeDetailPackAnim);
               this.mRewardsChallengeDetailPackAnim.x = this.mRewardsChallengeDetailTitle.x + (this.mRewardsChallengeDetailTitle.width - this.mRewardsChallengeDetailPackAnim.width) / 2 + this.mRewardsChallengeDetailPackAnim.width / 2;
               this.mRewardsChallengeDetailPackAnim.y = this.mRewardsChallengeDetailTitle.y + this.mRewardsChallengeDetailTitle.height * 2 + this.mRewardsChallengeDetailPackAnim.height / 2;
            }
            this.createCurrencyAmount(premium,questDef);
            title = bpChallengeRewardSlot.getQuestDef() ? bpChallengeRewardSlot.getQuestDef().getDesc() : "";
            craftCardDefUnlocked = bpChallengeRewardSlot.getQuestDef().isBattlePassQuest() && bpChallengeRewardSlot.getQuestDef().getRewardType(premium) == QuestsDefMng.REWARD_TYPE_UNLOCK_CRAFT ? questDef.getCraftCardUnlocked() : null;
            if(craftCardDefUnlocked != null)
            {
               title += " (" + TextManager.replaceParameters(TextManager.getText("TID_BP_CRAFT_CARD",true),[craftCardDefUnlocked.getName()]) + ")";
            }
            if(this.mRewardsChallengeDetailDesc == null)
            {
               this.mRewardsChallengeDetailDesc = new FSTextfield(this.mRewardsSeasonTitleTextfield.width,this.mRewardsSeasonTitleTextfield.height * 3,title,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mRewardsChallengeDetailDesc.x = this.mRewardsSeasonEndsTextfield.x;
               this.mRewardsChallengeDetailDesc.y = this.mBattlePassStatusTitle.y - this.mRewardsChallengeDetailDesc.height;
               this.mRewardsContainer.addChild(this.mRewardsChallengeDetailDesc);
            }
            this.mRewardsChallengeDetailDesc.text = title;
         }
      }
      
      private function createCurrencyAmount(param1:Boolean, param2:QuestDef) : void
      {
         var _loc5_:int = 0;
         if(this.mRewardsCurrencyTextfield)
         {
            this.mRewardsCurrencyTextfield.removeFromParent();
         }
         var _loc3_:int = 0;
         var _loc4_:String = "";
         if(param2)
         {
            _loc5_ = param2.getRewardType(param1);
            switch(_loc5_)
            {
               case QuestsDefMng.REWARD_TYPE_QUEST_COINS:
                  _loc3_ = param2.getRewardPoints(param1);
                  _loc4_ = _loc3_.toString();
                  break;
               case QuestsDefMng.REWARD_TYPE_RAID_COINS:
                  _loc3_ = param2.getRewardRaidPoints(param1);
                  _loc4_ = _loc3_.toString();
                  break;
               case QuestsDefMng.REWARD_TYPE_GOLD:
                  _loc3_ = param2.getRewardGold(param1);
                  _loc4_ = _loc3_.toString();
                  break;
               case QuestsDefMng.REWARD_TYPE_TOKENS:
                  _loc3_ = param2.getRewardTokens(param1);
                  _loc4_ = _loc3_.toString();
                  break;
               case QuestsDefMng.REWARD_TYPE_JOB_XP:
                  _loc3_ = int(param2.getRewardJobXP().split(":")[1]);
                  _loc4_ = _loc3_ + "xp";
            }
         }
         if(_loc3_ > 0 && this.mRewardsCurrencyTextfield == null)
         {
            this.mRewardsCurrencyTextfield = new FSTextfield(this.mRewardsChallengeDetailImage.width,this.mRewardsChallengeDetailImage.height,_loc4_);
            this.mRewardsCurrencyTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD);
            this.mRewardsCurrencyTextfield.x = this.mRewardsChallengeDetailImage.x;
            this.mRewardsCurrencyTextfield.y = this.mRewardsChallengeDetailImage.y;
            this.mRewardsCurrencyTextfield.format.horizontalAlign = Align.CENTER;
            this.mRewardsCurrencyTextfield.touchable = false;
         }
         if(_loc3_ > 0 && Boolean(this.mRewardsCurrencyTextfield))
         {
            this.mRewardsCurrencyTextfield.text = _loc4_;
            this.mRewardsContainer.addChild(this.mRewardsCurrencyTextfield);
         }
      }
      
      private function rewardsFillRewards(param1:int, param2:int) : void
      {
         var _loc3_:Vector.<QuestDef> = null;
         var _loc4_:int = 0;
         var _loc5_:BattlePassChallengeRewardSlot = null;
         if(this.mRewardsScrollContainer)
         {
            this.mRewardsScrollContainer.removeChildren();
         }
         if(this.mRewardsScrollContainer)
         {
            _loc3_ = InstanceMng.getQuestsDefMng().getSeasonBattlePassQuests();
            if(_loc3_ != null && _loc3_.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = new BattlePassChallengeRewardSlot(_loc3_[_loc4_],param1,param2);
                  this.mRewardsScrollContainer.height = _loc5_.height;
                  this.mRewardsScrollContainer.addChild(_loc5_);
                  _loc4_++;
               }
            }
         }
      }
      
      private function getRewardsScrollContainerLayout() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.gap = 3;
         _loc1_.verticalAlign = Align.LEFT;
         return _loc1_;
      }
      
      private function createInfoSection() : void
      {
         var onUpgradeBattlePassInfoClicked:Function = null;
         var w:int = 0;
         var h:int = 0;
         var slotW:int = 0;
         var slotH:int = 0;
         var slotInfo1:BattlePassInfoSlot = null;
         var slotInfo2:BattlePassInfoSlot = null;
         var slotInfo3:BattlePassInfoSlot = null;
         var slotInfo4:BattlePassInfoSlot = null;
         var coord:FSCoordinate = null;
         var i:int = 0;
         onUpgradeBattlePassInfoClicked = function():void
         {
            var _loc2_:ShopBoostDef = null;
            var _loc3_:String = null;
            var _loc4_:Boolean = false;
            var _loc1_:Boolean = ownerHasValidPass();
            if(!_loc1_)
            {
               if(mInfoBuyBattlePassButton == null)
               {
                  _loc2_ = ShopBoostDef(InstanceMng.getShopBoostsDefMng().getShopBoostDefByKeyname(BoostsMng.BOOST_ID_PURCHASE_BATTLE_PASS));
                  if(_loc2_ != null)
                  {
                     _loc3_ = InstanceMng.getApplication().getInAppsManager().getPriceByDef(_loc2_);
                     _loc4_ = _loc3_ != null && _loc3_ != "" && _loc3_ != "N.A.";
                     mInfoBuyBattlePassButton = new FSButton(Root.assets.getTexture("buy_button"),_loc3_);
                     Utils.setupButton9Scale(mInfoBuyBattlePassButton,12.5,12.5,2.5,2.5,83.25,29.5);
                     mInfoBuyBattlePassButton.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
                     mInfoContainer.addChild(mInfoBuyBattlePassButton);
                     mInfoBuyBattlePassButton.addEventListener(Event.TRIGGERED,onBuyBattlePassTriggered);
                  }
               }
               if(mInfoBuyBattlePassButton)
               {
                  mInfoBuyBattlePassButton.x = mBox.x + mBox.width / 2;
                  mInfoBuyBattlePassButton.y = mBox.y + mBox.height;
                  SpecialFX.createTransition(mInfoBuyBattlePassButton,new FSCoordinate(mInfoBuyBattlePassButton.x,mBox.y + mBox.height + mInfoBuyBattlePassButton.height / 2),1,0,null,null,Bounce.easeOut);
               }
            }
         };
         this.showBattlePassStatusInfo(false);
         if(this.mInfoSlots == null && this.mInfoContainer == null)
         {
            this.mInfoContainer = new Component();
            this.mInfoSlots = new Vector.<BattlePassInfoSlot>();
            w = mBox.width * 0.9;
            h = mBox.height / 6;
            if(this.mInfoTitle == null)
            {
               this.mInfoTitle = new FSTextfield(w,h,TextManager.getText("TID_BP_INFO_DESC_00",true));
               this.mInfoTitle.x = (mBox.width - w) / 2;
               this.mInfoTitle.y = h / 4;
               this.mInfoContainer.addChild(this.mInfoTitle);
            }
            if(this.mInfoSlotDescription == null)
            {
               this.mInfoSlotDescription = new FSTextfield(w,h,TextManager.getText("TID_BP_INFO_CHOOSE",true),16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               this.mInfoSlotDescription.border = true;
               this.mInfoSlotDescription.x = this.mInfoTitle.x;
               this.mInfoSlotDescription.y = mBox.height - this.mInfoSlotDescription.height - h / 3;
               this.mInfoContainer.addChild(this.mInfoSlotDescription);
            }
            slotW = mBox.width / 4.5;
            slotH = (this.mInfoSlotDescription.y - (this.mInfoTitle.y + this.mInfoTitle.height)) * 0.85;
            slotInfo1 = new BattlePassInfoSlot(slotW,slotH,TextManager.getText("TID_BP_INFO_NAME_01"),"battlepass_info_icon_01",16777215,TextManager.getText("TID_BP_INFO_DESC_01",true),this.mInfoSlotDescription,this.mInfoSlots,onUpgradeBattlePassInfoClicked);
            slotInfo2 = new BattlePassInfoSlot(slotW,slotH,TextManager.getText("TID_BP_INFO_NAME_02"),"battlepass_info_icon_02",16777215,TextManager.getText("TID_BP_INFO_DESC_02",true),this.mInfoSlotDescription,this.mInfoSlots);
            slotInfo3 = new BattlePassInfoSlot(slotW,slotH,TextManager.getText("TID_BP_INFO_NAME_03"),"battlepass_info_icon_03",16777215,TextManager.getText("TID_BP_INFO_DESC_03",true),this.mInfoSlotDescription,this.mInfoSlots);
            slotInfo4 = new BattlePassInfoSlot(slotW,slotH,TextManager.getText("TID_BP_INFO_NAME_04"),"battlepass_info_icon_04",16777215,TextManager.getText("TID_BP_INFO_DESC_04",true),this.mInfoSlotDescription,this.mInfoSlots);
            this.mInfoSlots.push(slotInfo1);
            this.mInfoSlots.push(slotInfo2);
            this.mInfoSlots.push(slotInfo3);
            this.mInfoSlots.push(slotInfo4);
            coord = new FSCoordinate();
            i = 0;
            i = 0;
            while(i < this.mInfoSlots.length)
            {
               coord = Utils.getXYPositionInContainer(i,this.mInfoSlots[i].width,this.mInfoSlots[i].height,mBox.width,mBox.height * 0.98,this.mInfoSlots.length,1,true);
               this.mInfoSlots[i].x = coord.getX() + this.mInfoSlots[i].width / 2;
               this.mInfoSlots[i].y = coord.getY() + this.mInfoSlots[i].height / 2;
               this.mInfoContainer.addChild(this.mInfoSlots[i]);
               i++;
            }
         }
         addChild(this.mInfoContainer);
      }
      
      public function updateSelectedSection(param1:int) : void
      {
         this.mCurrentSectionIndex = param1;
         var _loc2_:Texture = Root.assets.getTexture("guild_create_icon");
         var _loc3_:Texture = Root.assets.getTexture("guild_button_options_up");
         var _loc4_:Number = 0.99;
         var _loc5_:Number = 0.5;
         switch(this.mCurrentSectionIndex)
         {
            case SECTION_CHALLENGE:
               this.updateSelectedTab(true,this.mChallengesTab);
               this.updateSelectedTab(false,this.mRewardsTab);
               this.updateSelectedTab(false,this.mInfoTab);
               this.removeChildrenFromUnselectedSection(this.mChallengesContainer);
               this.removeChildrenFromUnselectedSection(this.mRewardsContainer);
               this.removeChildrenFromUnselectedSection(this.mInfoContainer);
               if(this.mChallengesTab)
               {
                  this.mChallengesTab.disableTemporarily(0.15);
               }
               this.createChallengesSection();
               break;
            case SECTION_REWARDS:
               this.updateSelectedTab(false,this.mChallengesTab);
               this.updateSelectedTab(true,this.mRewardsTab);
               this.updateSelectedTab(false,this.mInfoTab);
               this.removeChildrenFromUnselectedSection(this.mChallengesContainer);
               this.removeChildrenFromUnselectedSection(this.mRewardsContainer);
               this.removeChildrenFromUnselectedSection(this.mInfoContainer);
               if(this.mRewardsTab)
               {
                  this.mRewardsTab.disableTemporarily(0.15);
               }
               this.createRewardsSection();
               break;
            case SECTION_INFO:
               this.updateSelectedTab(false,this.mChallengesTab);
               this.updateSelectedTab(false,this.mRewardsTab);
               this.updateSelectedTab(true,this.mInfoTab);
               this.removeChildrenFromUnselectedSection(this.mChallengesContainer);
               this.removeChildrenFromUnselectedSection(this.mRewardsContainer);
               this.removeChildrenFromUnselectedSection(this.mInfoContainer);
               if(this.mInfoTab)
               {
                  this.mInfoTab.disableTemporarily(0.15);
               }
               this.createInfoSection();
         }
         if(mCloseButton)
         {
            addChild(mCloseButton);
         }
      }
      
      private function removeChildrenFromUnselectedSection(param1:*) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      private function updateSelectedTab(param1:Boolean, param2:FSMenuButton) : void
      {
         if(param2)
         {
            if(param1)
            {
               param2.getButton().alpha = 0.99;
               param2.getExtraLeftImage().alpha = 0.99;
               param2.setFontColor(16777215);
               param2.updateUpTexture(Root.assets.getTexture("battlepass_button_options_up"));
            }
            else
            {
               param2.getButton().alpha = 0.5;
               param2.getExtraLeftImage().alpha = 0.5;
               param2.setFontColor(8421504);
               param2.updateUpTexture(Root.assets.getTexture("battlepass_button_options_down"));
            }
         }
      }
      
      public function onBattlePassQuestClaimed() : void
      {
         var _loc1_:int = 0;
         if(this.mRewardsScrollContainer)
         {
            _loc1_ = 0;
            _loc1_ = 0;
            while(_loc1_ < this.mRewardsScrollContainer.numChildren)
            {
               if(this.mRewardsScrollContainer.getChildAt(_loc1_) != null && this.mRewardsScrollContainer.getChildAt(_loc1_) is BattlePassChallengeRewardSlot)
               {
                  BattlePassChallengeRewardSlot(this.mRewardsScrollContainer.getChildAt(_loc1_)).onBattlePassQuestClaimed();
               }
               _loc1_++;
            }
         }
      }
      
      public function onBattlePassPurchased() : void
      {
         var _loc1_:int = 0;
         this.createBattlePassPurchasedAnimation(4);
         this.updateBattlePassStatusInfo();
         if(this.mRewardsPremiumRewardImageLock)
         {
            this.mRewardsPremiumRewardImageLock.removeFromParent();
         }
         if(this.mRewardsScrollContainer)
         {
            _loc1_ = 0;
            _loc1_ = 0;
            while(_loc1_ < this.mRewardsScrollContainer.numChildren)
            {
               if(this.mRewardsScrollContainer.getChildAt(_loc1_) != null && this.mRewardsScrollContainer.getChildAt(_loc1_) is BattlePassChallengeRewardSlot)
               {
                  BattlePassChallengeRewardSlot(this.mRewardsScrollContainer.getChildAt(_loc1_)).setValidPass(true);
               }
               _loc1_++;
            }
         }
         this.updateBuySection();
      }
      
      public function onBattlePassInvalidated() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.updateBattlePassStatusInfo();
         if(Boolean(this.mRewardsPremiumRewardImageLock) && Boolean(this.mRewardsContainer))
         {
            this.mRewardsContainer.addChild(this.mRewardsPremiumRewardImageLock);
         }
         if(this.mRewardsScrollContainer)
         {
            _loc1_ = this.mRewardsScrollContainer.width;
            _loc2_ = this.mRewardsScrollContainer.height;
            _loc3_ = 0;
            _loc3_ = 0;
            while(_loc3_ < this.mRewardsScrollContainer.numChildren)
            {
               if(this.mRewardsScrollContainer.getChildAt(_loc3_) != null && this.mRewardsScrollContainer.getChildAt(_loc3_) is BattlePassChallengeRewardSlot)
               {
                  BattlePassChallengeRewardSlot(this.mRewardsScrollContainer.getChildAt(_loc3_)).setValidPass(false);
               }
               _loc3_++;
            }
         }
         this.rewardsFillRewards(_loc1_,_loc2_);
         this.rewardsCreateDetailsSection();
         this.updateBuySection();
      }
      
      private function updateBuySection() : void
      {
         var _loc1_:Boolean = this.ownerHasValidPass();
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(this.mRewardsBuyBattlePassButton)
         {
            this.mRewardsBuyBattlePassButton.enabled = !_loc1_ && this.hasBattlePassQuests() && _loc2_ != null && InstanceMng.getServerConnection().isUserLoggedIn();
         }
         if(this.mInfoBuyBattlePassButton)
         {
            this.mInfoBuyBattlePassButton.enabled = this.mRewardsBuyBattlePassButton ? this.mRewardsBuyBattlePassButton.enabled : false;
         }
         var _loc3_:Vector.<QuestDef> = _loc2_ ? _loc2_.getBattlePassQuestsClaimed() : null;
         var _loc4_:int = _loc3_ ? int(_loc3_.length) : 0;
         var _loc5_:String = TextManager.getText("TID_BP_CHALLENGE_COMPLETED",true) + ": " + _loc4_;
         if(!_loc1_)
         {
            if(_loc4_ > 0)
            {
               _loc5_ += ". " + TextManager.getText("TID_BP_PURCHASE_INFO_CLAIM_REWARDS",true);
            }
            else
            {
               _loc5_ += ". " + TextManager.getText("TID_BP_PURCHASE_INFO_NO_REWARDS",true);
            }
         }
         if(this.mRewardsBuyInfoTextfield)
         {
            this.mRewardsBuyInfoTextfield.text = _loc5_;
         }
      }
      
      private function ownerHasValidPass() : Boolean
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         return _loc1_ ? _loc1_.hasValidBattlePass() : false;
      }
      
      private function updateEndSeasonInfo() : void
      {
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            this.updateServerTimeMS();
         }
         else
         {
            if(InstanceMng.getApplication())
            {
               InstanceMng.getServerConnection().refreshServerTime();
            }
            TweenMax.delayedCall(2,this.updateEndSeasonInfo);
         }
      }
      
      private function updateServerTimeMS() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         if(ServerConnection.smServerTimeMS != -1)
         {
            TweenMax.delayedCall(1,this.updateServerTimeMS);
            if(this.mRewardsSeasonEndsTextfield != null)
            {
               _loc1_ = Config.smServerConfig;
               if(_loc1_ != null)
               {
                  _loc2_ = Utils.isSeasonActive(_loc1_["dungeons_seasonStartingTime"],_loc1_["dungeons_seasonEndingTime"]);
                  if(_loc2_)
                  {
                     _loc3_ = this.hasBattlePassQuests() ? TextManager.getText("TID_SEASON_END") : TextManager.getText("TID_SEASON_STARTS");
                     this.mRewardsSeasonEndsTextfield.text = _loc3_ + " " + Utils.getSeasonTimeLeftString(_loc1_["dungeons_seasonStartingTime"],_loc1_["dungeons_seasonEndingTime"],_loc2_);
                  }
               }
            }
         }
      }
      
      override protected function removeFromStage() : void
      {
         var _loc1_:int = 0;
         if(this.mTopContainer)
         {
            this.mTopContainer.removeFromParent(true);
            this.mTopContainer = null;
         }
         if(this.mChallengesTab)
         {
            this.mChallengesTab.removeFromParent(true);
            this.mChallengesTab = null;
         }
         if(this.mRewardsTab)
         {
            this.mRewardsTab.removeFromParent(true);
            this.mRewardsTab = null;
         }
         if(this.mInfoTab)
         {
            this.mInfoTab.removeFromParent(true);
            this.mInfoTab = null;
         }
         if(this.mChallengesScrollContainer)
         {
            this.mChallengesScrollContainer.removeFromParent(true);
            this.mChallengesScrollContainer = null;
         }
         if(this.mRewardsContainer)
         {
            this.mRewardsContainer.removeFromParent(true);
            this.mRewardsContainer = null;
         }
         if(this.mInfoContainer)
         {
            this.mInfoContainer.removeFromParent(true);
            this.mInfoContainer = null;
         }
         if(this.mInfoSlotDescription)
         {
            this.mInfoSlotDescription.removeFromParent(true);
            this.mInfoSlotDescription = null;
         }
         if(this.mInfoTitle)
         {
            this.mInfoTitle.removeFromParent(true);
            this.mInfoTitle = null;
         }
         if(this.mInfoSlots)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mInfoSlots.length)
            {
               this.mInfoSlots[_loc1_].removeFromParent(true);
               _loc1_++;
            }
            Utils.destroyArray(this.mInfoSlots);
            this.mInfoSlots = null;
         }
         if(this.mBattlePassStatusTitle)
         {
            this.mBattlePassStatusTitle.removeFromParent(true);
            this.mBattlePassStatusTitle = null;
         }
         if(this.mBattlePassStatusSubtitle)
         {
            this.mBattlePassStatusSubtitle.removeFromParent(true);
            this.mBattlePassStatusSubtitle = null;
         }
         if(this.mChallengesQuestsComingSoon)
         {
            this.mChallengesQuestsComingSoon.removeFromParent(true);
            this.mChallengesQuestsComingSoon = null;
         }
         if(this.mRewardsNumberBG)
         {
            this.mRewardsNumberBG.removeFromParent(true);
            this.mRewardsNumberBG = null;
         }
         if(this.mRewardsRewardBG)
         {
            this.mRewardsRewardBG.removeFromParent(true);
            this.mRewardsRewardBG = null;
         }
         if(this.mRewardsPremiumRewardBG)
         {
            this.mRewardsPremiumRewardBG.removeFromParent(true);
            this.mRewardsPremiumRewardBG = null;
         }
         if(this.mRewardsChallengeTitle)
         {
            this.mRewardsChallengeTitle.removeFromParent(true);
            this.mRewardsChallengeTitle = null;
         }
         if(this.mRewardsRewardImage)
         {
            this.mRewardsRewardImage.removeFromParent(true);
            this.mRewardsRewardImage = null;
         }
         if(this.mRewardsPremiumRewardImage)
         {
            this.mRewardsPremiumRewardImage.removeFromParent(true);
            this.mRewardsPremiumRewardImage = null;
         }
         if(this.mRewardsScrollContainer)
         {
            this.mRewardsScrollContainer.removeFromParent(true);
            this.mRewardsScrollContainer = null;
         }
         if(this.mRewardsSeasonTitleTextfield)
         {
            this.mRewardsSeasonTitleTextfield.removeFromParent(true);
            this.mRewardsSeasonTitleTextfield = null;
         }
         if(this.mRewardsSeasonEndsTextfield)
         {
            this.mRewardsSeasonEndsTextfield.removeFromParent(true);
            this.mRewardsSeasonEndsTextfield = null;
         }
         if(this.mRewardsChallengeDetailTitle)
         {
            this.mRewardsChallengeDetailTitle.removeFromParent(true);
            this.mRewardsChallengeDetailTitle = null;
         }
         if(this.mRewardsChallengeDetailImage)
         {
            this.mRewardsChallengeDetailImage.removeFromParent(true);
            this.mRewardsChallengeDetailImage = null;
         }
         if(this.mRewardsChallengeDetailPackAnim)
         {
            this.mRewardsChallengeDetailPackAnim.removeFromParent(true);
            this.mRewardsChallengeDetailPackAnim = null;
         }
         if(this.mRewardsChallengeDetailDesc)
         {
            this.mRewardsChallengeDetailDesc.removeFromParent(true);
            this.mRewardsChallengeDetailDesc = null;
         }
         if(this.mRewardsBuyBattlePassButton)
         {
            this.mRewardsBuyBattlePassButton.removeFromParent(true);
            this.mRewardsBuyBattlePassButton = null;
         }
         if(this.mInfoBuyBattlePassButton)
         {
            this.mInfoBuyBattlePassButton.removeFromParent(true);
            this.mInfoBuyBattlePassButton = null;
         }
         if(this.mRewardsBuyInfoTextfield)
         {
            this.mRewardsBuyInfoTextfield.removeFromParent(true);
            this.mRewardsBuyInfoTextfield = null;
         }
         if(this.mRewardsRewardSlotHighlighted)
         {
            this.mRewardsRewardSlotHighlighted.removeFromParent(true);
            this.mRewardsRewardSlotHighlighted = null;
         }
         if(this.mRewardsCurrencyTextfield)
         {
            this.mRewardsCurrencyTextfield.removeFromParent(true);
            this.mRewardsCurrencyTextfield = null;
         }
         if(this.mRewardsPremiumRewardImageLock)
         {
            this.mRewardsPremiumRewardImageLock.removeFromParent(true);
            this.mRewardsPremiumRewardImageLock = null;
         }
         if(this.mRewardsPremiumShine)
         {
            this.mRewardsPremiumShine.removeFromParent(true);
            this.mRewardsPremiumShine = null;
         }
         this.disposePortraitsSkinsAssets();
         InstanceMng.getPopupMng().removePopup(FSPopupMng.BATTLE_PASS_POPUP_NAME);
         removeChildren(0,-1,true);
         super.removeFromStage();
      }
      
      private function disposePortraitsSkinsAssets() : void
      {
         var _loc1_:int = 0;
         if(this.mExtraResourcesLoaded)
         {
            _loc1_ = 0;
            _loc1_ = 0;
            while(_loc1_ < this.mExtraResourcesLoaded.length)
            {
               FSDebug.debugTrace("Destroying " + this.mExtraResourcesLoaded[_loc1_]);
               Root.assets.removeTexture(this.mExtraResourcesLoaded[_loc1_]);
               _loc1_++;
            }
         }
         Utils.destroyArray(this.mExtraResourcesLoaded);
         this.mExtraResourcesLoaded = null;
      }
      
      public function createBattlePassPurchasedAnimation(param1:Number = 2, param2:Function = null, param3:Array = null) : void
      {
         var _loc4_:Number = 0.6 * Utils.getDefaultSpeedTime();
         if(this.mBattlePassPurchasedAnimation == null)
         {
            this.mBattlePassPurchasedAnimation = new FSBattlePassPurchasedAnimation(param2,param3);
         }
         FSResourceMng.addToStage(this.mBattlePassPurchasedAnimation,FSResourceMng.LAYER_UI);
         this.mBattlePassPurchasedAnimation.x = Starling.current.stage.stageWidth / 2;
         this.mBattlePassPurchasedAnimation.y = Starling.current.stage.stageHeight / 2;
         this.mBattlePassPurchasedAnimation.performFadeIn();
         TweenMax.delayedCall(param1,this.removeBattlePassPurchasedAnimation);
      }
      
      public function removeBattlePassPurchasedAnimation(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         TweenMax.killDelayedCallsTo(this.removeBattlePassPurchasedAnimation);
         if(this.mBattlePassPurchasedAnimation.isShown())
         {
            _loc2_ = 0.25 * Utils.getDefaultSpeedTime();
            this.mBattlePassPurchasedAnimation.performFadeOut(_loc2_);
         }
      }
      
      public function addExtraResourceLoaded(param1:String) : void
      {
         if(this.mExtraResourcesLoaded == null)
         {
            this.mExtraResourcesLoaded = new Array();
         }
         this.mExtraResourcesLoaded.push(param1);
         FSDebug.debugTrace("Added to extra resource " + param1);
      }
      
      public function isExtraResourceLoaded(param1:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(this.mExtraResourcesLoaded)
         {
            _loc3_ = 0;
            _loc3_ = 0;
            while(_loc3_ < this.mExtraResourcesLoaded.length)
            {
               if(this.mExtraResourcesLoaded[_loc3_] == param1)
               {
                  return true;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
   }
}

