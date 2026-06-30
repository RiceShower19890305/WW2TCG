package com.fs.tcgengine.view.popups.pvp
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.greensock.TweenMax;
   import starling.events.Event;
   
   public class PopupWaitingForOpponent extends PopupStandard
   {
      
      protected var mMatchId:String;
      
      private var mOwnerIsMatchCreator:Boolean;
      
      protected var mRequestTimer:Boolean;
      
      public function PopupWaitingForOpponent(param1:Boolean = true)
      {
         super(false);
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         mAcceptButton.visible = false;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         TweenMax.delayedCall(1.5,this.onMatchInfoACK);
         this.mRequestTimer = true;
      }
      
      public function setup(param1:String, param2:String, param3:Boolean, param4:Boolean = false) : void
      {
         this.mMatchId = param1;
         this.mOwnerIsMatchCreator = param3;
         setMainFieldText(param2);
         var _loc5_:int = param4 && !this.mOwnerIsMatchCreator ? int(TimerUtil.secondToMs(-3)) : 0;
         PvPConnectionMng.smExpirationTime = TimerUtil.currentTimeMillis() + this.getWaitingForOpponentDefaultTime() + _loc5_;
      }
      
      protected function getWaitingForOpponentDefaultTime() : int
      {
         return TimerUtil.secondToMs(PvPConnectionMng.smPvPOpponentFoundTime);
      }
      
      override public function onClose(param1:Event) : void
      {
         this.mRequestTimer = false;
         super.closePopup();
      }
      
      public function disableRequestTimer() : void
      {
         this.mRequestTimer = false;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:String = null;
         if(this.mRequestTimer)
         {
            _loc2_ = TextManager.getText("TID_PVP_OPPONENT_WAIT") + ": ";
            Utils.setLogText(TextManager.getText("TID_GEN_WAIT") + " " + _loc2_ + PvPConnectionMng.getTimeTextLeft(true),false,true,false,false);
            if(PvPConnectionMng.smExpirationTimeLeft <= 0)
            {
               this.cancelMatch();
            }
         }
      }
      
      protected function cancelMatch(param1:Boolean = true) : void
      {
         TweenMax.killDelayedCallsTo(this.onMatchInfoACK);
         PvPConnectionMng.setMatchDead(null,this.mMatchId);
         Utils.setLogText(TextManager.getText("TID_PVP_CANCELLED"));
         FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_COULD_NOT_BEGIN_DESYNCH);
         this.mRequestTimer = false;
         PvPConnectionMng.removeFromPvPQueue();
         if(param1)
         {
            closePopup();
         }
      }
      
      public function onMatchInfoACK(param1:String = "OK", param2:int = 0) : void
      {
         TweenMax.killDelayedCallsTo(this.onMatchInfoACK);
         if(PvPConnectionMng.areUserStatusOK(param1) || PvPConnectionMng.isPlayingVSAI())
         {
            this.checkIfMatchOKViaRequestingServer(param1);
         }
         else if(param2 > 3)
         {
            this.checkIfMatchOKViaRequestingServer(param1);
         }
         else
         {
            param2++;
            TweenMax.delayedCall(3,this.onMatchInfoACK,[param1,param2]);
         }
      }
      
      private function checkIfMatchOKViaRequestingServer(param1:String) : void
      {
         var onMatchInfoReceived:Function = null;
         var checkStatus:String = param1;
         onMatchInfoReceived = function(param1:Object):void
         {
            if(Utils.getDataId(param1) == PvPConnectionMng.smCurrentMatchId)
            {
               PvPConnectionMng.updateBattleSyncData(param1);
            }
            if(param1.status == PvPConnectionMng.MATCH_STATUS_DEAD)
            {
               if(InstanceMng.getBattleEngine())
               {
                  BattleEnginePvP(InstanceMng.getBattleEngine()).onOpponentTimeEndedPerformCommonOps();
                  BattleEnginePvP(InstanceMng.getBattleEngine()).onMatchDesynchronizedPerformOps(false,true);
               }
               FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_MATCH_DEAD);
            }
            else if(PvPConnectionMng.areUserStatusOK(checkStatus) || PvPConnectionMng.isPlayingVSAI())
            {
               onBothPlayersOK(PvPConnectionMng.isPlayingVSAI(),param1);
            }
         };
         PvPConnectionMng.getMatchInfo(this.mMatchId,onMatchInfoReceived);
      }
      
      protected function onBothPlayersOK(param1:Boolean, param2:Object = null) : void
      {
         if(PvPConnectionMng.smInitMatchInfoReceived == false)
         {
            PvPConnectionMng.smInitMatchInfoReceived = true;
            this.mRequestTimer = false;
            Utils.removeLog();
            if(this.mOwnerIsMatchCreator || param1)
            {
               PvPConnectionMng.startMatch();
            }
            PvPConnectionMng.prepareUserDecksInfo(param2);
         }
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
      
      override protected function removeFromStage() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.removeFromStage();
      }
   }
}

