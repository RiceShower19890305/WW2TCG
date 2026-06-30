package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class TutorialDef extends Def
   {
      
      private var mTurn:int;
      
      private var mLevelSku:String;
      
      private var mAnimBGName:String;
      
      private var mAnimPosX:Number;
      
      private var mAnimPosY:Number;
      
      private var mCharacterBG:String;
      
      private var mFPS:int;
      
      public function TutorialDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("turn" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.turn);
            this.setTurn(int(_loc2_));
         }
         if("levelSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.levelSku);
            this.setLevelSku(_loc2_);
         }
         if("anim_bg" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.anim_bg);
            this.setAnimBGName(_loc2_);
         }
         if("animPosX" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.animPosX);
            this.setAnimPosX(Number(_loc2_));
         }
         if("animPosY" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.animPosY);
            this.setAnimPosY(Number(_loc2_));
         }
         if("character_bg" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.character_bg);
            this.setCharacterBG(_loc2_);
         }
         if("fps" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.fps);
            this.setFPS(int(_loc2_));
         }
      }
      
      public function getTurn() : int
      {
         return this.mTurn;
      }
      
      public function setTurn(param1:int) : void
      {
         this.mTurn = param1;
      }
      
      public function getLevelSku() : String
      {
         return this.mLevelSku;
      }
      
      public function setLevelSku(param1:String) : void
      {
         this.mLevelSku = param1;
      }
      
      public function getAnimBGName() : String
      {
         return this.mAnimBGName;
      }
      
      public function setAnimBGName(param1:String) : void
      {
         this.mAnimBGName = param1;
      }
      
      public function getAnimPosX() : Number
      {
         return this.mAnimPosX;
      }
      
      public function setAnimPosX(param1:Number) : void
      {
         this.mAnimPosX = param1;
      }
      
      public function getAnimPosY() : Number
      {
         return this.mAnimPosY;
      }
      
      public function setAnimPosY(param1:Number) : void
      {
         this.mAnimPosY = param1;
      }
      
      public function getCharacterBG() : String
      {
         return this.mCharacterBG;
      }
      
      public function setCharacterBG(param1:String) : void
      {
         this.mCharacterBG = param1;
      }
      
      public function getFPS() : int
      {
         return this.mFPS;
      }
      
      public function setFPS(param1:int) : void
      {
         this.mFPS = param1;
      }
   }
}

