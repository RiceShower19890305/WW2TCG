package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.utils.Utils;
   import starling.events.Event;
   
   public class LightningAnimation extends CustomSpritesheetAnimation
   {
      
      private var mLoopsAmountToDo:int;
      
      private var mLoopsAmountDone:int = 0;
      
      public function LightningAnimation(param1:int = 5)
      {
         this.mLoopsAmountToDo = param1;
         super(null);
      }
      
      override public function init() : void
      {
         super.init();
         Utils.playSound(Constants.SOUND_SACRIFICE_TRIGGER,SoundManager.TYPE_SFX);
      }
      
      override protected function getSpriteSheetName() : String
      {
         return "electric_anim_";
      }
      
      override protected function setupLooping() : void
      {
         if(mMc)
         {
            mMc.loop = this.mLoopsAmountToDo == -1;
         }
      }
      
      override protected function movieCompletedHandler(param1:Event) : void
      {
         if(this.mLoopsAmountToDo != -1)
         {
            ++this.mLoopsAmountDone;
            if(this.mLoopsAmountDone >= 10)
            {
               super.movieCompletedHandler(param1);
            }
            else
            {
               mMc.play();
            }
         }
      }
   }
}

