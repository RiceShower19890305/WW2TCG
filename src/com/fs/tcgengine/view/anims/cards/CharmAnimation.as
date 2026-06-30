package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSUnit;
   import starling.core.Starling;
   
   public class CharmAnimation extends CardAnimation
   {
      
      private var mAbility:Ability;
      
      public function CharmAnimation(param1:Ability)
      {
         this.mAbility = param1;
         super();
         setIsPermanent(true);
         setAbilityItBelongsTo(AbilitiesMng.SPECIAL_CAPTURED);
      }
      
      override public function init() : void
      {
         super.init();
         var _loc1_:String = this.mAbility ? this.mAbility.getAbilityDef().getSoundName() : "";
         if(_loc1_ != "")
         {
            Utils.playSound(_loc1_,SoundManager.TYPE_SFX);
         }
      }
      
      override protected function triggerParticleSystem() : void
      {
         if(mParticleSystem != null)
         {
            mParticleSystem.x = mAttachedToComponent.width / 2;
            mParticleSystem.y = mAttachedToComponent.height / 3;
            if(FSUnit(mAttachedToComponent).getAbsAnimsLayer() != null)
            {
               FSUnit(mAttachedToComponent).getAbsAnimsLayer().addChild(mParticleSystem);
            }
            Starling.juggler.add(mParticleSystem);
            mParticleSystem.start();
         }
      }
      
      override public function dispose() : void
      {
         this.mAbility = null;
         super.dispose();
      }
   }
}

