package com.gamesparks.sockets
{
   import flash.external.ExternalInterface;
   import flash.system.Security;
   import flash.utils.setTimeout;
   
   public class GSSocketExternal implements GSSocket
   {
      
      public static var networkAvailable:Boolean = true;
      
      private static var _nextID:int = 0;
      
      private static var _nextJsFunctionId:int = 0;
      
      private var instanceId:String;
      
      private var _connected:Boolean = false;
      
      private var _pingEnabled:Boolean = false;
      
      private var _onOpen:Function;
      
      private var _onClose:Function;
      
      private var _onMessage:Function;
      
      private var _onError:Function;
      
      private var _logger:Function;
      
      public function GSSocketExternal(param1:Function)
      {
         var logger:Function = param1;
         super();
         this.instanceId = new Date().time.toString() + "_" + (_nextID++).toString();
         this._logger = function(param1:String):void
         {
            logger("GSSocketExternal:" + param1);
         };
      }
      
      public static function IsAvailable() : Boolean
      {
         var _loc1_:Boolean = ExternalInterface.available;
         var _loc2_:Boolean = false;
         if(_loc1_)
         {
            try
            {
               _loc2_ = ExternalInterface.call("function(){ return (\"WebSocket\" in window); }");
            }
            catch(e:Error)
            {
            }
         }
         return _loc1_ && _loc2_;
      }
      
      public function Dispose() : void
      {
         this._logger("dispose");
         ExternalInterface.addCallback("OnClose_" + this.instanceId,function():void
         {
         });
         ExternalInterface.addCallback("OnOpen_" + this.instanceId,function():void
         {
         });
         ExternalInterface.addCallback("OnMessage_" + this.instanceId,function():void
         {
         });
         ExternalInterface.addCallback("OnError_" + this.instanceId,function():void
         {
         });
         ExternalInterface.addCallback("Log_" + this.instanceId,function():void
         {
         });
      }
      
      private function internalOnClose(param1:Object = null) : void
      {
         if(param1 != null && param1.code != 1000 && param1.code != 1005)
         {
            this._logger("abnormal close event. code: " + param1.code + "  reason: " + param1.reason);
         }
         else
         {
            this._logger("normal close event.");
         }
         this.Dispose();
         if(this._connected)
         {
            this._connected = false;
            this._onClose(this);
         }
      }
      
      private function internalOnError(param1:Object = null) : void
      {
         if(param1 != null)
         {
            this._logger(JSON.stringify(param1));
         }
         if(!this._connected)
         {
            this._onError(this,param1);
         }
         else
         {
            this.internalOnClose(param1);
         }
      }
      
      private function internalOnOpen(param1:Object = null) : void
      {
         this._connected = true;
         this._onOpen(this);
         if(this._pingEnabled)
         {
            this.keepAlive();
         }
      }
      
      private function internalOnMessage(param1:Object = null) : void
      {
         this._onMessage(param1,this);
      }
      
      private function internalLog(param1:Object) : void
      {
         this._logger(JSON.stringify(param1));
      }
      
      public function Connect(param1:String, param2:Function, param3:Function, param4:Function, param5:Function) : Boolean
      {
         var _loc12_:Boolean = false;
         if(!networkAvailable || !IsAvailable())
         {
            return false;
         }
         var _loc6_:Array = param1.match(/^(\w+):\/\/([^\/:]+)(:(\d+))?(\/.*)?(\?.*)?$/);
         if(!_loc6_)
         {
            this._logger("invalid url: " + param1);
            return false;
         }
         var _loc7_:String = _loc6_[1];
         var _loc8_:String = _loc6_[2];
         var _loc9_:int = _loc7_ == "wss" ? 443 : 80;
         var _loc10_:int = int(int(parseInt(_loc6_[4])) || _loc9_);
         Security.loadPolicyFile("xmlsocket://" + _loc8_ + ":" + _loc10_);
         Security.loadPolicyFile("xmlsocket://gamesparksbetabinaries.blob.core.windows.net");
         this._onError = param5;
         this._onOpen = param2;
         this._onMessage = param4;
         this._onClose = param3;
         ExternalInterface.addCallback("OnClose_" + this.instanceId,this.internalOnClose);
         ExternalInterface.addCallback("OnError_" + this.instanceId,this.internalOnError);
         ExternalInterface.addCallback("OnOpen_" + this.instanceId,this.internalOnOpen);
         ExternalInterface.addCallback("OnMessage_" + this.instanceId,this.internalOnMessage);
         ExternalInterface.addCallback("Log_" + this.instanceId,this.internalLog);
         var _loc11_:String = "function(url, id, instanceId){\n" + "\ttry { var ws = new WebSocket(decodeURIComponent(url));\n" + "       if (ws != null) { \n" + "\t\tws.instanceId = instanceId;\n" + "\t\tws.onopen \t  =  function(event) { try { document.getElementById(id).OnOpen_" + this.instanceId + "(event); } catch (ex) {};};\n" + "\t\tws.onmessage  =  function(event) { try { document.getElementById(id).OnMessage_" + this.instanceId + "(event.data); } catch (ex) {};};\n" + "\t\tws.onclose \t  =  function(event) { try { document.getElementById(id).OnClose_" + this.instanceId + "(event); } catch (ex) {};};\n" + "\t\tws.onerror \t  =  function(event) { try { document.getElementById(id).OnError_" + this.instanceId + "(null); } catch (ex) {};};\n" + "\t\twindow.gsWebSocket = ws;\n" + "\t\treturn true; }\n" + "\t} catch (err) {\n" + "\t\ttry { document.getElementById(id).OnError_" + this.instanceId + "(err);} catch (ex) {};\n" + "\t}\n" + "\treturn false;\n" + "}\n";
         try
         {
            _loc12_ = ExternalInterface.call(_loc11_,encodeURIComponent(param1),ExternalInterface.objectID,this.instanceId);
         }
         catch(e:Error)
         {
         }
         return _loc12_;
      }
      
      public function Connected() : Boolean
      {
         var _loc2_:Boolean = false;
         if(!networkAvailable || !IsAvailable())
         {
            return false;
         }
         var _loc1_:String = "function(id, instanceId){\n" + "try{\n" + "\tvar currentSocket = window.gsWebSocket;\n" + "\treturn (currentSocket != null && currentSocket.readyState == 1 && currentSocket.instanceId == instanceId);\n" + "}\n" + "catch (err) { \n" + "\t try {document.getElementById(id).OnError_" + this.instanceId + "(err); } catch (ex) {};\n" + "} return false;\n }";
         try
         {
            _loc2_ = ExternalInterface.call(_loc1_,ExternalInterface.objectID,this.instanceId);
         }
         catch(e:Error)
         {
         }
         if(this._connected && !_loc2_)
         {
            this._onClose(this);
         }
         return _loc2_;
      }
      
      public function Send(param1:String, param2:Boolean = false) : void
      {
         if(!networkAvailable || !IsAvailable())
         {
            return;
         }
         param1 = encodeURIComponent(param1);
         var _loc3_:String = "function(id, instanceId, msg, waitBufferedQueue){\n" + "\ttry {\n" + "\t\tvar currentSocket = window.gsWebSocket;\n" + "\t\tif (currentSocket != null && currentSocket.readyState == 1) {\n" + "\t\t\tvar data = decodeURIComponent(msg);\n" + "\t\t\tif (currentSocket.bufferedAmount == 0 || !waitBufferedQueue) {\n" + "\t\t\t\tcurrentSocket.send(data);\n" + "\t\t\t}\n" + "\t\t}\n" + "\t}\n" + "\tcatch (err){\n" + "\t \ttry {document.getElementById(id).OnError_" + this.instanceId + "(err); } catch (ex) {};\n" + "\t};}";
         try
         {
            ExternalInterface.call(_loc3_,ExternalInterface.objectID,this.instanceId,param1,param2);
         }
         catch(e:Error)
         {
         }
      }
      
      public function Disconnect() : void
      {
         this._pingEnabled = false;
         if(!IsAvailable())
         {
            return;
         }
         var _loc1_:String = "try {\n" + "\tvar currentSocket = window.gsWebSocket;\n" + "\tif (currentSocket != null && currentSocket.readyState == 1 && currentSocket.instanceId == instanceId) {\n" + "\t\tcurrentSocket.close();\n" + "\t\twindow.gsWebSocket = null;\n" + "\t}\n" + "} catch (err) {\n" + "\t try {document.getElementById(id).OnError_" + this.instanceId + "(err); } catch (ex) {};\n" + "}";
         try
         {
            ExternalInterface.call("function(id, instanceId){ " + _loc1_ + " }",ExternalInterface.objectID,this.instanceId);
         }
         catch(e:Error)
         {
         }
      }
      
      public function EnablePing() : void
      {
         this._pingEnabled = true;
      }
      
      public function keepAlive() : void
      {
         if(!this._connected || !IsAvailable() || !this._pingEnabled)
         {
            return;
         }
         if(networkAvailable)
         {
            this.Send(" ",true);
         }
         setTimeout(function():void
         {
            keepAlive();
         },5000);
      }
      
      public function GetName() : String
      {
         return this.instanceId;
      }
      
      public function IsExternal() : Boolean
      {
         return true;
      }
   }
}

