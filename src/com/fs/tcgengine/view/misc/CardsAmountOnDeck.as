package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   
   public class CardsAmountOnDeck extends Component
   {
      
      private const BG_NAME:String = "deck_total_amount";
      
      protected var mBG:FSImage;
      
      protected var mAmountTextfield:FSTextfield;
      
      protected var mAmount:FSNumber;
      
      protected var mDrawBG:Boolean;
      
      public function CardsAmountOnDeck(param1:int, param2:Boolean)
      {
         super();
         touchable = false;
         this.mDrawBG = param2;
         if(this.mAmount == null)
         {
            this.mAmount = new FSNumber();
         }
         this.mAmount.value = Number(param1);
         this.init();
      }
      
      private function init() : void
      {
         this.createBG();
         this.createAmountTextfield();
      }
      
      protected function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture(this.BG_NAME));
            addChild(this.mBG);
            this.mBG.visible = this.mDrawBG;
         }
      }
      
      protected function createAmountTextfield() : void
      {
         var _loc1_:int = 0;
         if(this.mAmountTextfield == null)
         {
            _loc1_ = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mAmountTextfield = new FSTextfield(this.mBG.width,this.mBG.height * 0.8);
            this.mAmountTextfield.y = (this.mBG.height - this.mAmountTextfield.height) / 2;
            this.mAmountTextfield.fontName = FSResourceMng.getFontByType();
            this.mAmountTextfield.color = 15852199;
            addChild(this.mAmountTextfield);
         }
         this.updateAmountTextfield();
      }
      
      public function updateAmountTextfield() : void
      {
         var _loc1_:int = 0;
         if(this.mAmountTextfield != null)
         {
            _loc1_ = Config.getConfig().getDeckCardsAmount();
            this.mAmountTextfield.text = this.getAmount().toString() + "/" + _loc1_.toString();
         }
      }
      
      public function getAmount() : int
      {
         return this.mAmount ? int(this.mAmount.value) : 0;
      }
      
      public function setAmount(param1:int) : void
      {
         if(this.mAmount == null)
         {
            this.mAmount = new FSNumber();
         }
         this.mAmount.value = Number(param1);
         this.updateAmountTextfield();
      }
      
      public function addAmount(param1:int) : void
      {
         this.setAmount(this.mAmount.value + param1);
         this.updateAmountTextfield();
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mAmountTextfield)
         {
            this.mAmountTextfield.removeFromParent(true);
            this.mAmountTextfield = null;
         }
         Utils.destroyObject(this.mAmount);
         this.mAmount = null;
         super.dispose();
      }
   }
}

