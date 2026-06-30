package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.rules.Def;
   
   public class ActionsDefMng extends CardDefMng
   {
      
      public function ActionsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new ActionDef();
      }
      
      override public function getDefBySku(param1:String) : Def
      {
         return mDefsBySku[param1];
      }
   }
}

