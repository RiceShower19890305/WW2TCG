package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   
   public class FSItemTargetedAnim extends Component implements FSModelUnloadableInterface
   {
      
      private var mSmallRing:FSImage;
      
      private var mBigRing:FSImage;
      
      private var mCurrentlyHovered:Boolean;
      
      private var mMotionStarted:Boolean;
      
      public function FSItemTargetedAnim(param1:Boolean = false)
      {
         super();
         this.mCurrentlyHovered = param1;
         this.createSmallRing();
         this.createBigRing();
         touchable = false;
      }
      
      private function createSmallRing() : void
      {
         var _loc1_:String = null;
         if(this.mSmallRing == null)
         {
            _loc1_ = this.mCurrentlyHovered ? "_highlight" : "";
            this.mSmallRing = new FSImage(Root.assets.getTexture("target_inner" + _loc1_));
            this.mSmallRing.alignPivot();
            this.mSmallRing.touchable = false;
            this.mSmallRing.x = 0;
            this.mSmallRing.y = 0;
         }
         this.mSmallRing.alpha = 0.0001;
         addChild(this.mSmallRing);
         SpecialFX.tweenRotate(this.mSmallRing,6,-1);
         SpecialFX.createYoYoZoomTransition(this.mSmallRing,1.25,0.5,-1,null,null,false);
      }
      
      private function createBigRing() : void
      {
         var _loc1_:String = null;
         if(this.mBigRing == null)
         {
            _loc1_ = this.mCurrentlyHovered ? "_highlight" : "";
            this.mBigRing = new FSImage(Root.assets.getTexture("target_outer" + _loc1_));
            this.mBigRing.touchable = false;
            this.mBigRing.alignPivot();
            this.mBigRing.x = 0;
            this.mBigRing.y = 0;
         }
         this.mBigRing.alpha = 0.0001;
         addChild(this.mBigRing);
         SpecialFX.tweenRotate(this.mBigRing,12,-1,null,-360);
         SpecialFX.createYoYoZoomTransition(this.mBigRing,1.15,2,-1,null,null,false);
      }
      
      public function setIsHovered(param1:Boolean) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this.mCurrentlyHovered = param1;
         if(this.mSmallRing)
         {
            _loc2_ = this.mCurrentlyHovered ? "_highlight" : "";
            _loc3_ = "target_inner" + _loc2_;
            this.mSmallRing.texture = Root.assets.getTexture(_loc3_);
         }
         if(this.mBigRing)
         {
            _loc2_ = this.mCurrentlyHovered ? "_highlight" : "";
            _loc3_ = "target_outer" + _loc2_;
            this.mBigRing.texture = Root.assets.getTexture(_loc3_);
         }
      }
      
      public function startMotion(param1:Boolean, param2:Function = null) : void
      {
         this.mMotionStarted = param1;
         var _loc3_:Number = param1 ? 0.999 : 0.001;
         var _loc4_:Number = 0.5;
         if(this.mSmallRing != null)
         {
            SpecialFX.tweenToAlpha(this.mSmallRing,_loc3_,_loc4_,0);
         }
         if(this.mBigRing != null)
         {
            SpecialFX.tweenToAlpha(this.mBigRing,_loc3_,_loc4_,0);
         }
         if(param2 != null)
         {
            TweenMax.delayedCall(_loc4_,param2);
         }
      }
      
      public function isMotionStarted() : Boolean
      {
         return this.mMotionStarted;
      }
      
      override public function dispose() : void
      {
         this.destroy();
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mSmallRing)
         {
            this.mSmallRing.removeFromParent();
            this.mSmallRing = null;
         }
         if(this.mBigRing)
         {
            this.mBigRing.removeFromParent();
            this.mBigRing = null;
         }
      }
   }
}

