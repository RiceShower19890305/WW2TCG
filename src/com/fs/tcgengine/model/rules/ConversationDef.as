package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class ConversationDef extends Def
   {
      
      private var mLevelSku:String;
      
      private var mIsEnemy:Boolean;
      
      private var mText:String;
      
      private var mTurn:int;
      
      private var mHeroSku:String;
      
      private var mStartTime:Number;
      
      private var mFadeTime:Number;
      
      private var mCallKey:String;
      
      public function ConversationDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         if("levelSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.levelSku);
            this.setLevelSku(_loc2_);
         }
         if("isEnemy" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isEnemy);
            this.setIsEnemy(Utils.stringToBoolean(_loc2_));
         }
         if("text" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.text);
            this.setText(_loc2_);
         }
         if("turn" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.turn);
            this.setTurn(int(_loc2_));
         }
         if("heroSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.heroSku);
            this.setHeroSku(_loc2_);
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
         if("callKey" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.callKey);
            this.mCallKey = _loc2_;
         }
      }
      
      public function setLevelSku(param1:String) : void
      {
         this.mLevelSku = param1;
      }
      
      public function getLevelSku() : String
      {
         return this.mLevelSku;
      }
      
      public function setIsEnemy(param1:Boolean) : void
      {
         this.mIsEnemy = param1;
      }
      
      public function isEnemy() : Boolean
      {
         return this.mIsEnemy;
      }
      
      public function setText(param1:String) : void
      {
         this.mText = param1;
      }
      
      public function getText() : String
      {
         return this.mText;
      }
      
      public function setTurn(param1:int) : void
      {
         this.mTurn = param1;
      }
      
      public function getTurn() : int
      {
         return this.mTurn;
      }
      
      public function setHeroSku(param1:String) : void
      {
         this.mHeroSku = param1;
      }
      
      public function getHeroSku() : String
      {
         return this.mHeroSku;
      }
      
      public function setStartTime(param1:Number) : void
      {
         this.mStartTime = param1;
      }
      
      public function getStartTime() : Number
      {
         return this.mStartTime;
      }
      
      public function setFadeTime(param1:Number) : void
      {
         this.mFadeTime = param1;
      }
      
      public function getFadeTime() : Number
      {
         return this.mFadeTime;
      }
      
      public function getCallKey() : String
      {
         return this.mCallKey;
      }
   }
}

