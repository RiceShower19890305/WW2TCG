package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.UnitDef;
   
   public class UnitsDefMng extends CardDefMng
   {
      
      public function UnitsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new UnitDef();
      }
      
      override public function getDefBySku(param1:String) : Def
      {
         return mDefsBySku[param1];
      }
   }
}

