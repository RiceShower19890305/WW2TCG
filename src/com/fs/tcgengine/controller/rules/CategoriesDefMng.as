package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.CategoryDef;
   import com.fs.tcgengine.model.rules.Def;
   
   public class CategoriesDefMng extends DefMng
   {
      
      public static var smCategoriesVec:Vector.<int>;
      
      public static const CATEGORY_UNITS:int = 0;
      
      public static const CATEGORY_ATTACHMENTS:int = 1;
      
      public static const CATEGORY_ACTIONS:int = 2;
      
      public static const CATEGORY_POWERS:int = 3;
      
      public function CategoriesDefMng(param1:String)
      {
         super(param1);
         smCategoriesVec = new Vector.<int>();
         smCategoriesVec.push(CATEGORY_UNITS);
         smCategoriesVec.push(CATEGORY_ATTACHMENTS);
         smCategoriesVec.push(CATEGORY_ACTIONS);
         smCategoriesVec.push(CATEGORY_POWERS);
      }
      
      override protected function createDef() : Def
      {
         return new CategoryDef();
      }
      
      public function getDefByIndex(param1:int) : CategoryDef
      {
         var _loc2_:CategoryDef = null;
         var _loc3_:CategoryDef = null;
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

