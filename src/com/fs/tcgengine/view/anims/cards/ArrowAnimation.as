package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSPower;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.easing.Linear;
   import starling.core.Starling;
   import starling.utils.deg2rad;
   
   public class ArrowAnimation extends CardAnimation
   {
      
      protected var mAbility:Ability;
      
      protected var mDamageDealerCard:FSCard;
      
      private var mArrowBuff:FSImage;
      
      private var mArrowImage:FSImage;
      
      public function ArrowAnimation(param1:Ability, param2:FSCard)
      {
         super();
         this.mAbility = param1;
         this.mDamageDealerCard = param2;
         setIsPermanent(true);
         setAbilityItBelongsTo(AbilitiesMng.ARROW_ANIM);
      }
      
      override public function setup(param1:*, param2:String = "", param3:FSImage = null) : void
      {
         var _loc4_:String = Boolean(this.mAbility) && Boolean(this.mAbility.getAbilityDef().getParticleName()) ? this.mAbility.getAbilityDef().getParticleName() : "";
         this.createArrowBuff();
         this.createArrowImage();
         super.setup(param1,_loc4_,param3);
      }
      
      protected function createArrowBuff() : void
      {
         if(this.mArrowBuff == null)
         {
            this.mArrowBuff = new FSImage(Root.assets.getTexture(this.getBuffAsset()));
            this.mArrowBuff.alignPivot();
         }
      }
      
      private function createArrowImage() : void
      {
         var _loc1_:String = null;
         if(this.mArrowImage == null)
         {
            _loc1_ = this.getAnimAsset();
            this.mArrowImage = new FSImage(Root.assets.getTexture(_loc1_));
            this.mArrowImage.alignPivot();
         }
      }
      
      protected function getAnimAsset() : String
      {
         return Boolean(this.mAbility) && Boolean(this.mAbility.getAbilityDef().getAnimAsset() != null) && this.mAbility.getAbilityDef().getAnimAsset() != "" ? this.mAbility.getAbilityDef().getAnimAsset() : "moving_arrow";
      }
      
      protected function getBuffAsset() : String
      {
         return "buff_arrow";
      }
      
      override protected function triggerExtraGraphicsTweening() : void
      {
         super.triggerExtraGraphicsTweening();
         this.performArrowAnims();
      }
      
      protected function performArrowAnims() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:FSCoordinate = null;
         var _loc9_:Boolean = false;
         var _loc10_:FSBattlefieldUserPortrait = null;
         if(mAttachedToComponent)
         {
            _loc5_ = Number(mAttachedToComponent.width);
            _loc6_ = Number(mAttachedToComponent.height);
            _loc7_ = false;
            if(mAttachedToComponent is FSCard)
            {
               _loc5_ = FSCard(mAttachedToComponent).hasAnimatedBG() ? FSCard(mAttachedToComponent).getBGAnimated().width : FSCard(mAttachedToComponent).getBG().width;
               _loc6_ = FSCard(mAttachedToComponent).hasAnimatedBG() ? FSCard(mAttachedToComponent).getBGAnimated().height : FSCard(mAttachedToComponent).getBG().height;
            }
            else
            {
               _loc5_ = Number(mAttachedToComponent.width);
               _loc6_ = Number(mAttachedToComponent.height);
            }
            if(mAttachedToComponent != null && mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait)
            {
               _loc7_ = true;
               _loc1_ = mAttachedToComponent.parent.x + _loc5_ / 2;
               _loc2_ = mAttachedToComponent.parent.y + _loc6_ / 2;
            }
            else
            {
               _loc1_ = Number(mAttachedToComponent.x);
               _loc2_ = Number(mAttachedToComponent.y);
            }
            if(this.mDamageDealerCard is FSPower || Boolean(this.mAbility) && Boolean(this.mAbility.isAbilityPassive()))
            {
               if(this.mDamageDealerCard != null)
               {
                  if(Boolean(this.mAbility) && this.mAbility.isAbilityPassive())
                  {
                     _loc9_ = this.mDamageDealerCard.getParentUserBattleInfo() != null ? !this.mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo() : true;
                  }
                  else
                  {
                     _loc9_ = this.mDamageDealerCard.isEnemyCard();
                  }
               }
               else if(Boolean(this.mAbility) && this.mAbility.isAbilityPassive())
               {
                  _loc9_ = InstanceMng.getBattleEngine() ? !InstanceMng.getBattleEngine().isOwnerTurn() : false;
               }
               _loc10_ = _loc9_ ? InstanceMng.getBattleEngine().getBattleScreen().getOpponentPortrait() : InstanceMng.getBattleEngine().getBattleScreen().getOwnerPortrait();
               _loc3_ = _loc10_.x + _loc10_.width / 2;
               _loc4_ = _loc10_.y + _loc10_.height / 2;
            }
            else
            {
               _loc3_ = this.mDamageDealerCard.x;
               _loc4_ = this.mDamageDealerCard.y + _loc6_ / 2;
            }
            this.setupAnimOrientation(_loc7_,_loc3_,_loc4_,_loc1_,_loc2_);
            if(this.mArrowBuff)
            {
               if(mAttachedToComponent != null && mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait)
               {
                  this.mArrowBuff.x = _loc3_ - this.mArrowBuff.width * 0.3;
                  this.mArrowBuff.y = _loc4_ - this.mArrowBuff.height * 0.4;
               }
               else
               {
                  this.mArrowBuff.x = _loc3_;
                  this.mArrowBuff.y = _loc4_ - this.mArrowBuff.height / 2;
               }
            }
            this.mArrowImage.x = _loc3_;
            this.mArrowImage.y = _loc4_;
            _loc8_ = new FSCoordinate(_loc1_,_loc2_);
            this.performMCTransition(_loc8_);
         }
      }
      
      override protected function triggerParticleSystem() : void
      {
         if(mParticleSystem != null)
         {
            if(this.mArrowImage)
            {
               mParticleSystem.emitterX = this.mArrowImage.x;
               mParticleSystem.emitterY = this.mArrowImage.y;
            }
            InstanceMng.getCurrentScreen().addChild(mParticleSystem);
            Starling.juggler.add(mParticleSystem);
            mParticleSystem.start();
         }
      }
      
      protected function performMCTransition(param1:FSCoordinate) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         if(this.mDamageDealerCard == null || Boolean(this.mDamageDealerCard) && Boolean(!this.mDamageDealerCard.isDefeated()))
         {
            _loc2_ = this.mAbility.getAbilityDef().getAnimDuration();
            _loc2_ = !isNaN(_loc2_) && _loc2_ > 0 ? _loc2_ : 1;
            _loc3_ = _loc2_ * Config.getConfig().getDefaultGeneralSpeedFactor();
            this.addImageToCurrentScreen(this.mArrowBuff);
            SpecialFX.tweenToAlpha(this.mArrowBuff,0.999,1,0,this.onCompleteAlpha);
            this.addImageToCurrentScreen(this.mArrowImage);
            if(mParticleSystem == null)
            {
               SpecialFX.createTransition(this.mArrowImage,param1,_loc3_,0,this.onImageArrivedTarget,[this.mArrowImage],Linear.easeOut);
            }
            else
            {
               _loc4_ = Math.abs(this.mArrowImage.x - param1.mX);
               _loc5_ = Math.abs(this.mArrowImage.y - param1.mY);
               _loc6_ = _loc4_ > _loc5_ ? true : false;
               _loc7_ = Boolean(this.mAbility) && this.mAbility.getAbilityDef().getParticleAnimBezierCurves() >= 1 ? this.mAbility.getAbilityDef().getParticleAnimBezierCurves() : 1;
               if(mParticleSystem)
               {
                  mParticleSystem.emitterX = this.mArrowImage.x;
                  mParticleSystem.emitterY = this.mArrowImage.y;
                  SpecialFX.createBezierCurvesBetweenTwoPoints(mParticleSystem,new FSCoordinate(this.mArrowImage.x,this.mArrowImage.y),new FSCoordinate(param1.mX,param1.mY),_loc3_,_loc7_,150,_loc6_);
               }
               SpecialFX.createBezierCurvesBetweenTwoPoints(this.mArrowImage,new FSCoordinate(this.mArrowImage.x,this.mArrowImage.y),new FSCoordinate(param1.mX,param1.mY),_loc3_,_loc7_,150,_loc6_,this.onImageArrivedTarget,[this.mArrowImage]);
            }
         }
      }
      
      private function onCompleteAlpha() : void
      {
         if(this.mArrowBuff)
         {
            this.mArrowBuff.removeFromParent();
            this.mArrowBuff.destroy();
            this.mArrowBuff = null;
         }
      }
      
      protected function setupAnimOrientation(param1:Boolean, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         if(this.mArrowImage)
         {
            this.mArrowImage.alignPivot();
            if(this.mDamageDealerCard)
            {
               _loc6_ = Boolean(this.mDamageDealerCard) && Boolean(this.mDamageDealerCard.getParentUserBattleInfo()) ? this.mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo() : false;
            }
            else if(Boolean(this.mAbility) && this.mAbility.isAbilityPassive())
            {
               _loc6_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().isOwnerTurn() : false;
            }
            if(!_loc6_)
            {
               this.mArrowImage.scaleY = -1;
            }
            _loc7_ = Utils.getAngle(param2,param3,param4,param5);
            _loc7_ = _loc7_ - (_loc6_ ? 90 : 270);
            this.mArrowImage.rotation = deg2rad(_loc7_);
         }
      }
      
      protected function addImageToCurrentScreen(param1:FSImage) : void
      {
         if(param1 != null && Boolean(InstanceMng.getCurrentScreen()))
         {
            InstanceMng.getCurrentScreen().addChild(param1);
         }
      }
      
      protected function onImageArrivedTarget(param1:FSImage) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
         if(mParticleSystem)
         {
            SpecialFX.tweenToAlpha(mParticleSystem,0.001,CardAnimation.getMaxDuration(),0,removeParticleSystemFromDL);
         }
      }
      
      override public function dispose() : void
      {
         this.mAbility = null;
         this.mDamageDealerCard = null;
         if(this.mArrowBuff)
         {
            this.mArrowBuff.removeFromParent();
            this.mArrowBuff.destroy();
         }
         this.mArrowBuff = null;
         if(this.mArrowImage)
         {
            this.mArrowImage.removeFromParent();
            this.mArrowImage.destroy();
         }
         this.mArrowImage = null;
         super.dispose();
      }
   }
}

