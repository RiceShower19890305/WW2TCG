package com.fs.tcgengine.view.deckbuilder
{
   public class RecycleRaidCoinsCount extends RecycleGoldCount
   {
      
      public function RecycleRaidCoinsCount(param1:int)
      {
         super(param1);
      }
      
      override protected function createGoldWatermark(param1:String = "gold_icon_XS") : void
      {
         super.createGoldWatermark("raid_coins_icon_XS");
      }
   }
}

