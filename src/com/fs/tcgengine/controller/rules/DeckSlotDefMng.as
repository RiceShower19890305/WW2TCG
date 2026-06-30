package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.DeckSlotDef;
   import com.fs.tcgengine.model.rules.Def;
   
   public class DeckSlotDefMng extends DefMng
   {
      
      public function DeckSlotDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new DeckSlotDef();
      }
      
      public function getDeckSlotDefByIndex(param1:int) : DeckSlotDef
      {
         var _loc2_:DeckSlotDef = null;
         var _loc3_:DeckSlotDef = null;
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

