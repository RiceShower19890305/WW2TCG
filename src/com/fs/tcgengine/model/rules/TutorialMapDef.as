package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class TutorialMapDef extends TutorialDeckBuilderDef
   {
      
      public static const TUTORIAL_MAP_TYPE_COMMON:int = 0;
      
      public static const TUTORIAL_MAP_TYPE_INFORMATION:int = 1;
      
      public static const TUTORIAL_MAP_TYPE_REWARD:int = 2;
      
      private var mLevel:int;
      
      private var mType:int;
      
      private var mPackSku:String;
      
      private var mTutorialReward:String;
      
      private var mDifficulty:int;
      
      private var mExtraImageBG:String;
      
      private var mJobToBuy:String = "";
      
      public function TutorialMapDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("level" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.level);
            this.setLevel(int(_loc2_));
         }
         if("type" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.type);
            this.mType = int(_loc2_);
         }
         if("packSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.packSku);
            this.mPackSku = String(_loc2_);
         }
         if("tutorialReward" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.tutorialReward);
            this.mTutorialReward = String(_loc2_);
         }
         if("difficulty" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.difficulty);
            this.mDifficulty = int(_loc2_);
         }
         if("extraImageBg" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.extraImageBg);
            this.mExtraImageBG = _loc2_;
         }
         if("jobToBuy" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.jobToBuy);
            this.mJobToBuy = _loc2_;
         }
      }
      
      public function getLevel() : int
      {
         return this.mLevel;
      }
      
      public function setLevel(param1:int) : void
      {
         this.mLevel = param1;
      }
      
      public function getType() : int
      {
         return this.mType;
      }
      
      public function getPackSku() : String
      {
         return this.mPackSku;
      }
      
      public function getTutorialReward() : String
      {
         return this.mTutorialReward;
      }
      
      public function getDifficulty() : int
      {
         return this.mDifficulty;
      }
      
      public function getExtraImageBG() : String
      {
         return this.mExtraImageBG;
      }
      
      public function hasToBuyJobOnStep() : Boolean
      {
         return this.mJobToBuy != "";
      }
      
      public function getJobToBuy() : String
      {
         return this.mJobToBuy;
      }
   }
}

