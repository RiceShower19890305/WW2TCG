package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import flash.utils.setTimeout;
   import starling.events.Event;
   import starling.textures.Texture;
   
   public class PopupStandard extends Popup
   {
      
      protected var mAcceptButton:FSButton;
      
      protected var mCancelButton:FSButton;
      
      protected var mCloseButton:FSButton;
      
      protected var mCloseButtonActive:Boolean;
      
      protected var mInfoTextfield:FSTextfield;
      
      protected var mText:String;
      
      protected var mCornerIcon:FSImage;
      
      public function PopupStandard(param1:Boolean = true)
      {
         this.mCloseButtonActive = param1;
         super();
      }
      
      override protected function setResourcesToLoad() : void
      {
         if(mBGName == Constants.STD_POPUP_BG_NAME)
         {
            notifyAssetsLoaded();
         }
         else
         {
            super.setResourcesToLoad();
         }
      }
      
      override protected function createBackground(param1:String, param2:int = 1000) : void
      {
         super.createBackground(param1,param2);
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.setupAcceptButton(TextManager.getText("TID_GEN_BUTTON_OK"));
         this.setupCloseButton();
         if(this.mText != "")
         {
            this.setMainFieldText(this.mText);
         }
         this.createCornerImage();
      }
      
      protected function createCornerImage(param1:String = "") : void
      {
         if(this.mCornerIcon == null && param1 != "")
         {
            this.mCornerIcon = new FSImage(Root.assets.getTexture(param1));
            this.mCornerIcon.alignPivot();
            this.mCornerIcon.x += this.mCornerIcon.width / 4;
            this.mCornerIcon.y += this.mCornerIcon.height / 4;
            addChild(this.mCornerIcon);
         }
      }
      
      protected function createFields() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Number = mBox.width * 0.8;
         var _loc2_:Number = this.mAcceptButton ? mBox.height - this.mAcceptButton.height * 1.3 : mBox.height / 2;
         if(this.mInfoTextfield == null)
         {
            _loc3_ = Utils.isDesktop() ? FSResourceMng.FONT_STD_SEMI_SMALL_SIZE : FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mInfoTextfield = new FSTextfield(_loc1_,_loc2_,"",16777215,_loc3_);
            this.mInfoTextfield.x = (mBox.width - this.mInfoTextfield.width) / 2;
            this.mInfoTextfield.y = mBox.height * 0.085;
            addChild(this.mInfoTextfield);
         }
      }
      
      public function setMainFieldText(param1:String = "") : void
      {
         this.mText = param1;
         if(this.mInfoTextfield == null && mFullyLoaded && param1 != "" && param1 != null && this.mAcceptButton != null)
         {
            this.createFields();
         }
         if(this.mInfoTextfield != null)
         {
            this.mInfoTextfield.text = this.mText;
         }
      }
      
      override protected function addButtonsEventListeners() : void
      {
         if(this.mAcceptButton != null)
         {
            this.mAcceptButton.addEventListener(Event.TRIGGERED,this.onAccept);
         }
         if(this.mCloseButton != null)
         {
            this.mCloseButton.addEventListener(Event.TRIGGERED,this.onClose);
         }
         if(this.mCancelButton != null)
         {
            this.mCancelButton.addEventListener(Event.TRIGGERED,this.onClose);
         }
      }
      
      override protected function removeButtonsEventListeners() : void
      {
         if(this.mAcceptButton != null)
         {
            this.mAcceptButton.removeEventListener(Event.TRIGGERED,this.onAccept);
         }
         if(this.mCloseButton != null)
         {
            this.mCloseButton.removeEventListener(Event.TRIGGERED,this.onClose);
         }
         if(this.mCancelButton != null)
         {
            this.mCancelButton.removeEventListener(Event.TRIGGERED,this.onClose);
         }
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         if(!mClosed)
         {
            if(this.mCloseButtonActive)
            {
               if(this.mCloseButton)
               {
                  addChild(this.mCloseButton);
               }
            }
         }
      }
      
      protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         var _loc4_:Texture = null;
         var _loc5_:Texture = null;
         var _loc6_:int = 0;
         if(this.mAcceptButton == null)
         {
            if(param2 == "")
            {
               param2 = Constants.ACCEPT_BUTTON_UP_NAME;
            }
            if(param3 == "")
            {
               param3 = param2;
            }
            param1 = param1 != null ? param1 : "";
            _loc4_ = Root.assets.getTexture(param2) == null ? Root.assets.getTexture(Constants.ACCEPT_BUTTON_UP_NAME) : Root.assets.getTexture(param2);
            _loc5_ = Root.assets.getTexture(param3) == null ? Root.assets.getTexture(Constants.ACCEPT_BUTTON_DOWN_NAME) : Root.assets.getTexture(param3);
            this.mAcceptButton = new FSButton(_loc4_,param1,_loc5_);
            Utils.handleButton9Scale(this.mAcceptButton,param2);
            this.mAcceptButton.name = "accept_button";
            this.mAcceptButton.x = mBox.width / 2;
            this.mAcceptButton.y = mBox.height - this.mAcceptButton.height / 2;
            _loc6_ = Utils.isDesktop() ? FSResourceMng.FONT_STD_SUBTITLE_SIZE : FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mAcceptButton.fontName = FSResourceMng.getFontByType(Config.getConfig().gameGetConfirmationPopupFontName());
            this.mAcceptButton.fontSize = _loc6_;
            this.mAcceptButton.fontColor = 16777215;
            addChild(this.mAcceptButton);
         }
      }
      
      protected function setupCancelButton(param1:String, param2:String = "", param3:String = "") : void
      {
         var _loc4_:Texture = null;
         if(this.mCancelButton == null)
         {
            if(param2 == "")
            {
               param2 = Constants.CANCEL_BUTTON_RED_NAME;
            }
            if(param3 == "")
            {
               param3 = Constants.CANCEL_BUTTON_RED_NAME;
            }
            param1 = param1 != null ? param1 : "";
            if(Root.assets.getTexture(Constants.CANCEL_BUTTON_RED_NAME) != null)
            {
               this.mCancelButton = new FSButton(Root.assets.getTexture(Constants.CANCEL_BUTTON_RED_NAME),param1,Root.assets.getTexture(Constants.CANCEL_BUTTON_RED_NAME));
               Utils.setupButton9Scale(this.mCancelButton,7.5,15,10,5,88.5,31.75);
            }
            else
            {
               this.mCancelButton = new FSButton(Root.assets.getTexture(Constants.ACCEPT_BUTTON_UP_NAME),param1,Root.assets.getTexture(Constants.ACCEPT_BUTTON_DOWN_NAME));
               this.mCancelButton.color = 16711680;
            }
            this.mCancelButton.x = mBox.width * 0.7;
            this.mCancelButton.y = mBox.height - this.mCancelButton.height / 2;
            if(this.mAcceptButton)
            {
               this.mAcceptButton.x = mBox.width * 0.3;
               _loc4_ = Root.assets.getTexture(Constants.ACCEPT_GREEN_BUTTON_UP_NAME);
               this.mAcceptButton.upState = _loc4_;
               this.mAcceptButton.downState = _loc4_;
               this.mAcceptButton.disabledState = _loc4_;
               this.mAcceptButton.overState = _loc4_;
               Utils.setupButton9Scale(this.mAcceptButton,7.5,15,10,5,85.5,31.75);
               this.mAcceptButton.y = mBox.height - this.mAcceptButton.height / 2;
            }
            this.mCancelButton.fontName = FSResourceMng.getFontByType(Config.getConfig().gameGetConfirmationPopupFontName());
            this.mCancelButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mCancelButton.fontColor = 16777215;
            addChild(this.mCancelButton);
         }
      }
      
      protected function onAccept(param1:Event) : void
      {
         if(param1)
         {
            param1.stopImmediatePropagation();
         }
         closePopup();
      }
      
      protected function setupCloseButton() : void
      {
         if(this.mCloseButtonActive && this.mCloseButton == null)
         {
            this.mCloseButton = new FSButton(Root.assets.getTexture(Constants.CLOSE_BUTTON_UP_NAME),"",Root.assets.getTexture(Constants.CLOSE_BUTTON_DOWN_NAME));
         }
         if(this.mCloseButton)
         {
            this.mCloseButton.x = mBox.width - this.mCloseButton.width / 2;
            this.mCloseButton.y = this.mCloseButton.height / 2;
            addChild(this.mCloseButton);
         }
      }
      
      public function onClose(param1:Event) : void
      {
         if(param1)
         {
            param1.stopImmediatePropagation();
         }
         closePopup();
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mAcceptButton)
         {
            this.mAcceptButton.removeFromParent(true);
            this.mAcceptButton = null;
         }
         if(this.mCloseButton)
         {
            this.mCloseButton.removeFromParent(true);
            this.mCloseButton = null;
         }
         if(this.mCancelButton)
         {
            this.mCancelButton.removeFromParent(true);
            this.mCancelButton = null;
         }
         if(this.mInfoTextfield)
         {
            this.mInfoTextfield.removeFromParent(true);
            this.mInfoTextfield = null;
         }
         if(this.mCornerIcon)
         {
            this.mCornerIcon.removeFromParent();
            this.mCornerIcon.destroy();
            this.mCornerIcon = null;
         }
         this.mText = "";
         InstanceMng.getPopupMng().removePopup(FSPopupMng.STANDARD_POPUP_NAME);
         super.removeFromStage();
      }
      
      public function enableCloseButton(param1:Boolean) : void
      {
         if(Boolean(this.mCloseButton) && this.mCloseButtonActive)
         {
            this.mCloseButton.enabled = param1;
         }
      }
      
      public function disableAcceptButtonTemporarily(param1:int = 2) : void
      {
         if(this.mAcceptButton)
         {
            this.enableAcceptButton(false);
            setTimeout(this.enableAcceptButton,param1 * 1000,true);
            Utils.setLogText(TextManager.getText("TID_GEN_WAIT") + " (" + param1 + " " + TextManager.getText("TID_GEN_TIME_SECONDS_ABR") + ")");
         }
      }
      
      public function enableAcceptButton(param1:Boolean) : void
      {
         if(this.mAcceptButton)
         {
            this.mAcceptButton.enabled = param1;
         }
      }
      
      override public function hasCloseButton() : Boolean
      {
         return this.mCloseButton != null;
      }
      
      override public function hasAcceptButton() : Boolean
      {
         return this.mAcceptButton != null;
      }
      
      override public function hasCancelButton() : Boolean
      {
         return this.mCancelButton != null;
      }
   }
}

