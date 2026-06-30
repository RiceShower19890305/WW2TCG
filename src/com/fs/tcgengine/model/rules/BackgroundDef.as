package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class BackgroundDef extends Def
   {
      
      private var mMeteoSku:String;
      
      private var mSocketPrefix:String;
      
      private var mCardHolderBG:String;
      
      private var mIsTutorial:Boolean;
      
      private var mHighlightsBGName:String;
      
      private var mIsOld:Boolean;
      
      public function BackgroundDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("meteoSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.meteoSku);
            this.setMeteoSku(_loc2_);
         }
         if("socket" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.socket);
            this.setSocketPrefix(_loc2_);
         }
         if("cardHolderBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardHolderBG);
            this.mCardHolderBG = _loc2_;
         }
         if("isTutorial" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isTutorial);
            this.mIsTutorial = Utils.stringToBoolean(_loc2_);
         }
         if("highlightsBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.highlightsBG);
            this.mHighlightsBGName = _loc2_;
         }
         if("isOld" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isOld);
            this.mIsOld = Utils.stringToBoolean(_loc2_);
         }
      }
      
      public function getMeteoSku() : String
      {
         return this.mMeteoSku;
      }
      
      public function setMeteoSku(param1:String) : void
      {
         this.mMeteoSku = param1;
      }
      
      public function getSocketPrefix() : String
      {
         return this.mSocketPrefix;
      }
      
      public function setSocketPrefix(param1:String) : void
      {
         this.mSocketPrefix = param1;
      }
      
      public function getCardHolderBG() : String
      {
         return this.mCardHolderBG;
      }
      
      public function isTutorial() : Boolean
      {
         return this.mIsTutorial;
      }
      
      public function isOld() : Boolean
      {
         return this.mIsOld;
      }
      
      public function getHighlightsBGName() : String
      {
         return this.mHighlightsBGName;
      }
   }
}

