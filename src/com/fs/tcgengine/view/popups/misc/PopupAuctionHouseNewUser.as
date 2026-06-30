package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.screens.FSAuctionsScreen;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Event;
   
   public class PopupAuctionHouseNewUser extends PopupStandard
   {
      
      private const TOKEN_IMAGE_NAME:String = "auction_token_large";
      
      private var mImage:FSImage;
      
      private var mTitle:FSTextfield;
      
      private var mTextInformative:FSTextfield;
      
      public function PopupAuctionHouseNewUser(param1:Boolean = true)
      {
         super(false);
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
         this.init();
      }
      
      private function init() : void
      {
         this.createImage();
         this.createTitle();
         this.createText();
      }
      
      private function createText() : void
      {
         if(Boolean(this.mTextInformative == null && this.mTitle) && Boolean(mBox) && Boolean(this.mImage))
         {
            this.mTextInformative = new FSTextfield(mBox.width * 0.8,mBox.height * 0.8 - this.mTitle.height - this.mImage.height,TextManager.getText("TID_AUCTIONS_TUTORIAL_DESC"));
            this.mTextInformative.x = mBox.width / 2 - this.mTextInformative.width / 2;
            this.mTextInformative.y = this.mTitle.y + this.mTitle.height;
            addChild(this.mTextInformative);
         }
      }
      
      private function createTitle() : void
      {
         if(Boolean(this.mTitle == null) && Boolean(this.mImage) && Boolean(mBox))
         {
            this.mTitle = new FSTextfield(mBox.width * 0.75,mBox.height / 6,TextManager.getText("TID_AUCTIONS_TUTORIAL_NAME"));
            this.mTitle.x = mBox.width / 2 - this.mTitle.width / 2;
            this.mTitle.y = this.mImage.y + this.mImage.height;
            addChild(this.mTitle);
         }
      }
      
      private function createImage() : void
      {
         if(this.mImage == null && Boolean(mBox))
         {
            this.mImage = new FSImage(Root.assets.getTexture(this.TOKEN_IMAGE_NAME));
            this.mImage.x = mBox.width / 2 - this.mImage.width / 2;
            this.mImage.y = this.mImage.height * 0.1;
            addChild(this.mImage);
         }
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mImage)
         {
            this.mImage.removeFromParent(true);
            this.mImage = null;
         }
         if(this.mTitle)
         {
            this.mTitle.removeFromParent(true);
            this.mTitle = null;
         }
         if(this.mTextInformative)
         {
            this.mTextInformative.removeFromParent(true);
            this.mTextInformative = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.AUCTION_HOUSE_NEW_USER_POPUP_NAME);
         super.removeFromStage();
      }
      
      override protected function onAccept(param1:Event) : void
      {
         var _loc2_:FSAuctionsScreen = InstanceMng.getCurrentScreen() as FSAuctionsScreen;
         if(_loc2_)
         {
            _loc2_.addInitialTokensToTokenVisor();
         }
         super.onAccept(param1);
      }
   }
}

