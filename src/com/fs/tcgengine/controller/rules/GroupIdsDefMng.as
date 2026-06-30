package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.GroupIdDef;
   
   public class GroupIdsDefMng extends DefMng
   {
      
      public function GroupIdsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new GroupIdDef();
      }
      
      public function getDefByIndex(param1:int) : GroupIdDef
      {
         var _loc2_:GroupIdDef = null;
         var _loc3_:GroupIdDef = null;
         for each(_loc3_ in mDefsBySku)
         {
            if(_loc3_.getIndex() == param1)
            {
               return _loc3_;
            }
         }
         return _loc2_;
      }
   }
}

