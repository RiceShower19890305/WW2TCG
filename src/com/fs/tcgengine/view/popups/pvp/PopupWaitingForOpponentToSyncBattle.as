package com.fs.tcgengine.view.popups.pvp
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.greensock.TweenMax;
   
   public class PopupWaitingForOpponentToSyncBattle extends PopupWaitingForOpponent
   {
      
      public function PopupWaitingForOpponentToSyncBattle(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function cancelMatch(param1:Boolean = true) : void
      {
         var showPvPScreen:Function = null;
         var close:Boolean = param1;
         showPvPScreen = function():void
         {
            if(InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).showPvPScreen();
            }
         };
         TweenMax.killDelayedCallsTo(this.onMatchInfoACK);
         mRequestTimer = false;
         PvPConnectionMng.setMatchDead(null,mMatchId);
         if(InstanceMng.getBattleEngine())
         {
            BattleEnginePvP(InstanceMng.getBattleEngine()).onMatchDesynchronizedPerformOps(false,true);
         }
         FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_DEAD);
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            closePopup(showPvPScreen);
         }
      }
      
      override public function onMatchInfoACK(param1:String = "OK", param2:int = 0) : void
      {
         super.onMatchInfoACK("OK_1",param2);
      }
      
      override protected function getWaitingForOpponentDefaultTime() : int
      {
         return TimerUtil.secondToMs(PvPConnectionMng.smPvPWaitingForOpponentTime / 4);
      }
      
      override protected function onBothPlayersOK(param1:Boolean, param2:Object = null) : void
      {
         mRequestTimer = false;
         Utils.removeLog();
         if(InstanceMng.getBattleEngine())
         {
            if(Config.BATTLE_HAS_INTRO)
            {
               closePopup(InstanceMng.getBattleEngine().playIntro);
            }
            else
            {
               closePopup(InstanceMng.getBattleEngine().notifyPlayerTurnDone);
            }
         }
         else
         {
            closePopup();
         }
      }
      
      override public function removeTranslucentBG() : Boolean
      {
         return false;
      }
      
      override protected function performOnOpenDefaultOps(param1:FSCoordinate, param2:Number = 0.6) : void
      {
         super.performOnOpenDefaultOps(param1,0.85);
      }
   }
}

