package net.gimite.websocket
{
   import com.adobe.net.proxies.RFC2817Socket;
   import com.gsolo.encryption.SHA1;
   import com.hurlant.crypto.tls.TLSConfig;
   import com.hurlant.crypto.tls.TLSEngine;
   import com.hurlant.crypto.tls.TLSSecurityParameters;
   import com.hurlant.crypto.tls.TLSSocket;
   import com.hurlant.util.Base64;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.net.*;
   import flash.security.*;
   import flash.system.*;
   import flash.utils.*;
   
   public class WebSocket extends EventDispatcher
   {
      
      private static const WEB_SOCKET_GUID:String = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
      
      private static const CONNECTING:int = 0;
      
      private static const OPEN:int = 1;
      
      private static const CLOSING:int = 2;
      
      private static const CLOSED:int = 3;
      
      private static const OPCODE_CONTINUATION:int = 0;
      
      private static const OPCODE_TEXT:int = 1;
      
      private static const OPCODE_BINARY:int = 2;
      
      private static const OPCODE_CLOSE:int = 8;
      
      private static const OPCODE_PING:int = 9;
      
      private static const OPCODE_PONG:int = 10;
      
      private static const STATUS_NORMAL_CLOSURE:int = 1000;
      
      private static const STATUS_NO_CODE:int = 1005;
      
      private static const STATUS_CLOSED_ABNORMALLY:int = 1006;
      
      private static const STATUS_SOCKET_ERROR:int = 2031;
      
      private static const STATUS_CONNECTION_ERROR:int = 5000;
      
      private var onPong:Function;
      
      private var id:int;
      
      private var url:String;
      
      private var scheme:String;
      
      private var host:String;
      
      private var port:uint;
      
      private var path:String;
      
      private var origin:String;
      
      private var requestedProtocols:Array;
      
      private var cookie:String;
      
      private var headers:String;
      
      private var proxyHost:String;
      
      private var proxyPort:int;
      
      private var rawSocket:Socket;
      
      private var tlsSocket:TLSSocket;
      
      private var tlsConfig:TLSConfig;
      
      private var socket:Socket;
      
      private var secureSocket:SecureSocket;
      
      private var acceptedProtocol:String;
      
      private var expectedDigest:String;
      
      private var buffer:ByteArray;
      
      private var fragmentsBuffer:ByteArray = null;
      
      private var headerState:int = 0;
      
      private var readyState:int = 0;
      
      private var logger:IWebSocketLogger;
      
      private var useFlashSecureSocket:Boolean = false;
      
      public function WebSocket(param1:int, param2:String, param3:Array, param4:String, param5:String, param6:int, param7:String, param8:String, param9:IWebSocketLogger, param10:Boolean)
      {
         var m:Array;
         var defaultPort:int;
         var proxySocket:RFC2817Socket = null;
         var id:int = param1;
         var url:String = param2;
         var protocols:Array = param3;
         var origin:String = param4;
         var proxyHost:String = param5;
         var proxyPort:int = param6;
         var cookie:String = param7;
         var headers:String = param8;
         var logger:IWebSocketLogger = param9;
         var useFlashSecureSocket:Boolean = param10;
         this.buffer = new ByteArray();
         super();
         this.logger = logger;
         this.id = id;
         this.url = url;
         m = url.match(/^(\w+):\/\/([^\/:]+)(:(\d+))?(\/.*)?(\?.*)?$/);
         if(!m)
         {
            this.fatal("SYNTAX_ERR: invalid url: " + url);
         }
         this.scheme = m[1];
         this.host = m[2];
         defaultPort = this.scheme == "wss" ? 443 : 80;
         this.port = uint(parseInt(m[4])) || uint(defaultPort);
         this.path = (m[5] || "/") + (m[6] || "");
         this.origin = origin;
         this.requestedProtocols = protocols;
         this.cookie = cookie;
         this.proxyHost = proxyHost;
         this.proxyPort = proxyPort;
         this.useFlashSecureSocket = useFlashSecureSocket;
         Security.loadPolicyFile("xmlsocket://" + this.host + ":" + this.port);
         Security.loadPolicyFile("xmlsocket://gamesparksbetabinaries.blob.core.windows.net");
         this.headers = headers;
         if(proxyHost != null && proxyPort != 0)
         {
            if(this.scheme == "wss")
            {
               this.fatal("wss with proxy is not supported");
            }
            proxySocket = new RFC2817Socket();
            proxySocket.setProxyInfo(proxyHost,proxyPort);
            proxySocket.addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
            this.rawSocket = this.socket = proxySocket;
         }
         else
         {
            this.rawSocket = new Socket();
            if(this.scheme == "wss")
            {
               if(!useFlashSecureSocket)
               {
                  this.tlsConfig = new TLSConfig(TLSEngine.CLIENT,null,null,null,null,null,TLSSecurityParameters.PROTOCOL_VERSION);
                  this.tlsConfig.trustAllCertificates = true;
                  this.tlsConfig.ignoreCommonNameMismatch = true;
                  this.tlsSocket = new TLSSocket();
                  this.tlsSocket.addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
                  this.socket = this.tlsSocket;
               }
               else
               {
                  this.secureSocket = new SecureSocket();
                  this.secureSocket.addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
                  this.rawSocket = this.socket = this.secureSocket;
               }
            }
            else
            {
               this.rawSocket.addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
               this.socket = this.rawSocket;
            }
         }
         this.rawSocket.addEventListener(Event.CLOSE,this.onSocketClose);
         this.rawSocket.addEventListener(Event.CONNECT,this.onSocketConnect);
         this.rawSocket.addEventListener(IOErrorEvent.IO_ERROR,this.onSocketIoError);
         this.rawSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSocketSecurityError);
         try
         {
            this.rawSocket.connect(this.host,this.port);
         }
         catch(e:Error)
         {
            logger.error("Error on connect: " + e);
         }
      }
      
      public function getId() : int
      {
         return this.id;
      }
      
      public function getReadyState() : int
      {
         return this.readyState;
      }
      
      public function getAcceptedProtocol() : String
      {
         return this.acceptedProtocol;
      }
      
      public function send(param1:String) : int
      {
         var dataBytes:ByteArray;
         var data:String = null;
         var frame:WebSocketFrame = null;
         var encData:String = param1;
         try
         {
            data = decodeURIComponent(encData);
         }
         catch(ex:URIError)
         {
            logger.error("SYNTAX_ERR: URIError in send()");
            return 0;
         }
         dataBytes = new ByteArray();
         dataBytes.writeUTFBytes(data);
         if(this.readyState == OPEN)
         {
            frame = new WebSocketFrame();
            frame.opcode = OPCODE_TEXT;
            frame.payload = dataBytes;
            if(this.sendFrame(frame))
            {
               return -1;
            }
            return dataBytes.length;
         }
         if(this.readyState == CLOSING || this.readyState == CLOSED)
         {
            return dataBytes.length;
         }
         this.fatal("invalid state");
         return 0;
      }
      
      public function close(param1:int = 1005, param2:String = "", param3:String = "client") : void
      {
         var closeConnection:Boolean;
         var frame:WebSocketFrame = null;
         var fireErrorEvent:Boolean = false;
         var wasClean:Boolean = false;
         var eventCode:int = 0;
         var code:int = param1;
         var reason:String = param2;
         var origin:String = param3;
         if(code != STATUS_NORMAL_CLOSURE && code != STATUS_NO_CODE && code != STATUS_CONNECTION_ERROR)
         {
            this.logger.error("Fail connection by " + origin + ": code=" + code + " reason=" + reason);
         }
         closeConnection = code == STATUS_CONNECTION_ERROR || origin == "server";
         try
         {
            if(this.readyState == OPEN && code != STATUS_CONNECTION_ERROR)
            {
               frame = new WebSocketFrame();
               frame.opcode = OPCODE_CLOSE;
               frame.payload = new ByteArray();
               if(origin == "client" && code != STATUS_NO_CODE)
               {
                  frame.payload.writeShort(code);
                  frame.payload.writeUTFBytes(reason);
               }
               this.sendFrame(frame);
            }
            if(closeConnection)
            {
               this.socket.close();
            }
         }
         catch(ex:Error)
         {
            logger.error("Error: " + ex.message);
         }
         if(closeConnection)
         {
            fireErrorEvent = this.readyState != CONNECTING && code == STATUS_CONNECTION_ERROR;
            this.readyState = CLOSED;
            if(fireErrorEvent)
            {
               dispatchEvent(new WebSocketEvent("error"));
            }
            wasClean = code != STATUS_CLOSED_ABNORMALLY && code != STATUS_CONNECTION_ERROR;
            eventCode = code == STATUS_CONNECTION_ERROR ? STATUS_CLOSED_ABNORMALLY : code;
            this.dispatchCloseEvent(wasClean,eventCode,reason);
         }
         else
         {
            this.readyState = CLOSING;
         }
      }
      
      private function onSocketConnect(param1:Event) : void
      {
         if(this.scheme == "wss")
         {
            if(!this.useFlashSecureSocket)
            {
               this.tlsSocket.startTLS(this.rawSocket,this.host,this.tlsConfig);
            }
         }
         var _loc2_:int = this.scheme == "wss" ? 443 : 80;
         var _loc3_:String = this.host + (this.port == _loc2_ ? "" : ":" + this.port);
         var _loc4_:String = this.generateKey();
         SHA1.b64pad = "=";
         this.expectedDigest = SHA1.b64_sha1(_loc4_ + WEB_SOCKET_GUID);
         var _loc5_:String = "";
         if(this.requestedProtocols.length > 0)
         {
            _loc5_ += "Sec-WebSocket-Protocol: " + this.requestedProtocols.join(",") + "\r\n";
         }
         if(this.headers)
         {
            _loc5_ += this.headers;
         }
         var _loc6_:String = "GET " + this.path + " HTTP/1.1\r\n" + "Host: " + _loc3_ + "\r\n" + "Upgrade: websocket\r\n" + "Connection: Upgrade\r\n" + "Sec-WebSocket-Key: " + _loc4_ + "\r\n" + "Origin: " + this.origin + "\r\n" + "Sec-WebSocket-Version: 13\r\n" + "Cookie: " + this.cookie + "\r\n" + _loc5_ + "\r\n";
         this.socket.writeUTFBytes(_loc6_);
         this.socket.flush();
      }
      
      private function onSocketClose(param1:Event) : void
      {
         this.readyState = CLOSED;
         this.dispatchCloseEvent(false,STATUS_CLOSED_ABNORMALLY,"");
      }
      
      private function onSocketIoError(param1:IOErrorEvent) : void
      {
         var _loc2_:String = null;
         if(this.readyState == CONNECTING)
         {
            _loc2_ = "cannot connect to Web Socket server at " + this.url + " (IoError: " + param1.text + ")";
         }
         else
         {
            _loc2_ = "error communicating with Web Socket server at " + this.url + " (IoError: " + param1.text + ")";
         }
         this.onConnectionError(_loc2_);
         if((param1.errorID == STATUS_SOCKET_ERROR || param1.text.indexOf("2048") >= 0) && this.useFlashSecureSocket == true)
         {
            this.useFlashSecureSocket = false;
            if(this.secureSocket != null)
            {
               this.logger.error("Server Certificate Status: " + this.secureSocket.serverCertificateStatus);
            }
         }
      }
      
      private function onSocketSecurityError(param1:SecurityErrorEvent) : void
      {
         var _loc2_:String = null;
         if(this.readyState == CONNECTING)
         {
            _loc2_ = "cannot connect to Web Socket server at " + this.url + " (SecurityError: " + param1.text + ")\n" + "make sure the server is running and Flash socket policy file is correctly placed";
         }
         else
         {
            _loc2_ = "error communicating with Web Socket server at " + this.url + " (SecurityError: " + param1.text + ")";
         }
         this.onConnectionError(_loc2_);
      }
      
      private function onConnectionError(param1:String) : void
      {
         if(this.readyState == CLOSED)
         {
            return;
         }
         this.logger.error(param1);
         this.close(STATUS_CONNECTION_ERROR);
      }
      
      private function onSocketData(param1:ProgressEvent) : void
      {
         var headerStr:String = null;
         var frame:WebSocketFrame = null;
         var code:int = 0;
         var reason:String = null;
         var pongEvent:WebSocketEvent = null;
         var data:String = null;
         var event:ProgressEvent = param1;
         var pos:int = int(this.buffer.length);
         this.socket.readBytes(this.buffer,pos);
         for(; pos < this.buffer.length; pos++)
         {
            if(this.headerState < 4)
            {
               if((this.headerState == 0 || this.headerState == 2) && this.buffer[pos] == 13)
               {
                  ++this.headerState;
               }
               else if((this.headerState == 1 || this.headerState == 3) && this.buffer[pos] == 10)
               {
                  ++this.headerState;
               }
               else
               {
                  this.headerState = 0;
               }
               if(this.headerState == 4)
               {
                  headerStr = this.readUTFBytes(this.buffer,0,pos + 1);
                  if(!this.validateHandshake(headerStr))
                  {
                     return;
                  }
                  this.removeBufferBefore(pos + 1);
                  pos = -1;
                  this.readyState = OPEN;
                  this.dispatchEvent(new WebSocketEvent("open"));
               }
               continue;
            }
            frame = this.parseFrame();
            if(!frame)
            {
               continue;
            }
            this.removeBufferBefore(frame.length);
            pos = -1;
            if(frame.rsv != 0)
            {
               this.close(1002,"RSV must be 0.");
               continue;
            }
            if(frame.mask)
            {
               this.close(1002,"Frame from server must not be masked.");
               continue;
            }
            if(frame.opcode >= 8 && frame.opcode <= 15 && frame.payload.length >= 126)
            {
               this.close(1004,"Payload of control frame must be less than 126 bytes.");
               continue;
            }
            switch(frame.opcode)
            {
               case OPCODE_CONTINUATION:
                  if(this.fragmentsBuffer == null)
                  {
                     this.close(1002,"Unexpected continuation frame");
                  }
                  else
                  {
                     this.fragmentsBuffer.writeBytes(frame.payload);
                     if(frame.fin)
                     {
                        data = this.readUTFBytes(this.fragmentsBuffer,0,this.fragmentsBuffer.length);
                        try
                        {
                           this.dispatchEvent(new WebSocketEvent("message",data));
                        }
                        catch(ex:URIError)
                        {
                           close(1007,"URIError while encoding the received data.");
                        }
                        this.fragmentsBuffer = null;
                     }
                  }
                  break;
               case OPCODE_TEXT:
                  if(frame.fin)
                  {
                     data = this.readUTFBytes(frame.payload,0,frame.payload.length);
                     try
                     {
                        this.dispatchEvent(new WebSocketEvent("message",data));
                     }
                     catch(ex:URIError)
                     {
                        close(1007,"URIError while encoding the received data.");
                     }
                  }
                  else
                  {
                     this.fragmentsBuffer = new ByteArray();
                     this.fragmentsBuffer.writeBytes(frame.payload);
                  }
                  break;
               case OPCODE_BINARY:
                  this.close(1003,"Received binary data, which is not supported.");
                  break;
               case OPCODE_CLOSE:
                  code = STATUS_NO_CODE;
                  reason = "";
                  if(frame.payload.length >= 2)
                  {
                     frame.payload.endian = Endian.BIG_ENDIAN;
                     frame.payload.position = 0;
                     code = int(frame.payload.readUnsignedShort());
                     reason = this.readUTFBytes(frame.payload,2,frame.payload.length - 2);
                  }
                  this.close(code,reason,"server");
                  break;
               case OPCODE_PING:
                  this.sendPong(frame.payload);
                  break;
               case OPCODE_PONG:
                  pongEvent = new WebSocketEvent("pong");
                  pongEvent.payload = frame.payload;
                  dispatchEvent(pongEvent);
                  break;
               default:
                  this.close(1002,"Received unknown opcode: " + frame.opcode);
            }
         }
      }
      
      public function sendPing(param1:ByteArray) : Boolean
      {
         var _loc2_:WebSocketFrame = new WebSocketFrame();
         _loc2_.opcode = OPCODE_PING;
         _loc2_.payload = param1;
         return this.sendFrame(_loc2_);
      }
      
      private function trim(param1:String) : String
      {
         if(param1 == null)
         {
            return "";
         }
         var _loc2_:int = 0;
         while(this.isWhitespace(param1.charAt(_loc2_)))
         {
            _loc2_++;
         }
         var _loc3_:* = int(param1.length - 1);
         while(this.isWhitespace(param1.charAt(_loc3_)))
         {
            _loc3_--;
         }
         if(_loc3_ >= _loc2_)
         {
            return param1.slice(_loc2_,_loc3_ + 1);
         }
         return "";
      }
      
      private function isWhitespace(param1:String) : Boolean
      {
         switch(param1)
         {
            case " ":
            case "\t":
            case "\r":
            case "\n":
            case "\f":
               return true;
            default:
               return false;
         }
      }
      
      private function validateHandshake(param1:String) : Boolean
      {
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc2_:Array = param1.split(/\r\n/);
         if(!_loc2_[0].match(/^HTTP\/1.1 101 /))
         {
            this.onConnectionError("bad response: " + _loc2_[0]);
            return false;
         }
         var _loc3_:Object = {};
         var _loc4_:Object = {};
         var _loc5_:int = 1;
         while(_loc5_ < _loc2_.length)
         {
            if(_loc2_[_loc5_].length != 0)
            {
               _loc7_ = _loc2_[_loc5_].match(/^(\S+):(.*)$/);
               if(!_loc7_)
               {
                  this.onConnectionError("failed to parse response header line: " + _loc2_[_loc5_]);
                  return false;
               }
               _loc8_ = _loc7_[1].toLowerCase();
               _loc9_ = this.trim(_loc7_[2]);
               _loc3_[_loc8_] = _loc9_;
               _loc4_[_loc8_] = _loc9_.toLowerCase();
            }
            _loc5_++;
         }
         if(_loc4_["upgrade"] != "websocket")
         {
            this.onConnectionError("invalid Upgrade: " + _loc3_["Upgrade"]);
            return false;
         }
         if(_loc4_["connection"] != "upgrade")
         {
            this.onConnectionError("invalid Connection: " + _loc3_["Connection"]);
            return false;
         }
         if(!_loc4_["sec-websocket-accept"])
         {
            this.onConnectionError("The WebSocket server speaks old WebSocket protocol, " + "which is not supported by web-socket-js. " + "It requires WebSocket protocol HyBi 10. " + "Try newer version of the server if available.");
            return false;
         }
         var _loc6_:String = _loc3_["sec-websocket-accept"];
         if(_loc6_ != this.expectedDigest)
         {
            this.onConnectionError("digest doesn\'t match: " + _loc6_ + " != " + this.expectedDigest);
            return false;
         }
         if(this.requestedProtocols.length > 0)
         {
            this.acceptedProtocol = _loc3_["sec-websocket-protocol"];
            if(this.requestedProtocols.indexOf(this.acceptedProtocol) < 0)
            {
               this.onConnectionError("protocol doesn\'t match: \'" + this.acceptedProtocol + "\' not in \'" + this.requestedProtocols.join(",") + "\'");
               return false;
            }
         }
         return true;
      }
      
      private function sendPong(param1:ByteArray) : Boolean
      {
         var _loc2_:WebSocketFrame = new WebSocketFrame();
         _loc2_.opcode = OPCODE_PONG;
         _loc2_.payload = param1;
         return this.sendFrame(_loc2_);
      }
      
      private function sendFrame(param1:WebSocketFrame) : Boolean
      {
         var header:ByteArray;
         var maskedPayload:ByteArray;
         var frame:WebSocketFrame = param1;
         var plength:uint = frame.payload.length;
         var mask:ByteArray = new ByteArray();
         var i:int = 0;
         while(i < 4)
         {
            mask.writeByte(this.randomInt(0,255));
            i++;
         }
         header = new ByteArray();
         header.writeByte((frame.fin ? 128 : 0) | frame.rsv << 4 | frame.opcode);
         if(plength <= 125)
         {
            header.writeByte(0x80 | plength);
         }
         else if(plength > 125 && plength < 65536)
         {
            header.writeByte(0x80 | 0x7E);
            header.writeShort(plength);
         }
         else if(plength >= 65536 && plength < 4294967296)
         {
            header.writeByte(0x80 | 0x7F);
            header.writeUnsignedInt(0);
            header.writeUnsignedInt(plength);
         }
         else
         {
            this.fatal("Send frame size too large");
         }
         header.writeBytes(mask);
         maskedPayload = new ByteArray();
         maskedPayload.length = frame.payload.length;
         i = 0;
         while(i < frame.payload.length)
         {
            maskedPayload[i] = mask[i % 4] ^ frame.payload[i];
            i++;
         }
         try
         {
            this.socket.writeBytes(header);
            this.socket.writeBytes(maskedPayload);
            this.socket.flush();
         }
         catch(ex:Error)
         {
            logger.error("Error while sending frame: " + ex.message);
            setTimeout(function():void
            {
               if(readyState != CLOSED)
               {
                  close(STATUS_CONNECTION_ERROR);
               }
            },0);
            return false;
         }
         return true;
      }
      
      private function parseFrame() : WebSocketFrame
      {
         var _loc4_:uint = 0;
         var _loc1_:WebSocketFrame = new WebSocketFrame();
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = 2;
         if(this.buffer.length < _loc2_)
         {
            return null;
         }
         _loc1_.fin = (this.buffer[0] & 0x80) != 0;
         _loc1_.rsv = (this.buffer[0] & 0x70) >> 4;
         _loc1_.opcode = this.buffer[0] & 0x0F;
         _loc1_.mask = (this.buffer[1] & 0x80) != 0;
         _loc3_ = uint(this.buffer[1] & 0x7F);
         if(_loc3_ == 126)
         {
            _loc2_ = 4;
            if(this.buffer.length < _loc2_)
            {
               return null;
            }
            this.buffer.endian = Endian.BIG_ENDIAN;
            this.buffer.position = 2;
            _loc3_ = this.buffer.readUnsignedShort();
         }
         else if(_loc3_ == 127)
         {
            _loc2_ = 10;
            if(this.buffer.length < _loc2_)
            {
               return null;
            }
            this.buffer.endian = Endian.BIG_ENDIAN;
            this.buffer.position = 2;
            _loc4_ = this.buffer.readUnsignedInt();
            _loc3_ = this.buffer.readUnsignedInt();
            if(_loc4_ != 0)
            {
               this.fatal("Frame length exceeds 4294967295. Bailing out!");
               return null;
            }
         }
         if(this.buffer.length < _loc2_ + _loc3_)
         {
            return null;
         }
         _loc1_.length = _loc2_ + _loc3_;
         _loc1_.payload = new ByteArray();
         this.buffer.position = _loc2_;
         this.buffer.readBytes(_loc1_.payload,0,_loc3_);
         return _loc1_;
      }
      
      private function dispatchCloseEvent(param1:Boolean, param2:int, param3:String) : void
      {
         var _loc4_:WebSocketEvent = new WebSocketEvent("close");
         _loc4_.wasClean = param1;
         _loc4_.code = param2;
         _loc4_.reason = param3;
         dispatchEvent(_loc4_);
      }
      
      private function removeBufferBefore(param1:int) : void
      {
         if(param1 == 0)
         {
            return;
         }
         var _loc2_:ByteArray = new ByteArray();
         this.buffer.position = param1;
         this.buffer.readBytes(_loc2_);
         this.buffer = _loc2_;
      }
      
      private function generateKey() : String
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.length = 16;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc1_[_loc2_] = this.randomInt(0,127);
            _loc2_++;
         }
         return Base64.encodeByteArray(_loc1_);
      }
      
      private function readUTFBytes(param1:ByteArray, param2:int, param3:int) : String
      {
         param1.position = param2;
         var _loc4_:String = "";
         var _loc5_:int = param2;
         while(_loc5_ < param2 + param3)
         {
            if(param1[_loc5_] == 0)
            {
               _loc4_ += param1.readUTFBytes(_loc5_ - param1.position) + "\x00";
               param1.position = _loc5_ + 1;
            }
            _loc5_++;
         }
         return _loc4_ + param1.readUTFBytes(param2 + param3 - param1.position);
      }
      
      private function randomInt(param1:uint, param2:uint) : uint
      {
         return param1 + Math.floor(Math.random() * (Number(param2) - param1 + 1));
      }
      
      private function fatal(param1:String) : void
      {
         this.logger.error(param1);
         throw param1;
      }
   }
}

