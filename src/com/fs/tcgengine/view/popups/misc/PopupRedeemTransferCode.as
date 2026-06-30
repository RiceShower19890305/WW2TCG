package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMenuScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSTextInput;
   import starling.events.Event;
   
   public class PopupRedeemTransferCode extends PopupConfirmation
   {
      
      public static const BG_NAME:String = "daily_popup";
      
      private var mRedeemCodeTextInput:FSTextInput;
      
      public function PopupRedeemTransferCode(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = BG_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,2000);
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         setMainFieldText(TextManager.getText("TID_MIGRATION_STEAM",true) + "\n\n" + TextManager.getText("TID_MIGRATION_INFO",true));
         this.createTextInput();
      }
      
      override protected function createFields() : void
      {
         super.createFields();
         if(mInfoTextfield)
         {
            mInfoTextfield.height = mBox.height / 1.7;
            mInfoTextfield.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         this.onAcceptFunction();
      }
      
      private function onAcceptFunction() : void
      {
         var _loc1_:int = 13;
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
            this.prepareMigrationProcess(_loc2_);
         }
         else
         {
            Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_CODE_ERROR_DIGITS"),[_loc1_]));
         }
      }
      
      private function prepareMigrationProcess(param1:String) : void
      {
         var _loc3_:UserData = null;
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         if(_loc2_ != null && _loc2_.isFullyLoaded())
         {
            if(_loc2_ is FSMenuScreen)
            {
               _loc3_ = Utils.getOwnerUserData();
               if(_loc3_ != null)
               {
                  if(!_loc3_.isInBlackList())
                  {
                     if(!_loc3_.isInDuplicatedList())
                     {
                        if(InstanceMng.getServerConnection().isUserLoggedIn())
                        {
                           this.migrateLogicProgress(param1);
                        }
                        else
                        {
                           Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
                        }
                     }
                     else
                     {
                        InstanceMng.getPopupMng().openConfirmationPopup("Error: " + TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"));
                        if(mCloseButton)
                        {
                           mCloseButton.setEnabled(true);
                        }
                        if(mAcceptButton)
                        {
                           mAcceptButton.setEnabled(true);
                        }
                     }
                  }
                  else
                  {
                     InstanceMng.getPopupMng().openConfirmationPopup("Error: " + TextManager.getText("TID_GEN_FRAUD_PURCHASE"));
                     if(mCloseButton)
                     {
                        mCloseButton.setEnabled(true);
                     }
                     if(mAcceptButton)
                     {
                        mAcceptButton.setEnabled(true);
                     }
                  }
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_RESET_MAIN_MENU"),true,false,false);
               if(mCloseButton)
               {
                  mCloseButton.setEnabled(true);
               }
               if(mAcceptButton)
               {
                  mAcceptButton.setEnabled(true);
               }
            }
         }
      }
      
      private function migrateLogicProgress(param1:String) : void
      {
         Utils.setLogText(TextManager.getText("TID_MIGRATION_STEAM_START",true),false,false,false);
         InstanceMng.getApplication().steamResetAllStats(true);
         FSTracker.trackMiscAction(FSTracker.CATEGORY_USER,FSTracker.ACTION_MIGRATION);
         this.migratePlayerOnServer(param1);
      }
      
      private function migratePlayerOnServer(param1:String) : void
      {
         InstanceMng.getServerConnection().performPlayerMigrationOnServer(param1,this.onMigrateSuccess,this.onMigrateFailed);
      }
      
      private function onMigrateSuccess() : void
      {
         closePopup();
         Utils.setLogText(TextManager.getText("TID_MIGRATION_STEAM_COMPLETE"),true);
      }
      
      private function onMigrateFailed() : void
      {
         if(mCloseButton)
         {
            mCloseButton.setEnabled(true);
         }
         if(mAcceptButton)
         {
            mAcceptButton.setEnabled(true);
         }
      }
      
      private function createTextInput() : void
      {
         if(Boolean(this.mRedeemCodeTextInput == null) && Boolean(mBox) && Boolean(mInfoTextfield))
         {
            this.mRedeemCodeTextInput = new FSTextInput();
            this.mRedeemCodeTextInput.restrict = "A-Za-z0-9\\-";
            this.mRedeemCodeTextInput.setSize(mBox.width / 3,mBox.height / 9);
            this.mRedeemCodeTextInput.maxChars = 13;
            this.mRedeemCodeTextInput.x = (mBox.width - this.mRedeemCodeTextInput.width) / 2;
            this.mRedeemCodeTextInput.y = mInfoTextfield.y + mInfoTextfield.height + 10;
            addChild(this.mRedeemCodeTextInput);
         }
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         super.setupAcceptButton(TextManager.getText("TID_MIGRATION_TRANSFER",true),"button_blue_large","button_blue_large");
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
         InstanceMng.getPopupMng().removePopup(FSPopupMng.REDEEM_TRANSFER_CODE_POPUP_NAME);
         super.removeFromStage();
      }
   }
}

