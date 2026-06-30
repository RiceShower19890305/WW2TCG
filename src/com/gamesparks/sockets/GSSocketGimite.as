package com.gamesparks.sockets
{
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import net.gimite.websocket.WebSocket;
   import net.gimite.websocket.WebSocketEvent;
   
   public class GSSocketGimite implements GSSocket
   {
      
      public static var networkAvailable:Boolean = true;
      
      private var websocket:WebSocket;
      
      private var secret:String;
      
      private var connected:Boolean = false;
      
      private var pingEnabled:Boolean = false;
      
      private var onOpen:Function;
      
      private var onClose:Function;
      
      private var onMessage:Function;
      
      private var onError:Function;
      
      private var logger:Function;
      
      public var useFlashSecureSocket:Boolean;
      
      public var name:String;
      
      private var hasErrored:Boolean = false;
      
      private var waitingForPong:Boolean = false;
      
      public function GSSocketGimite(param1:Function, param2:String, param3:Boolean)
      {
         var logger:Function = param1;
         var name:String = param2;
         var useFlashSecureSocket:Boolean = param3;
         super();
         this.name = name;
         this.logger = function(param1:String):void
         {
            logger((useFlashSecureSocket ? "GSSocketSS:" : "GSSocketTLS:") + param1);
         };
         this.useFlashSecureSocket = useFlashSecureSocket;
      }
      
      public function Dispose() : void
      {
         if(this.websocket != null)
         {
            this.logger("dispose");
            this.websocket.removeEventListener(WebSocketEvent.CLOSE,this.handleClose);
            this.websocket.removeEventListener(WebSocketEvent.OPEN,this.handleOpen);
            this.websocket.removeEventListener(WebSocketEvent.MESSAGE,this.handleMessage);
            this.websocket.removeEventListener(WebSocketEvent.ERROR,this.handleError);
            this.websocket.removeEventListener(WebSocketEvent.PONG,this.handlePong);
         }
      }
      
      public function Connect(param1:String, param2:Function, param3:Function, param4:Function, param5:Function) : Boolean
      {
         if(!networkAvailable)
         {
            return false;
         }
         this.onError = param5;
         this.onOpen = param2;
         this.onMessage = param4;
         this.onClose = param3;
         this.websocket = new WebSocket(0,param1,[],"*",null,0,null,null,new GSSocketGimiteLogger(this.logger),this.useFlashSecureSocket);
         this.websocket.addEventListener(WebSocketEvent.CLOSE,this.handleClose);
         this.websocket.addEventListener(WebSocketEvent.OPEN,this.handleOpen);
         this.websocket.addEventListener(WebSocketEvent.MESSAGE,this.handleMessage);
         this.websocket.addEventListener(WebSocketEvent.ERROR,this.handleError);
         this.websocket.addEventListener(WebSocketEvent.PONG,this.handlePong);
         return true;
      }
      
      private function handleClose(param1:WebSocketEvent) : void
      {
         this.Dispose();
         this.waitingForPong = false;
         this.connected = false;
         this.onClose(this);
      }
      
      private function handleOpen(param1:WebSocketEvent) : void
      {
         this.connected = true;
         this.onOpen(this);
         if(this.pingEnabled)
         {
            this.keepAlive();
         }
      }
      
      private function handleMessage(param1:WebSocketEvent) : void
      {
         this.onMessage(param1.message,this);
      }
      
      private function handleError(param1:WebSocketEvent) : void
      {
         if(!this.hasErrored)
         {
            this.hasErrored = true;
            this.onError(this);
         }
      }
      
      public function Connected() : Boolean
      {
         return this.websocket != null && this.websocket.getReadyState() == 1 && networkAvailable;
      }
      
      public function Send(param1:String, param2:Boolean = false) : void
      {
         if(!networkAvailable)
         {
            return;
         }
         this.websocket.send(param1);
      }
      
      public function Disconnect() : void
      {
         this.pingEnabled = false;
         if(this.websocket != null)
         {
            this.websocket.close();
            this.websocket = null;
         }
      }
      
      public function EnablePing() : void
      {
         this.pingEnabled = true;
      }
      
      public function keepAlive() : void
      {
         if(!this.connected || !this.pingEnabled)
         {
            return;
         }
         if(networkAvailable && this.websocket != null)
         {
            try
            {
               this.websocket.sendPing(new ByteArray());
            }
            catch(e:Error)
            {
            }
            this.waitingForPong = true;
         }
         setTimeout(function():void
         {
            if(websocket != null)
            {
               keepAlive();
            }
            else
            {
               pingEnabled = false;
            }
         },5000);
      }
      
      private function handlePong(param1:WebSocketEvent) : void
      {
         this.waitingForPong = false;
      }
      
      public function GetName() : String
      {
         return this.name;
      }
      
      public function IsExternal() : Boolean
      {
         return false;
      }
   }
}

