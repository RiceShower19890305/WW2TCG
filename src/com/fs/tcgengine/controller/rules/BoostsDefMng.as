package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.Def;
   
   public class BoostsDefMng extends DefMng
   {
      
      public function BoostsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new BoostDef();
      }
      
      public function getBoostDefByKeyname(param1:String) : BoostDef
      {
         var _loc2_:BoostDef = null;
         var _loc3_:Def = null;
         if(param1 != "" && param1 != null)
         {
            for each(_loc3_ in mDefsBySku)
            {
               if(BoostDef(_loc3_).getKeyName() == param1)
               {
                  return BoostDef(_loc3_);
               }
            }
         }
         return _loc2_;
      }
   }
}

