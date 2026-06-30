package com.fs.tcgengine.controller
{
   import com.adobe.serialization.json.JSON;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.FSMenuScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.popups.misc.NotificationMessage;
   import com.greensock.TweenMax;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import mx.utils.ObjectUtil;
   
   public class FSFacebookPlugin
   {
      
      public static var smJustLoggedOutFromFB:Boolean;
      
      public static const FACEBOOK_GRAPH_PREFIX:String = "http://graph.facebook.com/";
      
      public var mOnSuccessFunction:Function;
      
      protected var mFBId:String;
      
      protected var mFBFirstName:String;
      
      protected var mInvokedNotificationsProcessed:Boolean = false;
      
      protected var mOwnerInfoRequested:Boolean = false;
      
      protected var mCardDefToShare:CardDef;
      
      protected var mDelayToShare:int;
      
      protected var mFB:*;
      
      private var mInvitableFriendsListReceived:Boolean;
      
      protected var mSessionStatus:int = -1;
      
      protected var mWaitingForFriendsCallback:Function = null;
      
      private var mFBAPIVersion:String = "v7.0";
      
      public function FSFacebookPlugin()
      {
         super();
         this.init();
      }
      
      public function getInstance() : Object
      {
         return null;
      }
      
      protected function init() : void
      {
         if(Utils.isBrowser())
         {
            this.mFB = InstanceMng.getApplication().getFacebookPlugin();
         }
      }
      
      public function getAppID() : String
      {
         var _loc1_:String = "";
         switch(Config.ENVIRONMENT_ACTIVE)
         {
            case Config.ENVIRONMENT_DEV:
               _loc1_ = Config.getConfig().fbGetAppId(true);
               break;
            case Config.ENVIRONMENT_PROD:
               _loc1_ = Config.getConfig().fbGetAppId(false);
         }
         if(_loc1_ == null || _loc1_ == "")
         {
            if(Capabilities.isDebugger)
            {
               throw new Error("Facebook Id can not be null or empty!");
            }
         }
         return _loc1_;
      }
      
      public function login(param1:Function = null, param2:Boolean = true) : void
      {
         if(ServerConnection.smServerPlayerBlacklisted)
         {
            InstanceMng.getPopupMng().closePopupShown();
            InstanceMng.getPopupMng().openErrorPopup(TextManager.getText("TID_GEN_FRAUD_PURCHASE"),false);
            return;
         }
         if(ServerConnection.smServerPlayerDuplicated)
         {
            InstanceMng.getPopupMng().closePopupShown();
            InstanceMng.getPopupMng().openErrorPopup(TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"),false);
            return;
         }
         this.mOnSuccessFunction = param1;
         if(Utils.isBrowser())
         {
            if(this.mFB != null)
            {
               this.mFB.init(this.getAppID(),null);
               this.mFB.login(this.onBrowserLoginRequested,{"scope":this.getReadPermissions().toString()});
            }
         }
      }
      
      private function onBrowserLoginRequested(param1:Object, param2:Object) : void
      {
         if(param1)
         {
            if(param1.uid != null)
            {
               this.requestOwnerInfoToFB();
            }
            else
            {
               Utils.setLogText("Please, refresh the page and accept the permissions in order to be able to play");
            }
         }
         else
         {
            this.mFB.getLoginStatus();
            this.mFB.addJSEventListener("auth.statusChange",this.onStatusChange);
         }
      }
      
      private function onStatusChange(param1:Object) : void
      {
         if(param1.status === "connected")
         {
            this.requestOwnerInfoToFB();
         }
         else
         {
            FSDebug.debugTrace("Still no permissions granted");
         }
      }
      
      public function logout() : void
      {
         FSDebug.debugTrace("Attempting to logout from FB");
         if(Utils.smInternetAvailable && Boolean(this.mFB))
         {
            FSDebug.debugTrace("[logout] - Close session and clear token info");
            this.closeSessionAndClearTokenInformation();
            this.onLogoutPerformOps();
         }
         FSTracker.trackMiscAction(FSTracker.CATEGORY_MISC,FSTracker.ACTION_FB_LOGOUT);
      }
      
      protected function getReadPermissions(param1:Boolean = false) : Array
      {
         return param1 ? ["public_profile","user_friends"] : ["public_profile"];
      }
      
      protected function getPostPermissions() : Array
      {
         return [];
      }
      
      protected function onReadPermissionsCallBack(param1:Boolean, param2:Boolean, param3:String = null) : void
      {
         if(param1)
         {
            FSDebug.debugTrace("Login success");
            if(this.mOnSuccessFunction != null)
            {
               this.mOnSuccessFunction();
            }
            this.requestOwnerInfoToFB();
         }
         else
         {
            if(param3)
            {
               FSDebug.debugTrace("onReadPermissionsCallBack err: " + param3.toString());
               FSTracker.trackMiscAction(FSTracker.CATEGORY_MISC,FSTracker.ACTION_FB_READ_KO,{"error4":param3.toString()});
               if(InstanceMng.getCurrentScreen())
               {
                  InstanceMng.getCurrentScreen().onConnectionChange();
               }
               Utils.setLogText(TextManager.getText("TID_LOGIN_FACEBOOK_FAIL"),true);
               return;
            }
            if(param2)
            {
               if(InstanceMng.getCurrentScreen())
               {
                  InstanceMng.getCurrentScreen().onConnectionChange();
               }
               return;
            }
         }
         FSDebug.debugTrace("success:" + param1 + ",userCancelled:" + param2 + ",error:" + param3);
      }
      
      public function isSessionOpen() : Boolean
      {
         return this.mFB != null && this.isFBSessionOpen() && (Utils.isMobile() && Utils.smInternetAvailable || !Utils.isMobile());
      }
      
      protected function isFBSessionOpen() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.mSessionStatus == -1)
         {
            _loc1_ = this.mFB != null && this.mFB.getAuthResponse() != null && this.mFB.getAuthResponse().accessToken != null;
            this.mSessionStatus = _loc1_ == true ? 1 : 0;
         }
         else
         {
            if(this.mSessionStatus == 1)
            {
               return true;
            }
            _loc1_ = this.mFB != null && this.mFB.getAuthResponse() != null && this.mFB.getAuthResponse().accessToken != null;
            this.mSessionStatus = _loc1_ == true ? 1 : 0;
            _loc1_ = this.mSessionStatus == 1;
         }
         return _loc1_;
      }
      
      public function requestOwnerInfoToFB() : void
      {
         var _loc1_:Dictionary = null;
         if(Utils.smInternetAvailable)
         {
            if(!this.mOwnerInfoRequested)
            {
               FSDebug.debugTrace("[requestOwnerInfoToFB] - requesting owner info");
               this.mOwnerInfoRequested = true;
               _loc1_ = new Dictionary(true);
               _loc1_["fields"] = "payment_mobile_pricepoints";
               this.requestWithGraphPath("/me",_loc1_,"GET",this.onMe);
            }
            else
            {
               FSDebug.debugTrace("[requestOwnerInfoToFB] - owner info already requested");
            }
         }
      }
      
      public function requestWithGraphPath(param1:String, param2:Object = null, param3:String = "GET", param4:Function = null) : void
      {
         if(Utils.isBrowser() && Utils.smInternetAvailable)
         {
            this.mFB.api(param1,param4,param2,param3);
         }
      }
      
      public function requestProfilePicture(param1:String, param2:Function = null) : void
      {
         this.requestWithGraphPath("/" + param1,["picture.width(64)"],"GET",param2);
      }
      
      protected function isFBPostingAllowed() : Boolean
      {
         return true;
      }
      
      public function shareGame() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         if(Boolean(this.mFB) && this.isFBSessionOpen())
         {
            if(this.isFBPostingAllowed())
            {
               Utils.setLogText(TextManager.getText("TID_SHARE_INVITE_FRIEND"),false,false,false);
               _loc1_ = Utils.getShareGameText();
               _loc2_ = new Object();
               _loc2_.app_id = this.getAppID();
               _loc2_.from = this.mFBId;
               if(!Utils.isMobile())
               {
                  _loc2_.redirect_uri = Config.getConfig().getFanPageURL();
               }
               _loc2_.name = _loc1_;
               _loc2_.caption = _loc1_;
               _loc2_.description = _loc1_;
               _loc2_.picture = InstanceMng.getApplication().getCDNDomain() + Config.getConfig().getStorageNamespace() + "/share/share_game.jpg";
               _loc2_.link = Config.getConfig().getFanPageURL();
               this.dialog("feed",_loc2_,this.onShareGame);
            }
            else
            {
               this.reRequestDeclinedPermissions(this.getPostPermissions(),this.onPostPermissionAcceptedAfterAttemptingToShare);
            }
         }
      }
      
      protected function onShareGame(param1:Object, param2:Object = null) : void
      {
         if(param1)
         {
            FSDebug.debugTrace("Shared successfully");
            if(Config.getConfig().hasQuests())
            {
               InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_SHARE_GAME_QUEST,1);
            }
         }
         else
         {
            FSDebug.debugTrace("Shared FAILED");
         }
      }
      
      public function shareCardReceived(param1:CardDef, param2:int = 0) : void
      {
         var _loc3_:Object = null;
         var _loc4_:RarityDef = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(Boolean(this.mFB) && this.isFBSessionOpen())
         {
            if(this.isFBPostingAllowed())
            {
               if(param1)
               {
                  _loc3_ = new Object();
                  _loc3_.app_id = this.getAppID();
                  _loc3_.from = this.mFBId;
                  if(Utils.isMobile())
                  {
                     _loc3_.link = Config.getConfig().getFanPageURL();
                  }
                  else
                  {
                     _loc3_.redirect_uri = Config.getConfig().getFanPageURL();
                  }
                  _loc4_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(param1.getCardRarity()));
                  switch(_loc4_.getIndex())
                  {
                     case 2:
                        _loc5_ = "TID_SHARE_RARE_WON";
                        break;
                     case 3:
                        _loc5_ = "TID_SHARE_EPIC_WON";
                        break;
                     case 4:
                        _loc5_ = "TID_SHARE_LEGENDARY_WON";
                  }
                  _loc6_ = param1.getBGImageName();
                  _loc3_.name = TextManager.getText(_loc5_,true);
                  _loc3_.caption = TextManager.getText("TID_SHARE_CARD_WON",true);
                  _loc3_.description = Utils.getCardDescriptionForShare(param1);
                  _loc3_.picture = Utils.getCardsPath() + _loc6_ + "." + Config.getConfig().getGameShareImageExtension();
                  _loc7_ = Utils.isMobile() ? "photo" : "feed";
                  this.dialog(_loc7_,_loc3_,this.onShare,param2);
               }
            }
            else
            {
               this.mCardDefToShare = param1;
               this.mDelayToShare = param2;
               this.reRequestDeclinedPermissions(this.getPostPermissions(),this.onPostPermissionAcceptedAfterAttemptingToShare);
            }
         }
      }
      
      public function reRequestDeclinedPermissions(param1:Array, param2:Function = null, param3:Boolean = false) : void
      {
         if(Utils.isBrowser())
         {
            this.mFB.login(param2,{
               "scope":param1.toString(),
               "auth_type":"rerequest"
            });
         }
      }
      
      public function dialog(param1:String, param2:Object = null, param3:Function = null, param4:int = 0) : void
      {
         var method:String = param1;
         var data:Object = param2;
         var callback:Function = param3;
         var delay:int = param4;
         if(Utils.isBrowser())
         {
            if(data)
            {
               data["exclude_ids"] = [this.mFBId];
            }
            this.mFB.ui(method,data,function callbackF(param1:*):void
            {
               FSDebug.debugTrace("STOP");
               var _loc2_:int = Boolean(param1) && Boolean(param1.hasOwnProperty("error_code")) ? int(param1["error_code"]) : -1;
               var _loc3_:Boolean = _loc2_ == -1;
               if(callback != null)
               {
                  callback(_loc3_);
               }
            },null);
         }
      }
      
      public function sendLife(param1:String, param2:String = null) : void
      {
         var _loc3_:Object = null;
         if(Boolean(this.mFB) && this.isFBSessionOpen())
         {
            _loc3_ = new Object();
            _loc3_.app_id = this.getAppID();
            _loc3_.message = TextManager.getText("TID_LIFE_SENT_WW2");
            _loc3_.title = "Facebook Request!";
            _loc3_.data = "type=" + NotificationMessage.NOTIFICATION_TYPE_LIFE_RECEIVED;
            if(param2)
            {
               _loc3_.data += "&extraData=" + param2;
            }
            _loc3_.to = param1;
            this.dialog("apprequests",_loc3_,this.onLifeSent);
         }
      }
      
      public function sendInvitation(param1:String) : void
      {
         var _loc2_:Object = null;
         if(Boolean(this.mFB) && this.isFBSessionOpen())
         {
            _loc2_ = new Object();
            _loc2_.app_id = this.getAppID();
            _loc2_.message = TextManager.getText("TID_GEN_INVITATION_WW2");
            _loc2_.title = "Facebook Request!";
            _loc2_.data = "type=" + NotificationMessage.NOTIFICATION_TYPE_INVITE;
            _loc2_.to = param1;
            this.dialog("apprequests",_loc2_,this.onInvitesSent);
         }
      }
      
      public function sendMapUnlockHelp(param1:String, param2:String = null) : void
      {
         var _loc3_:Object = null;
         if(Boolean(this.mFB) && this.isFBSessionOpen())
         {
            _loc3_ = new Object();
            _loc3_.app_id = this.getAppID();
            _loc3_.message = TextManager.getText("TID_SOCIAL_RECEIVE_UNLOCK_FRIEND");
            _loc3_.title = "Facebook Request!";
            _loc3_.data = "type=" + NotificationMessage.NOTIFICATION_TYPE_UNLOCK_HELP_RECEIVED;
            _loc3_.to = param1;
            this.dialog("apprequests",_loc3_,this.onMapUnlockHelpSent);
         }
      }
      
      public function processTargetURL(param1:String) : void
      {
         var vars:URLVariables = null;
         var targetURL:String = null;
         var urlUnescaped:String = null;
         var requestIds:String = null;
         var reqId:String = null;
         var reqIdsArr:Array = null;
         var i:int = 0;
         var url:String = param1;
         try
         {
            if(url != null)
            {
               vars = new URLVariables(url);
               targetURL = vars.target_url;
               urlUnescaped = unescape(targetURL);
               if(urlUnescaped != null && urlUnescaped != "null")
               {
                  vars.decode(urlUnescaped);
                  requestIds = vars.request_ids;
                  if(requestIds != null && requestIds != "")
                  {
                     reqIdsArr = requestIds.split(",");
                     i = 0;
                     while(i < reqIdsArr.length)
                     {
                        reqId = reqIdsArr[i];
                        this.openFBRequestObject(reqId);
                        i++;
                     }
                  }
                  this.mInvokedNotificationsProcessed = true;
               }
            }
         }
         catch(e:Error)
         {
            FSDebug.debugTrace("Error catched on Facebook Plugin > processTargetURL - " + Error.getErrorMessage(0));
         }
      }
      
      protected function openFBRequestObject(param1:String) : void
      {
         var _loc2_:Object = null;
         if(Boolean(this.mFB) && this.isSessionOpen())
         {
            FSDebug.debugTrace("Opening FB Request object id: " + param1);
            _loc2_ = new Object();
            _loc2_.access_token = this.getAccessToken();
            this.requestWithGraphPath("/" + param1,_loc2_,"GET",this.onFBRequestObjectReceived);
         }
      }
      
      protected function onFBRequestObjectReceived(param1:Object, param2:Object = null) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:URLVariables = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:UserData = null;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         if(param1 != null && (!param1.hasOwnProperty("error") || param1.hasOwnProperty("error") && param1.error == null))
         {
            _loc3_ = param1.hasOwnProperty("from");
            if(_loc3_)
            {
               _loc4_ = param1.from.id;
               _loc5_ = param1.from.name;
               _loc6_ = param1.data;
               _loc7_ = new URLVariables(_loc6_);
               _loc8_ = int(_loc7_.type);
               _loc9_ = _loc7_.extra_data;
               _loc10_ = param1.id ? String(param1.id).split("_")[0] : "";
               _loc11_ = Utils.getOwnerUserData();
               if(_loc11_)
               {
                  _loc12_ = _loc8_ == NotificationMessage.NOTIFICATION_TYPE_PVP_REQUEST;
                  _loc13_ = _loc11_.isWaitingForMapToUnlock();
                  if(_loc12_ || !_loc13_ && _loc8_ == NotificationMessage.NOTIFICATION_TYPE_UNLOCK_HELP_RECEIVED)
                  {
                     this.deleteNotificationOnFB(_loc10_);
                     return;
                  }
               }
               InstanceMng.getServerConnection().addNotificationReceived(_loc10_,_loc8_,_loc4_,_loc5_,_loc9_,this.onObjectAddedToCollection);
            }
            else
            {
               FSDebug.debugTrace("DATA INVALID! Facebook SDK deprecated?");
            }
         }
      }
      
      protected function onObjectAddedToCollection(param1:String) : void
      {
         FSDebug.debugTrace("Object added succesfully");
         this.deleteNotificationOnFB(param1);
      }
      
      protected function deleteNotificationOnFB(param1:String) : void
      {
         if(this.mFB)
         {
            if(Utils.isBrowser())
            {
               this.requestWithGraphPath("/" + param1 + "?method=delete&",null,"GET",this.onFBNotificationDeleted);
            }
         }
      }
      
      protected function onFBNotificationDeleted(param1:Object, param2:Object = null) : void
      {
         if(param1)
         {
            FSDebug.debugTrace("Facebook notification processed and deleted from FB" + param1.toString());
         }
      }
      
      public function getFBId() : String
      {
         return this.mFBId;
      }
      
      public function getFBName() : String
      {
         return this.mFBFirstName;
      }
      
      public function getAccessToken() : String
      {
         return "";
      }
      
      public function getInvitableFriendsList(param1:Function = null) : void
      {
         var _loc2_:Dictionary = null;
         FSDebug.debugTrace("Getting fB friends");
         if(this.isFacebookPluginValid())
         {
            _loc2_ = new Dictionary(true);
            _loc2_["fields"] = "installed,first_name,picture.width(64)";
            _loc2_.access_token = this.getAccessToken();
            this.requestInvitableFriends(_loc2_,param1);
         }
      }
      
      protected function onInvitableFriends(param1:Object, param2:Object = null) : void
      {
         FSDebug.debugTrace("Invitable Friends list received");
         this.mInvitableFriendsListReceived = true;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(param1))
         {
            if(Utils.isMobile())
            {
               InstanceMng.getUserDataMng().fillFriendsList(param1.data);
            }
            else
            {
               InstanceMng.getUserDataMng().fillFriendsList(param1);
            }
            if(this.mWaitingForFriendsCallback != null)
            {
               this.mWaitingForFriendsCallback.apply();
               this.mWaitingForFriendsCallback = null;
            }
         }
      }
      
      public function getFBNotificationsFromFB() : void
      {
         var _loc1_:Object = null;
         if(Config.smNotificationsSystemEnabled && this.isFacebookPluginValid() && this.isSessionOpen())
         {
            FSDebug.debugTrace("[getFBNotificationsFromFB] - Getting FB notifications from FB");
            _loc1_ = new Object();
            _loc1_.access_token = this.getAccessToken();
            this.requestFBNotifications(_loc1_);
         }
      }
      
      private function requestInvitableFriends(param1:Object, param2:Function = null) : void
      {
         if(param2 != null)
         {
            this.mWaitingForFriendsCallback = param2;
         }
         this.requestWithGraphPath("/me/friends",param1,"GET",this.onInvitableFriends);
      }
      
      protected function requestFBNotifications(param1:Object) : void
      {
         this.requestWithGraphPath("/me/apprequests",param1,"GET",this.onFBNotifsReceivedFromFB);
      }
      
      protected function onFBNotifsReceivedFromFB(param1:Object, param2:Object = null) : void
      {
         var _loc3_:Object = null;
         FSDebug.debugTrace("[onFBNotifisReceivedFromFB] - Notifications Data received from FB");
         if(param1 != null)
         {
            if(Utils.isMobile())
            {
               if(param1.apprequests != null && param1.apprequests.data != null)
               {
                  for each(_loc3_ in param1.apprequests.data)
                  {
                     this.onFBRequestObjectReceived(_loc3_);
                  }
               }
               else if(param1.data != null)
               {
                  for each(_loc3_ in param1.data)
                  {
                     this.openFBRequestObject(_loc3_.id);
                  }
               }
               else
               {
                  for each(_loc3_ in param1)
                  {
                     if(_loc3_.application != null)
                     {
                        this.onFBRequestObjectReceived(_loc3_,param2);
                     }
                     else
                     {
                        this.openFBRequestObject(_loc3_.id);
                     }
                  }
               }
            }
            else
            {
               for each(_loc3_ in param1)
               {
                  if(_loc3_.application != null)
                  {
                     this.onFBRequestObjectReceived(_loc3_,param2);
                  }
                  else
                  {
                     this.openFBRequestObject(_loc3_.id);
                  }
               }
            }
            TweenMax.delayedCall(2,InstanceMng.getServerConnection().getNotifications);
         }
         else if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            InstanceMng.getServerConnection().getNotifications();
         }
      }
      
      public function requestLives(param1:String = null) : void
      {
         var _loc2_:Object = null;
         if(Boolean(this.mFB) && this.isFBSessionOpen())
         {
            _loc2_ = new Object();
            _loc2_.app_id = this.getAppID();
            _loc2_.message = TextManager.getText("TID_GEN_SEND_ME_LIVES");
            _loc2_.title = "Facebook Request!";
            _loc2_.data = "type=" + NotificationMessage.NOTIFICATION_TYPE_LIFE_REQUESTED;
            if(param1 != "" && param1 != null && Utils.isBrowser())
            {
               _loc2_.exclude_ids = [param1];
            }
            this.dialog("apprequests",_loc2_,this.onLivesRequestSent);
         }
      }
      
      public function requestUnlock(param1:String = null) : void
      {
         var _loc2_:Object = null;
         if(Boolean(this.mFB) && this.isFBSessionOpen())
         {
            _loc2_ = new Object();
            _loc2_.app_id = this.getAppID();
            _loc2_.message = TextManager.getText("TID_GEN_HELP_UNLOCK_MAP");
            _loc2_.title = "Facebook Request!";
            _loc2_.data = "type=" + NotificationMessage.NOTIFICATION_TYPE_UNLOCK_HELP_REQUESTED;
            if(param1 != "" && param1 != null && Utils.isBrowser())
            {
               _loc2_.exclude_ids = [param1];
            }
            this.dialog("apprequests",_loc2_,this.onUnlockHelpRequestSent);
         }
      }
      
      public function onLogoutPerformOps(param1:Boolean = true, param2:Boolean = false) : void
      {
         this.mFBId = "";
         this.mFBFirstName = "";
         this.mOwnerInfoRequested = false;
         this.onFBLoggedOutPerformCommonOps(param2);
         if(param1)
         {
            Utils.setLogText(TextManager.getText("TID_FACEBOOK_LOGOUT"));
         }
      }
      
      private function onFBLoggedOutPerformCommonOps(param1:Boolean = false) : void
      {
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         if(_loc2_ != null)
         {
            if(param1 && Boolean(InstanceMng.getFacebookPlugin()))
            {
               this.closeSessionAndClearTokenInformation();
            }
            if(_loc2_ is FSMapScreen)
            {
               FSMapScreen(_loc2_).removeAllMapsProfilePictures();
            }
            if(_loc2_ is FSMenuScreen)
            {
               FSMenuScreen(_loc2_).refreshButtons();
            }
            if(InstanceMng.getUserDataMng())
            {
               InstanceMng.getUserDataMng().purgeFriendsData();
               if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
               {
                  InstanceMng.getUserDataMng().getOwnerUserData().setNotificationsReceived(null);
               }
            }
            smJustLoggedOutFromFB = true;
            if(InstanceMng.getUserDataMng())
            {
               InstanceMng.getUserDataMng().resetOwnerUserData();
            }
            Utils.smInternetAvailable = false;
            InstanceMng.getServerConnection().forcePlayerDisconnection();
         }
      }
      
      protected function isFacebookPluginValid() : Boolean
      {
         return Utils.isMobile() ? this.mFB != null : true;
      }
      
      public function setFirstName(param1:String) : void
      {
         this.mFBFirstName = param1;
      }
      
      protected function onMe(param1:Object, param2:Object = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         if(this.isFacebookPluginValid() && param1 != null)
         {
            if(param1.id != null)
            {
               if(param1.error != null)
               {
                  if(param1.error.message)
                  {
                     Utils.setLogText("FB Error: " + param1.error.message,true,false,false,false);
                  }
               }
               else
               {
                  FSDebug.debugTrace("[onMe] - Logged on Facebook Succesfully");
                  this.mFBId = param1.id;
                  _loc3_ = param1.hasOwnProperty("payment_mobile_pricepoints") && Boolean(param1["payment_mobile_pricepoints"].hasOwnProperty("user_currency")) ? param1["payment_mobile_pricepoints"]["user_currency"] : "";
                  if(_loc3_ != "")
                  {
                     FSInAppsManager.smCurrencySymbol = _loc3_;
                  }
                  if(this.mFBFirstName == null || this.mFBFirstName == "")
                  {
                     this.mFBFirstName = Utils.isBrowser() ? param1.first_name : param1.name;
                  }
                  _loc4_ = Boolean(InstanceMng.getServerConnection()) && InstanceMng.getServerConnection().isUserLoggedIn();
                  if(Utils.isBrowser())
                  {
                     InstanceMng.getServerConnection().loginUser();
                  }
                  else
                  {
                     _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getExtId();
                     FSDebug.debugTrace("[onMe] - mFBId: " + this.mFBId);
                     FSDebug.debugTrace("[onMe] - offline extId: " + _loc5_);
                     if(this.mFBId == null)
                     {
                        FSDebug.debugTrace("[onMe] - FBID = null attempt to login");
                        InstanceMng.getServerConnection().loginUser();
                        return;
                     }
                     if(this.mFBId != _loc5_ && (_loc5_ != "" && _loc5_ != "sample") && InstanceMng.getServerConnection().isUserLoggedIn())
                     {
                        FSDebug.debugTrace("[onMe] - Logging out user and will check if needs to link");
                     }
                     else
                     {
                        FSDebug.debugTrace("[onMe] - Directly checking if needs to link");
                        if(Utils.smInternetAvailable)
                        {
                           InstanceMng.getServerConnection().loginViaFB();
                        }
                     }
                  }
               }
            }
            else if(param2 != null)
            {
               Utils.setLogText("Facebook Error: " + param1.error + " " + param2.errorMessage,true,false,false,false);
            }
         }
         else
         {
            this.mOwnerInfoRequested = false;
            this.requestOwnerInfoToFB();
         }
      }
      
      public function setFBId(param1:String) : void
      {
         this.mFBId = param1;
      }
      
      public function closeSessionAndClearTokenInformation(param1:Function = null) : void
      {
         var onLogout:Function = null;
         var onSuccess:Function = param1;
         onLogout = function(param1:Boolean):void
         {
            FSDebug.debugTrace("OnLogged out success? " + param1);
            mOwnerInfoRequested = false;
            if(onSuccess != null)
            {
               onSuccess();
            }
         };
         if(Utils.isBrowser())
         {
            this.mFB.logout(onLogout);
         }
      }
      
      protected function onShare(param1:Boolean) : void
      {
         if(param1)
         {
            FSDebug.debugTrace("Shared successfully");
            setTimeout(Utils.setLogText,1000,TextManager.getText("TID_SHARE_SUCCESS"));
         }
         else
         {
            FSDebug.debugTrace("Shared FAILED");
            setTimeout(Utils.setLogText,1000,TextManager.getText("TID_SHARE_PROBLEM") + " - Make sure Facebook Native app is installed");
         }
         this.mCardDefToShare = null;
         this.mDelayToShare = 0;
      }
      
      protected function onPostPermissionAcceptedAfterAttemptingToShare(param1:Boolean, param2:Boolean, param3:String = null) : void
      {
         if(param1)
         {
            InstanceMng.getUserDataMng().getOwnerUserData().setFBPostingOn(true);
            InstanceMng.getUserDataMng().updateFlags();
            if(this.mCardDefToShare)
            {
               this.shareCardReceived(this.mCardDefToShare,this.mDelayToShare);
            }
            else
            {
               this.shareGame();
            }
         }
      }
      
      protected function onLifeSent(param1:Object, param2:Object = null) : void
      {
         var _loc4_:URLVariables = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc3_:Boolean = param2 != null || param1.hasOwnProperty("error_code");
         if(!_loc3_)
         {
            _loc4_ = new URLVariables(param1.params);
            if(_loc4_ != null)
            {
               _loc5_ = true;
               _loc6_ = 0;
               _loc7_ = "";
               _loc8_ = 100;
               _loc9_ = 0;
               while(_loc5_)
               {
                  if(_loc4_["to[" + _loc6_ + "]"] != null)
                  {
                     _loc7_ += _loc4_["to[" + _loc6_ + "]"] + ",";
                     _loc6_++;
                  }
                  else
                  {
                     _loc5_ = false;
                     _loc10_ = String(_loc7_).lastIndexOf(",");
                     _loc7_ = String(_loc7_).slice(0,_loc10_);
                  }
                  if(++_loc9_ >= 100)
                  {
                     return;
                  }
               }
            }
         }
         else
         {
            FSDebug.debugTrace("Error on Facebook");
         }
      }
      
      protected function onInvitesSent(param1:Object, param2:Object = null) : void
      {
         var _loc3_:Boolean = param2 != null || param1.hasOwnProperty("error_code");
         if(!_loc3_)
         {
            FSDebug.debugTrace("Invitations sent");
         }
         else
         {
            FSDebug.debugTrace("Error on Facebook");
         }
      }
      
      protected function onMapUnlockHelpSent(param1:Object, param2:Object = null) : void
      {
         var _loc3_:Boolean = param2 != null || param1.hasOwnProperty("error_code");
         if(!_loc3_)
         {
            FSDebug.debugTrace("map unlock help sent");
         }
         else
         {
            FSDebug.debugTrace("Error on Facebook");
         }
      }
      
      protected function onUnlockHelpRequestSent(param1:Object, param2:Object = null) : void
      {
         var _loc3_:Boolean = param2 != null || param1.hasOwnProperty("error_code");
         if(!_loc3_)
         {
            FSDebug.debugTrace("Unlock help Request sent");
         }
         else
         {
            FSDebug.debugTrace("Error on Facebook");
         }
      }
      
      protected function onLivesRequestSent(param1:Object, param2:Object = null) : void
      {
         var _loc4_:URLVariables = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc3_:Boolean = param2 != null || param1.hasOwnProperty("error_code");
         if(!_loc3_)
         {
            FSDebug.debugTrace("Lives Request sent");
            _loc4_ = new URLVariables(param1.params);
            if(_loc4_ != null)
            {
               _loc5_ = true;
               _loc6_ = 0;
               _loc7_ = "";
               while(_loc5_)
               {
                  if(_loc4_["to[" + _loc6_ + "]"] != null)
                  {
                     _loc7_ += _loc4_["to[" + _loc6_ + "]"] + ",";
                     _loc6_++;
                  }
                  else
                  {
                     _loc5_ = false;
                     _loc8_ = String(_loc7_).lastIndexOf(",");
                     _loc7_ = String(_loc7_).slice(0,_loc8_);
                  }
               }
               if(_loc7_ != null && _loc7_ != "")
               {
                  InstanceMng.getUserDataMng().updateLifeRequested(_loc7_);
               }
            }
         }
         else
         {
            FSDebug.debugTrace("Error on Facebook");
         }
      }
      
      protected function getMapsPath() : String
      {
         return InstanceMng.getApplication().getCDNDomain() + Config.getConfig().getStorageNamespace() + "/share/maps/";
      }
      
      protected function getLevelsPath() : String
      {
         return InstanceMng.getApplication().getCDNDomain() + Config.getConfig().getStorageNamespace() + "/share/levels/";
      }
      
      protected function getAppNameSpace(param1:Boolean = false) : String
      {
         return Config.ENVIRONMENT_ACTIVE == Config.ENVIRONMENT_PROD || param1 ? Config.getConfig().fbGetNameSpace() : Config.getConfig().fbGetNameSpace() + "-dev";
      }
      
      public function requestProducts(param1:Array) : void
      {
         this.requestMultipleProducts(param1,this.onProductsProcessed);
      }
      
      private function onProductsProcessed(param1:Array) : void
      {
         if(param1 != null)
         {
            InstanceMng.getApplication().getInAppsManager().dispatchEvent(new InAppEvent(FSInAppsManager.PRODUCTS_REQUESTED,com.adobe.serialization.json.JSON.encode(param1),true,false));
         }
      }
      
      private function createProductURL(param1:String) : String
      {
         return InstanceMng.getResourcesMng().getCDNInfix(true) + param1 + ".html";
      }
      
      private function requestMultipleProducts(param1:Array, param2:Function = null) : void
      {
         var products:Array = null;
         var productId:String = null;
         var idsURL:String = null;
         var totalProductsRequested:int = 0;
         var onProductsIdsReceived:Function = null;
         var max:int = 0;
         var rounds:int = 0;
         var i:int = 0;
         var productIdentifiers:Array = param1;
         var callback:Function = param2;
         var processProductsRound:Function = function(param1:int):void
         {
            var _loc2_:int = param1 == 0 ? 0 : max;
            var _loc3_:int = param1 == 0 ? max : int(productIdentifiers.length);
            idsURL = "";
            var _loc4_:int = _loc2_;
            while(_loc4_ < _loc3_)
            {
               productId = productIdentifiers[_loc4_];
               if(productId == null)
               {
                  break;
               }
               idsURL += _loc4_ == _loc2_ ? createProductURL(productId) : "," + createProductURL(productId);
               _loc4_++;
            }
            requestWithGraphPath(mFBAPIVersion + "/",{
               "ids":idsURL,
               "scrape":true,
               "fields":"og_object",
               "access_token":getAccessToken()
            },"GET",onProductsIdsReceived);
         };
         onProductsIdsReceived = function(param1:Object, param2:Object):void
         {
            var onIdObjectsReceived:Function;
            var objectIdentifiers:* = undefined;
            var response:Object = param1;
            var fail:Object = param2;
            objectIdentifiers = undefined;
            var property:String = null;
            var ogProduct:Object = null;
            objectIdentifiers = new Object();
            var idsObject:String = "";
            if(response != null)
            {
               onIdObjectsReceived = function(param1:Object, param2:Object):void
               {
                  var currency:String = null;
                  var format:Object = null;
                  var responseObj:Object = param1;
                  var fail:Object = param2;
                  var processFacebookProductsReceived:Function = function(param1:Object):void
                  {
                     var _loc2_:String = null;
                     var _loc3_:Object = null;
                     var _loc4_:Object = null;
                     var _loc5_:Object = null;
                     var _loc6_:Object = null;
                     var _loc7_:* = NaN;
                     var _loc8_:Object = null;
                     var _loc9_:Boolean = false;
                     if(param1)
                     {
                        for(_loc2_ in param1)
                        {
                           _loc3_ = param1[_loc2_];
                           if(Boolean(_loc3_) && Boolean(_loc3_.data))
                           {
                              _loc4_ = new Object();
                              _loc4_.identifier = objectIdentifiers[_loc2_];
                              _loc4_.pluralTitle = _loc3_.data.plural_title;
                              _loc4_.userCurrency = currency;
                              _loc5_ = new Object();
                              for(_loc6_ in _loc3_.data.price)
                              {
                                 _loc8_ = _loc3_.data.price[_loc6_];
                                 _loc5_[_loc8_.currency] = _loc8_.amount;
                              }
                              if(_loc5_.hasOwnProperty(currency))
                              {
                                 _loc7_ = _loc5_[currency];
                                 _loc9_ = false;
                              }
                              else
                              {
                                 _loc7_ = parseFloat(_loc5_["USD"]);
                                 _loc9_ = true;
                              }
                              _loc4_.priceLocale = _loc7_.toFixed(2);
                              if(_loc9_)
                              {
                                 _loc4_.priceString = "" + _loc4_.priceLocale + " USD";
                              }
                              else if(format)
                              {
                                 if(format.pre)
                                 {
                                    _loc4_.priceString = format.symbol + " " + _loc4_.priceLocale;
                                 }
                                 else
                                 {
                                    _loc4_.priceString = "" + _loc4_.priceLocale + " " + format.symbol;
                                 }
                              }
                              else
                              {
                                 _loc4_.priceString = "" + _loc4_.priceLocale + " " + currency;
                              }
                              products.push(_loc4_);
                           }
                        }
                     }
                  };
                  currency = FSInAppsManager.smCurrencySymbol == "" ? Utils.getDefaultCurrency() : FSInAppsManager.smCurrencySymbol;
                  format = InstanceMng.getApplication().getInAppsManager().getSupportedCurrencies()[currency];
                  FSInAppsManager.smCurrencySymbol = currency;
                  processFacebookProductsReceived(responseObj);
                  if(callback != null && products.length >= totalProductsRequested)
                  {
                     callback(products);
                  }
               };
               for(property in response)
               {
                  ogProduct = response[property];
                  if(ogProduct.hasOwnProperty("og_object"))
                  {
                     objectIdentifiers[ogProduct.og_object.id] = cleanProductId(property);
                     idsObject += idsObject == "" ? ogProduct.og_object.id : "," + ogProduct.og_object.id;
                  }
                  else
                  {
                     --totalProductsRequested;
                  }
               }
               requestWithGraphPath(mFBAPIVersion + "/",{
                  "ids":idsObject,
                  "scrape":true,
                  "access_token":getAccessToken()
               },"GET",onIdObjectsReceived);
            }
            else
            {
               FSTracker.trackMiscAction(FSTracker.CATEGORY_MISC,FSTracker.ACTION_ERROR_DETECTED,{"error":"requestingProducts returned empty"});
            }
         };
         products = new Array();
         productId = null;
         idsURL = "";
         totalProductsRequested = 0;
         if(Boolean(productIdentifiers) && productIdentifiers.length > 0)
         {
            totalProductsRequested = int(productIdentifiers.length);
            max = 50;
            rounds = productIdentifiers.length > max ? 2 : 1;
            i = 0;
            while(i < rounds)
            {
               processProductsRound(i);
               i++;
            }
         }
      }
      
      private function cleanProductId(param1:String) : String
      {
         return param1.replace(InstanceMng.getResourcesMng().getCDNInfix(true),"").replace(".html","");
      }
      
      public function buyProduct(param1:String, param2:int = 1) : void
      {
         var onBuyProductCallBack:Function = null;
         var productURL:String = param1;
         var quantity:int = param2;
         onBuyProductCallBack = function(param1:Object):void
         {
            var _loc2_:InAppEvent = null;
            var _loc3_:Object = null;
            var _loc4_:String = "";
            var _loc5_:Object = null;
            if(param1 == null)
            {
               _loc4_ = "An error was found processing the payment.";
               FSDebug.debugTrace(_loc4_);
               _loc2_ = new InAppEvent(FSInAppsManager.PRODUCT_PURCHASE_ERROR,_loc4_,true,false);
               InstanceMng.getApplication().getInAppsManager().dispatchEvent(_loc2_);
               return;
            }
            FSDebug.debugTrace(ObjectUtil.toString(param1));
            if(param1.error_code)
            {
               if(param1.error_code != 1383010)
               {
                  _loc4_ = "An error was found processing the payment. " + param1.error_message + " Error code:" + param1.error_code;
                  FSDebug.debugTrace(_loc4_);
                  _loc2_ = new InAppEvent(FSInAppsManager.PRODUCT_PURCHASE_ERROR,_loc4_,true,false);
                  InstanceMng.getApplication().getInAppsManager().dispatchEvent(_loc2_);
               }
               else
               {
                  _loc2_ = new InAppEvent(FSInAppsManager.PRODUCT_PURCHASE_CANCELLED,param1.error_message,true,false);
                  InstanceMng.getApplication().getInAppsManager().dispatchEvent(_loc2_);
               }
               return;
            }
            _loc3_ = new Object();
            _loc3_.status = param1.status;
            _loc3_.identifier = productURL;
            _loc3_.payment_id = param1.payment_id;
            _loc3_.transaction_id = param1.request_id;
            _loc3_.receipt = param1.signed_request;
            _loc3_.amount = param1.amount;
            _loc3_.currency = param1.currency;
            if(param1.status == "completed")
            {
               param1.identifier = productURL;
               InstanceMng.getServerConnection().trackBrowserVerifiedPurchase(param1);
               _loc5_ = new Object();
               _loc5_.receipt = _loc3_;
               _loc2_ = new InAppEvent(FSInAppsManager.PRODUCT_PURCHASED_OK,param1.payment_id,true,false);
               _loc3_.success = true;
               _loc2_.setPurchaseInfo(_loc3_);
               InstanceMng.getApplication().getInAppsManager().dispatchEvent(_loc2_);
            }
            else if(param1.status == "initiated")
            {
               FSDebug.debugTrace("[Facebook Purchases]: TRANSACTION PENDING");
               _loc2_ = new InAppEvent(FSInAppsManager.PRODUCT_PURCHASE_PENDING,param1.error_message,true,false);
               _loc2_.setPurchaseInfo(_loc3_);
               InstanceMng.getApplication().getInAppsManager().dispatchEvent(_loc2_);
               InstanceMng.getServerConnection().createEntityInCollection("pendingFBPurchases",_loc3_);
            }
            else
            {
               FSDebug.debugTrace("[Facebook Purchases]: TRANSACTION KO");
               _loc2_ = new InAppEvent(FSInAppsManager.PRODUCT_PURCHASED_KO,param1.error_message,true,false);
               _loc3_.success = false;
               _loc2_.setPurchaseInfo(_loc3_);
               InstanceMng.getApplication().getInAppsManager().dispatchEvent(_loc2_);
            }
         };
         this.mFB.ui("pay",{
            "method":"pay",
            "action":"purchaseitem",
            "product":this.createProductURL(productURL),
            "quantity":quantity
         },onBuyProductCallBack);
      }
      
      public function invitableFriendsRequested() : Boolean
      {
         return this.mInvitableFriendsListReceived;
      }
   }
}

