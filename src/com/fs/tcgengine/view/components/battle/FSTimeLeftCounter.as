package com.fs.tcgengine.view.components.battle
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.greensock.TweenMax;
   
   public class FSTimeLeftCounter extends FSTurnsCounter
   {
      
      public function FSTimeLeftCounter(param1:int)
      {
         super(param1);
      }
      
      override protected function createTitleTextfield() : void
      {
         super.createTitleTextfield();
         if(mTitleTextfield != null)
         {
            mTitleTextfield.text = TextManager.getText("TID_GEN_TIME");
         }
      }
      
      override public function updateCounterAmount(param1:String, param2:int = 4) : void
      {
         var _loc3_:BattleEngine = InstanceMng.getBattleEngine();
         var _loc4_:Boolean = _loc3_ ? _loc3_.isOwnerTurn() : true;
         var _loc5_:int = !_loc4_ ? 59 : 30;
         var _loc6_:int = TimerUtil.msToSec(PvPConnectionMng.smExpirationTime - TimerUtil.currentTimeMillis());
         var _loc7_:Boolean = _loc6_ < _loc5_;
         FSDebug.debugTrace("Expiration time: " + _loc6_ + " seconds");
         var _loc8_:int = _loc4_ ? int(param1) : _loc6_;
         if(getAmountTextfield() != null)
         {
            getAmountTextfield().visible = _loc7_ && _loc8_ <= _loc5_ && param1 != "--";
         }
         if(_loc6_ < _loc5_)
         {
            super.updateCounterAmount(param1,11);
         }
      }
      
      override protected function startAlertEffects() : void
      {
         var _loc1_:Array = null;
         if(mAmountTextfield)
         {
            if(mAmountTextfield.fontName != FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED))
            {
               mAmountTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
            }
            _loc1_ = TweenMax.getTweensOf(mAmountTextfield);
            if(_loc1_ == null || Boolean(_loc1_) && Boolean(_loc1_.length == 0))
            {
               SpecialFX.createYoYoZoomTransition(mAmountTextfield,1.5,1,-1,null,null,false);
            }
         }
      }
      
      override protected function createAmountTextfield() : void
      {
         super.createAmountTextfield();
         if(!Config.getConfig().battleTurnsCounterSplitIn2())
         {
            mAmountTextfield.width = mBG.width * 0.7;
            mAmountTextfield.x = (mBG.width - mAmountTextfield.width) / 2 + mAmountTextfield.width / 1.5;
         }
      }
   }
}

