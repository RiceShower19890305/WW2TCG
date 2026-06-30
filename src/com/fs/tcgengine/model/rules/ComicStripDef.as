package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class ComicStripDef extends Def
   {
      
      private var mTriggeredOnMapSku:String;
      
      private var mShowOrder:int;
      
      private var mIsBG:Boolean;
      
      private var mStartTime:Number;
      
      private var mFadeTime:Number;
      
      private var mSound:String;
      
      private var mPosX:int;
      
      private var mPosY:int;
      
      private var mHasText:Boolean;
      
      private var mTextPosX:int;
      
      private var mTextPosY:int;
      
      private var mTextWidth:int;
      
      private var mTextHeight:int;
      
      private var mFX:String;
      
      private var mFXTransition:String;
      
      private var mZoomAmount:Number;
      
      public function ComicStripDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         if("triggeredOnMapSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.triggeredOnMapSku);
            this.setTriggeredOnMapSku(_loc2_);
         }
         if("showOrder" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.showOrder);
            this.setShowOrder(int(_loc2_));
         }
         if("isBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isBG);
            this.setIsBG(Utils.stringToBoolean(_loc2_));
         }
         if("startTime" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.startTime);
            this.setStartTime(Number(_loc2_));
         }
         if("fadeTime" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.fadeTime);
            this.setFadeTime(Number(_loc2_));
         }
         if("sound" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.sound);
            this.setSound(_loc2_);
         }
         if("posX" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.posX);
            this.setPosX(int(_loc2_));
         }
         if("posY" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.posY);
            this.setPosY(int(_loc2_));
         }
         if("hasText" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.hasText);
            this.setHasText(Utils.stringToBoolean(_loc2_));
         }
         if("textPosX" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.textPosX);
            this.setTextPosX(int(_loc2_));
         }
         if("textPosY" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.textPosY);
            this.setTextPosY(int(_loc2_));
         }
         if("textWidth" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.textWidth);
            this.setTextWidth(int(_loc2_));
         }
         if("textHeight" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.textHeight);
            this.setTextHeight(int(_loc2_));
         }
         if("fx" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.fx);
            this.setFX(_loc2_);
         }
         if("fxTransition" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.fxTransition);
            this.setFXTransition(_loc2_);
         }
         if("zoomAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.zoomAmount);
            this.setZoomAmount(int(_loc2_));
         }
      }
      
      public function getTriggeredOnMapSku() : String
      {
         return this.mTriggeredOnMapSku;
      }
      
      private function setTriggeredOnMapSku(param1:String) : void
      {
         this.mTriggeredOnMapSku = param1;
      }
      
      public function getShowOrder() : int
      {
         return this.mShowOrder;
      }
      
      private function setShowOrder(param1:int) : void
      {
         this.mShowOrder = param1;
      }
      
      public function getIsBG() : Boolean
      {
         return this.mIsBG;
      }
      
      private function setIsBG(param1:Boolean) : void
      {
         this.mIsBG = param1;
      }
      
      public function getStartTime() : Number
      {
         return this.mStartTime;
      }
      
      private function setStartTime(param1:Number) : void
      {
         this.mStartTime = param1;
      }
      
      public function getFadeTime() : Number
      {
         return this.mFadeTime;
      }
      
      private function setFadeTime(param1:Number) : void
      {
         this.mFadeTime = param1;
      }
      
      public function getSound() : String
      {
         return this.mSound;
      }
      
      private function setSound(param1:String) : void
      {
         this.mSound = param1;
      }
      
      public function getPosX() : int
      {
         return this.mPosX;
      }
      
      private function setPosX(param1:int) : void
      {
         this.mPosX = param1;
      }
      
      public function getPosY() : int
      {
         return this.mPosY;
      }
      
      private function setPosY(param1:int) : void
      {
         this.mPosY = param1;
      }
      
      public function getHasText() : Boolean
      {
         return this.mHasText;
      }
      
      private function setHasText(param1:Boolean) : void
      {
         this.mHasText = param1;
      }
      
      public function getTextPosX() : int
      {
         return this.mTextPosX;
      }
      
      private function setTextPosX(param1:int) : void
      {
         this.mTextPosX = param1;
      }
      
      public function getTextPosY() : int
      {
         return this.mTextPosY;
      }
      
      private function setTextPosY(param1:int) : void
      {
         this.mTextPosY = param1;
      }
      
      public function getTextWidth() : int
      {
         return this.mTextWidth;
      }
      
      private function setTextWidth(param1:int) : void
      {
         this.mTextWidth = param1;
      }
      
      public function getTextHeight() : int
      {
         return this.mTextHeight;
      }
      
      private function setTextHeight(param1:int) : void
      {
         this.mTextHeight = param1;
      }
      
      public function getFX() : String
      {
         return this.mFX;
      }
      
      public function getFXTransition() : String
      {
         return this.mFXTransition;
      }
      
      public function setFX(param1:String) : void
      {
         this.mFX = param1;
      }
      
      public function setFXTransition(param1:String) : void
      {
         this.mFXTransition = param1;
      }
      
      private function setZoomAmount(param1:Number) : void
      {
         this.mZoomAmount = param1;
      }
      
      public function getZoomAmount() : Number
      {
         return this.mZoomAmount;
      }
   }
}

