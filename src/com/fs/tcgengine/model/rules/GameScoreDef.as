package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class GameScoreDef extends Def
   {
      
      private var mPointsAmount:int;
      
      public function GameScoreDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("pointsAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.pointsAmount);
            this.setPointsAmount(int(_loc2_));
         }
      }
      
      public function getPointsAmount() : int
      {
         return this.mPointsAmount;
      }
      
      public function setPointsAmount(param1:int) : void
      {
         this.mPointsAmount = param1;
      }
   }
}

