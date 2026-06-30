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
   
   public class AxeAnimation extends CardAnimation
   {
      
      private static const AXE_BUFF:String = "buff_axe";
      
      private static const AXE_IMAGE:String = "axe";
      
      protected var mAbility:Ability;
      
      protected var mDamageDealerCard:FSCard;
      
      private var mAxeImage:FSImage;
      
      private var mAxeBuff:FSImage;
      
      private var mRotationRight:Boolean;
      
      public function AxeAnimation(param1:Ability, param2:FSCard)
      {
         super();
         this.mAbility = param1;
         this.mDamageDealerCard = param2;
         setIsPermanent(true);
         setAbilityItBelongsTo(AbilitiesMng.AXE_ANIM);
      }
      
      override public function setup(param1:*, param2:String = "", param3:FSImage = null) : void
      {
         this.createBuff();
         this.createImage();
         super.setup(param1,param2,param3);
      }
      
      private function createBuff() : void
      {
         if(this.mDamageDealerCard != null && this.mAxeBuff == null)
         {
            this.mAxeBuff = new FSImage(Root.assets.getTexture(AXE_BUFF));
            this.mAxeBuff.alignPivot();
         }
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
      
      protected function createImage() : void
      {
         if(this.mDamageDealerCard != null)
         {
            this.mAxeImage = new FSImage(Root.assets.getTexture(AXE_IMAGE));
            this.mAxeImage.alignPivot();
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
         this.performAxeAnims();
      }
      
      protected function performAxeAnims() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc9_:FSBattlefieldUserPortrait = null;
         var _loc5_:Number = Number(mAttachedToComponent.width);
         var _loc6_:Number = Number(mAttachedToComponent.height);
         var _loc7_:Boolean = false;
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
            _loc2_ = Number(mAttachedToComponent.parent.y);
         }
         else
         {
            _loc1_ = mAttachedToComponent.x + _loc5_ * 0.3;
            _loc2_ = mAttachedToComponent.y - _loc6_ * 0.2;
         }
         if(mAttachedToComponent != null && mAttachedToComponent.parent != null && mAttachedToComponent.parent is FSBattlefieldUserPortrait)
         {
            this.mAxeBuff.x = _loc3_ - this.mAxeBuff.width * 0.3;
            this.mAxeBuff.y = _loc4_ - this.mAxeBuff.height * 0.4;
         }
         else
         {
            this.mAxeBuff.x = _loc3_;
            this.mAxeBuff.y = _loc4_ - this.mAxeBuff.height * 0.4;
         }
         if(this.mDamageDealerCard is FSPower)
         {
            _loc9_ = this.mDamageDealerCard.isEnemyCard() ? InstanceMng.getBattleEngine().getBattleScreen().getOpponentPortrait() : InstanceMng.getBattleEngine().getBattleScreen().getOwnerPortrait();
            _loc3_ = this.mDamageDealerCard.isEnemyCard() ? _loc9_.x + _loc9_.width / 2 : _loc9_.x + _loc9_.width / 2;
            _loc4_ = this.mDamageDealerCard.isEnemyCard() ? _loc9_.y + _loc9_.height / 2 : _loc9_.y + _loc9_.height / 2;
         }
         else
         {
            _loc3_ = this.mDamageDealerCard.x;
            _loc4_ = this.mDamageDealerCard.y + _loc6_ / 2;
         }
         this.setupAnimOrientation(_loc7_,_loc3_,_loc4_,_loc1_,_loc2_);
         this.mAxeImage.x = _loc3_;
         this.mAxeImage.y = _loc4_ - this.mAxeImage.height * 0.4;
         var _loc8_:FSCoordinate = new FSCoordinate(_loc1_,_loc2_);
         this.performMCTransition(_loc8_);
      }
      
      protected function performMCTransition(param1:FSCoordinate) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(!this.mDamageDealerCard.isDefeated())
         {
            _loc2_ = this.mAbility.getAbilityDef().getAnimDuration();
            _loc2_ = !isNaN(_loc2_) && _loc2_ > 0 ? _loc2_ : 1;
            _loc3_ = _loc2_ * Config.getConfig().getDefaultGeneralSpeedFactor();
            this.addImageToCurrentScreen(this.mAxeBuff);
            SpecialFX.tweenToAlpha(this.mAxeBuff,0.999,1,0,this.onCompleteAlpha);
            this.addImageToCurrentScreen(this.mAxeImage);
            SpecialFX.createTransition(this.mAxeImage,param1,_loc3_,0,this.onAnimArrivedTarget,[this.mAxeImage],Linear.easeOut);
            if(this.mRotationRight)
            {
               SpecialFX.createRotation(this.mAxeImage,370,0.4,0,null,null,Linear.easeNone,-1);
            }
            else
            {
               SpecialFX.createRotation(this.mAxeImage,-370,0.4,0,null,null,Linear.easeNone,-1);
            }
         }
      }
      
      private function onCompleteAlpha() : void
      {
         if(this.mAxeBuff)
         {
            this.mAxeBuff.removeFromParent();
            this.mAxeBuff.destroy();
            this.mAxeBuff = null;
         }
      }
      
      protected function addImageToCurrentScreen(param1:FSImage) : void
      {
         if(param1 != null && Boolean(InstanceMng.getCurrentScreen()))
         {
            InstanceMng.getCurrentScreen().addChild(param1);
         }
      }
      
      protected function setupAnimOrientation(param1:Boolean, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         if(this.mAxeImage)
         {
            this.mAxeImage.alignPivot();
            _loc6_ = this.mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo();
            if(!_loc6_)
            {
               this.mAxeImage.scaleY = -1;
            }
            _loc7_ = Utils.getAngle(param2,param3,param4,param5);
            _loc7_ = _loc7_ - (_loc6_ ? 90 : 270);
            if(_loc6_ && _loc7_ > 0)
            {
               this.mRotationRight = true;
            }
            else
            {
               this.mRotationRight = false;
            }
            if(_loc6_)
            {
               this.mAxeImage.rotation = deg2rad(_loc7_);
            }
            else
            {
               this.mAxeImage.rotation = deg2rad(_loc7_);
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
         if(this.mAxeImage)
         {
            this.mAxeImage.removeFromParent();
            this.mAxeImage.destroy();
         }
         this.mAxeImage = null;
         if(this.mAxeBuff)
         {
            this.mAxeBuff.removeFromParent();
            this.mAxeBuff.destroy();
         }
         this.mAxeBuff = null;
         super.dispose();
      }
   }
}

