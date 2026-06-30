package com.fs.tcgengine.view.misc
{
   public class DeckSelector extends DeckSelectorMini
   {
      
      public function DeckSelector()
      {
         super();
      }
      
      override protected function createTitle(param1:Number = 5) : void
      {
      }
      
      override protected function createDeckTitle(param1:int, param2:Boolean = false) : DeckTitleDeckSelector
      {
         return new DeckTitleDeckBuilder(param1,false,this);
      }
   }
}

