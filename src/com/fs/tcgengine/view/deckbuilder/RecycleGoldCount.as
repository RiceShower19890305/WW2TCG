package com.fs.tcgengine.view.deckbuilder
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.misc.CardsAmountOnDeck;
   import com.fs.tcgengine.view.misc.FSImage;
   
   public class RecycleGoldCount extends CardsAmountOnDeck
   {
      
      private var mWatermarkBG:FSImage;
      
      public function RecycleGoldCount(param1:int)
      {
         super(param1,false);
      }
      
      override protected function createAmountTextfield() : void
      {
         super.createAmountTextfield();
         mAmountTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_GOLD);
         mAmountTextfield.width = mBG.width * 0.55;
         if(this.mWatermarkBG)
         {
            this.mWatermarkBG.x = mAmountTextfield.x + mAmountTextfield.width * 0.75;
         }
      }
      
      override protected function createBG() : void
      {
         super.createBG();
         this.createGoldWatermark();
      }
      
      protected function createGoldWatermark(param1:String = "gold_icon_XS") : void
      {
         if(this.mWatermarkBG == null)
         {
            this.mWatermarkBG = new FSImage(Root.assets.getTexture(param1));
            this.mWatermarkBG.touchable = false;
            this.mWatermarkBG.y = height / 2 - this.mWatermarkBG.height / 2;
            addChild(this.mWatermarkBG);
         }
      }
      
      override public function updateAmountTextfield() : void
      {
         if(mAmountTextfield != null)
         {
            mAmountTextfield.text = getAmount().toString();
         }
      }
      
      override public function dispose() : void
      {
         if(this.mWatermarkBG)
         {
            this.mWatermarkBG.removeFromParent(true);
            this.mWatermarkBG = null;
         }
         super.dispose();
      }
   }
}

