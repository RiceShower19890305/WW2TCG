package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import flash.utils.Dictionary;
   
   public class GoldDefMng extends DefMng
   {
      
      public function GoldDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new GoldDef();
      }
      
      public function getGoldBagsToShowInShop() : Dictionary
      {
         var _loc3_:GoldDef = null;
         var _loc1_:Dictionary = new Dictionary(true);
         var _loc2_:Dictionary = getAllDefs();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.getShowInShop())
            {
               _loc1_[_loc3_.getSku()] = _loc3_;
            }
         }
         return _loc1_;
      }
      
      public function getGoldBagsToShowInShopArray() : Array
      {
         var _loc3_:GoldDef = null;
         var _loc1_:Array = new Array();
         var _loc2_:Dictionary = getAllDefs();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.getShowInShop())
            {
               _loc1_.push(_loc3_);
            }
         }
         _loc1_.sort(DictionaryUtils.sortDefByIndex);
         return _loc1_;
      }
   }
}

