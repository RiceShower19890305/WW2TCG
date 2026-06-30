package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.events.MouseEvent;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class PopupGetTransferCode extends PopupConfirmation
   {
      
      public static const BG_NAME:String = "daily_popup";
      
      private var mTransferCode:String = "";
      
      public function PopupGetTransferCode(param1:Boolean = true)
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
         this.generateText();
      }
      
      override protected function createFields() : void
      {
         super.createFields();
         if(mInfoTextfield)
         {
            mInfoTextfield.height = mBox.height * 0.75;
            mInfoTextfield.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         this.onAcceptFunction();
      }
      
      private function onAcceptFunction() : void
      {
         if(Utils.isBrowser())
         {
            return;
         }
         this.copyCode(null);
      }
      
      private function copyCode(param1:MouseEvent) : void
      {
         if(Utils.isBrowser())
         {
            Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP,this.copyCode);
         }
         if(this.mTransferCode != null && this.mTransferCode != "")
         {
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,this.mTransferCode);
            Utils.setLogText(TextManager.getText("TID_MIGRATION_ID_COPY_SUCCESS"));
            closePopup();
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GEN_SERVER_RETRY"));
         }
      }
      
      public function getTransferCode(param1:String = "") : void
      {
         var _loc2_:String = "";
         param1 = param1 == "" ? InstanceMng.getUserDataMng().getOwnerUserData().getTransferCode() : param1;
         if(param1 == null || param1 == "")
         {
            InstanceMng.getServerConnection().generateTransferCode(this.getTransferCode);
            return;
         }
         this.mTransferCode = param1;
         this.generateText();
      }
      
      private function generateText() : void
      {
         var _loc1_:String = null;
         if(this.mTransferCode == "" || this.mTransferCode == null)
         {
            this.getTransferCode();
         }
         else
         {
            _loc1_ = TextManager.getText("TID_MIGRATION_WEB",true) + "\n\n" + TextManager.getText("TID_MIGRATION_INFO",true) + "\n\n" + TextManager.getText("TID_MIGRATION_ID",true) + " " + this.mTransferCode;
            setMainFieldText(_loc1_);
         }
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         super.setupAcceptButton(TextManager.getText("TID_MIGRATION_ID_COPY"),"button_blue_large","button_blue_large");
         if(mAcceptButton)
         {
            if(Utils.isBrowser())
            {
               mAcceptButton.addEventListener(TouchEvent.TOUCH,this.onRedeemCodeTouched);
            }
            mAcceptButton.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
         }
      }
      
      private function onRedeemCodeTouched(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(mAcceptButton) : null;
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.phase == TouchPhase.BEGAN)
         {
            Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP,this.copyCode);
         }
      }
      
      override protected function removeFromStage() : void
      {
         InstanceMng.getPopupMng().removePopup(FSPopupMng.GET_TRANSFER_CODE_POPUP_NAME);
         super.removeFromStage();
      }
   }
}

