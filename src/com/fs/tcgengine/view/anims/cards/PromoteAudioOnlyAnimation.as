package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.utils.Utils;
   
   public class PromoteAudioOnlyAnimation extends CardAnimation
   {
      
      public function PromoteAudioOnlyAnimation()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         Utils.playSound(Constants.SOUND_SUPPORT_TO_ATTACK,SoundManager.TYPE_SFX);
      }
   }
}

