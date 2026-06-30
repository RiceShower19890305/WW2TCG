package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class SubCategoryDef extends Def
   {
      
      private var mGameModeName:String;
      
      private var mAffinityBG:String;
      
      private var mColor:uint;
      
      private var mAnimAura:String;
      
      private var mIsUniversal:Boolean;
      
      public function SubCategoryDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("gameModeName" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameModeName);
            this.setGameModeName(_loc2_);
         }
         if("affinityBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.affinityBG);
            this.setAffinityBG(_loc2_);
         }
         if("color" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.color);
            this.setColor(uint(_loc2_));
         }
         if("animAura" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.animAura);
            this.mAnimAura = _loc2_;
         }
         if("isUniversal" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isUniversal);
            this.mIsUniversal = Utils.stringToBoolean(_loc2_);
         }
      }
      
      public function getGameModeName() : String
      {
         return this.mGameModeName;
      }
      
      public function setGameModeName(param1:String) : void
      {
         this.mGameModeName = param1;
      }
      
      public function setAffinityBG(param1:String) : void
      {
         this.mAffinityBG = param1;
      }
      
      public function getAffinityBG() : String
      {
         return this.mAffinityBG;
      }
      
      public function setColor(param1:uint) : void
      {
         this.mColor = param1;
      }
      
      public function getColor() : uint
      {
         return this.mColor;
      }
      
      public function getAnimAura() : String
      {
         return this.mAnimAura;
      }
      
      public function isUniversal() : Boolean
      {
         return this.mIsUniversal;
      }
   }
}

