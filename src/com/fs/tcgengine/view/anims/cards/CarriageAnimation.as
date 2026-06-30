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
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import starling.core.Starling;
   import starling.events.Event;
   
   public class CarriageAnimation extends CardAnimation
   {
      
      private static const CARRIAGE_IMAGE:String = "carriage";
      
      private static const CARRIAGE_TRACE_IMAGE:String = "carriage_trace";
      
      private static const CARRIAGE_DUST_IMAGE:String = "carriage_dust";
      
      private static const CARRIAGE_BUFF:String = "buff_carriage";
      
      private static const STAGE_WIDTH:int = Starling.current.stage.stageWidth;
      
      private static const STAGE_HEIGHT:int = Starling.current.stage.stageHeight;
      
      protected var mAbility:Ability;
      
      protected var mDamageDealerCard:FSCard;
      
      private var mCarriageImage:FSImage;
      
      private var mCarriageTraceImage:FSImage;
      
      private var mCarriageDustImageTop:FSImage;
      
      private var mCarriageDustImageBot:FSImage;
      
      private var mCarriageBuff:FSImage;
      
      private var mShakeRequested:Boolean = false;
      
      public function CarriageAnimation(param1:Ability, param2:FSCard)
      {
         super();
         this.mAbility = param1;
         this.mDamageDealerCard = param2;
         setIsPermanent(true);
         setAbilityItBelongsTo(AbilitiesMng.CARRIAGE_ANIM);
      }
      
      override public function setup(param1:*, param2:String = "", param3:FSImage = null) : void
      {
         this.createBuff();
         this.createImages();
         super.setup(param1,param2,param3);
      }
      
      private function createBuff() : void
      {
         if(this.mDamageDealerCard != null && this.mCarriageBuff == null)
         {
            this.mCarriageBuff = new FSImage(Root.assets.getTexture(CARRIAGE_BUFF));
            this.mCarriageBuff.alignPivot();
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
      
      protected function createImages() : void
      {
         if(this.mDamageDealerCard != null)
         {
            if(this.mCarriageImage == null)
            {
               this.mCarriageImage = new FSImage(Root.assets.getTexture(CARRIAGE_IMAGE));
               this.mCarriageImage.alignPivot();
            }
            if(Boolean(this.mCarriageImage) && this.mCarriageTraceImage == null)
            {
               this.mCarriageTraceImage = new FSImage(Root.assets.getTexture(CARRIAGE_TRACE_IMAGE));
               this.mCarriageTraceImage.alignPivot();
            }
            if(Boolean(this.mCarriageImage && this.mCarriageTraceImage) && Boolean(this.mCarriageDustImageTop == null) && this.mCarriageDustImageBot == null)
            {
               this.mCarriageDustImageTop = new FSImage(Root.assets.getTexture(CARRIAGE_DUST_IMAGE));
               this.mCarriageDustImageBot = new FSImage(Root.assets.getTexture(CARRIAGE_DUST_IMAGE));
               this.mCarriageDustImageTop.alignPivot();
               this.mCarriageDustImageBot.alignPivot();
            }
            this.addImageToCurrentScreen(this.mCarriageDustImageTop);
            this.addImageToCurrentScreen(this.mCarriageDustImageBot);
            this.addImageToCurrentScreen(this.mCarriageTraceImage);
            this.addImageToCurrentScreen(this.mCarriageImage);
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
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.triggerExtraGraphicsTweening();
         this.performCarriageAnims();
      }
      
      protected function performCarriageAnims() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = this.mDamageDealerCard.getParentUserBattleInfo().isOwnerBattleInfo();
         _loc1_ = STAGE_WIDTH * 0.2;
         _loc2_ = _loc3_ ? STAGE_HEIGHT * 0.2 : STAGE_HEIGHT * 0.6;
         this.mCarriageTraceImage.x = _loc1_ - this.mCarriageTraceImage.width * 0.3;
         this.mCarriageTraceImage.y = _loc2_;
         this.mCarriageDustImageTop.x = this.mCarriageTraceImage.x + this.mCarriageDustImageTop.width * 0.2;
         this.mCarriageDustImageTop.y = this.mCarriageTraceImage.y - this.mCarriageDustImageTop.height * 0.4;
         this.mCarriageDustImageBot.x = this.mCarriageTraceImage.x + this.mCarriageDustImageBot.width * 0.2;
         this.mCarriageDustImageBot.y = this.mCarriageTraceImage.y + this.mCarriageDustImageBot.height * 0.5;
         this.mCarriageImage.x = _loc1_;
         this.mCarriageImage.y = _loc2_;
         this.mCarriageBuff.x = this.mDamageDealerCard.x;
         this.mCarriageBuff.y = this.mDamageDealerCard.y;
         this.performMCTransition();
      }
      
      protected function performMCTransition() : void
      {
         var _loc1_:FSCoordinate = null;
         var _loc2_:FSCoordinate = null;
         var _loc3_:FSCoordinate = null;
         var _loc4_:FSCoordinate = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(!this.mDamageDealerCard.isDefeated())
         {
            this.addImageToCurrentScreen(this.mCarriageBuff);
            SpecialFX.tweenToAlpha(this.mCarriageBuff,0.999,1,0,this.onCompleteAlpha);
            if(Boolean(this.mCarriageImage) && this.mCarriageImage.x < STAGE_WIDTH)
            {
               SpecialFX.createZoomAlphaTween(this.mCarriageDustImageBot,1,0.899,0.001,1,4,null,this.onAlphaBotComplete);
               SpecialFX.createZoomAlphaTween(this.mCarriageDustImageTop,0.5,0.899,0.001,1,4,null,this.onAlphaTopComplete);
               _loc1_ = new FSCoordinate(this.mCarriageImage.x + this.mCarriageTraceImage.width + STAGE_WIDTH,this.mCarriageImage.y);
               _loc2_ = new FSCoordinate(this.mCarriageTraceImage.x + this.mCarriageTraceImage.width + STAGE_WIDTH,this.mCarriageTraceImage.y);
               _loc3_ = new FSCoordinate(this.mCarriageImage.x + this.mCarriageTraceImage.width + STAGE_WIDTH,this.mCarriageDustImageBot.y);
               _loc4_ = new FSCoordinate(this.mCarriageImage.x + this.mCarriageTraceImage.width + STAGE_WIDTH,this.mCarriageDustImageTop.y);
               _loc5_ = this.mAbility.getAbilityDef().getAnimDuration();
               _loc5_ = !isNaN(_loc5_) && _loc5_ > 0 ? _loc5_ : 3.6;
               _loc6_ = _loc5_ * Config.getConfig().getDefaultGeneralSpeedFactor();
               SpecialFX.createTransition(this.mCarriageImage,_loc1_,_loc6_,0,this.onTransitionComplete,null,Linear.easeNone);
               SpecialFX.createTransition(this.mCarriageTraceImage,_loc2_,_loc6_,0,null,null,Linear.easeNone);
               this.requestShake(6,1.5);
            }
            else
            {
               this.onAnimArrivedTarget();
            }
         }
      }
      
      private function onAlphaBotComplete() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this.mCarriageImage) && this.mCarriageImage.x < STAGE_WIDTH)
         {
            _loc1_ = this.mCarriageTraceImage.x;
            this.mCarriageDustImageBot.x = _loc1_;
            SpecialFX.createZoomAlphaTween(this.mCarriageDustImageBot,1,0.899,0.001,1,4,null,this.onAlphaBotComplete);
         }
      }
      
      private function onAlphaTopComplete() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this.mCarriageImage) && this.mCarriageImage.x < STAGE_WIDTH)
         {
            _loc1_ = this.mCarriageTraceImage.x;
            this.mCarriageDustImageTop.x = _loc1_;
            SpecialFX.createZoomAlphaTween(this.mCarriageDustImageTop,1,0.899,0.001,1,4,null,this.onAlphaTopComplete);
         }
      }
      
      private function onTransitionComplete() : void
      {
         this.performMCTransition();
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
         if(this.mCarriageImage)
         {
            TweenMax.killTweensOf(this.mCarriageImage);
            this.mCarriageImage.removeFromParent();
            this.mCarriageImage.destroy();
            this.mCarriageImage = null;
         }
         if(this.mCarriageTraceImage)
         {
            TweenMax.killTweensOf(this.mCarriageTraceImage);
            this.mCarriageTraceImage.removeFromParent();
            this.mCarriageTraceImage.destroy();
            this.mCarriageTraceImage = null;
         }
         if(this.mCarriageDustImageBot)
         {
            TweenMax.killTweensOf(this.mCarriageDustImageBot);
            this.mCarriageDustImageBot.removeFromParent();
            this.mCarriageDustImageBot.destroy();
            this.mCarriageDustImageBot = null;
         }
         if(this.mCarriageDustImageTop)
         {
            TweenMax.killTweensOf(this.mCarriageDustImageTop);
            this.mCarriageDustImageTop.removeFromParent();
            this.mCarriageDustImageTop.destroy();
            this.mCarriageDustImageTop = null;
         }
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         if(this.mShakeRequested)
         {
            this.shake(3);
         }
      }
      
      public function shake(param1:Number = 1) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Number = Utils.randomNumber(-param1,param1);
         var _loc3_:Number = Utils.randomNumber(-param1,param1);
         if(this.mCarriageImage)
         {
            if(this.mCarriageImage.x + _loc2_ > this.mCarriageImage.x - param1 && this.mCarriageImage.x + _loc2_ < this.mCarriageImage.x + param1)
            {
               this.mCarriageImage.x += _loc2_;
            }
            if(this.mCarriageImage.y + _loc3_ > this.mCarriageImage.y - param1 && this.mCarriageImage.y + _loc3_ < this.mCarriageImage.y + param1)
            {
               this.mCarriageImage.y += _loc3_;
            }
         }
      }
      
      public function requestShake(param1:Number = 1, param2:Number = 1) : void
      {
         this.mShakeRequested = true;
         TweenMax.killDelayedCallsTo(this.requestShake);
         TweenMax.delayedCall(param1,this.stopShake);
         this.shake(param2);
      }
      
      private function stopShake() : void
      {
         this.mShakeRequested = false;
      }
      
      private function onCompleteAlpha() : void
      {
         if(this.mCarriageBuff)
         {
            this.mCarriageBuff.removeFromParent();
            this.mCarriageBuff.destroy();
            this.mCarriageBuff = null;
         }
      }
      
      override public function dispose() : void
      {
         this.mAbility = null;
         this.mDamageDealerCard = null;
         if(this.mCarriageImage)
         {
            this.mCarriageImage.removeFromParent();
            this.mCarriageImage.destroy();
         }
         this.mCarriageImage = null;
         if(this.mCarriageTraceImage)
         {
            this.mCarriageTraceImage.removeFromParent();
            this.mCarriageTraceImage.destroy();
         }
         this.mCarriageTraceImage = null;
         if(this.mCarriageDustImageTop)
         {
            this.mCarriageDustImageTop.removeFromParent();
            this.mCarriageDustImageTop.destroy();
         }
         this.mCarriageDustImageTop = null;
         if(this.mCarriageBuff)
         {
            this.mCarriageBuff.removeFromParent();
            this.mCarriageBuff.destroy();
         }
         this.mCarriageBuff = null;
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.dispose();
      }
   }
}

