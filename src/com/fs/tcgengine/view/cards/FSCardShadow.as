package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import flash.geom.Rectangle;
   import starling.textures.Texture;
   
   public class FSCardShadow extends Component
   {
      
      public static const ZOOM_OUT_CARD_HEIGHT_PERCENT:Number = 0.7;
      
      public static const CARD_HEIGHT_PERCENT:Number = 0.65;
      
      protected var mShadow9Scale:FSImage;
      
      protected var mParentCard:FSCard;
      
      private var mCustomShadow:FSImage;
      
      public function FSCardShadow(param1:FSCard)
      {
         super();
         this.mParentCard = param1;
         this.initialize(true);
         pivotX = width / 2;
         pivotY = height / 2;
      }
      
      protected function initialize(param1:Boolean = false) : void
      {
         var _loc2_:Texture = null;
         var _loc3_:Rectangle = null;
         if(param1)
         {
            _loc2_ = Root.assets.getTexture("card_shadow");
            if(_loc2_)
            {
               _loc3_ = new Rectangle(0,0,_loc2_.width,_loc2_.height);
               if(_loc2_)
               {
                  this.mShadow9Scale = new FSImage(_loc2_);
                  this.mShadow9Scale.scale9Grid = _loc3_;
                  this.setShadowSize();
                  this.mShadow9Scale.touchable = false;
                  addChild(this.mShadow9Scale);
               }
            }
         }
         if(Config.getConfig().useSilhouetteCardShadow())
         {
            if(Boolean(this.mParentCard) && Boolean(this.mParentCard.getBG()))
            {
               this.mCustomShadow = new FSImage(this.mParentCard.getBG().texture);
               this.mCustomShadow.color = 0;
               this.mCustomShadow.alpha = 0.6;
               this.mCustomShadow.width = this.mParentCard.getBG().width;
               this.mCustomShadow.height = this.mParentCard.getBG().height;
               this.mCustomShadow.x = this.mParentCard.getBG().x;
               this.mCustomShadow.y = this.mParentCard.getBG().y;
               this.mCustomShadow.visible = false;
               addChild(this.mCustomShadow);
               this.mCustomShadow.touchable = false;
               if(this.mShadow9Scale)
               {
                  this.mShadow9Scale.visible = this.mParentCard == null || Boolean(this.mParentCard) && !this.mParentCard.isOnBF();
               }
            }
         }
      }
      
      private function setShadowSize() : void
      {
         var _loc1_:CompositeFrame = this.mParentCard.getFrameBG();
         var _loc2_:FSImage = this.mParentCard.getBG();
         var _loc3_:Boolean = Config.getConfig().useSilhouetteCardShadow();
         var _loc4_:int = -1;
         var _loc5_:int = -1;
         if(_loc3_)
         {
            if(_loc1_)
            {
               _loc4_ = _loc1_.width;
               _loc5_ = _loc1_.height;
            }
         }
         else if(_loc2_)
         {
            _loc4_ = _loc2_.width;
            _loc5_ = _loc2_.height;
         }
         if(this.mParentCard != null && _loc4_ != -1 && _loc5_ != -1)
         {
            this.mShadow9Scale.width = _loc4_;
            this.mShadow9Scale.height = _loc5_;
         }
      }
      
      public function onShadowTweeningUpdate() : void
      {
         if(this.mParentCard == null)
         {
            return;
         }
         rotationX = this.mParentCard.rotationX;
         rotationY = this.mParentCard.rotationY;
         rotationZ = this.mParentCard.rotationZ;
         scaleX = this.mParentCard.scaleX;
         scaleY = this.mParentCard.scaleY;
         if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSBattleScreen && !this.mParentCard.isZoomedIn() && !InstanceMng.getBattleEngine().getAbilityLockedUI())
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).addChild(this);
            FSBattleScreen(InstanceMng.getCurrentScreen()).addChild(this.mParentCard);
         }
         if(Config.getConfig().useSilhouetteCardShadow())
         {
            if(Boolean(this.mParentCard) && Boolean(this.mParentCard.getFrameBG()))
            {
               if(this.isOnBF() && !this.mParentCard.getFrameBG().visible)
               {
                  if(this.mCustomShadow != null && !this.mCustomShadow.visible)
                  {
                     this.mCustomShadow.visible = true;
                  }
               }
               if(this.mParentCard.isOnBF())
               {
                  if(Boolean(this.mShadow9Scale) && Boolean(this.mShadow9Scale.parent != null) && !this.mParentCard.isMoving())
                  {
                     this.mShadow9Scale.removeFromParent();
                  }
               }
            }
         }
      }
      
      private function isOnBF() : Boolean
      {
         return Boolean(this.mParentCard) && (this.mParentCard.isOnBF() || !this.mParentCard.isAlive() && this.mParentCard is FSUnit);
      }
      
      public function onCardTweeningOver() : void
      {
         if(Config.getConfig().useSilhouetteCardShadow())
         {
            if(Boolean(this.mShadow9Scale && this.mShadow9Scale.parent != null) && Boolean(this.mParentCard) && this.mParentCard.isOnBF())
            {
               this.mShadow9Scale.removeFromParent();
            }
         }
      }
      
      public function setOnDefaultPos() : void
      {
         if(this.mParentCard)
         {
            x = this.mParentCard.x;
            y = this.mParentCard.y;
         }
      }
      
      public function getDefaultXPos() : Number
      {
         return this.mParentCard.x;
      }
      
      public function getDefaultYPos() : Number
      {
         return this.mParentCard.y;
      }
      
      public function getDefaultZoomOutXPos() : Number
      {
         return this.mParentCard.getAttachedToSocket().x;
      }
      
      public function getDefaultZoomOutYPos() : Number
      {
         return this.mParentCard.getAttachedToSocket().y;
      }
      
      override public function dispose() : void
      {
         if(this.mShadow9Scale)
         {
            this.mShadow9Scale.removeFromParent(true);
            this.mShadow9Scale = null;
         }
         if(this.mCustomShadow)
         {
            this.mCustomShadow.removeFromParent();
            this.mCustomShadow.destroy();
            this.mCustomShadow = null;
         }
         if(!Config.USE_CARD_POOLING)
         {
            this.mParentCard = null;
         }
         super.dispose();
      }
      
      public function getOffsetToMoveX() : Number
      {
         var _loc1_:Number = 0;
         if(this.mParentCard)
         {
            if(this.mParentCard.hasAnimatedBG())
            {
               _loc1_ = this.mParentCard.getBGAnimated() ? this.mParentCard.getBGAnimated().width / 5 : 0;
            }
            else
            {
               _loc1_ = this.mParentCard.getBG() ? this.mParentCard.getBG().width / 5 : 0;
            }
         }
         return _loc1_;
      }
      
      public function getOffsetToMoveY() : Number
      {
         var _loc1_:Number = 0;
         if(this.mParentCard.hasAnimatedBG())
         {
            _loc1_ = this.mParentCard.getBGAnimated() ? this.mParentCard.getBGAnimated().height / 5 : 0;
         }
         else
         {
            _loc1_ = this.mParentCard.getBG() ? this.mParentCard.getBG().height / 5 : 0;
         }
         return _loc1_;
      }
      
      public function onPromote() : void
      {
         if(Config.getConfig().useSilhouetteCardShadow())
         {
            if(Boolean(this.mCustomShadow) && Boolean(this.mParentCard) && Boolean(this.mParentCard.getBG()))
            {
               this.mCustomShadow.texture = this.mParentCard.getBG().texture;
            }
         }
      }
   }
}

