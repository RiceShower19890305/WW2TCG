package com.fs.tcgengine.view.popups.levels
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import starling.events.Event;
   
   public class PopupActionPointsLeft extends PopupStandard
   {
      
      private var mBattleEngine:BattleEngine;
      
      private var mAllowAttack:Boolean;
      
      public function PopupActionPointsLeft(param1:Boolean = true)
      {
         super();
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         setupCancelButton(TextManager.getText("TID_GEN_BUTTON_CANCEL"));
      }
      
      override protected function onAccept(param1:Event) : void
      {
         if(this.mBattleEngine != null && this.mBattleEngine.isOnlineMatch() && !Utils.smInternetAvailable)
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
            return;
         }
         if(this.mBattleEngine != null)
         {
            if(mAcceptButton)
            {
               mAcceptButton.enabled = false;
            }
            if(mCancelButton)
            {
               mCancelButton.enabled = false;
            }
            if(this.mBattleEngine.getBattleScreen())
            {
               this.mBattleEngine.getBattleScreen().enableBoostsPanel(false);
            }
            this.mBattleEngine.disableAttackButton();
            if(Config.getConfig().gameHasSacrifice())
            {
               this.mBattleEngine.enableSacrificeButton(false);
            }
            else if(Config.getConfig().gameHasPowers())
            {
               if(this.mBattleEngine.isOwnerTurn())
               {
                  this.mBattleEngine.enableOwnerPowerButton(false);
                  if(this.mBattleEngine.getOwnerBattleInfo())
                  {
                     this.mBattleEngine.getOwnerBattleInfo().setPowerAvailable(false);
                  }
               }
               else
               {
                  this.mBattleEngine.enableOpponentPowerButton(false);
                  if(this.mBattleEngine.getOpponentBattleInfo())
                  {
                     this.mBattleEngine.getOpponentBattleInfo().setPowerAvailable(false);
                  }
               }
            }
            closePopup();
            if(this.mBattleEngine != null && this.mBattleEngine.isOnlineMatch() && !Utils.smInternetAvailable)
            {
               Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
               return;
            }
            if(!this.mBattleEngine.isOnlineMatch() || this.mBattleEngine.isOnlineMatch() && BattleEnginePvP(this.mBattleEngine).isAttackaAllowed())
            {
               if(Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen() is FSBattleScreen)
               {
                  FSBattleScreen(InstanceMng.getCurrentScreen()).getAttackButton().performCommonOpsBeforeAttacking(true);
               }
            }
            this.mBattleEngine.getBattleScreen().suggestPlayableCardOFF();
         }
      }
      
      override public function onClose(param1:Event) : void
      {
         super.onClose(param1);
         if(mAcceptButton)
         {
            mAcceptButton.enabled = false;
         }
         if(mCancelButton)
         {
            mCancelButton.enabled = false;
         }
         if(Boolean(this.mBattleEngine) && Boolean(this.mBattleEngine.getBattleScreen()))
         {
            this.mBattleEngine.getBattleScreen().suggestPlayableCardON();
         }
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         super.setupAcceptButton(TextManager.getText("TID_GEN_FIGHT"),param2,param3);
      }
      
      public function setup(param1:BattleEngine, param2:Boolean = true) : void
      {
         this.mBattleEngine = param1;
         this.mAllowAttack = param2;
         if(!this.mAllowAttack)
         {
            if(mAcceptButton)
            {
               mAcceptButton.visible = false;
            }
            if(mCancelButton)
            {
               mCancelButton.visible = false;
            }
         }
         if(mCloseButton)
         {
            mCloseButton.visible = !this.mAllowAttack;
         }
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
      
      override protected function removeFromStage() : void
      {
         this.mBattleEngine = null;
         super.removeFromStage();
      }
   }
}

