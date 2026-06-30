package com.gamesparks
{
   import flash.utils.ByteArray;
   
   public class GSRequest extends GSData
   {
      
      protected var timeoutSeconds:int = 5;
      
      internal var callback:Function = null;
      
      internal var requestId:String;
      
      internal var durable:Boolean = false;
      
      internal var durableRetryTicks:Number = 0;
      
      private var gs:GS;
      
      public function GSRequest(param1:GS, param2:Object = null)
      {
         if(param2 == null)
         {
            param2 = new Object();
         }
         super(param2);
         this.gs = param1;
      }
      
      public function getData() : Object
      {
         return data;
      }
      
      public function send(param1:Function) : String
      {
         this.callback = param1;
         var _loc2_:GSRequest = this.deepCopy();
         this.gs.send(_loc2_);
         return _loc2_.getData().requestId;
      }
      
      public function hasCallback() : Boolean
      {
         if(this.callback != null)
         {
            return true;
         }
         return false;
      }
      
      public function setCallback(param1:Function) : void
      {
         this.callback = param1;
      }
      
      public function setDurable(param1:Boolean) : void
      {
         this.durable = param1;
      }
      
      internal function getTimeoutSeconds() : int
      {
         return this.timeoutSeconds;
      }
      
      protected function toArray(param1:*) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
      
      private function deepCopy() : GSRequest
      {
         var _loc1_:GSRequest = new GSRequest(this.gs);
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(data);
         _loc2_.position = 0;
         _loc1_.data = _loc2_.readObject();
         _loc1_.timeoutSeconds = this.timeoutSeconds;
         _loc1_.callback = this.callback;
         _loc1_.durable = this.durable;
         return _loc1_;
      }
   }
}

