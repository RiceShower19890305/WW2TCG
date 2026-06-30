package com.fs.tcgengine.view.board
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   
   public class BloodScreen extends Component
   {
      
      private const BG_NAME:String = "blood_screen";
      
      private const FADE_SPEED:Number = 4;
      
      private var mBGLeftTop:FSImage;
      
      private var mBGLeftBottom:FSImage;
      
      private var mBGRightTop:FSImage;
      
      private var mBGRightBottom:FSImage;
      
      public function BloodScreen()
      {
         super();
      }
      
      public function trigger() : void
      {
         if(this.mBGLeftTop == null)
         {
            this.mBGLeftTop = new FSImage(Root.assets.getTexture(this.BG_NAME));
            this.mBGLeftTop.x = 0;
            this.mBGLeftTop.y = this.mBGLeftTop.height;
            this.mBGLeftTop.scaleY = -1;
         }
         if(this.mBGLeftBottom == null)
         {
            this.mBGLeftBottom = new FSImage(Root.assets.getTexture(this.BG_NAME));
            this.mBGLeftBottom.x = 0;
            this.mBGLeftBottom.y = InstanceMng.getCurrentScreen().getBG().height / 2;
         }
         if(this.mBGRightTop == null)
         {
            this.mBGRightTop = new FSImage(Root.assets.getTexture(this.BG_NAME));
            this.mBGRightTop.x = InstanceMng.getCurrentScreen().getBG().width;
            this.mBGRightTop.y = this.mBGLeftTop.y;
            this.mBGRightTop.scaleX = -1;
            this.mBGRightTop.scaleY = -1;
         }
         if(this.mBGRightBottom == null)
         {
            this.mBGRightBottom = new FSImage(Root.assets.getTexture(this.BG_NAME));
            this.mBGRightBottom.x = InstanceMng.getCurrentScreen().getBG().width;
            this.mBGRightBottom.y = this.mBGLeftBottom.y;
            this.mBGRightBottom.scaleX = -1;
         }
         this.mBGLeftBottom.alpha = 0.999;
         this.mBGRightBottom.alpha = 0.999;
         this.mBGLeftTop.alpha = 0.999;
         this.mBGRightTop.alpha = 0.999;
         addChild(this.mBGLeftBottom);
         addChild(this.mBGLeftTop);
         addChild(this.mBGRightBottom);
         addChild(this.mBGRightTop);
         SpecialFX.tweenToAlpha(this.mBGLeftBottom,0.001,this.FADE_SPEED,0);
         SpecialFX.tweenToAlpha(this.mBGLeftTop,0.001,this.FADE_SPEED,0);
         SpecialFX.tweenToAlpha(this.mBGRightBottom,0.001,this.FADE_SPEED,0,this.removeLeftBGFromDL);
         SpecialFX.tweenToAlpha(this.mBGRightTop,0.001,this.FADE_SPEED,0,this.removeRightBGFromDL);
      }
      
      private function removeLeftBGFromDL() : void
      {
         if(this.mBGLeftBottom != null)
         {
            this.mBGLeftBottom.removeFromParent();
         }
         if(this.mBGLeftTop != null)
         {
            this.mBGLeftTop.removeFromParent();
         }
      }
      
      private function removeRightBGFromDL() : void
      {
         if(this.mBGRightBottom != null)
         {
            this.mBGRightBottom.removeFromParent();
         }
         if(this.mBGRightTop != null)
         {
            this.mBGRightTop.removeFromParent();
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBGLeftBottom)
         {
            this.mBGLeftBottom.removeFromParent(true);
            this.mBGLeftBottom = null;
         }
         if(this.mBGLeftTop)
         {
            this.mBGLeftTop.removeFromParent(true);
            this.mBGLeftTop = null;
         }
         if(this.mBGRightBottom)
         {
            this.mBGRightBottom.removeFromParent(true);
            this.mBGRightBottom = null;
         }
         if(this.mBGRightTop)
         {
            this.mBGRightTop.removeFromParent(true);
            this.mBGRightTop = null;
         }
         super.dispose();
      }
   }
}

