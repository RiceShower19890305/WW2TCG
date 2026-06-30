package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   
   public class FSTopMenuBar extends Component
   {
      
      private const BG_NAME:String = "menu_bar";
      
      private var mBG:FSImage;
      
      public function FSTopMenuBar()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.createBG();
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture(this.BG_NAME));
            this.mBG.touchable = false;
         }
         addChild(this.mBG);
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         super.dispose();
      }
   }
}

