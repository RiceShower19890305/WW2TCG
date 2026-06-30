package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.ResourceDef;
   import flash.utils.Dictionary;
   
   public class ResourceDefMng extends DefMng
   {
      
      public function ResourceDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new ResourceDef();
      }
      
      public function getResourcesByFolderName(param1:String = "") : Dictionary
      {
         var _loc5_:ResourceDef = null;
         var _loc2_:Dictionary = getAllDefs();
         var _loc3_:Dictionary = new Dictionary(true);
         var _loc4_:int = 0;
         if(param1 != "")
         {
            for each(_loc5_ in _loc2_)
            {
               if(Boolean(_loc5_) && _loc5_.getFolderSku() == param1)
               {
                  _loc3_[_loc4_] = _loc5_;
                  _loc4_++;
               }
            }
         }
         else
         {
            _loc3_ = _loc2_;
         }
         return _loc3_;
      }
   }
}

