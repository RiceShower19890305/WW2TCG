package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.SubCategoryDef;
   
   public class SubCategoriesDefMng extends DefMng
   {
      
      public function SubCategoriesDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new SubCategoryDef();
      }
   }
}

