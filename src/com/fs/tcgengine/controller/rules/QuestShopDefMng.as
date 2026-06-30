package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.QuestShopDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import flash.utils.Dictionary;
   
   public class QuestShopDefMng extends DefMng
   {
      
      public function QuestShopDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new QuestShopDef();
      }
      
      public function getItemsToShowInShop() : Array
      {
         var _loc3_:QuestShopDef = null;
         var _loc4_:String = null;
         var _loc5_:PackDef = null;
         var _loc6_:CardDef = null;
         var _loc1_:Array = new Array();
         var _loc2_:Dictionary = getAllDefs();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.getType() == FSShopItem.SHOP_ITEM_TYPE_PACK || _loc3_.getType() == FSShopItem.SHOP_ITEM_TYPE_RAID_COINS)
            {
               _loc5_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc3_.getPackSku()));
               if(_loc5_)
               {
                  _loc3_.setBGXLImageName(_loc5_.getBGXLImageName());
               }
            }
            else
            {
               _loc6_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_.getCardSku()));
               if(_loc6_)
               {
                  _loc4_ = Config.getConfig().XLViewUsesXLTextures() ? _loc6_.getBGXLImageName() : _loc6_.getBGImageName();
                  _loc3_.setBGXLImageName(_loc4_);
               }
            }
            _loc1_.push(_loc3_);
         }
         _loc1_.sort(DictionaryUtils.sortQuestShopItemsByPrice);
         return _loc1_;
      }
   }
}

