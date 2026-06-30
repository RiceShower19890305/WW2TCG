package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.DailyRewardDef;
   import com.fs.tcgengine.model.rules.Def;
   import flash.utils.Dictionary;
   
   public class DailyRewardsDefMng extends DefMng
   {
      
      public function DailyRewardsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new DailyRewardDef();
      }
      
      public function getDefByDay(param1:int, param2:Boolean = false) : DailyRewardDef
      {
         var _loc3_:DailyRewardDef = null;
         var _loc4_:Dictionary = null;
         var _loc5_:Def = null;
         if(param1 != -1)
         {
            _loc4_ = getAllDefs();
            for each(_loc5_ in _loc4_)
            {
               if(DailyRewardDef(_loc5_).getDay() == param1 && DailyRewardDef(_loc5_).isOldPlayerComingBackDef() == param2)
               {
                  return DailyRewardDef(_loc5_);
               }
            }
         }
         return _loc3_;
      }
   }
}

