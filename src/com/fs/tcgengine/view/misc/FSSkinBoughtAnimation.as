package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.particles.FSPDParticleSystem;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.greensock.easing.Back;
   import starling.core.Starling;
   
   public class FSSkinBoughtAnimation extends FSVictoryAnimation
   {
      
      private var mSkinName:String;
      
      public function FSSkinBoughtAnimation(param1:String, param2:Function = null, param3:Array = null, param4:Boolean = false)
      {
         this.mSkinName = param1;
         super(null,param2,param3,param4);
      }
      
      override protected function createChar(param1:String = "win_anim_char") : void
      {
      }
      
      override protected function createSpecialFX() : void
      {
      }
      
      override protected function createSparkles() : void
      {
      }
      
      override protected function createSubBG(param1:String = "victory_level_bg", param2:Number = 1) : void
      {
      }
      
      override protected function createBG(param1:String = "victory_level_panel") : void
      {
         if(mBG == null)
         {
            mBG = new FSImage(Root.assets.getTexture(this.mSkinName));
         }
         mBG.alignPivot();
         mBG.x = 0;
         mBG.y = 0;
         addChild(mBG);
      }
      
      override protected function createTextfield(param1:String = "TID_GEN_LEVEL_VICTORY") : void
      {
      }
      
      override protected function addParticleToStage(param1:FSPDParticleSystem) : void
      {
         InstanceMng.getCurrentScreen().addChild(param1);
         Starling.juggler.add(param1);
      }
      
      override protected function createAnimBars() : void
      {
         super.createAnimBars();
         if(mBGAnimBar1)
         {
            mBGAnimBar1.x = mBG.x;
            mBGAnimBar1.y = mBG.y + mBG.height / 3;
         }
         if(mBGAnimBar2)
         {
            mBGAnimBar2.x = mBGAnimBar1.x - mBGAnimBar2.width / 3;
            mBGAnimBar2.y = mBGAnimBar1.y;
         }
         if(mBGAnimBar3)
         {
            mBGAnimBar3.x = mBG.x;
            mBGAnimBar3.y = mBGAnimBar1.y;
         }
         if(mBGAnimBar4)
         {
            mBGAnimBar4.x = mBGAnimBar3.x + mBGAnimBar4.width / 3;
            mBGAnimBar4.y = mBGAnimBar1.y;
         }
      }
      
      override public function unload() : void
      {
         if(mOnFadeOffCompleteFunction != null)
         {
            if(mOnFadeOffCompleteParams != null)
            {
               mOnFadeOffCompleteFunction(mOnFadeOffCompleteParams);
            }
            else
            {
               mOnFadeOffCompleteFunction();
            }
         }
         visible = false;
         removeFromParent();
         if(mFirework1)
         {
            mFirework1.removeFromParent();
            mFirework1 = null;
         }
         if(mFirework2)
         {
            mFirework2.removeFromParent();
            mFirework2 = null;
         }
         if(mFirework3)
         {
            mFirework3.removeFromParent();
            mFirework3 = null;
         }
         InstanceMng.getPopupMng().showFirstQueuedPopup();
      }
      
      override public function performFadeIn() : void
      {
         mIsShown = true;
         scaleX = 0;
         scaleY = 0;
         visible = true;
         var _loc1_:Number = 0.5 * Utils.getDefaultSpeedTime();
         SpecialFX.createZoomAlphaTween(this,_loc1_,0,1,0,1.5,Back.easeIn,startAnimsAfterFadeIn);
      }
      
      override public function performFadeOut(param1:Number = 0.5) : void
      {
         mIsShown = false;
         SpecialFX.createZoomAlphaTween(this,param1,1,0,1.5,0,Back.easeOut,this.unload);
      }
   }
}

