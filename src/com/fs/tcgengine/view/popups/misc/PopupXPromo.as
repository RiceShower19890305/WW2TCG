package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.view.misc.FSImage;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import starling.events.Event;
   
   public class PopupXPromo extends PopupStandard
   {
      
      public static const BG_NAME:String = "daily_popup";
      
      private var mXPromoImg:FSImage;
      
      public function PopupXPromo(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = BG_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         this.createXPromoImage();
         var _loc3_:int = 1280 * 1.05;
         super.createBackground(param1,_loc3_);
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         var _loc4_:String = TextManager.getText("TID_GEN_DOWNLOAD");
         super.setupAcceptButton(_loc4_,Constants.ACCEPT_BUTTON_XL_UP_NAME,Constants.ACCEPT_BUTTON_XL_DOWN_NAME);
         if(mAcceptButton)
         {
            mAcceptButton.y += mAcceptButton.height / 2;
            mAcceptButton.fontName = FSResourceMng.getFontByType();
            mAcceptButton.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
            addChild(mAcceptButton);
         }
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.setupXPromoImage();
      }
      
      private function getXPromoImageName() : String
      {
         var _loc1_:String = Main.smCrossPromotionInfo != "" && Main.smCrossPromotionInfo != null && Main.smCrossPromotionInfo.split(",") != null ? Main.smCrossPromotionInfo.split(",")[0] : "";
         return _loc1_ != "" ? "xpromo_" + _loc1_ : "";
      }
      
      private function createXPromoImage() : void
      {
         var _loc1_:String = this.getXPromoImageName();
         if(this.mXPromoImg == null && _loc1_ != "")
         {
            this.mXPromoImg = new FSImage(Root.assets.getTexture(_loc1_));
         }
      }
      
      private function setupXPromoImage() : void
      {
         if(this.mXPromoImg)
         {
            this.mXPromoImg.x = (mBox.width - this.mXPromoImg.width) / 2;
            this.mXPromoImg.y = (mBox.height - this.mXPromoImg.height) / 2;
            addChild(this.mXPromoImg);
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         this.onXPromoButtonTriggered();
         super.onAccept(param1);
      }
      
      private function onXPromoButtonTriggered() : void
      {
         var _loc1_:String = null;
         var _loc2_:URLRequest = null;
         if(Main.smCrossPromotionInfo != null)
         {
            _loc1_ = Main.smCrossPromotionInfo.split(",")[1];
            if(_loc1_)
            {
               FSTracker.trackFirebaseEvent("XPROMO_GO_TO_STORE");
               _loc2_ = new URLRequest(_loc1_);
               navigateToURL(_loc2_);
            }
         }
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mXPromoImg)
         {
            this.mXPromoImg.removeFromParent();
            this.mXPromoImg = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.X_PROMO_POPUP_NAME);
         super.removeFromStage();
      }
   }
}

