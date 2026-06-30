package com.fs.tcgengine.view.popups.levels
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TargetMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.PostBoostButton;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import starling.events.Event;
   
   public class PopupPostBoost extends PopupStandard
   {
      
      public static const OUT_OF_LIFES:int = 0;
      
      public static const OUT_OF_TURNS:int = 1;
      
      public static const OUT_OF_LIFES_AND_TURNS:int = 2;
      
      private var mPostBoostButton:PostBoostButton;
      
      private var mFreeImage:FSImage;
      
      public function PopupPostBoost(param1:Boolean = true)
      {
         super(false);
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mPostBoostButton)
         {
            this.mPostBoostButton.removeFromParent();
            this.mPostBoostButton = null;
         }
         if(this.mFreeImage)
         {
            this.mFreeImage.removeFromParent();
            this.mFreeImage.destroy();
            this.mFreeImage = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.POST_BOOST_POPUP_NAME);
         super.removeFromStage();
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.setupPopup();
         this.createFreeText();
      }
      
      private function createFreeText() : void
      {
         if(!InstanceMng.getUserDataMng().getOwnerUserData().flagsGetUsedFreeBoost())
         {
            this.mFreeImage = new FSImage(Root.assets.getTexture("boost_free"));
            this.mFreeImage.touchable = false;
            this.mFreeImage.x = this.mPostBoostButton ? this.mPostBoostButton.x - this.mPostBoostButton.width / 2 : width / 2;
            this.mFreeImage.y = this.mPostBoostButton ? this.mPostBoostButton.y - this.mPostBoostButton.height / 2 : height / 2;
            SpecialFX.createYoYoAlphaTransition(this.mFreeImage,0.4,0.4);
            addChild(this.mFreeImage);
         }
      }
      
      override protected function createFields() : void
      {
         var _loc1_:Number = width * 0.85;
         var _loc2_:Number = height * 0.2;
         if(mInfoTextfield == null)
         {
            mInfoTextfield = new FSTextfield(_loc1_,_loc2_,"",16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            mInfoTextfield.x = (width - _loc1_) / 2;
            mInfoTextfield.y = mBox.height * 0.1;
            addChild(mInfoTextfield);
         }
      }
      
      public function setupPopup() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:TargetMng = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc3_ = InstanceMng.getTargetMng();
            _loc4_ = _loc3_ ? InstanceMng.getTargetMng().getCurrentLevelRequiredTurns() : 0;
            if(_loc4_ > 0)
            {
               _loc5_ = _loc3_ ? InstanceMng.getTargetMng().isSurvivalMode() : false;
               if(_loc5_)
               {
                  this.configurePopup(OUT_OF_LIFES);
               }
               else
               {
                  _loc6_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().getCurrentTurnId() : 0;
                  _loc7_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().getOwnerBattleInfo().getHP() : 0;
                  _loc2_ = _loc6_ < _loc4_;
                  _loc1_ = _loc7_ > 0;
                  if(!_loc2_ && !_loc1_)
                  {
                     this.configurePopup(OUT_OF_LIFES_AND_TURNS);
                  }
                  else
                  {
                     if(!_loc2_)
                     {
                        this.configurePopup(OUT_OF_TURNS);
                     }
                     if(!_loc1_)
                     {
                        this.configurePopup(OUT_OF_LIFES);
                     }
                  }
               }
            }
            else
            {
               this.configurePopup(OUT_OF_LIFES);
            }
         }
         else
         {
            closePopup();
         }
      }
      
      private function configurePopup(param1:int) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case OUT_OF_LIFES:
               _loc2_ = TextManager.getText("TID_GEN_LEVEL_OUT_LIFES");
               break;
            case OUT_OF_TURNS:
               _loc2_ = TextManager.getText("TID_GEN_LEVEL_OUT_TURNS");
               break;
            case OUT_OF_LIFES_AND_TURNS:
               _loc2_ = TextManager.getText("TID_GEN_LIFES_TURNS_OUT");
         }
         this.setMainFieldText(_loc2_);
         this.createPostBoostButton(param1);
      }
      
      override public function setMainFieldText(param1:String = "") : void
      {
         super.setMainFieldText(param1);
         if(!InstanceMng.getUserDataMng().getOwnerUserData().flagsGetUsedFreeBoost())
         {
            if(mInfoTextfield != null)
            {
               mInfoTextfield.text = mText + " " + TextManager.getText("TID_GEN_FREE_BOOST");
            }
         }
      }
      
      private function createPostBoostButton(param1:int) : void
      {
         this.mPostBoostButton = new PostBoostButton(param1);
         this.mPostBoostButton.x = mBox.width / 2;
         this.mPostBoostButton.y = mBox.height / 2;
         addChild(this.mPostBoostButton);
         this.mPostBoostButton.setEnabled(Config.smPostBoostsEnabled);
      }
      
      public function onPostBoostButtonClicked(param1:BoostDef) : void
      {
         this.onPostBoostButtonClickedPerformOps();
      }
      
      private function openBuyPostBoostPopup() : void
      {
         var _loc2_:Popup = null;
         var _loc1_:BoostDef = this.mPostBoostButton.getBoostDef();
         if(_loc1_ != null)
         {
            _loc2_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc2_)
            {
               _loc2_.hideTemporarily(InstanceMng.getPopupMng().openBuyPostBoostPopup,[_loc1_]);
            }
            else
            {
               InstanceMng.getPopupMng().openBuyPostBoostPopup(_loc1_);
            }
         }
      }
      
      private function onPostBoostButtonClickedPerformOps() : void
      {
         this.openBuyPostBoostPopup();
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = Constants.STD_POPUP_BG_NAME;
      }
      
      override protected function onAccept(param1:Event) : void
      {
         super.onAccept(param1);
         mOnClosedFunction = this.onAcceptPerformOps;
      }
      
      private function onAcceptPerformOps() : void
      {
         var _loc1_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc1_ != null)
         {
            InstanceMng.getPopupMng().openLevelFailedPopup(_loc1_.getLevelDef());
         }
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         super.setupAcceptButton(TextManager.getText("TID_GEN_LEVEL_END"));
         mAcceptButton.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
   }
}

