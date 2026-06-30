package com.fs.tcgengine.view.board
{
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import starling.text.TextFieldAutoSize;
   
   public class CardDescInfoSubBlock extends Component
   {
      
      private var mTitleTextfield:FSTextfield;
      
      private var mBodyTextfield:FSTextfield;
      
      private var mTitle:String;
      
      private var mBody:String;
      
      private var mColor:uint;
      
      public function CardDescInfoSubBlock(param1:String, param2:String, param3:uint)
      {
         super();
         this.mTitle = param1;
         this.mBody = param2;
         this.mColor = param3;
         this.createUI();
         touchable = false;
      }
      
      private function createUI() : void
      {
         this.createTitle();
         this.createDesc();
      }
      
      private function createTitle() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.mTitleTextfield == null)
         {
            _loc1_ = FSResourceMng.isOriental() ? 60 : 1;
            _loc2_ = FSResourceMng.isOriental() ? 28 : 1;
            if(FSResourceMng.isOriental())
            {
               _loc1_ /= Utils.isAndroidOrDesktop() || Utils.isBrowser() ? 1.7 : 1;
               _loc2_ /= Utils.isAndroidOrDesktop() || Utils.isBrowser() ? 1.75 : 1;
            }
            this.mTitleTextfield = new FSTextfield(_loc1_,_loc2_,this.mTitle,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mTitleTextfield.autoSize = FSResourceMng.isOriental() ? TextFieldAutoSize.NONE : TextFieldAutoSize.BOTH_DIRECTIONS;
            addChild(this.mTitleTextfield);
         }
      }
      
      private function createDesc() : void
      {
         if(this.mBodyTextfield == null)
         {
            this.mBodyTextfield = new FSTextfield(this.mTitleTextfield.width * 3,this.mTitleTextfield.height,this.mBody,this.mColor,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mBodyTextfield.autoSize = FSResourceMng.isOriental() ? TextFieldAutoSize.NONE : TextFieldAutoSize.BOTH_DIRECTIONS;
            this.mBodyTextfield.height = this.mTitleTextfield.height;
            this.mBodyTextfield.text = this.mBody;
         }
         this.mBodyTextfield.x = this.mTitleTextfield.x + this.mTitleTextfield.width;
         this.mBodyTextfield.y = this.mTitleTextfield.y - (this.mBodyTextfield.height - this.mTitleTextfield.height) / 2;
         addChild(this.mBodyTextfield);
      }
      
      override public function dispose() : void
      {
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mBodyTextfield)
         {
            this.mBodyTextfield.removeFromParent(true);
            this.mBodyTextfield = null;
         }
         super.dispose();
      }
   }
}

