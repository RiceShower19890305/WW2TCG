package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.Utils;
   
   public class MapDef extends Def
   {
      
      private var mLevelsAmount:int;
      
      private var mPath:String;
      
      private var mUnlockTime:Number = 0;
      
      private var mComicThumbnailBGName:String;
      
      private var mComicThumbnailName:String;
      
      private var mIsWorldMap:Boolean;
      
      private var mWorldsAvailable:Array;
      
      private var mWorldParentIndex:int = -1;
      
      public function MapDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         if("levelsAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.levelsAmount);
            this.setLevelsAmount(int(_loc2_));
         }
         if("unlockTime" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockTime);
            this.setUnlockTime(Number(_loc2_));
         }
         if("comicThumbnail" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.comicThumbnail);
            this.setComicThumbnailImageName(_loc2_);
         }
         if("comicName" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.comicName);
            this.setComicThumbnailName(_loc2_);
         }
         if("isWorldMap" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.isWorldMap);
            this.mIsWorldMap = Utils.stringToBoolean(_loc2_);
         }
         if("worldsAvailable" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.worldsAvailable);
            this.mWorldsAvailable = String(_loc2_).split(",");
         }
         if("worldParentIndex" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.worldParentIndex);
            this.mWorldParentIndex = int(_loc2_);
         }
      }
      
      public function getLevelsAmount() : int
      {
         return this.mLevelsAmount;
      }
      
      private function setLevelsAmount(param1:int) : void
      {
         this.mLevelsAmount = param1;
      }
      
      public function getPath() : String
      {
         return this.mPath;
      }
      
      private function setPath(param1:String) : void
      {
         this.mPath = param1;
      }
      
      private function setUnlockTime(param1:Number) : void
      {
         this.mUnlockTime = param1;
      }
      
      public function getUnlockTime() : Number
      {
         return this.mUnlockTime;
      }
      
      public function getComicThumbnailImageName() : String
      {
         return this.mComicThumbnailBGName;
      }
      
      private function setComicThumbnailImageName(param1:String) : void
      {
         this.mComicThumbnailBGName = param1;
      }
      
      public function getComicThumbnailTitle() : String
      {
         return this.mComicThumbnailName;
      }
      
      private function setComicThumbnailName(param1:String) : void
      {
         this.mComicThumbnailName = param1;
      }
      
      public function isWorldMap() : Boolean
      {
         return this.mIsWorldMap;
      }
      
      public function calculateBGName() : String
      {
         var _loc1_:String = mSku;
         var _loc2_:int = this.getWorldParentIndex();
         var _loc3_:int = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc2_) : 0;
         if(this.isWorldMap())
         {
            _loc1_ = _loc3_ == 0 ? "map_temp" : mSku + "_" + _loc3_;
         }
         return _loc1_;
      }
      
      public function getMapWorldsAvailable() : Array
      {
         return this.mWorldsAvailable;
      }
      
      public function getWorldParentIndex() : int
      {
         return this.mWorldParentIndex;
      }
      
      public function calculateMapName() : String
      {
         var _loc1_:String = getName();
         var _loc2_:int = this.getWorldParentIndex();
         var _loc3_:UserData = Utils.getOwnerUserData();
         var _loc4_:int = _loc3_ ? InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc2_) : 0;
         if(this.isWorldMap())
         {
            _loc1_ = _loc4_ == 0 ? getName() : TextManager.getText(getNameTID() + "_" + _loc4_);
         }
         return _loc1_;
      }
      
      public function calculateMapDesc() : String
      {
         var _loc1_:String = getDesc();
         var _loc2_:int = this.getWorldParentIndex();
         var _loc3_:int = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc2_) : 0;
         if(this.isWorldMap())
         {
            _loc1_ = _loc3_ == 0 ? getDesc() : TextManager.getText(getDescTID() + "_" + _loc3_);
         }
         return _loc1_;
      }
   }
}

