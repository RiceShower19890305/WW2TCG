package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import feathers.controls.ScrollText;
   import feathers.layout.HorizontalAlign;
   import starling.text.TextFormat;
   
   public class PopupReleaseNotes extends PopupStandard
   {
      
      public static const BG_NAME:String = "daily_popup";
      
      private var mReleaseNotes:String;
      
      private var mScrollText:ScrollText;
      
      public function PopupReleaseNotes(param1:Boolean = true)
      {
         super(param1);
      }
      
      public function setup(param1:String) : void
      {
         this.mReleaseNotes = param1 != null ? param1 : "";
         setMainFieldText(this.mReleaseNotes);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = BG_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,1882);
      }
      
      override protected function addBGToLoad() : void
      {
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mScrollText)
         {
            this.mScrollText.removeFromParent(true);
            this.mScrollText = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.RELEASE_NOTES_POPUP_NAME);
         super.removeFromStage();
      }
      
      override protected function createUI() : void
      {
         setMainFieldText(this.mReleaseNotes);
         super.createUI();
      }
      
      override protected function createFields() : void
      {
         var _loc1_:Number = mBox.width * 0.8;
         var _loc2_:Number = mAcceptButton ? mBox.height - mAcceptButton.height * 1.75 : mBox.height / 2;
         if(this.mScrollText == null)
         {
            this.mScrollText = new ScrollText();
            this.mScrollText.setSize(_loc1_,_loc2_);
            this.mScrollText.text = this.mReleaseNotes;
            this.mScrollText.embedFonts = true;
            this.mScrollText.fontStyles = new TextFormat();
            this.mScrollText.fontStyles.font = Main.getGameFont().fontName;
            this.mScrollText.fontStyles.size = Utils.isDesktop() || Utils.isBrowser() ? FSResourceMng.FONT_STD_SMALL_SIZE : FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mScrollText.fontStyles.color = 16777215;
            this.mScrollText.fontStyles.horizontalAlign = HorizontalAlign.LEFT;
            this.mScrollText.x = (mBox.width - this.mScrollText.width) / 2;
            this.mScrollText.y = mBox.height * 0.085;
            addChild(this.mScrollText);
         }
      }
   }
}

