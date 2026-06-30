package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.RaidDef;
   import flash.utils.Dictionary;
   
   public class RaidsDefMng extends DefMng
   {
      
      public static const DIFFICULTIES_AMOUNT:int = 4;
      
      public function RaidsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new RaidDef();
      }
      
      public function getDefByIndex(param1:int) : RaidDef
      {
         var _loc2_:RaidDef = null;
         var _loc3_:RaidDef = null;
         for each(_loc3_ in mDefsBySku)
         {
            if(_loc3_.getIndex() == param1)
            {
               return _loc3_;
            }
         }
         return _loc2_;
      }
      
      public function getDefsBySkuArray(param1:Array) : Dictionary
      {
         var _loc3_:int = 0;
         var _loc2_:Dictionary = new Dictionary();
         if(param1 != null)
         {
            _loc3_ = 0;
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(getDefBySku(param1[_loc3_]) != null)
               {
                  _loc2_[param1[_loc3_]] = getDefBySku(param1[_loc3_]);
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
   }
}

