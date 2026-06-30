package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.particles.FSPDParticleSystem;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import starling.core.Starling;
   
   public class FSAuctionWinAnimation extends FSVictoryAnimation
   {
      
      public function FSAuctionWinAnimation(param1:Function = null, param2:Array = null, param3:Boolean = false)
      {
         super(null,param1,param2,param3);
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
         super.createBG("auction_animation");
      }
      
      override protected function createTextfield(param1:String = "TID_GEN_LEVEL_VICTORY") : void
      {
         if(mTextfield == null)
         {
            mTextfield = new FSTextfield(mBG.width * 0.8,mBG.height * 0.2,TextManager.getText("TID_AUCTIONS_AUCTION_WON"),16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
         }
         mTextfield.alignPivot();
         mTextfield.x = mBG.x;
         mTextfield.y = mBG.y + mBG.height / 2 - mTextfield.height / 2;
         addChild(mTextfield);
      }
      
      override protected function addParticleToStage(param1:FSPDParticleSystem) : void
      {
         InstanceMng.getCurrentScreen().addChild(param1);
         Starling.juggler.add(param1);
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
   }
}

