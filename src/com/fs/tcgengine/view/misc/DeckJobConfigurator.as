package com.fs.tcgengine.view.misc
{
   public class DeckJobConfigurator
   {
      
      private var mDeckIndex:String;
      
      private var mJobSku:String;
      
      private var mActiveAbiliySku:String;
      
      private var mSkinSku:String;
      
      public function DeckJobConfigurator(param1:String, param2:String, param3:String, param4:String)
      {
         super();
         this.mDeckIndex = param1;
         this.mJobSku = param2;
         this.mActiveAbiliySku = param3;
         this.mSkinSku = param4;
      }
      
      public function getDeckIndex() : String
      {
         return this.mDeckIndex;
      }
      
      public function getJobSku() : String
      {
         return this.mJobSku;
      }
      
      public function getActiveAbilitySku() : String
      {
         return this.mActiveAbiliySku;
      }
      
      public function getSkinSku() : String
      {
         return this.mSkinSku;
      }
      
      public function setJobSku(param1:String) : void
      {
         this.mJobSku = param1;
      }
      
      public function setActiveAbilitySku(param1:String) : void
      {
         this.mActiveAbiliySku = param1;
      }
      
      public function getString() : String
      {
         return String(this.mDeckIndex + "-" + this.mJobSku + "-" + this.mActiveAbiliySku + "-" + this.mSkinSku);
      }
      
      public function setSelectedSkinSku(param1:String) : void
      {
         this.mSkinSku = param1;
      }
   }
}

