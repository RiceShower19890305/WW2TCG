package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import starling.events.Event;
   
   public class PopupError extends PopupStandard
   {
      
      public static const PLAY_STORE_BASE_URI:String = "market://details?id=air.";
      
      public static const APP_STORE_BASE_URI:String = "itms-apps://itunes.apple.com/us/app/apple-store/id";
      
      private var mReloginButton:FSButton;
      
      private var mIsConnectionIssue:Boolean;
      
      private var mIsVersionOutdatedIssue:Boolean;
      
      private var mShowAcceptButton:Boolean = false;
      
      public function PopupError(param1:Boolean = true)
      {
         super(false);
      }
      
      override public function notifyAssetsLoaded() : void
      {
         super.notifyAssetsLoaded();
      }
      
      public function setupPopup(param1:Boolean, param2:Boolean = false, param3:Boolean = false) : void
      {
         this.mIsConnectionIssue = param1;
         this.mIsVersionOutdatedIssue = param3;
         if(this.mIsConnectionIssue && !Config.allowKeepPlayingAfterDisconnection())
         {
            if(InstanceMng.getBattleEngine())
            {
               InstanceMng.getBattleEngine().setBattleStateId(BattleEngine.BATTLE_STATE_BATTLE_OVER);
            }
         }
         this.mShowAcceptButton = param2;
         if(mAcceptButton)
         {
            mAcceptButton.visible = this.mShowAcceptButton;
            mAcceptButton.enabled = !InstanceMng.getServerConnection().wasDualConnectionDetected() && this.mIsConnectionIssue ? Utils.smRawInternetAvailable : true;
            if(this.mIsConnectionIssue)
            {
               mAcceptButton.text = TextManager.getText("TID_GEN_RELOGIN");
            }
            mAcceptButton.readjustSize();
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         if(this.mIsVersionOutdatedIssue)
         {
            Utils.onGoToAppStoreTriggered();
            InstanceMng.getApplication().exitApp();
         }
         else if(this.mIsConnectionIssue)
         {
            if(mAcceptButton)
            {
               mAcceptButton.enabled = false;
            }
            if(InstanceMng.getBattleEngine())
            {
               InstanceMng.getBattleEngine().setBattleStateId(BattleEngine.BATTLE_STATE_BATTLE_OVER);
               InstanceMng.getBattleEngine().onBattleOverCommonOps();
               if(InstanceMng.getBattleEngine().getBattleScreen())
               {
                  InstanceMng.getBattleEngine().getBattleScreen().performCardsLeavingFX(0,closePopup,[Utils.relogin]);
               }
            }
            else
            {
               closePopup(Utils.relogin);
            }
         }
         else
         {
            super.onAccept(param1);
         }
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mReloginButton)
         {
            this.mReloginButton.removeFromParent(true);
            this.mReloginButton = null;
         }
         super.removeFromStage();
      }
      
      override public function onConnectionChange() : void
      {
         if(Boolean(mAcceptButton) && mAcceptButton.visible)
         {
            mAcceptButton.enabled = !InstanceMng.getServerConnection().wasDualConnectionDetected() && this.mIsConnectionIssue ? Utils.smRawInternetAvailable : true;
         }
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         super.setupAcceptButton(param1,param2,param3);
         if(mAcceptButton)
         {
            mAcceptButton.visible = this.mShowAcceptButton;
            mAcceptButton.enabled = !InstanceMng.getServerConnection().wasDualConnectionDetected() && this.mIsConnectionIssue ? Utils.smRawInternetAvailable : true;
            if(this.mIsConnectionIssue)
            {
               mAcceptButton.text = TextManager.getText("TID_GEN_RELOGIN");
            }
         }
         if(Config.allowKeepPlayingAfterDisconnection())
         {
            if(this.mReloginButton == null)
            {
               this.mReloginButton = new FSButton(Root.assets.getTexture(Constants.ACCEPT_BUTTON_UP_NAME),TextManager.getText("TID_GEN_RELOGIN"));
               this.mReloginButton.x = mAcceptButton.x;
               this.mReloginButton.y = mAcceptButton.y;
               this.mReloginButton.addEventListener(Event.TRIGGERED,this.onClick);
            }
            this.setEnableReloginButton(true);
            if(this.mReloginButton)
            {
               addChild(this.mReloginButton);
            }
         }
      }
      
      private function onClick() : void
      {
         if(Utils.smInternetAvailable || Utils.smRawInternetAvailable)
         {
            this.setEnableReloginButton(false);
            InstanceMng.getServerConnection().loginUser(true);
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GEN_LOG_NEEDED"),true);
         }
      }
      
      public function setEnableReloginButton(param1:Boolean) : void
      {
         if(this.mReloginButton)
         {
            this.mReloginButton.enabled = param1;
         }
      }
   }
}

