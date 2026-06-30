package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Event;
   
   public class PopupSettingsConfirmation extends PopupStandard
   {
      
      public static const ACCEPT_BUTTON_NAME:String = "settings_confirmation_button";
      
      private const BG_NAME:String = "settings_popup";
      
      private var mWarningTextfield:FSTextfield;
      
      private var mWarningMessage:String;
      
      private var mIconImage:FSImage;
      
      private var mTextureName:String;
      
      private var mOnClickFunction:Function;
      
      public function PopupSettingsConfirmation(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mWarningTextfield)
         {
            this.mWarningTextfield.removeFromParent(true);
            this.mWarningTextfield = null;
         }
         if(this.mIconImage)
         {
            this.mIconImage.removeFromParent(true);
            this.mIconImage = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.SETTINGS_CONFIRMATION_POPUP_NAME);
         super.removeFromStage();
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = this.BG_NAME;
      }
      
      public function setup(param1:String, param2:String, param3:String, param4:String, param5:Function) : void
      {
         setMainFieldText(param1);
         mInfoTextfield.height = mBox.height * 0.1;
         mInfoTextfield.y = mBox.height * 0.65;
         this.mTextureName = param2;
         this.mWarningMessage = param3;
         mAcceptButton.text = param4;
         mAcceptButton.upState = Root.assets.getTexture(ACCEPT_BUTTON_NAME);
         mAcceptButton.downState = Root.assets.getTexture(ACCEPT_BUTTON_NAME);
         mAcceptButton.y = mBox.height;
         mAcceptButton.fontColor = 16777215;
         mAcceptButton.fontName = FSResourceMng.getFontByType();
         this.mOnClickFunction = param5;
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.createImage();
         this.createWarningMessage();
      }
      
      private function createImage() : void
      {
         if(this.mIconImage == null)
         {
            this.mIconImage = new FSImage(Root.assets.getTexture(this.mTextureName));
            this.mIconImage.x = mBox.width / 2 - this.mIconImage.width / 2;
            this.mIconImage.y = mBox.height * 0.15;
            addChild(this.mIconImage);
         }
      }
      
      private function createWarningMessage() : void
      {
         if(this.mWarningTextfield == null)
         {
            this.mWarningTextfield = new FSTextfield(mBox.width,mBox.height * 0.1,this.mWarningMessage,16711680);
            this.mWarningTextfield.y = mInfoTextfield.y + mInfoTextfield.height;
            addChild(this.mWarningTextfield);
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         closePopup(this.mOnClickFunction);
      }
   }
}

