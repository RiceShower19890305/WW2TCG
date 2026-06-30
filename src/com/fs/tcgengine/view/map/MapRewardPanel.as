package com.fs.tcgengine.view.map
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.utils.Align;
   
   public class MapRewardPanel extends Component
   {
      
      private var mQuad:Quad;
      
      private var mTitle:FSTextfield;
      
      private var mSubtitle:FSTextfield;
      
      private var mLeftIcon:FSImage;
      
      public function MapRewardPanel(param1:String, param2:String, param3:String = "")
      {
         super();
         this.createUI(param1,param2,param3);
      }
      
      private function createUI(param1:String, param2:String, param3:String = "") : void
      {
         this.createQuad();
         this.createTitle(param1);
         this.createSubtitle(param2);
         this.createLeftIcon(param3);
      }
      
      private function createQuad() : void
      {
         if(this.mQuad == null)
         {
            this.mQuad = new Quad(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight / 7,0);
            this.mQuad.x = 0;
            this.mQuad.y = 0;
            this.mQuad.alpha = 0.65;
            addChild(this.mQuad);
         }
      }
      
      private function createTitle(param1:String) : void
      {
         if(this.mTitle == null)
         {
            this.mTitle = new FSTextfield(this.mQuad.width,this.mQuad.height / 1.5,param1,16777215,FSResourceMng.FONT_STD_BIG_TITLE_SIZE);
            this.mTitle.format.verticalAlign = Align.BOTTOM;
            addChild(this.mTitle);
         }
      }
      
      private function createSubtitle(param1:String) : void
      {
         if(this.mSubtitle == null)
         {
            this.mSubtitle = new FSTextfield(this.mQuad.width,this.mQuad.height - this.mTitle.height,param1,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mSubtitle.x = this.mTitle.x;
            this.mSubtitle.y = this.mTitle.y + this.mTitle.height;
            this.mSubtitle.format.verticalAlign = Align.TOP;
            addChild(this.mSubtitle);
         }
      }
      
      private function createLeftIcon(param1:String = "") : void
      {
         if(param1 != "")
         {
            if(this.mLeftIcon == null)
            {
               this.mLeftIcon = new FSImage(Root.assets.getTexture(param1));
               this.mLeftIcon.alignPivot();
               this.mLeftIcon.x = this.mLeftIcon.width;
               this.mLeftIcon.y = this.mQuad.height / 2;
               addChild(this.mLeftIcon);
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mQuad)
         {
            this.mQuad.removeFromParent(true);
            this.mQuad = null;
         }
         if(this.mTitle)
         {
            this.mTitle.removeFromParent(true);
            this.mTitle = null;
         }
         if(this.mSubtitle)
         {
            this.mSubtitle.removeFromParent(true);
            this.mSubtitle = null;
         }
         if(this.mLeftIcon)
         {
            this.mLeftIcon.removeFromParent(true);
            this.mLeftIcon = null;
         }
         super.dispose();
      }
   }
}

