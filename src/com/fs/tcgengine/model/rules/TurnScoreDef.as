package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class TurnScoreDef extends Def
   {
      
      private var mTurnsLeft:int;
      
      private var mPointsAmountByGameMode:Dictionary;
      
      public function TurnScoreDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("turnsLeft" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.turnsLeft);
            this.setTurnsLeft(int(_loc2_));
         }
         if("pointsAmountGameMode0" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.pointsAmountGameMode0);
            this.setPointsAmountByGameModeIndex(int(_loc2_),0);
         }
         if("pointsAmountGameMode1" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.pointsAmountGameMode1);
            this.setPointsAmountByGameModeIndex(int(_loc2_),1);
         }
         if("pointsAmountGameMode2" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.pointsAmountGameMode2);
            this.setPointsAmountByGameModeIndex(int(_loc2_),2);
         }
         if("pointsAmountGameMode3" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.pointsAmountGameMode3);
            this.setPointsAmountByGameModeIndex(int(_loc2_),3);
         }
      }
      
      public function getTurnsLeft() : int
      {
         return this.mTurnsLeft;
      }
      
      public function setTurnsLeft(param1:int) : void
      {
         this.mTurnsLeft = param1;
      }
      
      public function getPointsAmountByGameModeIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         if(this.mPointsAmountByGameMode != null)
         {
            _loc2_ = int(this.mPointsAmountByGameMode[param1]);
         }
         return _loc2_;
      }
      
      public function setPointsAmountByGameModeIndex(param1:int, param2:int) : void
      {
         if(this.mPointsAmountByGameMode == null)
         {
            this.mPointsAmountByGameMode = new Dictionary(true);
         }
         this.mPointsAmountByGameMode[param2] = param1;
      }
   }
}

