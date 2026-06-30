package com.fs.tcgengine.view.components.battle
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardXL;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class PromoteCostBlock extends Component
   {
      
      private var mCostTextfield:FSTextfield;
      
      private var mCostPoints:int;
      
      private var mAPBoxesContainer:Component;
      
      private var mPromoteCardButton:FSButton;
      
      private var mParentCard:FSCard;
      
      private var mIsPromoting:Boolean = false;
      
      private var mTextFieldBG:FSImage;
      
      private var mTextField:FSTextfield;
      
      public function PromoteCostBlock(param1:int, param2:FSCard)
      {
         super();
         this.mCostPoints = param1;
         this.mParentCard = param2;
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createCostTitle();
         this.createAPBoxes();
         this.createPromoteButton();
         if(this.mPromoteCardButton)
         {
            this.mPromoteCardButton.addEventListener(TouchEvent.TOUCH,this.onTouched);
         }
      }
      
      private function onTouched(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            if(!this.mIsPromoting && !this.mParentCard.canBePromoted())
            {
               if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSBattleScreen)
               {
                  FSBattleScreen(InstanceMng.getCurrentScreen()).showNotEnoughAPEffect(this.mParentCard);
               }
            }
         }
      }
      
      private function createCostTitle() : void
      {
         if(this.mCostTextfield == null)
         {
            this.mCostTextfield = new FSTextfield(FSCardXL.COLUMN_WIDTH / 1.45,FSResourceMng.FONT_STD_SUBTITLE_SIZE * 1.55,TextManager.getText("TID_GEN_PROMOTE_COST") + ":");
            this.mCostTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mCostTextfield.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
            this.mCostTextfield.format.horizontalAlign = Align.RIGHT;
            addChild(this.mCostTextfield);
         }
      }
      
      private function createAPBoxes() : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSImage = null;
         var _loc4_:FSCoordinate = null;
         if(this.mAPBoxesContainer == null)
         {
            this.mAPBoxesContainer = new Component();
            this.mAPBoxesContainer.width = this.mCostTextfield.width;
            this.mAPBoxesContainer.x = this.mCostTextfield.x + this.mCostTextfield.width;
            this.mAPBoxesContainer.y = this.mCostTextfield.y;
            addChild(this.mAPBoxesContainer);
         }
         var _loc1_:int = Config.getConfig().getActionPointsShowMode();
         if(_loc1_ == ActionPointsCounter.AP_MODE_BOX || _loc1_ == ActionPointsCounter.AP_MODE_BOX_TEXTFIELD)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mCostPoints)
            {
               _loc3_ = new FSImage(Root.assets.getTexture("ap_crate"));
               _loc3_.x = _loc2_ * _loc3_.width * 1.05;
               this.mAPBoxesContainer.addChild(_loc3_);
               _loc2_++;
            }
            this.mAPBoxesContainer.y = this.mCostTextfield.y + (this.mCostTextfield.height - this.mAPBoxesContainer.height) / 2;
         }
         else
         {
            this.createTextfieldBG();
            this.createTextfield();
         }
      }
      
      private function createTextfieldBG() : void
      {
         if(this.mTextFieldBG == null)
         {
            this.mTextFieldBG = new FSImage(Root.assets.getTexture("ap_value_panel"));
            this.mTextFieldBG.x = 0;
            this.mTextFieldBG.y = 0;
            this.mTextFieldBG.y = this.mCostTextfield.y + (this.mCostTextfield.height - this.mTextFieldBG.height) / 2;
            this.mAPBoxesContainer.addChild(this.mTextFieldBG);
         }
      }
      
      private function createTextfield() : void
      {
         if(this.mTextField == null)
         {
            this.mTextField = new FSTextfield(this.mTextFieldBG.width,this.mTextFieldBG.height,"0");
            this.mTextField.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            this.mTextField.x = 0;
            this.mTextField.y = this.mCostTextfield.y + (this.mCostTextfield.height - this.mTextField.height) / 2;
            this.mTextField.text = String(this.mCostPoints);
            this.mAPBoxesContainer.addChild(this.mTextField);
         }
      }
      
      protected function createPromoteButton() : void
      {
         var _loc3_:CardDef = null;
         var _loc1_:Boolean = InstanceMng.getBattleEngine().getLevelDef().isUpgradeAllowed();
         var _loc2_:Boolean = this.mParentCard.getCardDef().getTier() < 3 && !this.mParentCard.isEnemyCard() && _loc1_;
         if(_loc2_)
         {
            if(this.mPromoteCardButton == null)
            {
               _loc3_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mParentCard.getCardDef().getUpgradeSku()));
               this.mPromoteCardButton = new FSButton(Root.assets.getTexture(Constants.PROMOTE_CARD_BUTTON),TextManager.getText("TID_GEN_UPGRADE_UNIT"));
               Utils.setupButton9Scale(this.mPromoteCardButton,7.5,15,10,5,104,31.5);
               this.mPromoteCardButton.fontName = FSResourceMng.getFontByType();
               this.mPromoteCardButton.fontColor = 16777215;
               this.mPromoteCardButton.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
               this.mPromoteCardButton.addEventListener(Event.TRIGGERED,this.onButtonTriggered);
               this.mPromoteCardButton.x = width / 2;
               this.mPromoteCardButton.y = this.mAPBoxesContainer.y + this.mAPBoxesContainer.height + this.mPromoteCardButton.height / 1.5;
            }
            else
            {
               _loc3_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mParentCard.getCardDef().getUpgradeSku()));
            }
            addChild(this.mPromoteCardButton);
         }
         if(this.mPromoteCardButton != null)
         {
            this.mPromoteCardButton.enabled = this.mParentCard.canBePromoted();
         }
      }
      
      private function onButtonTriggered(param1:Event) : void
      {
         var _loc2_:CardDef = null;
         var _loc3_:CardDef = null;
         this.mIsPromoting = true;
         if(this.mParentCard)
         {
            _loc2_ = this.mParentCard.getCardDef();
            _loc3_ = _loc2_ ? Utils.getNextTierCardDef(_loc2_.getSku()) : null;
            if(_loc3_)
            {
               this.mParentCard.promoteCard(_loc3_.getSku());
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mCostTextfield)
         {
            this.mCostTextfield.removeFromParent(true);
            this.mCostTextfield = null;
         }
         if(this.mAPBoxesContainer)
         {
            this.mAPBoxesContainer.removeChildren();
            this.mAPBoxesContainer.removeFromParent(true);
            this.mAPBoxesContainer = null;
         }
         if(this.mPromoteCardButton)
         {
            this.mPromoteCardButton.removeFromParent(true);
            this.mPromoteCardButton = null;
         }
         if(this.mTextField)
         {
            this.mTextField.removeFromParent(true);
            this.mTextField = null;
         }
         if(this.mTextFieldBG)
         {
            this.mTextFieldBG.removeFromParent(true);
            this.mTextFieldBG = null;
         }
         this.mParentCard = null;
         super.dispose();
      }
   }
}

