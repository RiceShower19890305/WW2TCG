package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.view.cards.FSCard;
   
   public class SubmarineBulletAnim extends TankBulletAnim
   {
      
      public function SubmarineBulletAnim(param1:FSCard, param2:int = -1, param3:String = "", param4:String = "", param5:Number = 0.2)
      {
         super(param1,1,"submarine_fire","torpedo_bullet_hole",param5);
      }
      
      override protected function getAmmoName() : String
      {
         return "torpedo_ammo";
      }
      
      override protected function showBulletParticles(param1:Number, param2:Number, param3:String = "gunshot") : void
      {
         super.showBulletParticles(param1,param2,"bigbullet");
      }
   }
}

