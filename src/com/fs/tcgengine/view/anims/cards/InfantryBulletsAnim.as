package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.controller.FSCardAnimsMng;
   import com.fs.tcgengine.view.cards.FSCard;
   
   public class InfantryBulletsAnim extends BulletsAnim
   {
      
      public function InfantryBulletsAnim(param1:FSCard, param2:int = -1, param3:String = "", param4:String = "", param5:Number = 0.2, param6:Boolean = true)
      {
         param2 = param2 == -1 ? FSCardAnimsMng.INFANTRY_BULLETS_AMOUNT : param2;
         param3 = param3 == "" ? FSCardAnimsMng.INFANTRY_GUN_FIRE_SOUND_NAME : param3;
         param4 = param4 == "" ? FSCardAnimsMng.STD_BULLET_IMAGE_NAME : param4;
         super(param1,param2,param3,param4,param5,param6);
      }
      
      override protected function getBulletExplosionTextureName() : String
      {
         return "bullet_smoke_";
      }
      
      override protected function isBulletExplosionGunSmoke() : Boolean
      {
         return true;
      }
   }
}

