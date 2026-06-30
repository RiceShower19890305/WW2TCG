package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.view.cards.FSCard;
   
   public class JavelinDamageAnimation extends ArrowDamageAnimation
   {
      
      public function JavelinDamageAnimation(param1:FSCard, param2:int = -1, param3:String = "", param4:String = "", param5:Number = 0.04)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function getAmmoName() : String
      {
         return "javelin_nailed";
      }
   }
}

