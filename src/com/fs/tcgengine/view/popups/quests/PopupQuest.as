package com.fs.tcgengine.view.popups.quests
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.BoostsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.quests.Quest;
   import com.fs.tcgengine.model.rules.QuestDef;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.buttons.FSSideImageButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.quests.QuestSlot;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.Direction;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.TiledRowsLayout;
   import feathers.layout.VerticalAlign;
   import feathers.layout.VerticalLayout;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class PopupQuest extends PopupStandard
   {
      
      public static const INFO_QUEST_BG:String = "quest_info_button";
      
      private const QUEST_PANEL_BG:String = "questpanel_title";
      
      private const QUEST_JOURNAL_ICON:String = "quest_journal_button_icon";
      
      private const AMOUNT_QUEST_CURRENCY:String = "amount_quest_currency";
      
      private const QUEST_REFRESH_BG:String = "buy_quest_button";
      
      private const QUEST_REFRESH_ICON:String = "quest_reset_button_icon";
      
      private var mResetQuestButton:FSSideImageButton;
      
      private var mResetQuestIcon:FSImage;
      
      private var mQuestTextfield:FSTextfield;
      
      private var mAmountCurrencyTextfield:FSTextfield;
      
      private var mTimeDailyResetTextfield:FSTextfield;
      
      private var mTitleTextfield:FSTextfield;
      
      private var mAmountCurrencyImage:FSImage;
      
      private var mInfoButton:FSButton;
      
      private var mJournalScrollContainer:ScrollContainer;
      
      private var mQuestVector:Vector.<Quest>;
      
      private var mIsBrowsingQuests:Boolean = true;
      
      public function PopupQuest(param1:Boolean = true)
      {
         super(param1);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = Constants.POPUP_EXTENDED_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,1200);
         if(Boolean(mBox) && Config.getConfig().gameHasCustomPopups())
         {
            mBox.scale = Constants.POPUP_EXTENDED_SCALE_FACTOR;
         }
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.createJournalQuestUI();
         this.createAmountQuestsCoins();
         this.hideOkbutton();
      }
      
      override protected function createCornerImage(param1:String = "") : void
      {
         super.createCornerImage(this.QUEST_JOURNAL_ICON);
      }
      
      private function createJournalQuestUI() : void
      {
         this.createResetQuestButton();
         this.createTimeResetDailyQuestTextfield();
         this.createInfoButton();
         this.fillQuests();
      }
      
      private function hideOkbutton() : void
      {
         mAcceptButton.visible = false;
      }
      
      protected function fillQuests() : void
      {
         var _loc1_:Quest = null;
         if(this.mJournalScrollContainer)
         {
            this.mJournalScrollContainer.removeChildren();
         }
         else
         {
            this.createJournalScrollContainer();
         }
         var _loc2_:Vector.<Quest> = InstanceMng.getQuestsMng().getQuestsUnlocked();
         for each(_loc1_ in _loc2_)
         {
            this.addQuestJournalToScrollContainer(new QuestSlot(_loc1_,this.mJournalScrollContainer));
         }
      }
      
      private function createInfoButton() : void
      {
         if(this.mInfoButton == null)
         {
            this.mInfoButton = new FSButton(Root.assets.getTexture(INFO_QUEST_BG));
            this.mInfoButton.scale = 0.8;
            this.mInfoButton.x = width / 2 - this.mInfoButton.width / 3;
            this.mInfoButton.y = height - this.mInfoButton.height * 1.15;
            this.mInfoButton.scaleWhenDown = 1;
            this.mInfoButton.enableScaleOnMouseOver(false);
            this.mInfoButton.setTooltipText(TextManager.getText("TID_QUEST_INFO"));
            addChild(this.mInfoButton);
         }
      }
      
      private function createTimeResetDailyQuestTextfield() : void
      {
         if(this.mTimeDailyResetTextfield == null)
         {
            this.mTimeDailyResetTextfield = new FSTextfield(width / 1.9,this.mResetQuestButton.height,TextManager.replaceParameters(TextManager.getText("TID_DAILY_QUEST_RESET"),[Utils.getDailyKeyTimeResetText()]));
            this.mTimeDailyResetTextfield.x = this.mResetQuestButton.x + this.mResetQuestButton.width / 2 + 5;
            this.mTimeDailyResetTextfield.y = this.mResetQuestButton.y - this.mResetQuestButton.height / 2;
            this.mTimeDailyResetTextfield.format.horizontalAlign = Align.LEFT;
         }
         addChild(this.mTimeDailyResetTextfield);
      }
      
      private function refreshResetDailyQuestsTime() : void
      {
         if(this.mTimeDailyResetTextfield)
         {
            if(Utils.getDailyKeyTime() != -1 && !isNaN(Utils.getDailyKeyTime()))
            {
               this.mTimeDailyResetTextfield.text = TextManager.replaceParameters(TextManager.getText("TID_DAILY_QUEST_RESET"),[Utils.getDailyKeyTimeResetText()]);
            }
         }
      }
      
      private function createResetQuestButton() : void
      {
         if(this.mResetQuestButton == null)
         {
            this.mResetQuestButton = new FSSideImageButton(Root.assets.getTexture(this.QUEST_REFRESH_BG),TextManager.getText("TID_QUEST_RESET"),Align.RIGHT);
            Utils.setupButton9Scale(this.mResetQuestButton,12.5,12.5,2.5,2.5,83.25,29.5);
            if(this.mResetQuestIcon == null)
            {
               this.mResetQuestIcon = new FSImage(Root.assets.getTexture(this.QUEST_REFRESH_ICON));
            }
            this.mResetQuestButton.addChildToContents(this.mResetQuestIcon);
            this.mResetQuestButton.x = this.mResetQuestButton.width;
            this.mResetQuestButton.y = mCornerIcon.y + mCornerIcon.height / 1.85;
            this.mResetQuestButton.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
            this.mResetQuestButton.addEventListener(Event.TRIGGERED,this.onResetTriggered);
         }
         addChild(this.mResetQuestButton);
      }
      
      private function onResetTriggered(param1:Event) : void
      {
         var _loc3_:ShopBoostDef = null;
         var _loc4_:FSShopItem = null;
         var _loc5_:Popup = null;
         var _loc2_:String = InstanceMng.getUserDataMng().getOwnerUserData().canResetDailyQuests();
         if(_loc2_ != "")
         {
            Utils.setLogText(_loc2_);
         }
         else
         {
            _loc3_ = ShopBoostDef(InstanceMng.getShopBoostsDefMng().getShopBoostDefByKeyname(BoostsMng.BOOST_ID_RESET_DAILY_QUESTS));
            if(_loc3_ != null)
            {
               _loc4_ = new FSShopItem(_loc3_,false,null,true);
               _loc5_ = InstanceMng.getPopupMng().getPopupShown();
               if(_loc5_)
               {
                  _loc5_.hideTemporarily(InstanceMng.getPopupMng().openShopItemPopup,[_loc4_]);
               }
               else
               {
                  InstanceMng.getPopupMng().openShopItemPopup(_loc4_);
               }
            }
         }
      }
      
      private function createAmountQuestsCoins() : void
      {
         if(this.mAmountCurrencyImage == null)
         {
            this.mAmountCurrencyImage = new FSImage(Root.assets.getTexture(this.AMOUNT_QUEST_CURRENCY));
            this.mAmountCurrencyImage.x = width * 0.73;
            this.mAmountCurrencyImage.y = height * 0.84;
         }
         addChild(this.mAmountCurrencyImage);
         if(Boolean(this.mAmountCurrencyImage) && this.mAmountCurrencyTextfield == null)
         {
            this.mAmountCurrencyTextfield = new FSTextfield(this.mAmountCurrencyImage.width,this.mAmountCurrencyImage.height,InstanceMng.getUserDataMng().getOwnerUserData().getQuestsCoins().toString());
            this.mAmountCurrencyTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            this.mAmountCurrencyTextfield.x = this.mAmountCurrencyImage.x;
            this.mAmountCurrencyTextfield.y = this.mAmountCurrencyImage.y;
         }
         addChild(this.mAmountCurrencyTextfield);
      }
      
      private function cleanJournal() : void
      {
         if(this.mResetQuestButton)
         {
            this.mResetQuestButton.removeFromParent();
            this.mResetQuestButton.destroy();
            this.mResetQuestButton = null;
         }
         if(this.mResetQuestIcon)
         {
            this.mResetQuestIcon.removeFromParent();
            this.mResetQuestIcon.destroy();
            this.mResetQuestIcon = null;
         }
         if(this.mTimeDailyResetTextfield)
         {
            this.mTimeDailyResetTextfield.removeFromParent();
            this.mTimeDailyResetTextfield = null;
         }
         if(this.mJournalScrollContainer)
         {
            this.mJournalScrollContainer.removeFromParent();
            this.mJournalScrollContainer = null;
         }
         if(this.mInfoButton)
         {
            this.mInfoButton.removeFromParent();
            this.mInfoButton.destroy();
            this.mInfoButton = null;
         }
      }
      
      private function addQuestJournalToScrollContainer(param1:QuestSlot) : void
      {
         var _loc2_:Number = NaN;
         if(this.mJournalScrollContainer)
         {
            _loc2_ = param1.width * 1.15;
            this.mJournalScrollContainer.width = _loc2_;
            this.mJournalScrollContainer.x = (mBox.width - _loc2_) / 2;
            if(!this.journalAlreadyContainsQuest(param1.getQuest().getDef()))
            {
               this.mJournalScrollContainer.addChild(param1);
            }
         }
      }
      
      private function createJournalScrollContainer() : void
      {
         if(this.mJournalScrollContainer == null)
         {
            this.mJournalScrollContainer = new ScrollContainer();
            this.mJournalScrollContainer.height = mBox.height * 0.665;
            this.mJournalScrollContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mJournalScrollContainer.layout = this.getContainerLayoutVertical();
            this.mJournalScrollContainer.y = this.mResetQuestButton.y + this.mResetQuestButton.height / 1.5;
            this.mJournalScrollContainer.touchable = true;
            addChild(this.mJournalScrollContainer);
         }
      }
      
      private function journalAlreadyContainsQuest(param1:QuestDef) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:Boolean = false;
         if(this.mJournalScrollContainer)
         {
            _loc3_ = this.mJournalScrollContainer.numChildren;
            while(_loc4_ < _loc3_)
            {
               if(QuestSlot(this.mJournalScrollContainer.getChildAt(_loc4_)) != null && QuestSlot(this.mJournalScrollContainer.getChildAt(_loc4_)).getQuest().getDef().getSku() == param1.getSku())
               {
                  return true;
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      private function getContainerLayoutHorizontal() : TiledRowsLayout
      {
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.paging = Direction.NONE;
         _loc1_.horizontalGap = 5;
         _loc1_.verticalGap = 5;
         _loc1_.paddingTop = 2;
         _loc1_.paddingRight = 0;
         _loc1_.paddingBottom = 0;
         _loc1_.paddingLeft = 0;
         _loc1_.verticalAlign = VerticalAlign.TOP;
         _loc1_.tileVerticalAlign = VerticalAlign.TOP;
         _loc1_.horizontalAlign = HorizontalAlign.CENTER;
         _loc1_.tileHorizontalAlign = HorizontalAlign.CENTER;
         return _loc1_;
      }
      
      private function getContainerLayoutVertical() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 5;
         _loc1_.horizontalAlign = HorizontalAlign.CENTER;
         return _loc1_;
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mAmountCurrencyImage)
         {
            this.mAmountCurrencyImage.removeFromParent(true);
            this.mAmountCurrencyImage = null;
         }
         if(this.mAmountCurrencyTextfield)
         {
            this.mAmountCurrencyTextfield.removeFromParent(true);
            this.mAmountCurrencyTextfield = null;
         }
         if(this.mResetQuestButton)
         {
            this.mResetQuestButton.removeFromParent(true);
            this.mResetQuestButton = null;
         }
         if(this.mResetQuestIcon)
         {
            this.mResetQuestIcon.removeFromParent(true);
            this.mResetQuestIcon = null;
         }
         if(this.mTimeDailyResetTextfield)
         {
            this.mTimeDailyResetTextfield.removeFromParent();
            this.mTimeDailyResetTextfield = null;
         }
         if(this.mInfoButton)
         {
            this.mInfoButton.removeFromParent(true);
            this.mInfoButton = null;
         }
         if(this.mJournalScrollContainer)
         {
            this.mJournalScrollContainer.removeFromParent(true);
            this.mJournalScrollContainer = null;
         }
         if(this.mQuestTextfield)
         {
            this.mQuestTextfield.removeFromParent(true);
            this.mQuestTextfield = null;
         }
         Utils.destroyArray(this.mQuestVector);
         this.mQuestVector = null;
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         InstanceMng.getPopupMng().removePopup(FSPopupMng.QUEST_POPUP_NAME);
         super.removeFromStage();
      }
      
      public function refreshAmountQuestsCoins(param1:int) : void
      {
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData().getQuestsCoins();
         if(this.mAmountCurrencyTextfield)
         {
            if(this.mAmountCurrencyTextfield.text != "")
            {
               SpecialFX.createTextfieldAmountTransition(this.mAmountCurrencyTextfield,_loc2_,0.25,true);
            }
            else
            {
               this.mAmountCurrencyTextfield.text = _loc2_.toString();
            }
            if(param1 < 0)
            {
               InstanceMng.getTextParticlesMng().showTextParticle(param1.toString(),16711680,this.mAmountCurrencyTextfield);
            }
            else
            {
               InstanceMng.getTextParticlesMng().showTextParticle("+ " + param1,65280,this.mAmountCurrencyTextfield);
            }
         }
      }
      
      public function getJournalScrollContainer() : ScrollContainer
      {
         return this.mJournalScrollContainer;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this.mTimeDailyResetTextfield)
         {
            this.refreshResetDailyQuestsTime();
         }
      }
      
      public function onQuestsMngResetedCleanPopup() : void
      {
         if(this.mJournalScrollContainer)
         {
            this.mJournalScrollContainer.removeChildren();
         }
         this.fillQuests();
      }
      
      override public function onClose(param1:Event) : void
      {
         this.touchable = false;
         super.onClose(param1);
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
      
      override public function onConnectionChange() : void
      {
         var _loc1_:QuestSlot = null;
         var _loc2_:int = 0;
         super.onConnectionChange();
         if(this.mJournalScrollContainer)
         {
            _loc2_ = 0;
            _loc2_ = 0;
            while(_loc2_ < this.mJournalScrollContainer.numChildren)
            {
               _loc1_ = QuestSlot(this.mJournalScrollContainer.getChildAt(_loc2_));
               if(Boolean(_loc1_) && _loc1_.getQuest().isCommunityQuest())
               {
                  _loc1_.onConnectionChanged();
               }
               _loc2_++;
            }
         }
      }
   }
}

