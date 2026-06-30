package com.gamesparks
{
   import com.adobe.serialization.json.JSON;
   import com.adobe.utils.StringUtil;
   import com.gamesparks.api.messages.GSMessageHandler;
   import com.gamesparks.api.requests.*;
   import com.gamesparks.sockets.GSSocket;
   import com.gamesparks.sockets.GSSocketSelector;
   import com.hurlant.crypto.hash.HMAC;
   import com.hurlant.crypto.hash.SHA256;
   import com.hurlant.util.Base64;
   import com.hurlant.util.Hex;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.system.Capabilities;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import mx.utils.UIDUtil;
   
   public class GS
   {
      
      private static var _nextID:int = 0;
      
      public static var ignoreSecureSocket:Boolean = false;
      
      private static const _SDK:String = "AS3";
      
      private static const _VERSION:String = "1.5.3";
      
      private var _id:int;
      
      protected var _itemsToSend:Array = new Array();
      
      protected var _persistentItemsToSend:Array = new Array();
      
      private var _pendingRequests:Dictionary = new Dictionary();
      
      private var _queueTimeout:uint;
      
      private var _persistentQueueTimeout:uint;
      
      protected var _authToken:String = "0";
      
      private var _userId:String;
      
      private var _persistantQueue_playerId:String = "";
      
      private var _sessionId:String;
      
      private var _initialised:Boolean = false;
      
      private var _initialising:Boolean = false;
      
      private var _disabledSharedObject:Boolean = false;
      
      protected var _available:Boolean = false;
      
      protected var _authenticated:Boolean = false;
      
      protected var _durableQueueDirty:Boolean = false;
      
      protected var _durableQueuePaused:Boolean = false;
      
      private var _requestBuilder:GSRequestBuilder;
      
      private var _messageHandler:GSMessageHandler = new GSMessageHandler();
      
      private var _messageCallback:Function;
      
      private var _availabilityCallback:Function;
      
      private var _authenticatedCallback:Function;
      
      private var _messageHandlerCallback:Function;
      
      private var _liveServers:Boolean = false;
      
      private var _apiSecret:String = "";
      
      private var _apiKey:String = "";
      
      private var _apiCredential:String = "";
      
      private var _url:String;
      
      private var _lbUrl:String;
      
      protected var _socket:GSSocket;
      
      private var _logger:Function;
      
      private var _stopped:Boolean = false;
      
      private var _stage:Stage;
      
      private var _overlay:Sprite = new Sprite();
      
      private var _text:TextField = new TextField();
      
      private var _format:TextFormat = new TextFormat();
      
      private var _webSocketErrorCount:Number = 0;
      
      private var _deviceOS:String = "";
      
      private var _deviceID:String = "";
      
      private var _platform:String = Capabilities.manufacturer;
      
      public function GS(param1:Stage = null)
      {
         super();
         this._id = _nextID++;
         this._stage = param1;
         if(this._stage != null)
         {
            this._stage.addChild(this._overlay);
            this._stage.addEventListener(Event.RESIZE,this.resizeListener);
         }
         this._requestBuilder = new GSRequestBuilder(this);
         var _loc2_:Object = new Object();
         var _loc3_:String = Capabilities.os;
         var _loc4_:Array = _loc3_.split(" ");
         if(_loc4_[0] == "Windows")
         {
            this._deviceOS = "WINDOWS";
         }
         else if(_loc4_[0] == "Mac")
         {
            this._deviceOS = "MACOS";
         }
         else if(_loc4_[0] == "iPhone")
         {
            this._deviceOS = "IOS";
         }
         else
         {
            this._deviceOS = _loc4_[0];
            this._deviceOS.toUpperCase();
         }
         this.loadSettings();
      }
      
      private function resizeListener(param1:Event) : void
      {
         this._text.y = this._stage.stageHeight - this._text.textHeight - 5;
         this._text.width = this._stage.stageWidth;
      }
      
      public function setAvailabilityCallback(param1:Function) : GS
      {
         this._availabilityCallback = param1;
         return this;
      }
      
      public function setAuthenticatedCallback(param1:Function) : GS
      {
         this._authenticatedCallback = param1;
         return this;
      }
      
      public function setMessageHandlerCallback(param1:Function) : GS
      {
         this._messageHandlerCallback = param1;
         return this;
      }
      
      public function setUseLiveServices(param1:Boolean) : GS
      {
         this._liveServers = param1;
         this.buildServiceUrl();
         return this;
      }
      
      public function setApiSecret(param1:String) : GS
      {
         this._apiSecret = param1;
         this.buildServiceUrl();
         return this;
      }
      
      public function setApiKey(param1:String) : GS
      {
         this._apiKey = param1;
         this.buildServiceUrl();
         return this;
      }
      
      public function setApiCredential(param1:String) : GS
      {
         this._apiCredential = param1;
         this.buildServiceUrl();
         return this;
      }
      
      public function setLogger(param1:Function) : GS
      {
         this._logger = param1;
         return this;
      }
      
      public function connect() : void
      {
         this._initialising = true;
         this._stopped = false;
         if(this._webSocketErrorCount > 5)
         {
            this._webSocketErrorCount = 0;
            this._url = this._lbUrl;
         }
         this._socket = new GSSocketSelector(this.log,ignoreSecureSocket);
         this._socket.Connect(this._url,this.handleWebSocketOpen,this.handleWebSocketClosed,this.handleWebSocketMessage,this.handleWebSocketError);
         this.log("*** GameSparks SDK v" + _VERSION + " connecting to " + this._url + " " + this._socket.GetName());
         if(this._stage != null)
         {
            if(this._text.stage)
            {
               this._text.parent.removeChild(this._text);
            }
            if(this._liveServers == false)
            {
               this._format.color = 14540253;
               this._format.size = 18;
               this._text.text = "GameSparks Preview mode v" + _VERSION;
               this._text.setTextFormat(this._format);
               this._text.y = this._stage.stageHeight - this._text.textHeight - 5;
               this._text.width = this._stage.stageWidth;
               this._overlay.addChild(this._text);
               this._overlay.mouseEnabled = false;
               this._overlay.mouseChildren = false;
            }
         }
      }
      
      private function initialisePersistentQueue() : void
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:GSRequest = null;
         if(this._persistantQueue_playerId == this._userId)
         {
            return;
         }
         var _loc1_:Boolean = this._durableQueuePaused;
         this._durableQueuePaused = true;
         var _loc2_:Array = new Array();
         var _loc3_:String = this.loadPersistentQueue();
         if(_loc3_ != null && _loc3_.length > 0)
         {
            _loc4_ = _loc3_.split(/\n/);
            for each(_loc5_ in _loc4_)
            {
               if(StringUtil.trim(_loc5_).length > 0)
               {
                  _loc6_ = this.stringToRequest(_loc5_);
                  if(_loc6_ != null)
                  {
                     _loc2_.push(_loc6_);
                  }
               }
            }
         }
         this._persistentItemsToSend = _loc2_;
         this._persistantQueue_playerId = this._userId;
         this._durableQueuePaused = _loc1_;
         this.log("_persistantQueue COUNT: " + this._persistentItemsToSend.length);
      }
      
      private function writeDurableQueueIfDirty() : void
      {
         var _loc1_:String = null;
         var _loc2_:GSRequest = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         if(this._durableQueueDirty)
         {
            this._durableQueueDirty = false;
            _loc1_ = "";
            for each(_loc2_ in this._persistentItemsToSend)
            {
               _loc3_ = com.adobe.serialization.json.JSON.encode(_loc2_.getData());
               _loc4_ = new Object();
               _loc4_.rq = _loc3_;
               _loc4_.sq = this.getHmac(_loc3_);
               _loc5_ = com.adobe.serialization.json.JSON.encode(_loc4_);
               _loc1_ += _loc5_ + "\n";
            }
            this.savePersistentQueue(_loc1_);
         }
      }
      
      public function send(param1:GSRequest) : void
      {
         var _loc2_:Object = null;
         if(param1.durable)
         {
            this.sendDurable(param1);
         }
         else
         {
            _loc2_ = param1.getData();
            _loc2_.requestId = String(new Date().time) + String(Math.floor(Math.random() * 10000));
            this._itemsToSend.push(param1);
            setTimeout(this.timeoutRequest,param1.getTimeoutSeconds() * 1000,param1);
            this.processQueues();
         }
      }
      
      public function sendDurable(param1:GSRequest) : void
      {
         param1.durable = true;
         this._persistentItemsToSend.push(param1);
         this._durableQueueDirty = true;
         this.processQueues();
      }
      
      private function timeoutRequest(param1:GSRequest) : void
      {
         var _loc4_:Object = null;
         var _loc2_:int = this._itemsToSend.indexOf(param1);
         var _loc3_:Boolean = false;
         if(_loc2_ != -1)
         {
            this._itemsToSend.splice(_loc2_,1);
            _loc3_ = true;
         }
         if(this._pendingRequests[param1.getData().requestId] == param1)
         {
            delete this._pendingRequests[param1.getData().requestId];
            _loc3_ = true;
         }
         if(_loc3_ && param1.callback != null && !param1.durable)
         {
            _loc4_ = new Object();
            _loc4_.error = new Object();
            _loc4_.error.error = "timeout";
            _loc4_.requestId = param1.getAttribute("requestId");
            param1.callback(_loc4_);
         }
      }
      
      public function disconnect() : void
      {
         if(this._queueTimeout)
         {
            clearTimeout(this._queueTimeout);
            this._queueTimeout = 0;
         }
         this._stopped = true;
         if(this._socket != null)
         {
            this._socket.Dispose();
            this._socket.Disconnect();
            this._socket = null;
         }
         this.setAvailable(false);
         this.setAuthenticated(null);
      }
      
      public function reset() : void
      {
         this.disconnect();
         this._authToken = "0";
         this._userId = null;
         this._sessionId = null;
         this.connect();
      }
      
      public function getRequestBuilder() : GSRequestBuilder
      {
         return this._requestBuilder;
      }
      
      public function getMessageHandler() : GSMessageHandler
      {
         return this._messageHandler;
      }
      
      private function handleWebSocketClosed(param1:GSSocket) : void
      {
         var socket:GSSocket = param1;
         if(socket != this._socket)
         {
            this.log("handleWebSocketClosed : Not the right socket " + socket.GetName());
            return;
         }
         if(socket != null)
         {
            this.log("Websocket closed. initialised=" + this._initialised + " initialising=" + this._initialising + " stopped=" + this._stopped + " " + socket.GetName());
         }
         else
         {
            this.log("Websocket closed. initialised=" + this._initialised + " initialising=" + this._initialising + " stopped=" + this._stopped);
         }
         if(this._queueTimeout)
         {
            clearTimeout(this._queueTimeout);
            this._queueTimeout = 0;
         }
         if(this._socket != null)
         {
            this._socket.Dispose();
            this._socket.Disconnect();
            this._socket = null;
         }
         this.setAvailable(false);
         if((this._initialised || this._initialising) && !this._stopped)
         {
            setTimeout(function():void
            {
               ++_webSocketErrorCount;
               connect();
            },5000);
         }
      }
      
      private function handleWebSocketError(param1:GSSocket, param2:String = "") : void
      {
         var socket:GSSocket = param1;
         var error:String = param2;
         if(socket != this._socket)
         {
            this.log("handleWebSocketErr : Not the right socket " + socket.GetName());
            return;
         }
         if(socket != null)
         {
            this.log("Websocket Error " + error + " " + socket.GetName());
         }
         else
         {
            this.log("Websocket Error " + error);
         }
         if((this._initialised || this._initialising) && !this._stopped && this._socket != null && !this._socket.Connected() && this._socket.IsExternal())
         {
            if(this._queueTimeout)
            {
               clearTimeout(this._queueTimeout);
               this._queueTimeout = 0;
            }
            if(this._socket != null)
            {
               this._socket.Dispose();
               this._socket.Disconnect();
               this._socket = null;
            }
            setTimeout(function():void
            {
               ++_webSocketErrorCount;
               connect();
            },5000);
         }
      }
      
      private function handleWebSocketOpen(param1:GSSocket) : void
      {
         if(param1 != this._socket)
         {
            this.log("handleWebSocketOpen : Not the right socket " + param1.GetName());
            return;
         }
         this.log("Websocket Connected " + param1.GetName());
         this._webSocketErrorCount = 0;
      }
      
      private function processQueues(param1:TimerEvent = null) : void
      {
         var request:GSRequest = null;
         var data:Object = null;
         var request2:GSRequest = null;
         var data2:Object = null;
         var packet:String = null;
         var event:TimerEvent = param1;
         if(this._queueTimeout)
         {
            clearTimeout(this._queueTimeout);
            this._queueTimeout = 0;
         }
         if(this._socket != null && this._socket.Connected() && this._available)
         {
            this.writeDurableQueueIfDirty();
            if(!this._durableQueuePaused && this._authenticated)
            {
               for each(request in this._persistentItemsToSend)
               {
                  if(request.durableRetryTicks == 0 || request.durableRetryTicks < new Date().time)
                  {
                     try
                     {
                        request.durableRetryTicks = new Date().time + 10000;
                        data = request.getData();
                        data.requestId = "d_" + String(new Date().time) + String(Math.floor(Math.random() * 10000));
                        this.log(com.adobe.serialization.json.JSON.encode(data));
                        this._socket.Send(com.adobe.serialization.json.JSON.encode(data));
                        this._pendingRequests[data.requestId] = request;
                     }
                     catch(e:Error)
                     {
                     }
                  }
               }
            }
            else
            {
               this._queueTimeout = setTimeout(this.processQueues,500);
            }
            if(this._itemsToSend.length > 0)
            {
               request2 = this._itemsToSend.shift();
               try
               {
                  data2 = request2.getData();
                  packet = com.adobe.serialization.json.JSON.encode(data2);
                  this.log(packet);
                  this._socket.Send(packet);
                  this._pendingRequests[data2.requestId] = request2;
               }
               catch(e:Error)
               {
                  _itemsToSend.unshift(_itemsToSend);
               }
            }
            if(this._itemsToSend.length > 0 && this._queueTimeout == 0)
            {
               this._queueTimeout = setTimeout(this.processQueues,500);
            }
         }
         else if(this._socket != null)
         {
            this._queueTimeout = setTimeout(this.processQueues,500);
         }
      }
      
      private function log(param1:String) : void
      {
         var _loc2_:Date = null;
         if(this._logger != null)
         {
            _loc2_ = new Date();
            this._logger(_loc2_.hours + ":" + _loc2_.minutes + ":" + _loc2_.seconds + "." + _loc2_.milliseconds + "  id: " + this._id + "   " + param1);
         }
      }
      
      private function loadSettings() : void
      {
         var sharedObject:SharedObject = null;
         if(this._disabledSharedObject)
         {
            if(this._deviceID.length == 0)
            {
               try
               {
                  this._deviceID = UIDUtil.createUID();
               }
               catch(e:Error)
               {
                  _deviceID = new Date().time + "" + int(Math.random() * int.MAX_VALUE);
               }
            }
            return;
         }
         try
         {
            sharedObject = SharedObject.getLocal("settings");
            if(sharedObject.data.authToken != null && sharedObject.data.authToken != "0")
            {
               this._authToken = sharedObject.data.authToken;
            }
            if(sharedObject.data.deviceID != null && sharedObject.data.deviceID.length > 0)
            {
               this._deviceID = sharedObject.data.deviceID;
            }
            else
            {
               try
               {
                  this._deviceID = UIDUtil.createUID();
               }
               catch(e:Error)
               {
                  _deviceID = new Date().time + "" + int(Math.random() * int.MAX_VALUE);
               }
               this.saveSettings();
            }
         }
         catch(e:Error)
         {
            log("UNABLE TO LOAD SETTINGS");
         }
      }
      
      private function saveSettings() : void
      {
         var sharedObject:SharedObject = null;
         if(this._disabledSharedObject)
         {
            return;
         }
         try
         {
            sharedObject = SharedObject.getLocal("settings");
            sharedObject.data.deviceID = this._deviceID;
            sharedObject.data.authToken = this._authToken;
            sharedObject.flush();
         }
         catch(e:Error)
         {
            log("UNABLE TO SAVE SETTINGS");
         }
      }
      
      private function loadPersistentQueue() : String
      {
         var sharedObject:SharedObject = null;
         if(!this._userId || this._disabledSharedObject)
         {
            return null;
         }
         try
         {
            sharedObject = SharedObject.getLocal(this._userId);
            return sharedObject.data.durableRequests;
         }
         catch(e:Error)
         {
            log("UNABLE TO LOAD PERSISTENT QUEUE " + e);
         }
         return null;
      }
      
      private function savePersistentQueue(param1:String) : void
      {
         var sharedObject:SharedObject = null;
         var queue:String = param1;
         if(!this._userId || this._disabledSharedObject)
         {
            return;
         }
         try
         {
            sharedObject = SharedObject.getLocal(this._userId);
            sharedObject.data.durableRequests = queue;
            sharedObject.flush();
         }
         catch(e:Error)
         {
            log("UNABLE TO SAVE PERSISTENT QUEUE " + e);
         }
      }
      
      protected function resetPersistentQueue() : void
      {
         var _loc1_:SharedObject = null;
         if(!this._userId || this._disabledSharedObject)
         {
            return;
         }
         try
         {
            _loc1_ = SharedObject.getLocal(this._userId);
            _loc1_.clear();
         }
         catch(e:Error)
         {
         }
      }
      
      public function disableSharedObject(param1:Boolean) : void
      {
         this._disabledSharedObject = param1;
      }
      
      private function handleWebSocketMessage(param1:String, param2:GSSocket) : void
      {
         var _loc4_:GSRequest = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         this.log("handleWebSocketMessage" + param1);
         var _loc3_:Object = com.adobe.serialization.json.JSON.decode(param1);
         if(_loc3_.authToken)
         {
            this._authToken = _loc3_.authToken;
            this.saveSettings();
            this.log("Got authtoken " + this._authToken);
         }
         if(StringUtil.endsWith(_loc3_["@class"],"Response") && Boolean(_loc3_.userId))
         {
            this._userId = _loc3_.userId;
            this.initialisePersistentQueue();
            this.setAuthenticated(this._userId);
         }
         if(_loc3_.connectUrl != null)
         {
            this.log("Changing connect url to " + _loc3_.connectUrl);
            if(this._queueTimeout)
            {
               clearTimeout(this._queueTimeout);
               this._queueTimeout = 0;
            }
            this._available = false;
            this._authenticated = false;
            if(this._socket != null)
            {
               this._socket.Dispose();
               this._socket.Disconnect();
               this._socket = null;
            }
            this._url = _loc3_.connectUrl;
            this.connect();
            return;
         }
         if(Boolean(_loc3_.requestId) && _loc3_.requestId != 0)
         {
            _loc4_ = this._pendingRequests[_loc3_.requestId];
            delete this._pendingRequests[_loc3_.requestId];
            if(_loc4_ != null)
            {
               if(_loc4_.durableRetryTicks > 0)
               {
                  if(!StringUtil.endsWith(_loc3_["@class"],"ClientError"))
                  {
                     this._durableQueueDirty = this._persistentItemsToSend.splice(this._persistentItemsToSend.indexOf(_loc4_),1);
                     this.writeDurableQueueIfDirty();
                  }
               }
               if(_loc4_.callback != null)
               {
                  _loc4_.callback(_loc3_);
               }
            }
            else
            {
               this.log("no pending request yet");
            }
         }
         else if(StringUtil.endsWith(_loc3_["@class"],"Message"))
         {
            if(this._messageHandlerCallback != null)
            {
               this._messageHandlerCallback(_loc3_);
            }
            this._messageHandler.handle(_loc3_);
         }
         else if(_loc3_["@class"] == ".AuthenticatedConnectResponse" && param2 == this._socket)
         {
            if(_loc3_.error)
            {
               this.log("INCORRECT APIKEY / APISECRET");
               this.disconnect();
            }
            if(_loc3_.sessionId != null)
            {
               this._sessionId = _loc3_.sessionId;
            }
            if(_loc3_.nonce != null)
            {
               _loc5_ = new Object();
               _loc5_["@class"] = ".AuthenticatedConnectRequest";
               _loc5_.hmac = this.getHmac(_loc3_.nonce);
               _loc5_.os = this._deviceOS;
               _loc5_.platform = this._platform;
               _loc5_.deviceId = this._deviceID;
               if(this._authToken != "0")
               {
                  _loc5_.authToken = this._authToken;
               }
               if(this._sessionId != null)
               {
                  _loc5_.sessionId = this._sessionId;
               }
               _loc6_ = com.adobe.serialization.json.JSON.encode(_loc5_);
               this.log("sending:" + _loc6_);
               if(this._socket != null)
               {
                  this._socket.Send(_loc6_);
               }
               return;
            }
            if(_loc3_.connectUrl == null)
            {
               this._initialised = true;
               this._initialising = false;
               this.setAvailable(true);
               this.processQueues();
            }
         }
      }
      
      private function setAvailable(param1:Boolean) : void
      {
         if(this._available != param1)
         {
            this._available = param1;
            if(this._availabilityCallback != null)
            {
               this._availabilityCallback(param1);
            }
         }
      }
      
      private function setAuthenticated(param1:String) : void
      {
         if(param1)
         {
            this._authenticated = true;
         }
         else
         {
            this._authenticated = false;
         }
         if(this._authenticatedCallback != null)
         {
            this._authenticatedCallback(param1);
         }
      }
      
      private function getHmac(param1:String) : String
      {
         var _loc2_:HMAC = new HMAC(new SHA256());
         var _loc3_:ByteArray = Hex.toArray(Hex.fromString(this._apiSecret));
         var _loc4_:ByteArray = Hex.toArray(Hex.fromString(param1));
         return Base64.encodeByteArray(_loc2_.compute(_loc3_,_loc4_));
      }
      
      private function stringToRequest(param1:String) : GSRequest
      {
         var _loc2_:Object = com.adobe.serialization.json.JSON.decode(param1);
         var _loc3_:String = _loc2_.rq;
         var _loc4_:String = _loc2_.sq;
         var _loc5_:String = this.getHmac(_loc3_);
         if(_loc5_ == _loc4_)
         {
            return new GSRequest(this,com.adobe.serialization.json.JSON.decode(_loc3_));
         }
         return null;
      }
      
      private function buildServiceUrl() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc4_:String = null;
         var _loc3_:String = this._apiKey;
         if(this._liveServers)
         {
            _loc2_ = "live";
         }
         else
         {
            _loc2_ = "preview";
         }
         if(this._apiCredential.length == 0)
         {
            _loc4_ = "device";
         }
         else
         {
            _loc4_ = this._apiCredential;
         }
         _loc1_ = this._apiSecret.indexOf(":");
         if(_loc1_ > 0)
         {
            _loc4_ = "secure";
            _loc3_ = this._apiSecret.substring(0,_loc1_) + "/" + _loc3_;
         }
         this._url = "wss://" + _loc2_ + "-" + _loc3_ + ".ws.gamesparks.net/ws/" + _loc4_ + "/" + _loc3_ + "?deviceOS=" + this._deviceOS + "&deviceID=" + this._deviceID + "&SDK=" + _SDK;
         this._lbUrl = this._url;
      }
      
      public function isAvailable() : Boolean
      {
         return this._available;
      }
      
      public function isAuthenticated() : Boolean
      {
         return this._authenticated;
      }
      
      public function getDeviceStats() : GSData
      {
         var _loc1_:Object = new Object();
         var _loc2_:String = Capabilities.os;
         var _loc3_:Array = _loc2_.split(" ");
         if(_loc3_[0] == "Windows")
         {
            _loc1_["manufacturer"] = "Microsoft";
            if(_loc3_[1] == "CE" || _loc3_[1] == "SmartPhone" || _loc3_[1] == "PocketPC" || _loc3_[1] == "CEPC" || _loc3_[1] == "Mobile")
            {
               _loc1_["model"] = "Smartphone";
            }
            else
            {
               _loc1_["model"] = "PC";
            }
            _loc1_["os.name"] = _loc2_;
            _loc1_["os.version"] = "Unknown";
         }
         else if(_loc3_[0] == "Mac")
         {
            _loc1_["manufacturer"] = "Apple";
            _loc1_["model"] = "Unknown";
            _loc1_["os.name"] = "Mac OS X";
            _loc1_["os.version"] = _loc3_[2];
         }
         else if(_loc3_[0] == "iPhone")
         {
            _loc1_["manufacturer"] = "Apple";
            _loc1_["model"] = _loc2_;
            _loc1_["os.name"] = "iPhone";
            _loc1_["os.version"] = "Unknown";
         }
         else
         {
            _loc1_["manufacturer"] = "Unknown";
            _loc1_["model"] = "Unknown";
            _loc1_["os.name"] = _loc2_;
            _loc1_["os.version"] = "Unknown";
         }
         _loc1_["memory"] = uint(System.totalMemory / 1024 / 1024) + " MB";
         _loc1_["cpu.cores"] = "0";
         _loc1_["cpu.vendor"] = Capabilities.cpuArchitecture;
         _loc1_["resolution"] = Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY;
         _loc1_["gssdk"] = _VERSION;
         _loc1_["engine"] = _SDK;
         _loc1_["engine.version"] = Capabilities.version;
         return new GSData(_loc1_);
      }
   }
}

