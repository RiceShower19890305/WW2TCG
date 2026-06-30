package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.view.cards.FSCard;
   
   public class ShipBulletAnim extends TankBulletAnim
   {
      
      public function ShipBulletAnim(param1:FSCard, param2:int = -1, param3:String = "", param4:String = "", param5:Number = 0.2)
      {
         super(param1,3,param3,param4,param5);
      }
      
      override protected function showBulletParticles(param1:Number, param2:Number, param3:String = "gunshot") : void
      {
         super.showBulletParticles(param1,param2,"bigbullet");
      }
   }
}

