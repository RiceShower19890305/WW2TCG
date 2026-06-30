package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.WorldDef;
   
   public class WorldsDefMng extends DefMng
   {
      
      public function WorldsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new WorldDef();
      }
   }
}

