package com.gamesparks.sockets
{
   import net.gimite.websocket.IWebSocketLogger;
   
   public class GSSocketGimiteLogger implements IWebSocketLogger
   {
      
      private var logger:Function;
      
      public function GSSocketGimiteLogger(param1:Function)
      {
         super();
         this.logger = param1;
      }
      
      public function log(param1:String) : void
      {
         this.logger("log:" + param1);
      }
      
      public function error(param1:String) : void
      {
         this.logger("err:" + param1.split("rror").join("rr"));
      }
   }
}

