package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.DeckCardsPanel;
   import com.fs.tcgengine.view.misc.DeckJobConfigurator;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Event;
   
   public class FSPowerXL extends FSCardXL
   {
      
      private var mChoosePowerButton:FSButton;
      
      private var mIconPower:FSImage;
      
      public function FSPowerXL(param1:FSCard)
      {
         super(param1);
         this.createUI();
         this.setSummonPosition();
      }
      
      override protected function createSummonCostTextfield() : void
      {
         var _loc1_:Number = NaN;
         if(Config.getConfig().getShowSummonCost())
         {
            _loc1_ = !Utils.isTablet() ? 0.8 * Layout.getFontMultiplier() * 1.25 : Layout.getFontMultiplier();
            if(canShowSummonCost())
            {
               if(mSummonTextfield == null)
               {
                  mSummonTextfield = new FSTextfield(1,1,"",16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
                  mSummonTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
                  mSummonTextfield.touchable = false;
                  mSummonTextfield.alignPivot();
                  if(Utils.isIphone())
                  {
                     mSummonTextfield.x = mFrameSummonIcon.x - mFrameSummonIcon.width * 0.18;
                     mSummonTextfield.y = mFrameSummonIcon.y - mFrameSummonIcon.height * 0.18;
                  }
                  else
                  {
                     mSummonTextfield.x = mFrameSummonIcon.x;
                     mSummonTextfield.y = mFrameSummonIcon.y;
                  }
                  mSummonTextfield.width = mFrameSummonIcon.width * _loc1_;
                  mSummonTextfield.height = mFrameSummonIcon.height * _loc1_;
               }
               mSummonTextfield.text = String(getCardCostByType());
               mSubComponentsContainer.addChild(mSummonTextfield);
            }
         }
      }
      
      private function setSummonPosition() : void
      {
         if(mSummonTextfield)
         {
            mSummonTextfield.x = mFrameSummonIcon.x;
            mSummonTextfield.y = mFrameSummonIcon.y;
         }
      }
      
      private function createUI() : void
      {
         this.createChoosePowerButton();
         this.createFavouriteButton();
      }
      
      private function createChoosePowerButton() : void
      {
         var _loc3_:JobDef = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc1_:Boolean = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen ? FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getEdidionStatus() == FSDeckBuilderScreen.STATUS_EDITING : false;
         var _loc2_:Boolean = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen ? !FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).isViewAllCardsModeON() : false;
         if(_loc1_ && _loc2_)
         {
            if(this.mChoosePowerButton == null)
            {
               _loc3_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getCurrentJobSelected();
               _loc4_ = Boolean(_loc3_) && _loc3_.getActiveSecondarySku() == mParentCard.getCardDef().getSku();
               _loc5_ = !_loc4_ || _loc4_ && JobsMng.isActiveSecondaryAbilityUnlocked(_loc3_);
               _loc6_ = _loc5_ ? TextManager.getText("TID_DUNGEON_CHOOSE_BUTTON") : TextManager.getText("TID_GEN_LOCKED");
               _loc7_ = _loc5_ ? "power_button_lit" : "power_button_unlit";
               this.mChoosePowerButton = new FSButton(Root.assets.getTexture(_loc7_),_loc6_,null,true,null,Root.assets.getTexture(_loc7_));
               this.mChoosePowerButton.fontSize = 25;
               this.mChoosePowerButton.x = mParentCard.x + this.mChoosePowerButton.width * 0.3;
               this.mChoosePowerButton.y = mParentCard.y + mParentCard.height + this.mChoosePowerButton.height * 2.2;
               this.mChoosePowerButton.addEventListener(Event.TRIGGERED,this.onChoosePowerTriggered);
            }
            addChild(this.mChoosePowerButton);
         }
      }
      
      override protected function createFavouriteButton() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.createFavouriteButton();
         if(mFavouriteButton)
         {
            if(this.mChoosePowerButton)
            {
               this.mChoosePowerButton.x -= mFavouriteButton.width / 2;
               _loc1_ = this.mChoosePowerButton.x + this.mChoosePowerButton.width / 2;
               _loc2_ = this.mChoosePowerButton.y - this.mChoosePowerButton.height / 2;
               mFavouriteButton.x = _loc1_;
               mFavouriteButton.y = _loc2_;
            }
         }
      }
      
      private function onChoosePowerTriggered(param1:Event) : void
      {
         var _loc3_:FSDeckBuilderScreen = null;
         var _loc4_:DeckCardsPanel = null;
         var _loc5_:String = null;
         var _loc6_:JobDef = null;
         var _loc7_:Boolean = false;
         var _loc8_:UserData = null;
         var _loc9_:int = 0;
         var _loc10_:DeckJobConfigurator = null;
         var _loc2_:FSCard = mParentCard;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc3_ = InstanceMng.getCurrentScreen() as FSDeckBuilderScreen;
            _loc4_ = _loc3_.getCurrentCardsPanel();
            _loc5_ = _loc4_.getcurrentDeckPowerSku();
            _loc6_ = _loc3_.getCurrentJobSelected();
            _loc7_ = (Boolean(_loc6_)) && _loc6_.getActiveSecondarySku() == mParentCard.getCardDef().getSku();
            if(!_loc7_ || _loc7_ && JobsMng.isActiveSecondaryAbilityUnlocked(_loc6_))
            {
               if(_loc5_ == null || _loc5_ == "")
               {
                  this.managePowerSelected(_loc2_,_loc4_,_loc3_);
               }
               else if(_loc5_ != _loc2_.getCardDef().getSku())
               {
                  this.managePowerUnselected(_loc5_,_loc4_,_loc3_);
                  this.managePowerSelected(_loc2_,_loc4_,_loc3_);
               }
               if(Config.getConfig().gameHasClassSystem())
               {
                  _loc8_ = Utils.getOwnerUserData();
                  if(_loc8_)
                  {
                     _loc9_ = _loc8_.getSelectedDeckIndex();
                     _loc10_ = InstanceMng.getUserDataMng().getOwnerUserData().getDeckJobConfiguratorByDeck(_loc9_);
                     if(_loc10_)
                     {
                        _loc10_.setActiveAbilitySku(mCardDef.getSku());
                     }
                  }
                  InstanceMng.getUserDataMng().getOwnerUserData().setDeckJobConfigurator(_loc10_);
               }
            }
            else
            {
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_JOBS_UNLOCKED_ABILITY"),[_loc3_.getCurrentJobSelected().getUnlockSecondaryAbiliyLevel().toString()]),true);
            }
         }
      }
      
      private function managePowerUnselected(param1:String, param2:DeckCardsPanel, param3:FSDeckBuilderScreen) : void
      {
         var _loc4_:DeckBuilderCard = param3.getCardInfoByCardSku(param1);
         param2.removeCardInfoFromCatalog(param1,1);
         param2.cleanPower();
         if(_loc4_ != null)
         {
            _loc4_.setAmount(_loc4_.getAmount() + 1);
            _loc4_.hidePowerSelectedText();
         }
      }
      
      private function managePowerSelected(param1:FSCard, param2:DeckCardsPanel, param3:FSDeckBuilderScreen) : void
      {
         var _loc4_:DeckBuilderCard = null;
         if(Boolean(param1 && param2) && Boolean(param3) && param1.getCardDef() is PowerDef)
         {
            param2.setCurrentPowerSkuToDeckCardsPanel(param1.getCardDef().getSku());
            param2.createBgPowerIcon();
            _loc4_ = param3.getCardInfoByCardSku(param1.getCardDef().getSku());
            if(_loc4_)
            {
               _loc4_.setAmount(_loc4_.getAmount() - 1);
               _loc4_.showPowerSelectedText();
            }
         }
      }
      
      override protected function setHeightPercentages() : void
      {
         mAbilitiesHeightBlockPercent = FSCardXL.ABILITIES_BLOCK_HEIGHT_PERCENTAGE;
         mDescBlockHeightPercent = 85;
      }
      
      override public function createTierFrame(param1:Boolean = false) : void
      {
      }
      
      override protected function createPromoteInfo() : void
      {
      }
      
      override public function showDamageAndShield(param1:Boolean = false) : void
      {
      }
      
      override public function dispose() : void
      {
         if(this.mChoosePowerButton)
         {
            this.mChoosePowerButton.removeFromParent(true);
            this.mChoosePowerButton = null;
         }
         if(this.mIconPower)
         {
            this.mIconPower.removeFromParent(true);
            this.mIconPower = null;
         }
         super.dispose();
      }
   }
}

