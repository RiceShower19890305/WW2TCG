package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.core.Starling;
   
   public class ArtilleryAnim extends BulletsAnim
   {
      
      protected const AREA_SUPPORT:int = 0;
      
      protected const AREA_FRONT:int = 1;
      
      protected const AREA_ALL:int = 2;
      
      protected var mAbilityDef:AbilityDef;
      
      public function ArtilleryAnim(param1:AbilityDef, param2:FSCard, param3:int = -1, param4:String = "", param5:String = "", param6:Number = 0.2, param7:Boolean = true)
      {
         this.mAbilityDef = param1;
         super(param2,param3,param4,param5,0.25,param7);
      }
      
      override protected function getBulletExplosionTextureName() : String
      {
         return "explosion_m_";
      }
      
      override protected function playExplosionSound(param1:Number, param2:String = "") : void
      {
         super.playExplosionSound(param1,Constants.SOUND_EXPLOSION_HIT);
      }
      
      protected function calculateAttackArea() : int
      {
         var _loc1_:int = this.mAbilityDef.getTargetIndex();
         var _loc2_:int = -1;
         if(_loc1_ == AbilitiesMng.TARGET_ENEMY_SUPPORT_LANE_CARDS)
         {
            _loc2_ = this.AREA_SUPPORT;
         }
         else if(_loc1_ == AbilitiesMng.TARGET_ENEMY_ATTACK_LANE_CARDS)
         {
            _loc2_ = this.AREA_FRONT;
         }
         else
         {
            _loc2_ = this.AREA_ALL;
         }
         return _loc2_;
      }
      
      override protected function calculateBulletsDestinations() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc1_:int = this.calculateAttackArea();
         if(_loc1_ != -1 && mDamageDealerCard != null && mDamageDealerCard.getParentUserBattleInfo() != null)
         {
            _loc2_ = mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo();
            _loc3_ = Starling.current.stage.stageWidth * 0.45;
            _loc4_ = Starling.current.stage.stageWidth;
            _loc5_ = _loc2_ ? int(Starling.current.stage.stageHeight * 0.05) : int(Starling.current.stage.stageHeight * 0.6);
            _loc6_ = _loc2_ ? int(Starling.current.stage.stageHeight * 0.5) : Starling.current.stage.stageHeight;
            _loc7_ = _loc4_ - _loc3_;
            _loc8_ = _loc6_ - _loc5_;
            switch(_loc1_)
            {
               case this.AREA_SUPPORT:
                  _loc5_ = _loc2_ ? int(Starling.current.stage.stageHeight * 0.05) : int(Starling.current.stage.stageHeight * 0.75);
                  _loc6_ = _loc2_ ? int(Starling.current.stage.stageHeight * 0.3) : Starling.current.stage.stageHeight;
                  break;
               case this.AREA_FRONT:
                  _loc5_ = _loc2_ ? int(Starling.current.stage.stageHeight * 0.35) : int(Starling.current.stage.stageHeight * 0.6);
                  _loc6_ = _loc2_ ? int(Starling.current.stage.stageHeight * 0.5) : int(Starling.current.stage.stageHeight * 0.75);
            }
            if(mBulletImagesCatalog != null)
            {
               _loc12_ = 0;
               _loc13_ = 0;
               _loc14_ = _loc1_ == this.AREA_ALL ? 2 : 1;
               _loc9_ = 0;
               while(_loc9_ < mBulletImagesCatalog.length)
               {
                  _loc12_ = _loc7_ / mBulletImagesCatalog.length * _loc9_;
                  _loc13_ = _loc7_ / mBulletImagesCatalog.length * (_loc9_ + 1);
                  _loc10_ = _loc3_ + Utils.randomNumber(_loc12_,_loc13_);
                  _loc11_ = Utils.randomNumber(_loc5_,_loc6_);
                  if(m_BulletsEndPositions == null)
                  {
                     m_BulletsEndPositions = new Vector.<FSCoordinate>();
                  }
                  m_BulletsEndPositions.push(new FSCoordinate(_loc10_,_loc11_));
                  _loc9_++;
               }
            }
         }
      }
      
      override protected function getBulletEndCoord(param1:int) : FSCoordinate
      {
         return m_BulletsEndPositions ? m_BulletsEndPositions[param1] : null;
      }
      
      override protected function addBulletHoleImageToDisplayList(param1:FSImage, param2:Boolean = false) : void
      {
         Utils.createExplosionLight(param1.x,param1.y);
      }
   }
}

