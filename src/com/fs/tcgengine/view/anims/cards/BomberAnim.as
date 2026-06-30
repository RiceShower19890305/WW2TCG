package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.FSCardAnimsMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import starling.core.Starling;
   
   public class BomberAnim extends ArtilleryAnim
   {
      
      private static const BOMBER_SOUND:String = "bomber_fx";
      
      private static const BOMBER_PLANE_IMAGE:String = "bomber_anim";
      
      public static const STAGE_WIDTH:int = Starling.current.stage.stageWidth;
      
      public static const STAGE_HEIGHT:int = Starling.current.stage.stageHeight;
      
      private var m_BomberPlane:FSImage;
      
      public function BomberAnim(param1:AbilityDef, param2:FSCard, param3:int = -1, param4:String = "", param5:String = "", param6:Number = 0.2, param7:Boolean = true)
      {
         mAbilityDef = param1;
         super(param1,param2,4,FSCardAnimsMng.TANK_GUN_FIRE_SOUND_NAME,FSCardAnimsMng.TANK_BULLET_IMAGE_NAME,0.75,false);
         setAbilityItBelongsTo(AbilitiesMng.BOMBER_BF_ANIM);
      }
      
      override protected function getBulletExplosionTextureName() : String
      {
         return "explosion_m_";
      }
      
      override protected function calculateAttackArea() : int
      {
         return AREA_ALL;
      }
      
      override public function setup(param1:*, param2:String = "", param3:FSImage = null) : void
      {
         this.createPlane();
         super.setup(param1,param2,param3);
      }
      
      private function createPlane() : void
      {
         this.m_BomberPlane = new FSImage(Root.assets.getTexture(BOMBER_PLANE_IMAGE));
         this.m_BomberPlane.scale = 2;
         this.m_BomberPlane.alignPivot();
      }
      
      override protected function triggerExtraGraphicsTweening() : void
      {
         var _loc1_:Boolean = mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo();
         var _loc2_:Number = _loc1_ ? STAGE_HEIGHT * 0.05 : STAGE_HEIGHT * 0.58;
         this.m_BomberPlane.x = -this.m_BomberPlane.width / 2;
         this.m_BomberPlane.y = _loc2_ + this.m_BomberPlane.height / 2;
         this.m_BomberPlane.visible = true;
         Utils.playSound(BOMBER_SOUND,SoundManager.TYPE_SFX);
         this.addImageToCurrentScreen(this.m_BomberPlane);
         var _loc3_:FSCoordinate = new FSCoordinate(STAGE_WIDTH + this.m_BomberPlane.width / 2,this.m_BomberPlane.y);
         var _loc4_:Number = mBulletsAmount * mSpeedFactor * 2;
         SpecialFX.createTransition(this.m_BomberPlane,_loc3_,_loc4_,0);
         TweenMax.delayedCall(_loc4_ / 4,super.triggerExtraGraphicsTweening);
      }
      
      override protected function playExplosionSound(param1:Number, param2:String = "") : void
      {
         super.playExplosionSound(param1,Constants.SOUND_EXPLOSION_HIT);
      }
      
      protected function addImageToCurrentScreen(param1:FSImage) : void
      {
         if(param1 != null && Boolean(InstanceMng.getCurrentScreen()))
         {
            InstanceMng.getCurrentScreen().addChild(param1);
         }
      }
      
      override public function dispose() : void
      {
         if(this.m_BomberPlane)
         {
            this.m_BomberPlane.removeFromParent();
         }
         this.m_BomberPlane = null;
         super.dispose();
      }
   }
}

