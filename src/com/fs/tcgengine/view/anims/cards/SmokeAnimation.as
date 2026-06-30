package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.misc.FSImage;
   
   public class SmokeAnimation extends PoisonAnimation
   {
      
      public function SmokeAnimation(param1:Ability, param2:FSCard)
      {
         super(param1,param2);
      }
      
      override public function setup(param1:*, param2:String = "", param3:FSImage = null) : void
      {
         super.setup(param1,"smoke_fire",param3);
      }
      
      override protected function createMC() : void
      {
         if(mDamageDealerCard != null)
         {
            mPoisonImage = new FSImage(Root.assets.getTexture("smoke_fire"));
            mPoisonImage.alignPivot();
         }
      }
      
      override protected function triggerParticleSystem() : void
      {
         super.triggerParticleSystem();
         if(mParticleSystem != null)
         {
            mParticleSystem.y = mAttachedToComponent is FSUnit ? mAttachedToComponent.height / 1.25 : mAttachedToComponent.height / 1.5;
         }
      }
   }
}

