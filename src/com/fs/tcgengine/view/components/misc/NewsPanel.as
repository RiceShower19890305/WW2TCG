package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.components.Component;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.text.TextFieldAutoSize;
   import starling.utils.Align;
   
   public class NewsPanel extends Component
   {
      
      private const TYPE_STD:int = 0;
      
      private const TYPE_WARNING:int = 1;
      
      private const TYPE_ALERT:int = 2;
      
      private const TYPE_FIX:int = 3;
      
      private var mTitle:String;
      
      private var mText:String;
      
      private var mType:int;
      
      private var mURL:String;
      
      protected var mQuad:Quad;
      
      private var mTitleTextfield:FSTextfield;
      
      private var mTextTextfield:FSTextfield;
      
      public function NewsPanel(param1:String, param2:String, param3:int, param4:String = "")
      {
         super();
         this.mTitle = param1;
         this.mText = param2;
         this.mType = param3;
         this.mURL = param4;
         this.createUI();
      }
      
      private function createUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.mQuad == null)
         {
            _loc1_ = InstanceMng.getApplication().getDefaultStageWidth();
            _loc2_ = InstanceMng.getApplication().getDefaultStageHeight();
            this.mQuad = new Quad(_loc1_ / 3,_loc2_ / 2,0);
            this.mQuad.touchable = true;
            this.mQuad.alpha = 0.85;
            this.mQuad.setVertexAlpha(0,0);
            this.mQuad.setVertexAlpha(1,0);
            this.mQuad.setVertexAlpha(3,0);
            addChild(this.mQuad);
         }
         this.createTitle();
         this.createText();
         if(this.mURL != "" && this.mURL != null)
         {
            touchable = true;
            addEventListener(TouchEvent.TOUCH,this.onTouch);
            this.mQuad.useHandCursor = true;
         }
         else
         {
            touchable = false;
            removeEventListener(TouchEvent.TOUCH,this.onTouch);
            this.mQuad.useHandCursor = false;
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:URLRequest = null;
         if(param1.getTouch(this,TouchPhase.ENDED) != null)
         {
            _loc2_ = new URLRequest(this.mURL);
            navigateToURL(_loc2_);
         }
      }
      
      private function createTitle() : void
      {
         var _loc1_:uint = 0;
         if(this.mTitleTextfield == null)
         {
            switch(this.mType)
            {
               case 0:
                  _loc1_ = 255;
                  break;
               case 1:
                  _loc1_ = 16776960;
                  break;
               case 2:
                  _loc1_ = 16711680;
                  break;
               case 3:
                  _loc1_ = 65280;
            }
            this.mTitleTextfield = new FSTextfield(this.mQuad.width * 0.9,this.mQuad.height / 7,this.mTitle,_loc1_,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mTitleTextfield.touchable = true;
            this.mTitleTextfield.format.horizontalAlign = Align.LEFT;
            this.mTitleTextfield.x = (this.mQuad.width - this.mTitleTextfield.width) / 2;
            addChild(this.mTitleTextfield);
         }
      }
      
      private function createText() : void
      {
         var _loc1_:int = 0;
         if(this.mTextTextfield == null)
         {
            _loc1_ = FSResourceMng.isOriental() ? int(InstanceMng.getApplication().getDefaultStageHeight() / 3) : 1;
            this.mTextTextfield = new FSTextfield(this.mQuad.width * 0.9,_loc1_,this.mText,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mTextTextfield.touchable = true;
            this.mTextTextfield.x = (this.mQuad.width - this.mTextTextfield.width) / 2;
            this.mTextTextfield.y = this.mTitleTextfield.y + this.mTitleTextfield.height;
            this.mTextTextfield.autoSize = FSResourceMng.isOriental() ? TextFieldAutoSize.NONE : TextFieldAutoSize.VERTICAL;
            this.mTextTextfield.format.horizontalAlign = Align.LEFT;
            this.mTextTextfield.format.verticalAlign = Align.TOP;
            this.mQuad.height = this.mTitleTextfield.height + this.mTextTextfield.height * 1.15 < Starling.current.stage.stageHeight * 0.75 ? this.mTitleTextfield.height + this.mTextTextfield.height * 1.15 : Starling.current.stage.stageHeight * 0.75;
            addChild(this.mTextTextfield);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mQuad)
         {
            this.mQuad.removeFromParent(true);
            this.mQuad = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mTextTextfield)
         {
            this.mTextTextfield.removeFromParent(true);
            this.mTextTextfield = null;
         }
         super.dispose();
      }
   }
}

