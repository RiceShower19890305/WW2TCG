package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.controller.TextManager;
   
   public class CardCraftLayer extends CardFusionLayer
   {
      
      public function CardCraftLayer(param1:FSCard)
      {
         super(param1);
      }
      
      override protected function createIcon(param1:String) : void
      {
         super.createIcon("craft");
      }
      
      override protected function createText(param1:String = "") : void
      {
         super.createText(TextManager.getText("TID_CRAFT"));
      }
   }
}

