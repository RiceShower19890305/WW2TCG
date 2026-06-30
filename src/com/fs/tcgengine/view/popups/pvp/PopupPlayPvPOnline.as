package com.fs.tcgengine.view.popups.pvp
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.screens.FSPvPScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.Utils;
   import starling.events.Event;
   
   public class PopupPlayPvPOnline extends PopupPlayPvPOffline
   {
      
      private var mGoToMatchOnAccept:Boolean = false;
      
      public function PopupPlayPvPOnline(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function removeFromStage() : void
      {
         if(mDeckSelectorOwner)
         {
            mDeckSelectorOwner.removeFromParent();
            mDeckSelectorOwner.destroy();
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.PLAY_PVP_ONLINE_POPUP_NAME);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.removeFromStage();
      }
      
      override protected function createDeckSelectors() : void
      {
         createDeckSelector(true);
      }
      
      override public function onClose(param1:Event) : void
      {
         closePopup(this.onCancelPerformActions);
      }
      
      private function onCancelPerformActions() : void
      {
         PvPConnectionMng.removeFromPvPQueue();
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         Utils.removeLog();
      }
      
      override protected function onAcceptPerformActions() : void
      {
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         if(_loc1_ is FSPvPScreen)
         {
            FSPvPScreen(_loc1_).refreshPlayPvPButtons(true);
         }
         if(!PvPConnectionMng.smPlayingFriendlyMatch && !this.mGoToMatchOnAccept)
         {
            if(InstanceMng.getUserDataMng())
            {
               InstanceMng.getUserDataMng().updateSelectedDeckIndexPvP();
            }
            PvPConnectionMng.enqueueInPvP();
         }
         else if(PvPConnectionMng.smPlayingFriendlyMatch)
         {
            if(InstanceMng.getUserDataMng())
            {
               InstanceMng.getUserDataMng().updateSelectedDeckIndexPvP();
            }
            if(this.mGoToMatchOnAccept)
            {
               PvPConnectionMng.getMatchInfo(PvPConnectionMng.smCurrentMatchId,this.onMatchInfoReceivedUpdateMatch);
            }
            else
            {
               PvPConnectionMng.sendFriendlyPvPRequest();
            }
         }
      }
      
      private function onMatchInfoReceivedUpdateMatch(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(param1 != null && param1.status != PvPConnectionMng.MATCH_STATUS_DEAD)
         {
            _loc2_ = param1.u1.uid == InstanceMng.getServerConnection().getUserId();
            _loc3_ = param1.u1.uid == InstanceMng.getServerConnection().getUserId() || param1.u2.uid == InstanceMng.getServerConnection().getUserId();
            if(_loc3_)
            {
               PvPConnectionMng.updateOwnerAcceptedMatch(param1);
               InstanceMng.getPopupMng().openWaitingForOpponentPopup(PvPConnectionMng.smCurrentMatchId,TextManager.getText("TID_PVP_SYNC"),_loc2_,true);
            }
         }
         else
         {
            closePopup(this.onCancelPerformActions);
            Utils.setLogText("You took to long to accept! Match already dead.");
         }
      }
      
      public function goToSyncPlayersOnAccept(param1:Boolean) : void
      {
         this.mGoToMatchOnAccept = param1;
         if(this.mGoToMatchOnAccept)
         {
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:String = TextManager.getText("TID_PVP_OPPONENT_WAIT") + ": ";
         Utils.setLogText(TextManager.getText("TID_GEN_WAIT") + " " + _loc2_ + PvPConnectionMng.getTimeTextLeft(true),false,true,false,false);
         if(PvPConnectionMng.smExpirationTimeLeft <= 0)
         {
            this.cancelMatch();
         }
      }
      
      protected function cancelMatch(param1:Boolean = true) : void
      {
         Utils.setLogText(TextManager.getText("TID_PVP_CANCELLED"));
         PvPConnectionMng.removeFromPvPQueue();
         if(param1)
         {
            closePopup();
         }
      }
   }
}

