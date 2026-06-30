package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.greensock.TweenMax;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import starling.events.Event;
   
   public class PopupAppRating extends PopupStandard
   {
      
      public static const PLAY_STORE_BASE_URI:String = "market://details?id=air.";
      
      private static const PLAY_REVIEW:String = "&reviewId=0";
      
      public static const APP_STORE_BASE_URI:String = "itms-apps://itunes.apple.com/app/id{appStoreId}?action=write-review";
      
      public static const ANDROID_STORE_BASE_URI:String = PLAY_STORE_BASE_URI;
      
      public function PopupAppRating(param1:Boolean = true)
      {
         super(false);
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         setupCancelButton(TextManager.getText("TID_GEN_REMIND_LATER"));
      }
      
      override protected function onAccept(param1:Event) : void
      {
         super.onAccept(param1);
         this.onRateTriggered();
      }
      
      private function onRateTriggered() : void
      {
         var _loc2_:URLRequest = null;
         if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            FSMapScreen(InstanceMng.getCurrentScreen()).performPortraitTransition(true);
         }
         InstanceMng.getUserDataMng().getOwnerUserData().setRatePopupShown(true);
         InstanceMng.getUserDataMng().updateFlags();
         var _loc1_:String = "";
         if(Utils.isIOS())
         {
            _loc1_ = APP_STORE_BASE_URI.replace("{appStoreId}",Config.getConfig().getiOSAppID());
         }
         else if(Utils.isAndroid())
         {
            _loc1_ = PLAY_STORE_BASE_URI + Utils.getNameSpace() + PLAY_REVIEW;
         }
         else if(Utils.isDesktop())
         {
            _loc1_ = Constants.STEAM_APP_PAGE + Config.getConfig().getSteamAppId();
         }
         else if(Utils.isBrowser())
         {
            if(InstanceMng.getApplication().isFacebookBrowser())
            {
               _loc1_ = Config.getConfig().getFanPageURL();
            }
            else
            {
               this.addKongRateReward();
            }
         }
         if(_loc1_ != "")
         {
            _loc2_ = new URLRequest(_loc1_);
            navigateToURL(_loc2_);
         }
      }
      
      public function addKongRateReward() : void
      {
         var _loc1_:Object = new Object();
         _loc1_.when = ServerConnection.smServerTimeMS;
         _loc1_.uid = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
         _loc1_.sku = "CUSTOM_GOLD";
         _loc1_.type = 3;
         _loc1_.amount = Config.getConfig().gameGetGoldGiftKongRate();
         _loc1_.origin = "KONG_RATE";
         InstanceMng.getServerConnection().createEntityInCollection("rewards",_loc1_);
      }
      
      override public function onClose(param1:Event) : void
      {
         super.onClose(param1);
         TweenMax.delayedCall(0.5,this.performPortraitTransition);
      }
      
      private function performPortraitTransition() : void
      {
         if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            FSMapScreen(InstanceMng.getCurrentScreen()).performPortraitTransition(true);
         }
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         var _loc4_:String = TextManager.getText("TID_GEN_RATE_NOW");
         if(Utils.isBrowser())
         {
            _loc4_ = InstanceMng.getApplication().isFacebookBrowser() ? TextManager.getText("TID_GEN_RATE_NOW_BROWSER") : TextManager.getText("TID_ACHIEVEMENT_CLAIM");
         }
         super.setupAcceptButton(_loc4_,param2,param3);
      }
   }
}

