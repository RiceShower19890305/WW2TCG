package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSPower;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.easing.Linear;
   import starling.core.Starling;
   import starling.utils.deg2rad;
   
   public class PoisonAnimation extends CardAnimation
   {
      
      protected var mAbility:Ability;
      
      protected var mDamageDealerCard:FSCard;
      
      protected var mPoisonImage:FSImage;
      
      public function PoisonAnimation(param1:Ability, param2:FSCard)
      {
         super();
         this.mAbility = param1;
         this.mDamageDealerCard = param2;
         setIsPermanent(true);
         setAbilityItBelongsTo(AbilitiesMng.SPECIAL_POISON);
      }
      
      override public function setup(param1:*, param2:String = "", param3:FSImage = null) : void
      {
         this.createMC();
         super.setup(param1,param2,param3);
      }
      
      override public function init() : void
      {
         super.init();
         var _loc1_:String = this.mAbility.getAbilityDef().getSoundName();
         if(_loc1_ != "" && _loc1_ != null)
         {
            Utils.playSound(_loc1_,SoundManager.TYPE_SFX);
         }
      }
      
      protected function createMC() : void
      {
         if(this.mDamageDealerCard != null)
         {
            this.mPoisonImage = new FSImage(Root.assets.getTexture("poison"));
            this.mPoisonImage.alignPivot();
         }
      }
      
      override protected function triggerParticleSystem() : void
      {
         if(mParticleSystem != null)
         {
            mParticleSystem.x = mAttachedToComponent.width / 2;
            mParticleSystem.y = mAttachedToComponent.height / 3;
            if(mAttachedToComponent is FSUnit)
            {
               if(FSUnit(mAttachedToComponent).getAbsAnimsLayer() != null)
               {
                  FSUnit(mAttachedToComponent).getAbsAnimsLayer().addChild(mParticleSystem);
               }
            }
            else
            {
               addChild(mParticleSystem);
            }
            Starling.juggler.add(mParticleSystem);
            mParticleSystem.start();
         }
      }
      
      override protected function triggerExtraGraphicsTweening() : void
      {
         super.triggerExtraGraphicsTweening();
         this.performPoisonAnims();
      }
      
      protected function performPoisonAnims() : void
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
         if(mAttachedToComponent != null)
         {
            _loc5_ = Number(mAttachedToComponent.width);
            _loc6_ = Number(mAttachedToComponent.height);
            _loc7_ = false;
            if(mAttachedToComponent is FSCard)
            {
               if(FSCard(mAttachedToComponent).hasAnimatedBG() && Boolean(FSCard(mAttachedToComponent).getBGAnimated()))
               {
                  _loc5_ = FSCard(mAttachedToComponent).getBGAnimated().width;
                  _loc6_ = FSCard(mAttachedToComponent).getBGAnimated().height;
               }
               else if(FSCard(mAttachedToComponent).getBG())
               {
                  _loc5_ = FSCard(mAttachedToComponent).getBG().width;
                  _loc6_ = FSCard(mAttachedToComponent).getBG().height;
               }
               else
               {
                  _loc5_ = Number(mAttachedToComponent.width);
                  _loc6_ = Number(mAttachedToComponent.height);
               }
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
               _loc2_ = mAttachedToComponent.parent.y + _loc6_;
            }
            else
            {
               _loc1_ = Number(mAttachedToComponent.x);
               _loc2_ = Number(mAttachedToComponent.y);
            }
            if(this.mDamageDealerCard)
            {
               if(this.mDamageDealerCard is FSPower)
               {
                  _loc10_ = this.mDamageDealerCard.isEnemyCard() ? InstanceMng.getBattleEngine().getBattleScreen().getOpponentPortrait() : InstanceMng.getBattleEngine().getBattleScreen().getOwnerPortrait();
                  _loc3_ = this.mDamageDealerCard.isEnemyCard() ? _loc10_.x + _loc10_.width / 2 : _loc10_.x + _loc10_.width / 2;
                  _loc4_ = this.mDamageDealerCard.isEnemyCard() ? _loc10_.y + _loc10_.height / 2 : _loc10_.y + _loc10_.height / 2;
               }
               else
               {
                  _loc3_ = this.mDamageDealerCard.x;
                  _loc4_ = this.mDamageDealerCard.y + _loc6_;
               }
               this.setupAnimOrientation(_loc7_,_loc3_,_loc4_,_loc1_,_loc2_);
               _loc9_ = this.mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo();
               _loc4_ = _loc9_ ? _loc4_ - this.mDamageDealerCard.height / 2 : _loc4_ + this.mDamageDealerCard.height / 2;
            }
            if(this.mPoisonImage)
            {
               this.mPoisonImage.x = _loc3_;
               this.mPoisonImage.y = _loc4_;
            }
            _loc8_ = new FSCoordinate(_loc1_,_loc2_);
            this.performMCTransition(_loc8_);
         }
      }
      
      protected function performMCTransition(param1:FSCoordinate) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(Boolean(this.mDamageDealerCard) && !this.mDamageDealerCard.isDefeated())
         {
            _loc2_ = this.mAbility.getAbilityDef().getAnimDuration();
            _loc2_ = !isNaN(_loc2_) && _loc2_ > 0 ? _loc2_ : 1;
            _loc3_ = _loc2_ * Config.getConfig().getDefaultGeneralSpeedFactor();
            InstanceMng.getCurrentScreen().addChild(this.mPoisonImage);
            SpecialFX.createTransition(this.mPoisonImage,param1,_loc3_,0,this.onAnimArrivedTarget,[this.mPoisonImage],Linear.easeOut);
         }
      }
      
      protected function setupAnimOrientation(param1:Boolean, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         if(this.mPoisonImage)
         {
            this.mPoisonImage.alignPivot();
            _loc6_ = this.mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo();
            if(!_loc6_)
            {
               this.mPoisonImage.scaleY = -1;
            }
            _loc7_ = Utils.getAngle(param2,param3,param4,param5);
            _loc7_ = _loc7_ - (_loc6_ ? 90 : 270);
            if(_loc6_)
            {
               this.mPoisonImage.rotation = deg2rad(_loc7_);
            }
            else
            {
               this.mPoisonImage.rotation = deg2rad(_loc7_);
            }
         }
      }
      
      protected function onAnimArrivedTarget(param1:FSImage) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      override public function dispose() : void
      {
         this.mAbility = null;
         this.mDamageDealerCard = null;
         if(this.mPoisonImage)
         {
            this.mPoisonImage.removeFromParent();
            this.mPoisonImage.destroy();
         }
         this.mPoisonImage = null;
         super.dispose();
      }
   }
}

