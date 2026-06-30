package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.text.TextFieldAutoSize;
   import starling.utils.Align;
   
   public class FSTick extends Component
   {
      
      public static const TICK_IMAGE_ON_NAME:String = "checkbox_on";
      
      public static const TICK_IMAGE_OFF_NAME:String = "checkbox_off";
      
      protected var mTickImage:FSImage;
      
      protected var mLabelTextfield:FSTextfield;
      
      private var mChecked:Boolean;
      
      protected var mIsInfo:Boolean = false;
      
      protected var mTouchable:Boolean = false;
      
      protected var mHasSimpleUI:Boolean;
      
      public function FSTick(param1:String, param2:Boolean, param3:Boolean = false, param4:Boolean = false)
      {
         super();
         this.mHasSimpleUI = Config.getConfig().battleHasSimpleUI();
         this.mTouchable = param2;
         this.mIsInfo = param4;
         this.createBG();
         this.createTickImage(param3);
         this.createLabel(param1);
         this.setChecked(param3);
         this.addEventListeners();
      }
      
      protected function createBG() : void
      {
      }
      
      protected function createTickImage(param1:Boolean) : void
      {
         var _loc2_:String = null;
         if(this.mTickImage == null)
         {
            _loc2_ = param1 ? TICK_IMAGE_ON_NAME : TICK_IMAGE_OFF_NAME;
            this.mTickImage = new FSImage(Root.assets.getTexture(_loc2_));
         }
         addChild(this.mTickImage);
      }
      
      protected function createLabel(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mLabelTextfield == null)
         {
            _loc3_ = this.mTickImage ? int(this.mTickImage.height * 1.5) : FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mLabelTextfield = new FSTextfield(1,_loc3_,param1,16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mLabelTextfield.wordWrap = false;
            this.mLabelTextfield.autoSize = FSResourceMng.isOriental() ? TextFieldAutoSize.NONE : TextFieldAutoSize.HORIZONTAL;
            this.mLabelTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mLabelTextfield.format.horizontalAlign = Align.LEFT;
            this.mLabelTextfield.format.verticalAlign = Align.CENTER;
         }
         if(this.mTickImage)
         {
            _loc2_ = this.mIsInfo ? int(this.mTickImage.width * 18) : int(this.mTickImage.width * 10);
         }
         else
         {
            _loc2_ = this.mIsInfo ? int(Main.smScaleFactor * 30 * 18) : int(Main.smScaleFactor * 30 * 10);
            if(FSResourceMng.isOriental())
            {
               _loc2_ = 300;
            }
         }
         this.mLabelTextfield.width = _loc2_;
         this.mLabelTextfield.x = this.mTickImage ? this.mTickImage.x + this.mTickImage.width + 2 : 0;
         this.mLabelTextfield.y = this.mTickImage ? this.mTickImage.y - (this.mLabelTextfield.height - this.mTickImage.height) / 2 : 0;
         addChild(this.mLabelTextfield);
      }
      
      public function changeLabelFontName(param1:String, param2:uint = 16777215) : void
      {
         if(this.mLabelTextfield)
         {
            this.mLabelTextfield.fontName = param1;
            this.mLabelTextfield.color = param2;
         }
      }
      
      public function setText(param1:String) : void
      {
         if(this.mLabelTextfield != null)
         {
            this.mLabelTextfield.text = param1.toUpperCase();
         }
      }
      
      public function setChecked(param1:Boolean, param2:Boolean = true) : void
      {
         var _loc3_:String = null;
         if(!this.mIsInfo)
         {
            this.mChecked = param1;
            if(this.mTickImage != null)
            {
               _loc3_ = this.mChecked ? TICK_IMAGE_ON_NAME : TICK_IMAGE_OFF_NAME;
               this.mTickImage.texture = Root.assets.getTexture(_loc3_);
            }
         }
      }
      
      public function addEventListeners() : void
      {
         if(this.mTouchable)
         {
            addEventListener(TouchEvent.TOUCH,this.onTouch);
         }
      }
      
      protected function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            this.setChecked(!this.mChecked);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mTickImage)
         {
            this.mTickImage.removeFromParent(true);
            this.mTickImage = null;
         }
         if(this.mLabelTextfield)
         {
            this.mLabelTextfield.removeFromParent(true);
            this.mLabelTextfield = null;
         }
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
   }
}

