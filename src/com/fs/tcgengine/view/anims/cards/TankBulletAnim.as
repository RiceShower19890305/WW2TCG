package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.controller.FSCardAnimsMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.misc.FSImage;
   
   public class TankBulletAnim extends BulletsAnim
   {
      
      public function TankBulletAnim(param1:FSCard, param2:int = -1, param3:String = "", param4:String = "", param5:Number = 0.2, param6:Boolean = true)
      {
         param2 = param2 == -1 ? FSCardAnimsMng.TANK_BULLETS_AMOUNT : param2;
         param3 = param3 == "" ? FSCardAnimsMng.TANK_GUN_FIRE_SOUND_NAME : param3;
         param4 = param4 == "" ? FSCardAnimsMng.TANK_BULLET_IMAGE_NAME : param4;
         super(param1,param2,param3,param4,param5,param6);
      }
      
      override public function setup(param1:*, param2:String = "", param3:FSImage = null) : void
      {
         super.setup(param1,"",param3);
      }
      
      override protected function scaleBulletImage(param1:FSImage) : void
      {
      }
      
      override protected function getAmmoName() : String
      {
         return "tank_ammo";
      }
      
      override public function getAmmoSpeed() : Number
      {
         return 1 * Utils.getDefaultSpeedTime();
      }
      
      override protected function showBulletParticles(param1:Number, param2:Number, param3:String = "gunshot") : void
      {
         super.showBulletParticles(param1,param2,"bigbullet");
      }
      
      override protected function getBulletExplosionTextureName() : String
      {
         return "explosion_m_";
      }
   }
}

