package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.AuctionTicketDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import flash.utils.Dictionary;
   
   public class AuctionTicketsDefMng extends GoldDefMng
   {
      
      public function AuctionTicketsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new AuctionTicketDef();
      }
      
      public function getAuctionTicketBagsToShowInShop() : Dictionary
      {
         var _loc3_:AuctionTicketDef = null;
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
      
      public function getAuctionTicketBagsToShowInShopArray() : Array
      {
         var _loc3_:AuctionTicketDef = null;
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

