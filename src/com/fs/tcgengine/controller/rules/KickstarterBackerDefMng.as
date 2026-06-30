package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.KickstarterBackerDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import flash.utils.Dictionary;
   
   public class KickstarterBackerDefMng extends DefMng
   {
      
      public function KickstarterBackerDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new KickstarterBackerDef();
      }
      
      public function getBackersListSortedBySurname(param1:String = "") : Array
      {
         var _loc4_:Array = null;
         var _loc5_:KickstarterBackerDef = null;
         var _loc2_:Dictionary = getAllDefs();
         var _loc3_:Dictionary = new Dictionary(true);
         if(param1 != "")
         {
            for each(_loc5_ in _loc2_)
            {
               if(_loc5_.getKickType() == param1)
               {
                  _loc3_[_loc5_.getSku()] = _loc5_;
               }
            }
         }
         else
         {
            _loc3_ = _loc2_;
         }
         _loc4_ = DictionaryUtils.dictionaryToArray(_loc3_);
         _loc4_.sort(DictionaryUtils.sortBackersBySurname);
         return _loc4_;
      }
   }
}

