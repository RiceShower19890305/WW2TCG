package com.fs.tcgengine.view.components.misc
{
   public class FSLoadingCardMC extends FSLoadingMC
   {
      
      public function FSLoadingCardMC()
      {
         super();
      }
      
      override protected function setupSpriteSheet() : void
      {
         mSpriteSheetPrefix = "card_loading_";
         mFPS = 25;
      }
   }
}

