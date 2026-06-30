package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.RestrictionDef;
   
   public class RestrictionsDefMng extends DefMng
   {
      
      public function RestrictionsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new RestrictionDef();
      }
   }
}

