package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.view.cards.FSCard;
   
   public class JavelinAnimation extends ArrowAnimation
   {
      
      public function JavelinAnimation(param1:Ability, param2:FSCard)
      {
         super(param1,param2);
         setAbilityItBelongsTo(AbilitiesMng.JAVELIN_ANIM);
      }
      
      override protected function getAnimAsset() : String
      {
         return Boolean(mAbility) && Boolean(mAbility.getAbilityDef().getAnimAsset()) && mAbility.getAbilityDef().getAnimAsset() != "" ? mAbility.getAbilityDef().getAnimAsset() : "javelin";
      }
      
      override protected function getBuffAsset() : String
      {
         return "buff_javelin";
      }
   }
}

