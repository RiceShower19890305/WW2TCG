package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.controller.FSCardAnimsMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   
   public class AirplaneBulletsAnim extends BulletsAnim
   {
      
      public function AirplaneBulletsAnim(param1:FSCard, param2:int = -1, param3:String = "", param4:String = "", param5:Number = 0.2, param6:Boolean = true)
      {
         param2 = param2 == -1 ? FSCardAnimsMng.AIRPLANES_BULLETS_AMOUNT : param2;
         param3 = param3 == "" ? FSCardAnimsMng.AIRPLANES_GUN_FIRE_SOUND_NAME : param3;
         param4 = param4 == "" ? FSCardAnimsMng.STD_BULLET_IMAGE_NAME : param4;
         super(param1,param2,param3,param4,param5,param6);
      }
      
      override protected function calculateBulletsDestinations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSImage = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(mBulletImagesCatalog != null)
         {
            _loc5_ = Number(mAttachedToComponent.width);
            _loc6_ = Number(mAttachedToComponent.height);
            _loc7_ = 0;
            _loc8_ = 0;
            _loc1_ = 0;
            while(_loc1_ < mBulletImagesCatalog.length)
            {
               _loc2_ = mBulletImagesCatalog[_loc1_];
               this.scaleBulletImage(_loc2_);
               _loc7_ = _loc1_ * _loc2_.height;
               if(mAttachedToComponent is FSCard && (Boolean(FSCard(mAttachedToComponent).getBG()) || Boolean(FSCard(mAttachedToComponent).getBGAnimated())))
               {
                  _loc8_ = FSImage(mBulletImagesCatalog[0]).width;
                  _loc3_ = _loc1_ == 0 ? Utils.randomInt(_loc8_,_loc5_ * 0.65) : m_BulletsEndPositions[0].getX();
                  _loc4_ = _loc1_ == 0 ? Utils.randomInt(_loc8_ / 2,_loc6_ * 0.5) : m_BulletsEndPositions[0].getY() + _loc7_ / 2;
               }
               else
               {
                  _loc3_ = mAttachedToComponent.x + _loc5_ / 3 - _loc8_ / 2;
                  _loc9_ = mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait ? int(FSBattlefieldUserPortrait(mAttachedToComponent.parent).getNameFrame().height * 1.35) : 0;
                  _loc4_ = mAttachedToComponent.y + _loc9_ + _loc7_ / 2;
               }
               if(m_BulletsEndPositions == null)
               {
                  m_BulletsEndPositions = new Vector.<FSCoordinate>();
               }
               if(_loc1_ % 2 != 0)
               {
                  _loc3_ = m_BulletsEndPositions[_loc1_ - 1].getX() + _loc2_.width + 1;
                  _loc4_ = m_BulletsEndPositions[_loc1_ - 1].getY();
               }
               m_BulletsEndPositions.push(new FSCoordinate(_loc3_,_loc4_));
               _loc1_++;
            }
         }
      }
      
      override protected function playExplosionSound(param1:Number, param2:String = "") : void
      {
      }
      
      override protected function performBulletsAnims() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:FSImage = null;
         var _loc4_:FSImage = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Boolean = false;
         var _loc11_:FSCoordinate = null;
         var _loc12_:FSCoordinate = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Boolean = false;
         if(mBulletsVector != null && mAttachedToComponent != null && mDamageDealerCard != null)
         {
            _loc2_ = 0;
            _loc5_ = Number(mAttachedToComponent.width);
            _loc6_ = Number(mAttachedToComponent.height);
            _loc10_ = mAttachedToComponent != null && mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait;
            _loc13_ = 0;
            _loc14_ = 0;
            if(mDamageDealerCard.hasAnimatedBG() && mDamageDealerCard.getBGAnimated() != null)
            {
               _loc13_ = mDamageDealerCard.getBGAnimated().width;
               _loc14_ = mDamageDealerCard.getBGAnimated().height;
            }
            else if(mDamageDealerCard.getBG() != null)
            {
               _loc13_ = mDamageDealerCard.getBG().width;
               _loc14_ = mDamageDealerCard.getBG().height;
            }
            _loc7_ = mDamageDealerCard.x - _loc13_ / 4;
            _loc8_ = mDamageDealerCard.x + _loc13_ / 4;
            if(mDamageDealerCard.getParentUserBattleInfo() == null)
            {
               return;
            }
            _loc15_ = mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo();
            _loc9_ = _loc15_ ? mDamageDealerCard.y - mDamageDealerCard.height / 2 : mDamageDealerCard.y + mDamageDealerCard.height / 2;
            while(_loc2_ < mBulletsVector.length)
            {
               _loc11_ = getBulletEndCoord(_loc2_);
               _loc12_ = getBulletEndCoord(_loc2_ + 1);
               if(_loc11_ == null || _loc12_ == null)
               {
                  break;
               }
               _loc3_ = mBulletsVector[_loc2_];
               _loc4_ = mBulletsVector[_loc2_ + 1];
               if(Boolean(_loc3_) && Boolean(_loc4_))
               {
                  setupBulletOrientation(_loc3_,_loc10_,_loc7_,_loc9_,_loc11_.getX(),_loc11_.getY());
                  setupBulletOrientation(_loc4_,_loc10_,_loc8_,_loc9_,_loc12_.getX(),_loc12_.getY());
                  _loc3_.x = _loc7_;
                  _loc3_.y = _loc9_;
                  _loc4_.x = _loc8_;
                  _loc4_.y = _loc9_;
                  _loc1_ = _loc2_ * 0.05;
                  TweenMax.delayedCall(_loc1_,playGunShotSound);
                  performBulletTransition(_loc3_,_loc11_,_loc1_ + 0.001,_loc2_);
                  performBulletTransition(_loc4_,_loc12_,_loc1_ + 0.01,_loc2_ + 1);
                  _loc2_ += 2;
               }
            }
         }
      }
      
      override protected function scaleBulletImage(param1:FSImage) : void
      {
         param1.scaleX *= 0.7;
         param1.scaleY *= 0.7;
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

