package com.fs.tcgengine.view.socket
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.utils.deg2rad;
   
   public class AttachmentSocket extends FSCardSocket implements FSModelUnloadableInterface
   {
      
      private var mEmptyTextfield:FSTextfield;
      
      public function AttachmentSocket()
      {
         super();
      }
      
      override protected function createBG() : void
      {
         mBGImage = new FSImage(Root.assets.getTexture(Constants.SOCKET_CARD_ATTACHMENTS));
         this.createEmptyTextfield();
         SpecialFX.tweenToColor(mBGImage,0,8421504,0);
      }
      
      private function createEmptyTextfield() : void
      {
         if(this.mEmptyTextfield == null)
         {
            this.mEmptyTextfield = new FSTextfield(mBGImage.height / 1.5,mBGImage.height / 4,"",16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
            this.mEmptyTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
            this.mEmptyTextfield.touchable = false;
            this.mEmptyTextfield.rotation = deg2rad(-45);
            this.mEmptyTextfield.x = 10;
            this.mEmptyTextfield.y = mBGImage.height / 1.5;
         }
         this.mEmptyTextfield.text = TextManager.getText("TID_GEN_EMPTY");
         addChild(this.mEmptyTextfield);
      }
      
      override protected function setupScale() : void
      {
         mScaleFactor = 1;
      }
      
      override public function dispose() : void
      {
         if(this.mEmptyTextfield)
         {
            this.mEmptyTextfield.removeFromParent(true);
            this.mEmptyTextfield = null;
         }
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mEmptyTextfield)
         {
            this.mEmptyTextfield.removeFromParent();
            this.mEmptyTextfield = null;
         }
      }
   }
}

