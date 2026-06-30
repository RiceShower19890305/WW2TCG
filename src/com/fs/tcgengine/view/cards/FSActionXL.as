package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.utils.Utils;
   
   public class FSActionXL extends FSCardXL
   {
      
      public function FSActionXL(param1:FSCard)
      {
         super(param1);
      }
      
      override protected function setHeightPercentages() : void
      {
         mAbilitiesHeightBlockPercent = FSCardXL.ABILITIES_BLOCK_HEIGHT_PERCENTAGE;
         mDescBlockHeightPercent = 85;
      }
      
      override protected function createDescriptionInfoBlock() : void
      {
         super.createDescriptionInfoBlock();
         if(mDescriptionInfoBlock)
         {
            if(Utils.isAndroidOrDesktop() || Utils.isIphone())
            {
               mDescriptionInfoBlock.x = mFrameBG ? mFrameBG.x + mFrameBG.width * 1.35 : width + width * 0.5;
            }
            else
            {
               mDescriptionInfoBlock.x = mFrameBG ? mFrameBG.x + mFrameBG.width * 1.18 : width + 15;
            }
            mDescriptionInfoBlock.y = mFrameBG ? mFrameBG.y : 0;
         }
      }
      
      override public function createTierFrame(param1:Boolean = false) : void
      {
      }
      
      override protected function createPromoteInfo() : void
      {
      }
      
      override public function showDamageAndShield(param1:Boolean = false) : void
      {
      }
   }
}

