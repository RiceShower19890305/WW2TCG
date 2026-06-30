package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.BackgroundDef;
   import com.fs.tcgengine.model.rules.Def;
   
   public class BackgroundDefMng extends DefMng
   {
      
      public function BackgroundDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new BackgroundDef();
      }
   }
}

