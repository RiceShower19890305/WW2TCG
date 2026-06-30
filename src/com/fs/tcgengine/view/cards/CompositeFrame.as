package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import flash.geom.Point;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class CompositeFrame extends Component
   {
      
      private var mLeft:FSImage;
      
      private var mRight:FSImage;
      
      private var mTop:FSImage;
      
      private var mBottom:FSImage;
      
      private var mTextureName:String;
      
      public function CompositeFrame(param1:String)
      {
         this.mTextureName = param1;
         super();
         this.createUI();
      }
      
      public function updateTexture(param1:String) : void
      {
         var _loc2_:Boolean = this.validateTextureName(Align.LEFT,param1);
         var _loc3_:Boolean = this.validateTextureName(Align.RIGHT,param1);
         var _loc4_:Boolean = this.validateTextureName(Align.TOP,param1);
         var _loc5_:Boolean = this.validateTextureName(Align.BOTTOM,param1);
         if(_loc2_ && _loc3_ && _loc4_ && _loc5_)
         {
            this.mTextureName = param1;
            this.createUI();
         }
      }
      
      private function validateTextureName(param1:String, param2:String) : Boolean
      {
         return Root.assets.getTexture(param2 + this.getImageSuffix(param1)) != null;
      }
      
      private function createUI() : void
      {
         this.mLeft = this.createImage(Align.LEFT,this.mLeft);
         this.mRight = this.createImage(Align.RIGHT,this.mRight);
         this.mTop = this.createImage(Align.TOP,this.mTop);
         this.mBottom = this.createImage(Align.BOTTOM,this.mBottom);
         this.refreshImagesPositions();
      }
      
      private function createImage(param1:String, param2:FSImage) : FSImage
      {
         var _loc3_:String = this.getImageSuffix(param1);
         var _loc4_:Texture = null;
         var _loc5_:Point = new Point();
         var _loc6_:FSImage = param2;
         _loc4_ = Root.assets.getTexture(this.mTextureName + _loc3_);
         if(_loc6_ == null)
         {
            _loc6_ = new FSImage(_loc4_,false);
         }
         else
         {
            _loc6_.texture = _loc4_;
         }
         _loc6_.alignPivot();
         addChild(_loc6_);
         return _loc6_;
      }
      
      private function getImageSuffix(param1:String) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case Align.LEFT:
               _loc2_ = "_side_left";
               break;
            case Align.RIGHT:
               _loc2_ = "_side_right";
               break;
            case Align.TOP:
               _loc2_ = "_side_top";
               break;
            case Align.BOTTOM:
               _loc2_ = "_side_bottom";
         }
         return _loc2_;
      }
      
      private function refreshImagesPositions() : void
      {
         if(this.mLeft)
         {
            this.mLeft.x = this.mLeft.width / 2;
            this.mLeft.y = this.mLeft.height / 2;
         }
         if(this.mTop)
         {
            this.mTop.x = this.mTop.width / 2;
            this.mTop.y = this.mTop.height / 2;
         }
         if(this.mRight)
         {
            this.mRight.x = this.mTop.x + this.mTop.width / 2 - this.mRight.width / 2;
            this.mRight.y = this.mLeft.y;
         }
         if(this.mBottom)
         {
            this.mBottom.x = this.mTop.x;
            this.mBottom.y = this.mLeft.y + this.mLeft.height / 2 - this.mBottom.height / 2;
         }
      }
      
      public function reset(param1:Boolean = true) : void
      {
         if(!Config.USE_CARD_POOLING)
         {
            return;
         }
         Utils.resetComponent(this);
         if(param1)
         {
            this.mLeft.texture = null;
            this.mRight.texture = null;
            this.mTop.texture = null;
            this.mBottom.texture = null;
         }
         removeFromParent();
      }
      
      override public function dispose() : void
      {
         if(this.mLeft)
         {
            this.mLeft.removeFromParent();
            this.mLeft = null;
         }
         if(this.mTop)
         {
            this.mTop.removeFromParent();
            this.mTop = null;
         }
         if(this.mRight)
         {
            this.mRight.removeFromParent();
            this.mRight = null;
         }
         if(this.mBottom)
         {
            this.mBottom.removeFromParent();
            this.mBottom = null;
         }
         super.dispose();
      }
   }
}

