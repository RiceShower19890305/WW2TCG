package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.BoostsMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.boosts.Boost;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.popups.Popup;
   import com.greensock.TweenMax;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class BoostItem extends Component implements FSModelUnloadableInterface
   {
      
      private const AMOUNT_BOX_NAME:String = "boost_socket_amount";
      
      private var mBoostDef:BoostDef;
      
      private var mButton:FSButton;
      
      private var mIndex:int;
      
      private var mAmountBox:Component;
      
      private var mAmountTextfield:FSTextfield;
      
      private var mBoostType:int;
      
      private var mSelectedImage:FSImage;
      
      private var mIsSelected:Boolean = false;
      
      public function BoostItem(param1:int, param2:BoostDef, param3:int)
      {
         super();
         this.mBoostDef = param2;
         this.mIndex = param1;
         this.mBoostType = param3;
         this.init();
      }
      
      private function init() : void
      {
         this.createButton();
         this.showCurrentAmount();
         SpecialFX.createYoYoZoomTransition(this,1.04,1.75,-1);
      }
      
      private function createButton() : void
      {
         if(this.mButton == null && Boolean(this.mBoostDef))
         {
            this.mButton = new FSButton(Root.assets.getTexture(this.mBoostDef.getBGImageName()));
            this.mButton.x += this.mButton.width / 2;
            this.mButton.y += this.mButton.height / 2;
            addChild(this.mButton);
            this.mButton.addEventListener(Event.TRIGGERED,this.onButtonTriggered);
         }
      }
      
      private function onButtonTriggered(param1:Event) : void
      {
         var _loc3_:Popup = null;
         var _loc2_:Boost = InstanceMng.getBoostsMng().getBoost(this.mBoostDef);
         if(_loc2_ != null)
         {
            _loc2_.setBoostItemParent(this);
            if(_loc2_.userHasBoost())
            {
               switch(this.mBoostType)
               {
                  case BoostsMng.PRE_BOOST:
                     this.mIsSelected = !this.mIsSelected;
                     this.setSelected(this.mIsSelected);
                     break;
                  case BoostsMng.BOOST:
                     _loc2_.execute();
                     break;
                  case BoostsMng.POST_BOOST:
               }
            }
            else if(!Screen.isScreenLocked())
            {
               if(InstanceMng.getCurrentScreen() is FSBattleScreen)
               {
                  FSBattleScreen(InstanceMng.getCurrentScreen()).enableBoostsPanel(false);
                  TweenMax.delayedCall(3,this.battleScreenEnableBoostsPanel,[true]);
               }
               _loc3_ = InstanceMng.getPopupMng().getPopupShown();
               if(_loc3_)
               {
                  _loc3_.hideTemporarily(InstanceMng.getPopupMng().openBuyBoostPopup,[this]);
               }
               else
               {
                  InstanceMng.getPopupMng().openBuyBoostPopup(this);
               }
            }
         }
      }
      
      private function battleScreenEnableBoostsPanel(param1:Boolean) : void
      {
         if(Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).enableBoostsPanel(param1);
         }
      }
      
      private function setSelected(param1:Boolean) : void
      {
         if(this.mIsSelected)
         {
            if(this.mSelectedImage == null)
            {
               this.mSelectedImage = new FSImage(Root.assets.getTexture("seal_approved"));
               this.mSelectedImage.touchable = false;
               this.mSelectedImage.alignPivot();
               this.mSelectedImage.x = this.mSelectedImage.width / 2;
               this.mSelectedImage.y = this.mSelectedImage.height / 2;
               addChild(this.mSelectedImage);
            }
            InstanceMng.getUserDataMng().getOwnerUserData().addPreBoost(this.mBoostDef.getSku());
         }
         else
         {
            InstanceMng.getUserDataMng().getOwnerUserData().removePreBoost(this.mBoostDef.getSku());
         }
         if(this.mButton)
         {
            this.mButton.alpha = this.mIsSelected ? 0.5 : 1;
         }
         if(this.mSelectedImage)
         {
            this.mSelectedImage.visible = this.mIsSelected;
         }
         if(this.mAmountBox)
         {
            this.mAmountBox.visible = !this.mIsSelected;
         }
      }
      
      public function onExecuted() : void
      {
         this.updateAmount();
         this.checkAfterExecution();
      }
      
      private function checkAfterExecution() : void
      {
         if(Boolean(this.mBoostDef) && this.mBoostDef.isPermanent())
         {
            this.setEnabled(false);
         }
      }
      
      private function showCurrentAmount() : void
      {
         var _loc1_:FSImage = null;
         if(this.mAmountBox == null)
         {
            this.mAmountBox = new Component();
            _loc1_ = new FSImage(Root.assets.getTexture(this.AMOUNT_BOX_NAME));
            this.mAmountBox.alignPivot();
            this.mAmountBox.x = this.mButton ? this.mButton.x : 0;
            this.mAmountBox.y = this.mButton ? this.mButton.y : 0;
            this.mAmountBox.touchable = false;
            this.mAmountBox.addChild(_loc1_);
            addChild(this.mAmountBox);
         }
         if(this.mAmountTextfield == null)
         {
            this.mAmountTextfield = new FSTextfield(this.mAmountBox.width * 1.25,this.mAmountBox.height);
            this.mAmountTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mAmountTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mAmountTextfield.format.horizontalAlign = Align.CENTER;
            this.mAmountTextfield.touchable = false;
            this.mAmountBox.addChild(this.mAmountTextfield);
            this.updateAmount();
         }
      }
      
      public function updateAmount() : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(this.mAmountBox == null)
         {
            this.init();
         }
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(_loc1_ != null && Boolean(this.mBoostDef))
         {
            _loc3_ = _loc1_.getBoostAmount(this.mBoostDef.getSku());
         }
         _loc2_ = _loc3_ > 0 ? _loc3_.toString() : "+";
         if(this.mAmountTextfield)
         {
            this.mAmountTextfield.text = _loc2_;
         }
      }
      
      public function getBoostDef() : BoostDef
      {
         return this.mBoostDef;
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         alpha = param1 ? 1 : 0.5;
         touchable = param1;
      }
      
      override public function dispose() : void
      {
         if(this.mButton)
         {
            this.mButton.removeFromParent(true);
            this.mButton = null;
         }
         if(this.mAmountBox)
         {
            this.mAmountBox.removeFromParent(true);
            this.mAmountBox = null;
         }
         if(this.mAmountTextfield)
         {
            this.mAmountTextfield.removeFromParent(true);
            this.mAmountTextfield = null;
         }
         if(this.mSelectedImage)
         {
            this.mSelectedImage.removeFromParent(true);
            this.mSelectedImage = null;
         }
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mButton)
         {
            this.mButton.removeFromParent();
            this.mButton.destroy();
            this.mButton = null;
         }
         if(this.mAmountBox)
         {
            this.mAmountBox.removeFromParent();
            this.mAmountBox = null;
         }
         if(this.mAmountTextfield)
         {
            this.mAmountTextfield.removeFromParent();
            this.mAmountTextfield = null;
         }
         if(this.mSelectedImage)
         {
            this.mSelectedImage.removeFromParent();
            this.mSelectedImage.destroy();
            this.mSelectedImage = null;
         }
      }
   }
}

