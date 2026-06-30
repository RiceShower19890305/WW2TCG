package com.gamesparks.sockets
{
   import flash.net.SecureSocket;
   import flash.utils.setTimeout;
   
   public class GSSocketSelector implements GSSocket
   {
      
      private static var socketCreator:Function;
      
      private static var socketType:String;
      
      protected static var selectorCount:Number = 0;
      
      private var _logger:Function;
      
      private var ignoreSecureSocket:Boolean;
      
      private var wrappedSocket:GSSocket;
      
      private var _onOpen:Function;
      
      private var _onClose:Function;
      
      private var _onMessage:Function;
      
      private var _onError:Function;
      
      private var _closeEventFired:Boolean = false;
      
      private var _errorEventFired:Boolean = false;
      
      private var errorCount:int = 0;
      
      protected var attemptedSockets:Array = new Array();
      
      protected var _errors:Array = new Array();
      
      protected var selectorInstance:Number = 0;
      
      public function GSSocketSelector(param1:Function, param2:Boolean = false)
      {
         super();
         this._logger = param1;
         this.selectorInstance = ++selectorCount;
         this.ignoreSecureSocket = param2;
      }
      
      public static function reset() : void
      {
         if(socketCreator != null)
         {
            socketCreator = null;
            socketType = null;
         }
      }
      
      public function Dispose() : void
      {
         if(this.wrappedSocket != null)
         {
            this.wrappedSocket.Dispose();
         }
         this.cleanupAttemptedSockets(this.wrappedSocket);
      }
      
      public function Connect(param1:String, param2:Function, param3:Function, param4:Function, param5:Function) : Boolean
      {
         var superThis:GSSocket = null;
         var url:String = param1;
         var onOpen:Function = param2;
         var onClose:Function = param3;
         var onMessage:Function = param4;
         var onError:Function = param5;
         var timeout:int = 10000;
         this._onError = onError;
         this._onOpen = onOpen;
         this._onMessage = onMessage;
         this._onClose = onClose;
         if(socketCreator != null)
         {
            this._logger("Creating " + socketType);
            this.wrappedSocket = socketCreator(socketType + "_" + this.selectorInstance);
            this.wrappedSocket.Connect(url,this.handleWebSocketOpen,this.handleWebSocketClosed,this.handleWebSocketMessage,this.handleWebSocketError);
            this.wrappedSocket.EnablePing();
         }
         else
         {
            try
            {
               if(this.ignoreSecureSocket)
               {
                  this._logger("Creating 2 Sockets");
               }
               else
               {
                  this._logger("Creating 3 Sockets");
               }
               this.createSocket(url,this.externalSocket,"externalSocket_" + this.selectorInstance);
               this.createSocket(url,this.internalSocket,"internalSocket_" + this.selectorInstance);
               if(!this.ignoreSecureSocket)
               {
                  this.createSocket(url,this.internalSecureSocket,"internalSecureSocket_" + this.selectorInstance);
               }
            }
            catch(err:Error)
            {
               _logger(err);
            }
         }
         superThis = this;
         setTimeout(function():void
         {
            var error:String = null;
            if(wrappedSocket == null || !wrappedSocket.Connected())
            {
               try
               {
                  cleanupAttemptedSockets(superThis);
                  for each(error in _errors)
                  {
                     _logger(error);
                  }
                  _onError(superThis);
               }
               catch(e:Error)
               {
                  _logger(e);
               }
               if(wrappedSocket == null)
               {
                  Connect(url,onOpen,onClose,onMessage,onError);
               }
            }
         },timeout);
         return true;
      }
      
      private function cleanupAttemptedSockets(param1:GSSocket) : void
      {
         var _loc2_:GSSocket = null;
         for each(_loc2_ in this.attemptedSockets)
         {
            if(_loc2_ != param1)
            {
               _loc2_.Dispose();
               _loc2_.Disconnect();
            }
         }
         this.attemptedSockets.length = 0;
      }
      
      private function createSocket(param1:String, param2:Function, param3:String) : void
      {
         var url:String = param1;
         var creator:Function = param2;
         var name:String = param3;
         var newSocket:GSSocket = creator(name);
         if(newSocket != null)
         {
            this.attemptedSockets.push(newSocket);
            newSocket.Connect(url,this.handleWebSocketOpen,this.handleWebSocketClosed,function(param1:String, param2:GSSocket):void
            {
               if(wrappedSocket == null)
               {
                  socketCreator = creator;
                  socketType = name;
                  wrappedSocket = param2;
                  cleanupAttemptedSockets(param2);
                  handleWebSocketOpen(param2);
                  handleWebSocketMessage(param1,param2);
               }
               else if(wrappedSocket == param2)
               {
                  handleWebSocketMessage(param1,param2);
               }
            },function(param1:GSSocket, param2:String = ""):void
            {
               if(socketCreator == null && param2 != "")
               {
                  _errors.push(param1.GetName() + ":" + param2);
               }
               handleWebSocketError(param1,param2);
            });
         }
      }
      
      private function handleWebSocketMessage(param1:String, param2:GSSocket) : void
      {
         if(this.wrappedSocket == param2)
         {
            this._onMessage(param1,this);
         }
      }
      
      private function handleWebSocketOpen(param1:GSSocket) : void
      {
         if(this.wrappedSocket == param1)
         {
            this._onOpen(this);
         }
      }
      
      private function handleWebSocketClosed(param1:GSSocket) : void
      {
         if(this.wrappedSocket == param1 && !this._closeEventFired)
         {
            this._closeEventFired = true;
            this._onClose(this);
         }
      }
      
      private function handleWebSocketError(param1:GSSocket, param2:String = "") : void
      {
         ++this.errorCount;
         if(this.wrappedSocket == param1 || this.errorCount == this.attemptedSockets.length)
         {
            if(!this._errorEventFired)
            {
               this._errorEventFired = true;
               this._onError(this);
            }
            setTimeout(this.handleWebSocketClosed,500,param1);
         }
      }
      
      public function Send(param1:String, param2:Boolean = false) : void
      {
         if(this.wrappedSocket != null)
         {
            this.wrappedSocket.Send(param1,param2);
         }
      }
      
      public function Connected() : Boolean
      {
         if(this.wrappedSocket != null)
         {
            return this.wrappedSocket.Connected();
         }
         return false;
      }
      
      public function Disconnect() : void
      {
         if(this.wrappedSocket != null)
         {
            this.wrappedSocket.Disconnect();
         }
      }
      
      public function EnablePing() : void
      {
      }
      
      private function externalSocket(param1:String) : GSSocket
      {
         if(!GSSocketExternal.IsAvailable())
         {
            return null;
         }
         return new GSSocketExternal(this._logger);
      }
      
      private function internalSecureSocket(param1:String) : GSSocket
      {
         if(!SecureSocket.isSupported)
         {
            return null;
         }
         return new GSSocketGimite(this._logger,param1,true);
      }
      
      private function internalSocket(param1:String) : GSSocket
      {
         return new GSSocketGimite(this._logger,param1,false);
      }
      
      public function GetName() : String
      {
         return "socketSelector_" + this.selectorInstance;
      }
      
      public function IsExternal() : Boolean
      {
         return this.wrappedSocket.IsExternal();
      }
   }
}

