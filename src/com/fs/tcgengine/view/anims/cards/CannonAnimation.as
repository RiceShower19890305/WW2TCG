package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.easing.Linear;
   import starling.utils.deg2rad;
   
   public class CannonAnimation extends CardAnimation
   {
      
      private static const CANNON_IMAGE:String = "cannonball";
      
      protected var mAbility:Ability;
      
      protected var mDamageDealerCard:FSCard;
      
      private var mCannonImage:FSImage;
      
      public function CannonAnimation(param1:Ability, param2:FSCard)
      {
         super();
         this.mAbility = param1;
         this.mDamageDealerCard = param2;
         setIsPermanent(true);
         setAbilityItBelongsTo(AbilitiesMng.CANNON_ANIM);
      }
      
      override public function setup(param1:*, param2:String = "", param3:FSImage = null) : void
      {
         this.createArrowImage();
         super.setup(param1,param2,param3);
      }
      
      private function createArrowImage() : void
      {
         if(this.mDamageDealerCard != null && this.mCannonImage == null)
         {
            this.mCannonImage = new FSImage(Root.assets.getTexture(CANNON_IMAGE));
            this.mCannonImage.alignPivot();
         }
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
         var _loc9_:FSBattleScreen = null;
         var _loc10_:Boolean = false;
         var _loc11_:FSBattlefieldUserPortrait = null;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
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
               _loc1_ = mAttachedToComponent.parent.x + _loc5_ * 0.3;
               _loc2_ = mAttachedToComponent.parent.y + _loc6_ / 2;
            }
            if(this.mDamageDealerCard.getType() == FSCard.TYPE_POWER || Boolean(this.mAbility) && Boolean(this.mAbility.isAbilityPassive()))
            {
               _loc9_ = FSBattleScreen(InstanceMng.getCurrentScreen());
               _loc10_ = this.mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo();
               _loc11_ = _loc10_ ? _loc9_.getOwnerPortrait() : _loc9_.getOpponentPortrait();
               _loc3_ = _loc11_.x + _loc11_.width * 0.2;
               _loc4_ = _loc11_.y;
            }
            this.setupAnimOrientation(_loc7_,_loc3_,_loc4_,_loc1_,_loc2_);
            this.mCannonImage.x = _loc3_;
            this.mCannonImage.y = _loc4_;
            _loc8_ = new FSCoordinate(_loc1_,_loc2_);
            this.performMCTransition(_loc8_);
         }
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
            this.addImageToCurrentScreen(this.mCannonImage);
            SpecialFX.createTransition(this.mCannonImage,param1,_loc3_,0,this.onImageArrivedTarget,[this.mCannonImage],Linear.easeOut);
         }
      }
      
      protected function setupAnimOrientation(param1:Boolean, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         if(this.mCannonImage)
         {
            this.mCannonImage.alignPivot();
            _loc6_ = this.mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo();
            if(!_loc6_)
            {
               this.mCannonImage.scaleY = -1;
            }
            _loc7_ = Utils.getAngle(param2,param3,param4,param5);
            _loc7_ = _loc7_ - (_loc6_ ? 90 : 270);
            this.mCannonImage.rotation = deg2rad(_loc7_);
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
      }
      
      override public function dispose() : void
      {
         this.mAbility = null;
         this.mDamageDealerCard = null;
         if(this.mCannonImage)
         {
            this.mCannonImage.removeFromParent();
            this.mCannonImage.destroy();
         }
         this.mCannonImage = null;
         super.dispose();
      }
   }
}

