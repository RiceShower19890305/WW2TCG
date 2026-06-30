package com.fs.tcgengine.controller
{
   import flash.events.Event;
   
   public class InAppEvent extends Event
   {
      
      private var mProducts:*;
      
      private var mPurchaseInfo:Object;
      
      public function InAppEvent(param1:String, param2:*, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.mProducts = param2;
      }
      
      public function getProducts() : *
      {
         return this.mProducts;
      }
      
      public function get products() : *
      {
         return this.mProducts;
      }
      
      public function setPurchaseInfo(param1:Object) : void
      {
         this.mPurchaseInfo = param1;
      }
      
      public function getPurchaseInfo() : Object
      {
         return this.mPurchaseInfo;
      }
   }
}

