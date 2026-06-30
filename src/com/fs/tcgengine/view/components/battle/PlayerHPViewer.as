package com.fs.tcgengine.view.components.battle
{
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSGaugeProgressBar;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import starling.utils.Align;
   
   public class PlayerHPViewer extends Component
   {
      
      private var mTextfield:FSTextfield;
      
      private var mProgressBar:FSGaugeProgressBar;
      
      private var mInitialHPValue:int;
      
      public function PlayerHPViewer()
      {
         super();
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createProgressBar();
         this.createTextfield();
      }
      
      private function createProgressBar() : void
      {
         if(this.mProgressBar == null)
         {
            this.mProgressBar = new FSGaugeProgressBar("","character_panel",1,false,-1,Config.getConfig().battleHasSimpleUI());
            this.mProgressBar.touchable = false;
            addChild(this.mProgressBar);
         }
      }
      
      private function createTextfield() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mTextfield == null)
         {
            _loc1_ = Config.getConfig().battleHasSimpleUI();
            _loc2_ = _loc1_ ? int(this.mProgressBar.width / 3) : int(this.mProgressBar.width * 0.7);
            _loc3_ = _loc1_ ? int(this.mProgressBar.height * 0.75) : int(this.mProgressBar.getUsefulHeight() * 0.7);
            this.mTextfield = new FSTextfield(_loc2_,_loc3_,"");
            this.mTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE * Layout.getFontMultiplier();
            this.mTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            this.mTextfield.format.horizontalAlign = Align.CENTER;
            this.mTextfield.format.verticalAlign = Align.CENTER;
            this.setPos();
            addChild(this.mTextfield);
         }
      }
      
      private function setPos() : void
      {
         var _loc1_:Boolean = false;
         if(this.mTextfield)
         {
            _loc1_ = Config.getConfig().battleHasSimpleUI();
            this.mTextfield.x = _loc1_ ? this.mProgressBar.x + 5 : this.mProgressBar.x + (this.mProgressBar.width - this.mTextfield.width) / 2 + 1;
            this.mTextfield.y = _loc1_ ? this.mProgressBar.y + 2 : this.mProgressBar.y + (this.mProgressBar.height - this.mTextfield.height) / 2 + 1;
         }
      }
      
      public function setFontSize(param1:Number) : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.fontSize = param1 * Layout.getFontMultiplier();
            this.setPos();
         }
      }
      
      public function getUsefulHeight() : int
      {
         return this.mProgressBar.height;
      }
      
      public function updateHP(param1:Number, param2:Boolean = false) : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.text = int(param1).toString();
         }
         if(param2)
         {
            this.mInitialHPValue = param1;
         }
         if(this.mProgressBar)
         {
            this.mProgressBar.setRatio(param1 / this.mInitialHPValue);
         }
      }
      
      public function getHPTextfield() : FSTextfield
      {
         return this.mTextfield;
      }
      
      override public function dispose() : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         if(this.mProgressBar)
         {
            this.mProgressBar.removeFromParent(true);
            this.mProgressBar = null;
         }
         super.dispose();
      }
   }
}

