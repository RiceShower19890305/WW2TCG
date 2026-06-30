package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.utils.SpecialFX;
   
   public class IconRotateAnimation extends IconZoomAnimation
   {
      
      public function IconRotateAnimation(param1:Ability)
      {
         super(param1);
      }
      
      override public function init() : void
      {
         super.init();
         this.triggerIconRotateTransition();
      }
      
      private function triggerIconRotateTransition() : void
      {
         if(mIconImage)
         {
            SpecialFX.tweenRotate(mIconImage,getTransitionTime(TRANSITION_DURATION));
         }
      }
   }
}

