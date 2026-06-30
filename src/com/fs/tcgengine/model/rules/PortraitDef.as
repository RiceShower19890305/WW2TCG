package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class PortraitDef extends Def
   {
      
      private var mRankFrameBG:String;
      
      private var mPvPSeasonReward:Array;
      
      private var mDungeonSeasonReward:Array;
      
      public function PortraitDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         if("bgRankFrame" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgRankFrame);
            this.setRankFrameBG(_loc2_);
         }
         if("pvpSeasonRewards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.pvpSeasonRewards);
            this.setPvPSeasonRewards(_loc2_.split(","));
         }
         if("dungeonSeasonRewards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.dungeonSeasonRewards);
            this.setDungeonSeasonRewards(_loc2_.split(","));
         }
      }
      
      private function setRankFrameBG(param1:String) : void
      {
         this.mRankFrameBG = param1;
      }
      
      private function setPvPSeasonRewards(param1:Array) : void
      {
         this.mPvPSeasonReward = param1;
      }
      
      private function setDungeonSeasonRewards(param1:Array) : void
      {
         this.mDungeonSeasonReward = param1;
      }
      
      public function getRankFrameBG() : String
      {
         return this.mRankFrameBG;
      }
      
      public function getPvPSeasonRewards() : Array
      {
         return this.mPvPSeasonReward;
      }
      
      public function getDungeonSeasonRewards() : Array
      {
         return this.mDungeonSeasonReward;
      }
   }
}

