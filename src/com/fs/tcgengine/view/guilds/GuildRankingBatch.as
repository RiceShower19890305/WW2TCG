package com.fs.tcgengine.view.guilds
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.utils.Align;
   
   public class GuildRankingBatch extends Component
   {
      
      protected var mBG:FSImage;
      
      private var mBGName:String;
      
      protected var mScore:Number;
      
      protected var mScoreTextfield:FSTextfield;
      
      public function GuildRankingBatch(param1:String, param2:Number)
      {
         super();
         touchable = false;
         this.mBGName = param1;
         this.mScore = param2;
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createScoreTextfield();
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture(this.mBGName));
            addChild(this.mBG);
         }
      }
      
      protected function createScoreTextfield() : void
      {
         var _loc1_:Number = NaN;
         if(this.mScoreTextfield == null)
         {
            _loc1_ = !isNaN(this.mScore) ? this.mScore : 0;
            this.mScoreTextfield = new FSTextfield(this.mBG.width * 0.5,this.mBG.height,_loc1_.toString());
            this.mScoreTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            this.mScoreTextfield.format.horizontalAlign = Align.RIGHT;
            this.mScoreTextfield.x = this.mBG.x + this.mBG.width * 0.45;
            this.mScoreTextfield.y = this.mBG.y;
            addChild(this.mScoreTextfield);
         }
      }
      
      public function updateScore(param1:String) : void
      {
         this.mScore = !isNaN(Number(param1)) ? Number(param1) : -1;
         if(this.mScoreTextfield)
         {
            this.mScoreTextfield.text = param1;
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mScoreTextfield)
         {
            this.mScoreTextfield.removeFromParent(true);
            this.mScoreTextfield = null;
         }
         removeChildren(0,-1,true);
         super.dispose();
      }
   }
}

