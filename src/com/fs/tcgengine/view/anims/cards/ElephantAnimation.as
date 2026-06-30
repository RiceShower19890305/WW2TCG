package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   
   public class ElephantAnimation extends CardAnimation
   {
      
      private static const FOOT_TOP:int = 0;
      
      private static const FOOT_BOT:int = 1;
      
      private static const ELEPHANT_STEP_IMAGE:String = "elephant_step";
      
      private static const ELEPHANT_STEP_DUST_IMAGE:String = "elephant_step_dust";
      
      private static const ELEPHANT_BUFF:String = "buff_elephant";
      
      public static const STAGE_WIDTH:int = Starling.current.stage.stageWidth;
      
      public static const STAGE_HEIGHT:int = Starling.current.stage.stageHeight;
      
      protected var mAbility:Ability;
      
      protected var mDamageDealerCard:FSCard;
      
      private var mElephantImageVector:Vector.<FSImage>;
      
      private var mElephantDustImageVector:Vector.<FSImage>;
      
      private var mElephantBuff:FSImage;
      
      private var mIsBFVersion:Boolean;
      
      public function ElephantAnimation(param1:Ability, param2:FSCard, param3:Boolean = false)
      {
         super();
         this.mAbility = param1;
         this.mDamageDealerCard = param2;
         this.mIsBFVersion = param3;
         setIsPermanent(true);
         var _loc4_:String = !param3 ? AbilitiesMng.ELEPHANT_ANIM : AbilitiesMng.ELEPHANT_BF_ANIM;
         setAbilityItBelongsTo(_loc4_);
      }
      
      override public function setup(param1:*, param2:String = "", param3:FSImage = null) : void
      {
         this.createBuff();
         this.createImageVector();
         super.setup(param1,param2,param3);
      }
      
      private function createBuff() : void
      {
         if(this.mDamageDealerCard != null && this.mElephantBuff == null)
         {
            this.mElephantBuff = new FSImage(Root.assets.getTexture(ELEPHANT_BUFF));
            this.mElephantBuff.alignPivot();
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
      
      protected function createImageVector() : void
      {
         var _loc1_:FSImage = null;
         var _loc2_:FSImage = null;
         var _loc3_:FSImage = null;
         var _loc4_:FSImage = null;
         if(this.mDamageDealerCard != null)
         {
            if(this.mElephantImageVector == null)
            {
               this.mElephantImageVector = new Vector.<FSImage>();
            }
            _loc1_ = new FSImage(Root.assets.getTexture(ELEPHANT_STEP_IMAGE));
            _loc2_ = new FSImage(Root.assets.getTexture(ELEPHANT_STEP_IMAGE));
            _loc1_.alignPivot();
            _loc2_.alignPivot();
            this.mElephantImageVector.push(_loc1_);
            this.mElephantImageVector.push(_loc2_);
            if(this.mElephantDustImageVector == null)
            {
               this.mElephantDustImageVector = new Vector.<FSImage>();
            }
            _loc3_ = new FSImage(Root.assets.getTexture(ELEPHANT_STEP_DUST_IMAGE));
            _loc4_ = new FSImage(Root.assets.getTexture(ELEPHANT_STEP_DUST_IMAGE));
            _loc3_.alignPivot();
            _loc4_.alignPivot();
            this.mElephantDustImageVector.push(_loc3_);
            this.mElephantDustImageVector.push(_loc4_);
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
         this.performElephantAnims();
      }
      
      protected function performElephantAnims() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc4_:FSImage = null;
         var _loc5_:FSImage = null;
         var _loc6_:FSImage = null;
         var _loc7_:FSImage = null;
         var _loc3_:Boolean = this.mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo();
         _loc1_ = this.mIsBFVersion ? STAGE_WIDTH * 0.45 : STAGE_WIDTH * 0.2;
         _loc2_ = _loc3_ ? STAGE_HEIGHT * 0.2 : STAGE_HEIGHT * 0.6;
         _loc4_ = this.getFeet(FOOT_TOP);
         _loc5_ = this.getFeet(FOOT_BOT);
         _loc4_.alignPivot();
         _loc4_.x = _loc1_;
         _loc4_.y = _loc2_;
         _loc4_.visible = true;
         _loc5_.x = _loc1_ + _loc4_.width;
         _loc5_.y = _loc2_ + _loc5_.height;
         _loc5_.alignPivot();
         _loc5_.visible = false;
         this.addVectorImageToCurrentScreen(this.mElephantImageVector);
         _loc6_ = this.getFeetDust(FOOT_TOP);
         _loc7_ = this.getFeetDust(FOOT_BOT);
         _loc6_.alignPivot();
         _loc6_.x = _loc4_.x;
         _loc6_.y = _loc4_.y;
         _loc7_.alignPivot();
         _loc7_.x = _loc7_.x;
         _loc7_.y = _loc7_.y;
         this.addVectorImageToCurrentScreen(this.mElephantDustImageVector);
         this.mElephantBuff.x = this.mDamageDealerCard.x;
         this.mElephantBuff.y = this.mDamageDealerCard.y;
         this.performMCTransition();
      }
      
      protected function performMCTransition() : void
      {
         var _loc1_:Number = NaN;
         if(this.mElephantBuff)
         {
            this.addImageToCurrentScreen(this.mElephantBuff);
            SpecialFX.tweenToAlpha(this.mElephantBuff,0.999,1,0,this.onCompleteAlpha);
            if(Boolean(this.mDamageDealerCard) && !this.mDamageDealerCard.isDefeated())
            {
               if(Boolean(this.mAbility) && Boolean(this.mAbility.getAbilityDef()))
               {
                  _loc1_ = this.getStepToStepTime();
                  FSDebug.debugTrace("Trans speed: " + _loc1_);
                  if(this.getFeet(FOOT_TOP).x < STAGE_WIDTH && this.getFeet(FOOT_BOT).x < STAGE_WIDTH)
                  {
                     setTimeout(this.moveFeetElephant,_loc1_);
                  }
                  else
                  {
                     this.onAnimArrivedTarget();
                  }
               }
            }
         }
      }
      
      protected function getStepToStepTime() : Number
      {
         var _loc1_:Number = this.mAbility.getAbilityDef().getAnimDuration();
         _loc1_ = !isNaN(_loc1_) && _loc1_ > 0 ? _loc1_ / 2 : 1.27;
         return _loc1_ / 1.5 * Config.getConfig().getDefaultGeneralSpeedFactor();
      }
      
      private function onCompleteAlpha() : void
      {
         if(this.mElephantBuff)
         {
            this.mElephantBuff.removeFromParent();
            this.mElephantBuff.destroy();
            this.mElephantBuff = null;
         }
      }
      
      private function moveFeetElephant() : void
      {
         if(this.getFeet(FOOT_TOP).visible)
         {
            this.moveFoot(true);
         }
         else
         {
            this.moveFoot(false);
         }
      }
      
      protected function moveFoot(param1:Boolean) : void
      {
         var _loc2_:int = param1 ? FOOT_BOT : FOOT_TOP;
         var _loc3_:int = param1 ? FOOT_TOP : FOOT_BOT;
         TweenMax.killTweensOf(this.getFeet(_loc2_));
         TweenMax.killTweensOf(this.getFeetDust(_loc2_));
         this.getFeet(_loc3_).visible = false;
         this.getFeetDust(_loc3_).visible = false;
         this.getFeet(_loc2_).x = this.getFeet(_loc3_).x + this.getFeet(_loc2_).width * 1.2;
         this.getFeetDust(_loc2_).x = this.getFeet(_loc2_).x;
         this.getFeetDust(_loc2_).y = this.getFeet(_loc2_).y;
         this.getFeet(_loc2_).visible = true;
         this.getFeetDust(_loc2_).visible = true;
         Utils.requestScreenShake(0.3,3);
         SpecialFX.createZoomAlphaTween(this.getFeetDust(_loc2_),0.5,0.999,0.001,1,2);
         SpecialFX.createZoomAlphaTween(this.getFeet(_loc2_),0.5,0.999,0.001,1,0.8,null,this.onZoomComplete);
      }
      
      private function onZoomComplete() : void
      {
         this.performMCTransition();
      }
      
      protected function addVectorImageToCurrentScreen(param1:Vector.<FSImage>) : void
      {
         if(param1 != null && param1.length > 0 && Boolean(InstanceMng.getCurrentScreen()))
         {
            InstanceMng.getCurrentScreen().addChild(param1[FOOT_TOP]);
            InstanceMng.getCurrentScreen().addChild(param1[FOOT_BOT]);
         }
      }
      
      protected function addImageToCurrentScreen(param1:FSImage) : void
      {
         if(param1 != null && Boolean(InstanceMng.getCurrentScreen()))
         {
            InstanceMng.getCurrentScreen().addChild(param1);
         }
      }
      
      protected function onAnimArrivedTarget() : void
      {
         if(this.mElephantImageVector)
         {
            this.mElephantImageVector[FOOT_TOP].removeFromParent();
            this.mElephantImageVector[FOOT_TOP].destroy();
            this.mElephantImageVector[FOOT_TOP] = null;
            this.mElephantImageVector[FOOT_BOT].removeFromParent();
            this.mElephantImageVector[FOOT_BOT].destroy();
            this.mElephantImageVector[FOOT_BOT] = null;
            Utils.destroyArray(this.mElephantImageVector);
            this.mElephantImageVector = null;
         }
         if(this.mElephantDustImageVector)
         {
            this.mElephantDustImageVector[FOOT_TOP].removeFromParent();
            this.mElephantDustImageVector[FOOT_TOP].destroy();
            this.mElephantDustImageVector[FOOT_TOP] = null;
            this.mElephantDustImageVector[FOOT_BOT].removeFromParent();
            this.mElephantDustImageVector[FOOT_BOT].destroy();
            this.mElephantDustImageVector[FOOT_BOT] = null;
            Utils.destroyArray(this.mElephantDustImageVector);
            this.mElephantDustImageVector = null;
         }
      }
      
      private function getFeet(param1:int) : FSImage
      {
         return this.mElephantImageVector[param1];
      }
      
      private function getFeetDust(param1:int) : FSImage
      {
         return this.mElephantDustImageVector[param1];
      }
      
      override public function dispose() : void
      {
         this.mAbility = null;
         this.mDamageDealerCard = null;
         Utils.destroyArray(this.mElephantImageVector);
         this.mElephantImageVector = null;
         Utils.destroyArray(this.mElephantDustImageVector);
         this.mElephantDustImageVector = null;
         if(this.mElephantBuff)
         {
            this.mElephantBuff.removeFromParent();
         }
         this.mElephantBuff = null;
         super.dispose();
      }
   }
}

