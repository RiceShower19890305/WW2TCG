package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.SubCategoryDef;
   
   public class SubCategoriesMng
   {
      
      public static const SUBCATEGORY_01:int = 0;
      
      public static const SUBCATEGORY_02:int = 1;
      
      public static const SUBCATEGORY_03:int = 2;
      
      public static const SUBCATEGORY_04:int = 3;
      
      public static const SUBCATEGORY_05:int = 4;
      
      public function SubCategoriesMng()
      {
         super();
      }
      
      public function getSubcategoriesNamesByDefSku(param1:Array) : String
      {
         var _loc3_:int = 0;
         var _loc4_:SubCategoryDef = null;
         var _loc5_:Boolean = false;
         var _loc2_:String = "";
         if(param1 != null)
         {
            _loc5_ = param1.length > 3;
            if(!_loc5_)
            {
               _loc3_ = 0;
               while(_loc3_ < param1.length)
               {
                  _loc4_ = SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(param1[_loc3_]));
                  if(_loc4_ != null)
                  {
                     _loc2_ += !_loc4_.isUniversal() ? _loc4_.getName() : "";
                  }
                  if(_loc3_ < param1.length - 1 && _loc2_ != "")
                  {
                     _loc2_ += " / ";
                  }
                  _loc3_++;
               }
            }
         }
         return _loc5_ ? TextManager.getText("TID_GEN_UNIVERSAL") : _loc2_;
      }
   }
}

