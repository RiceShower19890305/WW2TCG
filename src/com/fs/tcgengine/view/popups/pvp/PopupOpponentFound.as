package com.fs.tcgengine.view.popups.pvp
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.popups.player.PlayerPortrait;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.greensock.TweenMax;
   import starling.events.Event;
   
   public class PopupOpponentFound extends PopupStandard
   {
      
      private var mMatchId:String;
      
      private var mRequestTimer:Boolean;
      
      private var mExtraSecondsThatPassedInBackground:int;
      
      private var mOpponentPortrait:PlayerPortrait;
      
      private var mExtId:String;
      
      private var mMatchData:Object;
      
      public function PopupOpponentFound(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         createFields();
         FSDebug.debugTrace("[createUI] - Setting timer OpponentFound to TRUE");
         this.mRequestTimer = true;
         this.mExtraSecondsThatPassedInBackground = PvPConnectionMng.smPvPOpponentFoundTime - PvPConnectionMng.smTimeLeftAcceptOpponentFound;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         TweenMax.killDelayedCallsTo(PvPConnectionMng.checkIfPopupShownStillOpenForPvPOpponentFound);
      }
      
      private function modifyInfoTextfieldPos() : void
      {
         if(mInfoTextfield)
         {
            mInfoTextfield.height /= 2;
            mInfoTextfield.y = mCloseButton.y + mCloseButton.height / 1.5;
         }
      }
      
      private function createPortrait() : void
      {
         if(this.mExtId)
         {
            if(this.mOpponentPortrait == null)
            {
               this.mOpponentPortrait = new PlayerPortrait(this.mExtId,false);
               this.mOpponentPortrait.x = (width - this.mOpponentPortrait.width) / 2;
               this.mOpponentPortrait.y = this.mOpponentPortrait.height / 3;
               addChild(this.mOpponentPortrait);
            }
         }
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         if(!mClosed && Boolean(this.mOpponentPortrait))
         {
            this.mOpponentPortrait.loadProfilePicture();
         }
      }
      
      public function setup(param1:String, param2:Object, param3:String, param4:String = "") : void
      {
         this.mMatchData = param2;
         this.mMatchId = param1;
         setMainFieldText(param3);
         var _loc5_:Boolean = param2.hasOwnProperty("matchType") && param2["matchType"] == "FRIENDLY";
         var _loc6_:Boolean = param2.u1.uid == InstanceMng.getServerConnection().getUserId();
         var _loc7_:int = _loc5_ && !_loc6_ ? int(TimerUtil.secondToMs(-3)) : 0;
         PvPConnectionMng.smExpirationTime = TimerUtil.currentTimeMillis() + TimerUtil.secondToMs(PvPConnectionMng.smPvPOpponentFoundTime) + _loc7_;
         this.mExtId = param4;
         var _loc8_:Boolean = this.mExtId != null && this.mExtId != "";
         if(_loc8_)
         {
            this.createPortrait();
            this.modifyInfoTextfieldPos();
         }
         if(!Config.PVP_ALLOW_CANCEL_WHILE_SEARCHING && !_loc5_)
         {
            mAcceptButton.visible = false;
            mCloseButton.visible = false;
            TweenMax.delayedCall(3,closePopup);
            this.onMatchInfoReceivedUpdateMatch(param2);
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         closePopup(this.onAcceptPerformOps);
      }
      
      private function onAcceptPerformOps() : void
      {
         PvPConnectionMng.getMatchInfo(this.mMatchId,this.onMatchInfoReceivedUpdateMatch);
      }
      
      private function onMatchInfoReceivedUpdateMatch(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         if(param1 != null && param1.status != PvPConnectionMng.MATCH_STATUS_DEAD)
         {
            _loc2_ = param1.u1.uid == InstanceMng.getServerConnection().getUserId();
            _loc3_ = param1.u1.uid == InstanceMng.getServerConnection().getUserId() || param1.u2.uid == InstanceMng.getServerConnection().getUserId();
            if(_loc3_)
            {
               _loc4_ = param1.matchType == "FRIENDLY";
               PvPConnectionMng.smCurrentMatchId = this.mMatchId;
               if(_loc4_ && !_loc2_)
               {
                  InstanceMng.getPopupMng().openPlayPvPOnlinePopup(true);
               }
               else
               {
                  PvPConnectionMng.updateOwnerAcceptedMatch(param1);
                  InstanceMng.getPopupMng().openWaitingForOpponentPopup(this.mMatchId,TextManager.getText("TID_PVP_SYNC"),_loc2_,_loc4_);
               }
            }
            else
            {
               FSDebug.debugTrace("[onMatchInfoReceivedUpdateMatch] - Setting timer OpponentFound to FALSE");
               this.mRequestTimer = false;
               closePopup(this.onCancelPerformActions);
            }
         }
         else
         {
            closePopup(this.onCancelPerformActions);
         }
      }
      
      override public function onClose(param1:Event) : void
      {
         FSDebug.debugTrace("[onClose] - Setting timer OpponentFound to FALSE");
         this.mRequestTimer = false;
         closePopup(this.onCancelPerformActions);
         this.mExtraSecondsThatPassedInBackground = 0;
      }
      
      private function onCancelPerformActions() : void
      {
         PvPConnectionMng.removeFromPvPQueue(true);
         var _loc1_:Boolean = this.mMatchData.matchType == "FRIENDLY";
         if(_loc1_)
         {
            InstanceMng.getServerConnection().declineFriendlyPvP(1.5,this.mMatchData.u1.uid,this.mMatchData.u1.nick,TextManager.getText("TID_PVP_MATCH_CANCELLED"));
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_PVP_CANCELLED"));
         }
      }
      
      public function onMatchInfoReceivedDeleteMatch(param1:Object, param2:String) : void
      {
         PvPConnectionMng.setMatchDead(param1);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:String = null;
         if(this.mRequestTimer)
         {
            _loc2_ = TextManager.getText("TID_PVP_MATCH_TIME_LEFT") + " ";
            Utils.setLogText(TextManager.getText("TID_GEN_WAIT") + " " + _loc2_ + PvPConnectionMng.getTimeTextLeft(true,TimerUtil.secondToMs(this.mExtraSecondsThatPassedInBackground)),false,true,false,false);
            if(PvPConnectionMng.smExpirationTimeLeft <= 0)
            {
               FSDebug.debugTrace("[onEnterFrame] - Setting timer OpponentFound to FALSE");
               this.mRequestTimer = false;
               this.mExtraSecondsThatPassedInBackground = 0;
               Utils.removeLog();
               closePopup(this.onCancelPerformActions);
            }
         }
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mOpponentPortrait)
         {
            this.mOpponentPortrait.removeFromParent();
            this.mOpponentPortrait = null;
         }
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         InstanceMng.getPopupMng().removePopup(FSPopupMng.OPPONENT_FOUND_POPUP_NAME);
         super.removeFromStage();
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
   }
}

