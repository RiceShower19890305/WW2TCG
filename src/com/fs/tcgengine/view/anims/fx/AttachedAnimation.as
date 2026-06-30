package com.fs.tcgengine.view.anims.fx
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.Component;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class AttachedAnimation extends Component
   {
      
      private var mHorizontalTopMC:MovieClip;
      
      private var mHorizontalBottomMC:MovieClip;
      
      private var mVerticalLeftMC:MovieClip;
      
      private var mVerticalRightMC:MovieClip;
      
      private var mCard:FSCard;
      
      public function AttachedAnimation(param1:FSCard)
      {
         super();
         this.mCard = param1;
         this.createAnims();
      }
      
      private function createAnims() : void
      {
         if(Config.getConfig().getCardAttachedAnimOverSocket())
         {
            if(this.mHorizontalBottomMC == null)
            {
               this.mHorizontalBottomMC = this.createAnim("");
            }
         }
         else
         {
            if(this.mHorizontalTopMC == null)
            {
               this.mHorizontalTopMC = this.createAnim(Align.TOP);
            }
            if(this.mHorizontalBottomMC == null)
            {
               this.mHorizontalBottomMC = this.createAnim(Align.BOTTOM);
            }
            if(this.mVerticalLeftMC == null)
            {
               this.mVerticalLeftMC = this.createAnim(Align.LEFT);
            }
            if(this.mVerticalRightMC == null)
            {
               this.mVerticalRightMC = this.createAnim(Align.RIGHT);
            }
         }
         this.refreshPositions();
      }
      
      private function createAnim(param1:String) : MovieClip
      {
         var _loc2_:MovieClip = null;
         var _loc3_:String = "";
         switch(param1)
         {
            case Align.TOP:
            case Align.BOTTOM:
               _loc3_ = "attach_anim_horizontal_";
               break;
            case Align.LEFT:
            case Align.RIGHT:
               _loc3_ = "attach_anim_vertical_";
               break;
            default:
               _loc3_ = "play_card_effect_";
         }
         if(Root.assets.getTextures(_loc3_) != null && Root.assets.getTextures(_loc3_).length > 0)
         {
            _loc2_ = new MovieClip(Root.assets.getTextures(_loc3_),45);
            _loc2_.touchable = false;
            if(param1 == Align.TOP || param1 == "")
            {
               _loc2_.addEventListener(Event.COMPLETE,this.onMCCompleted);
            }
            _loc2_.alignPivot();
            this.refreshMCPos(_loc2_,param1);
         }
         return _loc2_;
      }
      
      private function refreshPositions() : void
      {
         if(Config.getConfig().getCardAttachedAnimOverSocket())
         {
            if(this.mHorizontalBottomMC)
            {
               this.refreshMCPos(this.mHorizontalBottomMC,"");
            }
         }
         else
         {
            if(this.mHorizontalTopMC)
            {
               this.refreshMCPos(this.mHorizontalTopMC,Align.TOP);
            }
            if(this.mHorizontalBottomMC)
            {
               this.refreshMCPos(this.mHorizontalBottomMC,Align.BOTTOM);
            }
            if(this.mVerticalLeftMC)
            {
               this.refreshMCPos(this.mVerticalLeftMC,Align.LEFT);
            }
            if(this.mVerticalRightMC)
            {
               this.refreshMCPos(this.mVerticalRightMC,Align.RIGHT);
            }
         }
      }
      
      private function refreshMCPos(param1:MovieClip, param2:String) : void
      {
         var _loc3_:Number = 1.2;
         if(Boolean(param1) && Boolean(this.mCard))
         {
            switch(param2)
            {
               case Align.TOP:
                  param1.width = this.mCard.width * _loc3_;
                  param1.scaleX = Utils.randomInt() == 0 ? param1.scaleX * 1 : param1.scaleX * -1;
                  param1.scaleY = 2;
                  param1.x = this.mCard.x;
                  param1.y = this.mCard.y - this.mCard.height / 2;
                  break;
               case Align.BOTTOM:
                  param1.width = this.mCard.width * _loc3_;
                  param1.scaleX = Utils.randomInt() == 0 ? param1.scaleX * 1 : param1.scaleX * -1;
                  param1.scaleY = -2;
                  param1.x = this.mCard.x;
                  param1.y = this.mCard.y + this.mCard.height / 2;
                  break;
               case Align.LEFT:
                  param1.height = this.mCard.height * _loc3_;
                  param1.scaleY = Utils.randomInt() == 0 ? param1.scaleY * 1 : param1.scaleY * -1;
                  param1.scaleX = 2;
                  param1.x = this.mCard.x - this.mCard.width / 2;
                  param1.y = this.mCard.y;
                  break;
               case Align.RIGHT:
                  param1.height = this.mCard.height * _loc3_;
                  param1.scaleY = Utils.randomInt() == 0 ? param1.scaleY * 1 : param1.scaleY * -1;
                  param1.scaleX = -2;
                  param1.x = this.mCard.x + this.mCard.width / 2;
                  param1.y = this.mCard.y;
                  break;
               default:
                  param1.width = this.mCard.width * _loc3_;
                  param1.scaleY = 2.15;
                  param1.x = this.mCard.x;
                  param1.y = this.mCard.y + this.mCard.height / 2 - param1.height / 3;
            }
         }
         if(!Starling.juggler.contains(param1))
         {
            Starling.juggler.add(param1);
         }
         param1.loop = false;
         InstanceMng.getCurrentScreen().addChild(param1);
         param1.currentFrame = 0;
         param1.play();
      }
      
      public function refreshCard(param1:FSCard) : void
      {
         this.mCard = param1;
         this.refreshPositions();
      }
      
      private function onMCCompleted(param1:Event) : void
      {
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).onAttachedAnimEnd(this);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mHorizontalTopMC)
         {
            Starling.juggler.remove(this.mHorizontalTopMC);
            this.mHorizontalTopMC.removeFromParent(true);
            this.mHorizontalTopMC = null;
         }
         if(this.mHorizontalBottomMC)
         {
            Starling.juggler.remove(this.mHorizontalBottomMC);
            this.mHorizontalBottomMC.removeFromParent(true);
            this.mHorizontalBottomMC = null;
         }
         if(this.mVerticalLeftMC)
         {
            Starling.juggler.remove(this.mVerticalLeftMC);
            this.mVerticalLeftMC.removeFromParent(true);
            this.mVerticalLeftMC = null;
         }
         if(this.mVerticalRightMC)
         {
            Starling.juggler.remove(this.mVerticalRightMC);
            this.mVerticalRightMC.removeFromParent(true);
            this.mVerticalRightMC = null;
         }
         this.mCard = null;
         super.dispose();
      }
   }
}

