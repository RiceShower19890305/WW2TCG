package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import flash.utils.Dictionary;
   
   public class ShopBoostDefMng extends DefMng
   {
      
      public function ShopBoostDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new ShopBoostDef();
      }
      
      public function getBoostsToShowInShop() : Dictionary
      {
         var _loc3_:ShopBoostDef = null;
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
      
      public function getBoostsToShowInShopArray() : Array
      {
         var _loc3_:ShopBoostDef = null;
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
      
      public function getShopBoostDefByKeyname(param1:String) : ShopBoostDef
      {
         var _loc2_:ShopBoostDef = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Def = null;
         if(param1 != "" && param1 != null)
         {
            _loc3_ = getAllDefs();
            for each(_loc4_ in _loc3_)
            {
               if(ShopBoostDef(_loc4_).getKeyName() == param1)
               {
                  return ShopBoostDef(_loc4_);
               }
            }
         }
         return _loc2_;
      }
      
      public function getDefByRegularBoostSku(param1:String) : ShopBoostDef
      {
         var _loc2_:ShopBoostDef = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Def = null;
         if(param1 != "" && param1 != null)
         {
            _loc3_ = getAllDefs();
            for each(_loc4_ in _loc3_)
            {
               if(ShopBoostDef(_loc4_).getBoostSku() == param1)
               {
                  return ShopBoostDef(_loc4_);
               }
            }
         }
         return _loc2_;
      }
   }
}

