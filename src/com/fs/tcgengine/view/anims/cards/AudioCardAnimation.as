package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSUnit;
   
   public class AudioCardAnimation extends CardAnimation
   {
      
      private var mDamageDealerCard:FSCard;
      
      public function AudioCardAnimation(param1:FSCard)
      {
         this.mDamageDealerCard = param1;
         super();
      }
      
      override public function init() : void
      {
         super.init();
         var _loc1_:String = UnitDef(FSUnit(this.mDamageDealerCard).getCardDef()).getDamageAudioName();
         Utils.playSound(_loc1_,SoundManager.TYPE_SFX);
      }
      
      override public function dispose() : void
      {
         this.mDamageDealerCard = null;
         super.dispose();
      }
   }
}

