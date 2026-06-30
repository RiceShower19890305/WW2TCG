package com.fs.tcgengine.view.popups.pvp
{
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.greensock.TweenMax;
   import starling.core.Starling;
   import starling.events.Event;
   
   public class PopupSearchingPvPOpponent extends PopupStandard
   {
      
      private var mStartQueueTime:Number;
      
      private var mTipsText:FSTextfield;
      
      public function PopupSearchingPvPOpponent(param1:Boolean = true)
      {
         super(true);
      }
      
      private function checkTime() : void
      {
         var _loc1_:int = int(TimerUtil.msToSec(ServerConnection.smServerTimeMS - this.mStartQueueTime));
         var _loc2_:String = TextManager.getText("TID_PVP_SEARCHING",true) + "\n" + TextManager.getText("TID_PVP_TIME_ELAPSED",true) + ": " + _loc1_ + " " + TextManager.getText("TID_GEN_TIME_SECONDS_ABR",true);
         this.setMainFieldText(_loc2_);
         if(_loc1_ > 80)
         {
            PvPConnectionMng.removeFromPvPQueue(true);
            Utils.setLogText(TextManager.getText("TID_PVP_OPPONENT_NOTFOUND"));
         }
         else
         {
            TweenMax.delayedCall(1,this.checkTime);
         }
      }
      
      override public function setMainFieldText(param1:String = "") : void
      {
         super.setMainFieldText(param1);
         this.setExtraInfo();
      }
      
      private function setExtraInfo() : void
      {
         var rollTipText:Function = null;
         var fadeOutAndRoll:Function = null;
         var stageWidth:int = 0;
         var tipsAmount:int = 0;
         var getTipsAmount:Function = function():int
         {
            var _loc1_:Boolean = false;
            var _loc2_:String = "";
            var _loc3_:* = 0;
            while(_loc1_ == false)
            {
               _loc3_++;
               _loc2_ = TextManager.getText("TID_PVP_RULES_" + Utils.transformValueToString(_loc3_.toString(),2),true);
               if(_loc2_ == null || _loc2_ == "" || _loc2_.indexOf("[") == 0)
               {
                  _loc1_ = true;
                  _loc3_--;
               }
            }
            return _loc3_;
         };
         rollTipText = function(param1:int, param2:int = -1):void
         {
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            if(mTipsText)
            {
               mTipsText.alpha = 0;
               _loc3_ = Utils.randomInt(1,param1);
               _loc4_ = param2 != -1 ? int(param2 + 1) : _loc3_;
               _loc4_ = _loc4_ > param1 ? 1 : _loc4_;
               mTipsText.text = TextManager.getText("TID_PVP_RULES_0" + _loc4_,true);
               SpecialFX.tweenToAlpha(mTipsText,1,0.5,0);
               TweenMax.delayedCall(8,fadeOutAndRoll,[param1,_loc4_]);
            }
         };
         fadeOutAndRoll = function(param1:int, param2:int = -1):void
         {
            if(mTipsText)
            {
               SpecialFX.tweenToAlpha(mTipsText,0,0.5,0,rollTipText,[param1,param2]);
            }
         };
         if(this.mTipsText == null && Boolean(mBox))
         {
            stageWidth = Starling.current.stage.stageWidth;
            this.mTipsText = new FSTextfield(stageWidth * 0.85,mBox.height * 0.75,"",16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mTipsText.x = (stageWidth - this.mTipsText.width) / 2;
            this.mTipsText.y = Starling.current.stage.stageHeight - this.mTipsText.height;
            this.mTipsText.alpha = 0;
            Starling.current.stage.addChild(this.mTipsText);
            tipsAmount = getTipsAmount();
            rollTipText(tipsAmount);
         }
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         mAcceptButton.visible = false;
      }
      
      override public function onClose(param1:Event) : void
      {
         this.cancelMatch();
         var _loc2_:int = int(TimerUtil.msToSec(ServerConnection.smServerTimeMS - this.mStartQueueTime));
         FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_QUEUE_CANCELLED,{"timeEllapsed":_loc2_ + " sec"});
         super.onClose(param1);
      }
      
      private function cancelMatch() : void
      {
         PvPConnectionMng.removeFromPvPQueue(true);
         Utils.setLogText(TextManager.getText("TID_PVP_QUEUE_LEFT"));
         closePopup();
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
      
      public function setupPopup() : void
      {
         var _loc1_:Number = NaN;
         if(mBox)
         {
            _loc1_ = mAcceptButton ? mBox.height - mAcceptButton.height : mBox.height / 2;
            if(mInfoTextfield)
            {
               mInfoTextfield.height = _loc1_;
            }
         }
         TweenMax.killDelayedCallsTo(this.checkTime);
         TweenMax.delayedCall(1,this.checkTime);
         this.mStartQueueTime = ServerConnection.smServerTimeMS;
         if(PvPConnectionMng.smCurrentMatchId != "" && PvPConnectionMng.smCurrentMatchId != null && Boolean(mCloseButton))
         {
            mCloseButton.enabled = false;
         }
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         if(!mClosed && !PvPConnectionMng.smUserInPvPQueue)
         {
            closePopup();
         }
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mTipsText)
         {
            this.mTipsText.removeFromParent(true);
            this.mTipsText = null;
         }
         TweenMax.killDelayedCallsTo(this.checkTime);
         super.removeFromStage();
      }
   }
}

