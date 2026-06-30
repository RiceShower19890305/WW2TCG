package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   
   public class RandomizePosAnimation extends IconZoomAnimation
   {
      
      public function RandomizePosAnimation(param1:Ability)
      {
         super(param1);
      }
      
      private function createRandomPositionTransition() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Number = CardAnimation.getMaxDuration() / 6;
         var _loc5_:FSCoordinate = new FSCoordinate();
         _loc1_ = 1;
         while(_loc1_ <= 2)
         {
            _loc3_ = Utils.randomNumber(mAttachedToComponent.width * 0.2,mAttachedToComponent.width * 0.8);
            _loc4_ = Utils.randomNumber(mAttachedToComponent.height * 0.2,mAttachedToComponent.height * 0.8);
            _loc5_.setX(_loc3_);
            _loc5_.setY(_loc4_);
            SpecialFX.createTransition(mIconImage,_loc5_,CardAnimation.getMaxDuration() / 4,CardAnimation.getMaxDuration() / 4 * _loc1_);
            _loc1_++;
         }
         unloadIconImage();
      }
      
      override protected function triggerIconZoomTransition(param1:Function) : void
      {
         super.triggerIconZoomTransition(this.createRandomPositionTransition);
      }
   }
}

