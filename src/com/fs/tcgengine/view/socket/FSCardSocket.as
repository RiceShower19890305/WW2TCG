package com.fs.tcgengine.view.socket
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.rules.BackgroundDef;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSItemTargetedAnim;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import starling.extensions.ColorArgb;
   
   public class FSCardSocket extends Component
   {
      
      private const TWEEN_FX_SPEED:Number = 0.5;
      
      protected var mBGImage:FSImage;
      
      protected var mBGImageForHighlights:FSImage;
      
      protected var mScaleFactor:Number;
      
      private var mIsEmpty:Boolean;
      
      private var mIsEnemy:Boolean;
      
      private var mRowIndex:int;
      
      private var mColumnIndex:int;
      
      protected var mIsOnBattlefield:Boolean;
      
      protected var mParentCard:FSCard;
      
      private var mBFCoords:FSCoordinate;
      
      private var mRowsAmount:int;
      
      private var mSocketIndex:int;
      
      private var mHighlightIsParticle:Boolean = true;
      
      protected var mItemTargetedAnim:FSItemTargetedAnim;
      
      public function FSCardSocket()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.mIsEmpty = true;
         this.mScaleFactor = 1;
         this.setRowIndex(0);
         this.setColumnIndex(0);
         this.mIsOnBattlefield = false;
         this.mParentCard = null;
      }
      
      public function setupSocket(param1:Boolean, param2:Boolean, param3:int, param4:int, param5:int, param6:int, param7:Boolean = false) : void
      {
         this.mIsEnemy = param1;
         this.mIsOnBattlefield = param2;
         this.setRowIndex(param3);
         this.setColumnIndex(param4);
         this.mSocketIndex = param6;
         this.setBFCoords(param3,param4);
         this.mRowsAmount = param5;
         this.loadSocketCard(param7);
         alignPivot();
      }
      
      private function loadSocketCard(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(param1)
         {
            this.createBGForSuggest();
         }
         else
         {
            this.createBG();
         }
         this.setupScale();
         if(this.mBGImage != null)
         {
            this.mBGImage.scaleX *= this.mScaleFactor;
            this.mBGImage.scaleY *= this.mScaleFactor;
            addChild(this.mBGImage);
         }
         if(this.mBGImageForHighlights != null)
         {
            this.mBGImageForHighlights.scaleX *= this.mScaleFactor;
            this.mBGImageForHighlights.scaleY *= this.mScaleFactor;
         }
      }
      
      protected function setupScale() : void
      {
         if(!this.mIsOnBattlefield)
         {
            this.mScaleFactor = Constants.OUT_OF_BATTLEFIELD_DEFAULT_FACTOR / 2;
         }
         else if(InstanceMng.getBattleEngine() != null && !InstanceMng.getBattleEngine().isPvPMatch())
         {
            this.mScaleFactor = Constants.BATTLEFIELD_DEFAULT_FACTOR;
            this.mScaleFactor = Config.getConfig().battleSocketScale();
         }
         if(InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().isPvPMatch() && this.mIsOnBattlefield)
         {
            this.mScaleFactor *= Config.getConfig().battleSocketPvPScale();
         }
      }
      
      protected function createBG() : void
      {
         var _loc1_:String = null;
         var _loc2_:BackgroundDef = null;
         if(this.mIsOnBattlefield && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc2_ = BackgroundDef(InstanceMng.getBackgroundDefMng().getDefBySku(FSBattleScreen(InstanceMng.getCurrentScreen()).getBGName()));
            if(_loc2_ != null && _loc2_.getSocketPrefix() != "" && _loc2_.getSocketPrefix() != null)
            {
               this.mBGImage = new FSImage(Root.assets.getTexture(_loc2_.getSocketPrefix() + "_off"));
               this.mBGImageForHighlights = new FSImage(Root.assets.getTexture(_loc2_.getSocketPrefix() + "_on"));
            }
            else
            {
               _loc1_ = Constants.SOCKET_CARD_ATTACHMENTS;
               this.mBGImage = new FSImage(Root.assets.getTexture(_loc1_));
               this.mBGImageForHighlights = new FSImage(Root.assets.getTexture(Constants.SOCKET_CARD_ATTACHMENTS));
               if(this.mBGImage)
               {
                  this.mBGImage.visible = !this.mIsOnBattlefield;
               }
            }
         }
         else
         {
            _loc1_ = Constants.SOCKET_ACTION_DECK;
            this.mBGImage = new FSImage(Root.assets.getTexture(_loc1_));
            this.mBGImageForHighlights = new FSImage(Root.assets.getTexture(Constants.SOCKET_CARD_ATTACHMENTS));
         }
      }
      
      private function createBGForSuggest() : void
      {
         this.mBGImage = new FSImage(Root.assets.getTexture(Constants.SOCKET_CARD_GLOW));
         visible = false;
      }
      
      public function isEmpty() : Boolean
      {
         return this.mIsEmpty;
      }
      
      public function setIsEmpty(param1:Boolean) : void
      {
         this.mIsEmpty = param1;
      }
      
      public function getIsEnemy() : Boolean
      {
         return this.mIsEnemy;
      }
      
      public function setIsEnemy(param1:Boolean) : void
      {
         this.mIsEnemy = param1;
      }
      
      public function getRowIndex() : int
      {
         return this.mRowIndex;
      }
      
      public function setRowIndex(param1:int) : void
      {
         this.mRowIndex = param1;
      }
      
      public function getCoordsString() : String
      {
         return "[" + this.mRowIndex + "," + this.mColumnIndex + "]";
      }
      
      public function getColumnIndex() : int
      {
         return this.mColumnIndex;
      }
      
      public function setColumnIndex(param1:int) : void
      {
         this.mColumnIndex = param1;
      }
      
      public function isBattlefieldSocket() : Boolean
      {
         return this.mIsOnBattlefield;
      }
      
      public function setIsOnBattlefield(param1:Boolean) : void
      {
         this.mIsOnBattlefield = param1;
      }
      
      public function getParentCard() : FSCard
      {
         return this.mParentCard;
      }
      
      public function setParentCard(param1:FSCard) : void
      {
         this.mParentCard = param1;
         this.setIsEmpty(param1 == null);
      }
      
      public function getBFCoords() : FSCoordinate
      {
         return this.mBFCoords;
      }
      
      public function setBFCoords(param1:int, param2:int) : void
      {
         this.mBFCoords = new FSCoordinate(param1,param2);
      }
      
      public function getBGImage() : FSImage
      {
         return this.mBGImage;
      }
      
      public function getBGImageForHighlights() : FSImage
      {
         return this.mBGImageForHighlights;
      }
      
      public function isSupportSocket() : Boolean
      {
         var _loc1_:int = this.getRowIndex();
         var _loc2_:Boolean = this.getIsEnemy() || this.mRowsAmount == 1 ? _loc1_ == 0 : _loc1_ == 1;
         var _loc3_:int = Config.IN_GAME_MAX_ROWS;
         return _loc3_ > 1 && _loc2_;
      }
      
      override public function activateHighlightTween(param1:uint = 65280, param2:Boolean = true, param3:Number = 1, param4:ColorArgb = null, param5:ColorArgb = null, param6:Boolean = false) : void
      {
         var _loc7_:FSCard = null;
         mHighlightRequested = true;
         if(this.mBGImageForHighlights)
         {
            TweenMax.killTweensOf(this.mBGImageForHighlights);
         }
         removeParticleSystem();
         TweenMax.killTweensOf(SpecialFX.tweenHighlightSocketToAlpha);
         if(!this.mIsEmpty)
         {
            _loc7_ = this.getParentCard();
            if(_loc7_ != null)
            {
               _loc7_.activateHighlightTween(param1);
            }
         }
         else
         {
            this.mBGImageForHighlights.alpha = 0.001;
            addChild(this.mBGImageForHighlights);
            SpecialFX.tweenToAlpha(this.mBGImageForHighlights,0.999,0.5,0);
            if(!this.mHighlightIsParticle)
            {
               this.mBGImageForHighlights.color = param1;
            }
         }
         if(this.mHighlightIsParticle)
         {
            this.activateSpecialHighlightParticle(param4,param5);
         }
      }
      
      public function activateTargetIntersectedAnim(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.mItemTargetedAnim == null)
            {
               this.mItemTargetedAnim = new FSItemTargetedAnim();
            }
            if(this.mItemTargetedAnim.parent == null)
            {
               TweenMax.killTweensOf(this.mItemTargetedAnim);
               TweenMax.killDelayedCallsTo(this.onItemTargetAnimMotionOff);
               this.mItemTargetedAnim.x = x + this.mBGImage.x;
               this.mItemTargetedAnim.y = y + this.mBGImage.y;
               this.mItemTargetedAnim.startMotion(true);
               InstanceMng.getCurrentScreen().addChild(this.mItemTargetedAnim);
            }
         }
         else if(Boolean(this.mItemTargetedAnim) && Boolean(this.mItemTargetedAnim.parent))
         {
            this.mItemTargetedAnim.startMotion(false,this.onItemTargetAnimMotionOff);
         }
      }
      
      private function onItemTargetAnimMotionOff() : void
      {
         if(this.mItemTargetedAnim)
         {
            this.mItemTargetedAnim.removeFromParent();
            this.mItemTargetedAnim.destroy();
            this.mItemTargetedAnim = null;
         }
      }
      
      override protected function tweenParticlePart1(param1:Number = -1, param2:Number = -1, param3:Boolean = true) : void
      {
         if(this.mBGImageForHighlights)
         {
            super.tweenParticlePart1(this.mBGImageForHighlights.width,this.mBGImageForHighlights.height,true);
         }
      }
      
      override protected function tweenParticlePart2(param1:Number = -1, param2:Number = -1) : void
      {
         if(this.mBGImageForHighlights)
         {
            super.tweenParticlePart2(param1,param2);
         }
      }
      
      override protected function tweenParticlePart3(param1:Number = -1, param2:Number = -1) : void
      {
         if(this.mBGImageForHighlights)
         {
            super.tweenParticlePart3(param1,param2);
         }
      }
      
      override protected function tweenParticlePart4(param1:Number = -1, param2:Number = -1) : void
      {
         if(this.mBGImageForHighlights)
         {
            super.tweenParticlePart4(param1,param2);
         }
      }
      
      override public function deactivateHighlightTween(param1:Boolean = false) : void
      {
         var _loc3_:FSCard = null;
         mHighlightRequested = false;
         var _loc2_:int = getChildIndex(this.mBGImageForHighlights);
         if(_loc2_ != -1)
         {
            if(param1)
            {
               SpecialFX.tweenToAlpha(this.mBGImageForHighlights,0,0.5,0,Utils.removeImageFromParent,[this.mBGImageForHighlights]);
            }
            else
            {
               SpecialFX.tweenToAlpha(this.mBGImageForHighlights,0,0.5,0,Utils.removeImageFromParent,[this.mBGImageForHighlights]);
            }
         }
         if(!this.mIsEmpty)
         {
            _loc3_ = this.getParentCard();
            if(_loc3_ != null)
            {
               _loc3_.deactivateHighlightTween(param1);
            }
         }
         if(this.mHighlightIsParticle)
         {
            deactivateSpecialHighlightParticle();
         }
      }
      
      public function getSocketIndex() : int
      {
         return this.mSocketIndex;
      }
      
      override public function dispose() : void
      {
         if(this.mBGImage)
         {
            this.mBGImage.removeFromParent(true);
            this.mBGImage = null;
         }
         if(this.mBGImageForHighlights)
         {
            this.mBGImageForHighlights.removeFromParent(true);
            this.mBGImageForHighlights = null;
         }
         if(this.mItemTargetedAnim)
         {
            this.mItemTargetedAnim.removeFromParent(true);
            this.mItemTargetedAnim = null;
         }
         this.mParentCard = null;
         this.mBFCoords = null;
         super.dispose();
      }
      
      override public function activateSpecialHighlightParticle(param1:ColorArgb = null, param2:ColorArgb = null) : void
      {
         var _loc3_:int = 0;
         super.activateSpecialHighlightParticle(param1,param2);
         if(Config.getConfig().battleSocketMorphParticles())
         {
            if(this.mParentCard != null)
            {
               if(mHighlightParticleSystem)
               {
                  _loc3_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(this.mParentCard.getCardDef().getFactionSku())).getIndex();
                  InstanceMng.getResourcesMng().morphParticleSystemProps(mHighlightParticleSystem,_loc3_);
               }
            }
         }
      }
   }
}

