package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.particles.FSPDParticleSystem;
   import com.fs.tcgengine.resources.AssetsParticles;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.greensock.TweenMax;
   import flash.geom.Point;
   import starling.textures.Texture;
   
   public class FSDefeatAnimation extends FSVictoryAnimation
   {
      
      public function FSDefeatAnimation(param1:Texture, param2:Function = null, param3:Array = null, param4:Boolean = false)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function createSubBG(param1:String = "victory_level_bg", param2:Number = 1) : void
      {
         super.createSubBG("defeat_level_bg",1.25);
      }
      
      override protected function createChar(param1:String = "win_anim_char") : void
      {
         super.createChar("lose_anim_char");
      }
      
      override protected function createSpecialFX() : void
      {
      }
      
      override protected function createSparkles() : void
      {
      }
      
      override protected function createAnimBars() : void
      {
      }
      
      override protected function createBG(param1:String = "victory_level_panel") : void
      {
         super.createBG("defeat_level_panel");
      }
      
      override protected function createTextfield(param1:String = "TID_GEN_LEVEL_VICTORY") : void
      {
         super.createTextfield("TID_GEN_LEVEL_DEFEAT");
      }
      
      override protected function createFX() : void
      {
         if(mFirework1 == null)
         {
            mFirework1 = AssetsParticles.requestParticleSystem("defeat_fire");
         }
      }
      
      override protected function triggerParticleSystem() : void
      {
         if(mFirework1 != null)
         {
            this.startParticle(mFirework1);
         }
      }
      
      override protected function startParticle(param1:FSPDParticleSystem, param2:Number = 0) : void
      {
         var _loc3_:Screen = null;
         var _loc4_:Point = null;
         if(Boolean(param1) && Boolean(mBG))
         {
            _loc3_ = InstanceMng.getCurrentScreen();
            if(_loc3_)
            {
               _loc4_ = new Point(mBG.x,mBG.y);
               param1.x = localToGlobal(_loc4_).x;
               param1.y = localToGlobal(_loc4_).y;
               addParticleToStage(param1);
               param1.start(3);
               TweenMax.delayedCall(3.25,SpecialFX.tweenToAlpha,[param1,0,1,0]);
            }
         }
      }
   }
}

