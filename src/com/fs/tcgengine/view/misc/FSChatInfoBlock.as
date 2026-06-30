package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import starling.display.Quad;
   import starling.text.TextFieldAutoSize;
   import starling.utils.Align;
   
   public class FSChatInfoBlock extends Component
   {
      
      protected var mText:FSTextfield;
      
      protected var mSeparator:Quad;
      
      protected var mMaxWidth:int;
      
      private var mFontName:String;
      
      public function FSChatInfoBlock(param1:int, param2:String, param3:String)
      {
         super();
         this.mMaxWidth = param1;
         this.mFontName = param3;
         this.createUI(param2);
      }
      
      protected function createUI(param1:String) : void
      {
         this.createText(param1);
         this.createSeparator();
      }
      
      protected function createText(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this.mText == null)
         {
            _loc2_ = FSResourceMng.isOriental(param1) ? 100 : 1;
            _loc2_ /= Utils.isAndroidOrDesktop() ? Main.smScaleFactor : 1;
            this.mText = new FSTextfield(this.mMaxWidth,_loc2_,param1);
            this.mText.x = 0;
            this.mText.y = 0;
            this.mText.fontName = this.mFontName;
            this.mText.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
            this.mText.format.horizontalAlign = Align.LEFT;
            this.mText.format.verticalAlign = Align.TOP;
            this.mText.autoSize = FSResourceMng.isOriental(param1) ? TextFieldAutoSize.NONE : TextFieldAutoSize.VERTICAL;
            addChild(this.mText);
         }
      }
      
      private function createSeparator() : void
      {
         if(this.mSeparator == null)
         {
            this.mSeparator = new Quad(this.mText.width,1,Config.getConfig().getGuildSeparatorColor());
            this.mSeparator.x = this.mText.x;
            this.mSeparator.y = this.mText.y + this.mText.height * 1.05;
            addChild(this.mSeparator);
         }
      }
      
      public function changeTextColor(param1:uint) : void
      {
         if(this.mText)
         {
            this.mText.format.color = param1;
         }
      }
      
      override public function dispose() : void
      {
         if(this.mText)
         {
            this.mText.removeFromParent(true);
            this.mText = null;
         }
         if(this.mSeparator)
         {
            this.mSeparator.removeFromParent(true);
            this.mSeparator = null;
         }
         super.dispose();
      }
   }
}

