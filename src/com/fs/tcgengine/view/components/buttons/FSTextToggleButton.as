package com.fs.tcgengine.view.components.buttons
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   
   public class FSTextToggleButton extends FSCheckBox
   {
      
      private const BG_IMAGE_NAME:String = "checkall_button";
      
      private var mBGImage:FSImage;
      
      private var mTextfield:FSTextfield;
      
      private var mText:String;
      
      private var mUsesBG:Boolean = true;
      
      public function FSTextToggleButton(param1:String, param2:Boolean = true)
      {
         this.mText = param1;
         this.mUsesBG = param2;
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mBGImage == null && this.mUsesBG)
         {
            this.mBGImage = new FSImage(Root.assets.getTexture(this.BG_IMAGE_NAME));
            Utils.setupImage9Scale(this.mBGImage,7.5,5,1.25,1.25,100.5,31);
            addChild(this.mBGImage);
         }
         if(mCheckBoxImage == null)
         {
            mCheckBoxImage = new FSImage(Root.assets.getTexture(CHECKBOX_IMAGE_NAME));
            mCheckBoxImage.alignPivot();
            mCheckBoxImage.x = mCheckBoxImage.width / 2;
            mCheckBoxImage.y = this.mUsesBG ? this.mBGImage.height / 2 : mCheckBoxImage.height / 2;
            addChild(mCheckBoxImage);
         }
         if(mCheckBoxTickImage == null)
         {
            mCheckBoxTickImage = new FSImage(Root.assets.getTexture(CHECKBOX_TICK_IMAGE_NAME));
            mCheckBoxTickImage.alignPivot();
            mCheckBoxTickImage.x = mCheckBoxImage.x;
            mCheckBoxTickImage.y = mCheckBoxImage.y;
            mCheckBoxTickImage.visible = false;
            addChild(mCheckBoxTickImage);
         }
         if(this.mTextfield == null)
         {
            _loc1_ = this.mBGImage ? int(this.mBGImage.width - (mCheckBoxTickImage.x + mCheckBoxTickImage.width)) : 50;
            _loc2_ = this.mBGImage ? int(this.mBGImage.height * 0.85) : int(mCheckBoxTickImage.height);
            _loc3_ = FSResourceMng.isOriental() ? FSResourceMng.FONT_STD_XSMALL_SIZE : FSResourceMng.FONT_STD_DEFAULT_SIZE;
            this.mTextfield = new FSTextfield(_loc1_,_loc2_,this.mText,16777215,_loc3_);
            this.mTextfield.touchable = true;
            this.mTextfield.x = mCheckBoxTickImage.x + mCheckBoxTickImage.width / 2;
            this.mTextfield.y = this.mBGImage ? this.mBGImage.y + (this.mBGImage.height - this.mTextfield.height) / 2 : 0;
            addChild(this.mTextfield);
         }
         addEventListeners();
         updateState();
      }
      
      public function setTextfieldFontSize(param1:int) : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.fontSize = param1;
         }
      }
      
      public function setTextfieldWidth(param1:int) : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.width = param1;
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBGImage)
         {
            this.mBGImage.removeFromParent(true);
            this.mBGImage = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         super.dispose();
      }
   }
}

