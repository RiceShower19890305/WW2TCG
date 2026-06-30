package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.ConfigDef;
   import com.fs.tcgengine.model.rules.Def;
   
   public class ConfigDefMng extends DefMng
   {
      
      public function ConfigDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new ConfigDef();
      }
   }
}

