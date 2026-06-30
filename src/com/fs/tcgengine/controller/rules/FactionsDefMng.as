package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.FactionDef;
   
   public class FactionsDefMng extends DefMng
   {
      
      public static const FACTION_GERMANY:int = 0;
      
      public static const FACTION_EEUU:int = 1;
      
      public static const FACTION_RUSSIA:int = 2;
      
      public static const FACTION_JAPAN:int = 3;
      
      public static const FACTION_BRITISH:int = 4;
      
      public function FactionsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new FactionDef();
      }
   }
}

