package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSTextInput;
   import com.fs.tcgengine.view.popups.Popup;
   import starling.events.Event;
   
   public class PopupRedeemReferralCode extends PopupConfirmation
   {
      
      private var mRedeemCodeTextInput:FSTextInput;
      
      public function PopupRedeemReferralCode(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         setMainFieldText(TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_REDEEM_GOLD"),[Config.smReferralGoldPerRecruitment]));
         this.createTextInput();
      }
      
      override protected function createFields() : void
      {
         super.createFields();
         if(mInfoTextfield)
         {
            mInfoTextfield.height = mBox.height / 2.35;
            mInfoTextfield.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         this.onAcceptFunction();
      }
      
      private function onAcceptFunction() : void
      {
         Utils.setLogText(TextManager.getText("TID_RECRUIT_CODE_REDEEMING"),false,false,false);
         var _loc1_:int = 8;
         var _loc2_:String = this.mRedeemCodeTextInput ? this.mRedeemCodeTextInput.text : "";
         if(_loc2_.length == _loc1_)
         {
            if(mCloseButton)
            {
               mCloseButton.setEnabled(false);
            }
            if(mAcceptButton)
            {
               mAcceptButton.setEnabled(false);
            }
            InstanceMng.getServerConnection().redeemReferralCode(_loc2_,this.onCodeRedeemSuccessfully,this.onCodeRedeemFailed);
         }
         else
         {
            Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_CODE_ERROR_DIGITS"),[_loc1_]));
         }
      }
      
      private function onCodeRedeemFailed(param1:Object) : void
      {
         if(mCloseButton)
         {
            mCloseButton.setEnabled(true);
         }
         if(mAcceptButton)
         {
            mAcceptButton.setEnabled(true);
         }
         if(param1 != null && param1.hasOwnProperty("error"))
         {
            Utils.setLogText("Error: " + param1["error"]);
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_RECRUIT_CODE_ERROR"));
         }
      }
      
      private function onCodeRedeemSuccessfully() : void
      {
         Utils.setLogText(TextManager.getText("TID_RECRUIT_CODE_SUCCESS"));
         var _loc1_:Popup = InstanceMng.getPopupMng().getPopupInBackground();
         if(_loc1_ != null && _loc1_ is PopupReferral)
         {
            PopupReferral(_loc1_).onCodeRedeemedSuccessfully();
            if(InstanceMng.getCurrentScreen() is FSMapScreen)
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).checkRewardsToClaim();
            }
         }
         closePopup();
      }
      
      private function createTextInput() : void
      {
         if(Boolean(this.mRedeemCodeTextInput == null) && Boolean(mBox) && Boolean(mInfoTextfield))
         {
            this.mRedeemCodeTextInput = new FSTextInput();
            this.mRedeemCodeTextInput.restrict = "A-Z0-9";
            this.mRedeemCodeTextInput.setSize(mBox.width / 3,mBox.height / 5);
            this.mRedeemCodeTextInput.maxChars = 8;
            this.mRedeemCodeTextInput.x = (mBox.width - this.mRedeemCodeTextInput.width) / 2;
            this.mRedeemCodeTextInput.y = mInfoTextfield.y + mInfoTextfield.height;
            addChild(this.mRedeemCodeTextInput);
         }
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         super.setupAcceptButton(TextManager.getText("TID_RECRUIT_REDEEM"),"button_blue_large","button_blue_large");
         if(mAcceptButton)
         {
            mAcceptButton.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
         }
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mRedeemCodeTextInput)
         {
            this.mRedeemCodeTextInput.removeFromParent(true);
            this.mRedeemCodeTextInput = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.REDEEM_REFERRAL_CODE_POPUP_NAME);
         super.removeFromStage();
      }
   }
}

